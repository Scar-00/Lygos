use crate::ast::{symbol, symbol::Symbol, FunctionArg, Generate, AST};
use crate::lexer::{Loc, Tagged};
use crate::log::*;
use crate::types::Type;

#[derive(Debug)]
pub struct CallExpr {
    pub caller: Box<AST>,
    args: Vec<AST>,
}

impl CallExpr {
    pub fn new(caller: Box<AST>, args: Vec<AST>) -> Self {
        Self{ caller, args }
    }

    pub fn gen_code_internal(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext, obj: Option<(&AST, bool)>, obj_value: Option<llvm::ValueRef>) -> Option<llvm::ValueRef> {
        if obj_value.is_some() {
            assert!(
                obj.is_some() && obj_value.is_some(),
                "obj & obj_value need to both be defined"
            );
        }

        let fn_name = Tagged::new(self.loc().clone(), self.caller.get_value());
        let fully_qualified_name = match obj {
            Some(obj) => {
                let struct_name = if obj.1 { obj.0.get_value() } else { obj.0.get_type(scope, ctx).unwrap().get_name() };
                let strct = scope.get_struct(&Tagged::new(obj.0.loc().clone(), struct_name));
                let r#fn = strct.get_function(self.caller.loc(), self.caller.get_value());
                r#fn.name_mangeled.clone()
            }
            None => self.caller.get_value(),
        };
        let mut func: Option<llvm::Function> = ctx.module.get_function(&fully_qualified_name).map(|i| i.into());

        /*
         * FIXME(S):
         * the mecanism for getting type of a function is flawed, breaks when calling member
         * function of type which is located in another struct -> foo.bar.baz();
         */

        let ty = match obj {
            Some(obj) => {
                let struct_name = if obj.1 { obj.0.get_value() } else { obj.0.get_type(scope, ctx).unwrap().get_name() };
                let strct = scope.get_struct(&Tagged::new(obj.0.loc().clone(), struct_name));
                let r#fn = strct.get_function(fn_name.loc(), fn_name.inner());
                r#fn.ret_type.clone()
            }
            None => {
                if scope.has_symbol(fn_name.inner()) {
                    if let Symbol::Function(_) = scope.resolve_symbol(&fn_name) {
                        scope.get_function(&fn_name).ret_type.clone()
                    }else {
                        self.caller.get_type(scope, ctx).unwrap()
                    }
                }else {
                    self.caller.get_type(scope, ctx).unwrap()
                }
            }
        };
        let mut is_ptr = false;
        let r#fn = if let Type::FuncPtr(func_ptr) = &ty {
            let caller_ty = self.caller.get_type(scope, ctx).unwrap();
            let ptr = self.caller.gen_code(scope, ctx).unwrap();
            let load = ctx.builder.create_load(&scope.resolve_type(&caller_ty, ctx), &ptr);
            func = Some(llvm::Function::from(load));
            is_ptr = true;
            let args = func_ptr.params.iter().map(|arg| {
                FunctionArg{ id: Tagged::new(arg.get_loc().clone(), "".to_owned()), typ: arg.clone() }
            }).collect();
            symbol::Function::new(Tagged::new(self.caller.loc().clone(), "".to_owned()), "".to_owned(), args, *func_ptr.ret_type.clone(), true)
        } else {
            match obj {
                Some(obj) => {
                    let struct_name = if obj.1 { obj.0.get_value() } else { obj.0.get_type(scope, ctx).unwrap().get_name() };
                    let strct = scope.get_struct(&Tagged::new(obj.0.loc().clone(), struct_name));
                    strct.get_function(fn_name.loc(), fn_name.inner()).clone()
                }
                None => scope.get_function(&fn_name).clone(),
            }
        };

        if func.is_none() {
            let args: Vec<llvm::TypeRef> = r#fn.args.iter().map(|t| scope.resolve_type(&t.typ, ctx)).collect();
            let fn_type = llvm::FunctionTypeRef::get(scope.resolve_type(&r#fn.ret_type, ctx), &args, false);
            func = Some(llvm::Function::create(fn_type, &r#fn.name_mangeled, &ctx.module));
        }

        if !is_ptr {
            let func = func.as_ref().unwrap();
            if !func.is_var_arg() && func.args().len() != (self.args.len() + if obj_value.is_some() { 1 } else { 0 })
            {
                error_msg_label(
                    format!("function `{}` expected `{}` args, but `{}` were supplied",
                        fn_name.inner(), func.args().len(), self.args.len() + if obj_value.is_some() { 1 } else { 0 }
                    ).as_str(),
                    ErrorLabel::from(self.loc(), "incorrect number of arguments supplied"),
                );
            }
        }

        let mut args: Vec<llvm::ValueRef> = self.args.iter_mut().map(|arg| {
            let arg_ty = arg.get_type(scope, ctx).unwrap();
            let mut val = arg.gen_code(scope, ctx).unwrap();
            if arg.should_load() {
                val = val.try_load(&scope.resolve_type(&arg_ty, ctx), ctx.builder);
            }

            // TODO(S): add try to safely cast args to expected type

            //if allow_implicit_cast(val.get_type(), )

            val
        })
        .collect();

        let is_memeber = obj_value.is_some();
        if let Some(mut obj_value) = obj_value {
            /*
             *  NOTE(S): store `self` in temporary varialbe to deref it
             *  NOTE(S): maybe find a more efficient way to do this?
             *
             */
            let ty = &r#fn.args[0].typ;
            if let Type::Pointer(_) = ty {
                if !obj_value.get_type().is_pointer_ty() {
                    let alloc = ctx.builder.create_alloca(&obj_value.get_type(), None);
                    ctx.builder.create_store(&obj_value, &alloc);
                    obj_value = alloc;
                }
            }
            args.insert(0, obj_value);
        }

        let adder = if is_memeber { 1 } else { 0 };
        let mut iter = adder;
        while iter < r#fn.args.len() && iter < self.args.len() {
            let expected_type = &r#fn.args[iter].typ;
            if !self.args[iter - adder].get_type(scope, ctx).unwrap().matches(expected_type)
            {
                error_msg_labels(
                    format!("invalid argument type for function `{}`", fn_name.inner()).as_str(),
                    &[
                        ErrorLabel::from(self.args[iter - adder].loc(), format!("provided value has type: `{}`", self.args[iter - adder].get_type(scope, ctx).unwrap().get_full_name()).as_str()),
                        ErrorLabel::from(r#fn.args[iter].id.loc(), format!("expected type is: `{}`", expected_type.get_full_name()).as_str()),
                    ]
                );
            }
            iter += 1;
        }

        if is_ptr {
            if let Type::FuncPtr(ptr) = ty {
                let params: Vec<llvm::TypeRef> = ptr
                    .params
                    .iter()
                    .map(|param| scope.resolve_type(param, ctx))
                    .collect();
                let func_ty = llvm::FunctionTypeRef::get(
                    scope.resolve_type(&*ptr.ret_type, ctx),
                    &params,
                    false,
                );
                return Some(ctx.builder.create_ptr_call(
                    &func_ty.into(),
                    &func.unwrap().into(),
                    &args,
                ));
            }
        }
        return Some(ctx.builder.create_call(&func.unwrap().into(), &args));
    }
}

impl Generate for CallExpr {
    fn loc(&self) -> &Loc {
        return self.caller.loc();
    }

    fn get_value(&self) -> String {
        return self.caller.get_value();
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        return self.gen_code_internal(scope, ctx, None, None);
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        let fn_name = Tagged::new(self.loc().clone(), self.caller.get_value());
        let ty = if scope.has_symbol(fn_name.inner()) {
            scope.get_function(&fn_name).ret_type.clone()
        } else {
            self.caller.get_type(scope, ctx).unwrap()
        };
        if let Type::FuncPtr(ptr) = ty {
            return Some(*ptr.ret_type.clone());
        }
        return Some(scope.get_function(&fn_name).ret_type.clone());
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct MemberCallExpr {
    obj: Box<AST>,
    r#fn: Box<AST>,
    deref: bool,
}

impl MemberCallExpr {
    pub fn new(obj: Box<AST>, r#fn: Box<AST>, deref: bool) -> Self {
        Self{ obj, r#fn, deref }
    }
}

impl Generate for MemberCallExpr {
    fn loc(&self) -> &Loc {
        return self.obj.loc();
    }

    fn get_value(&self) -> String {
        return self.obj.get_value();
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let obj_ty = self.obj.get_type(scope, ctx).unwrap();
        let mut obj = self.obj.gen_code(scope, ctx).unwrap();
        if self.deref {
            let obj_type = scope.resolve_type(&obj_ty, ctx);
            let ty = if !obj.get_type().matches(&obj_type) {
                obj_type
            }else {
                scope.resolve_type(obj_ty.get_base().unwrap(), ctx)
            };
            obj = obj.try_load(&ty, ctx.builder);
        }

        /*let struct_name = self.obj.get_type(scope, ctx).unwrap().get_name();
        if let AST::CallExpr(call) = &mut *self.r#fn {
            if let AST::Id(id) = &mut *call.caller {
                *id.id.inner_mut() = struct_name + "_" + id.id.inner();
            }
            return call.gen_code_internal(scope, ctx, Some(&self.obj), Some(obj));
        }*/
        if let AST::CallExpr(call) = &mut *self.r#fn {
            return call.gen_code_internal(scope, ctx, Some((&self.obj, false)), Some(obj));
        }
        unreachable!("fn should allways be of type `callexpr`");
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        let struct_name = self.obj.get_type(scope, ctx).unwrap().get_name();
        let strct = scope.get_struct(&Tagged::new(self.obj.loc().clone(), struct_name));
        let r#fn = strct.get_function(self.r#fn.loc(), self.r#fn.get_value());
        return Some(r#fn.ret_type.clone());
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct ReturnExpr {
    loc: Loc,
    value: Option<Box<AST>>,
}

impl ReturnExpr {
    pub fn new(loc: Loc, value: Option<Box<AST>>) -> Self {
        Self{ loc, value }
    }
}

impl Generate for ReturnExpr {
    fn loc(&self) -> &Loc {
        &self.loc
    }

    fn get_value(&self) -> String {
        "ret".to_owned()
    }

    /*
     *  FIXME!!!!(S): add error if the type of the return value does not match the function sigature
     */

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        if self.value.is_none() {
            if !ctx.current_function.is_null() {
                if let Some(bb) = unsafe{&(*ctx.current_function).ret_block} {
                    ctx.builder.create_br(bb);
                }
            }
            return None;
        }

        if scope.get_return_alloc().is_none() {
            let loc = self.value.as_ref().unwrap().loc();
            error_msg_label(
                format!(
                    "invalid return type `{}` for function with return type `void`",
                    self.value.as_ref().unwrap().get_type(scope, ctx).unwrap().get_full_name()
                ).as_str(),
                ErrorLabel::from(loc, "invalid return type"),
            );
        }

        if !ctx.current_function.is_null() {
            if let AST::InitializerList(list) = &mut **self.value.as_mut().unwrap() {
                let ty = unsafe { ctx.current_function.as_ref().unwrap() }.ret_type.clone();
                list.set_typ(Some(ty));
            }
        }

        let value_ty = self.value.as_ref().unwrap().get_type(scope, ctx).unwrap();
        let mut value = self.value.as_mut().unwrap().gen_code(scope, ctx).unwrap();
        if self.value.as_ref().unwrap().should_load()
        {
            match **self.value.as_ref().unwrap() {
                AST::UnaryExpr(_) => {},
                _ => {
                    value = value.try_load(&scope.resolve_type(&value_ty, ctx), ctx.builder);
                },
            }
        }

        if !ctx.current_function.is_null() {
            if let Some(bb) = unsafe { (*ctx.current_function).ret_block.as_ref() } {
                let store = ctx.builder.create_store(&value, scope.get_return_alloc().unwrap());
                ctx.builder.create_br(bb);
                return Some(store);
            }
        }

        return Some(ctx.builder.create_store(&value, scope.get_return_alloc().unwrap()));
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        None
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}
