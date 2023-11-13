use crate::types::Type;
use crate::lexer::{Tagged, Loc};
use crate::ast::{AST, FunctionArg, Generate, symbol, symbol::Symbol};
use crate::log::*;

#[derive(Debug)]
pub struct CallExpr {
    pub caller: Box<AST>,
    args: Vec<AST>,
}

impl CallExpr {
    pub fn new(caller: Box<AST>, args: Vec<AST>) -> Self {
        Self{ caller, args }
    }

    fn gen_code_internal(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext, obj: Option<&AST>, obj_value: Option<llvm::ValueRef>) -> Option<llvm::ValueRef> {
        if obj.is_some() || obj_value.is_some() {
            assert!(obj.is_some() && obj_value.is_some(), "obj & obj_value need to both be defined");
        }

        let fn_name = Tagged::new(self.loc().clone(), self.caller.get_value());
        let mut func: Option<llvm::Function> = ctx.module.get_function(&fn_name.inner()).map(|i| i.into());

        /*
         * FIXME(S):
         * the mecanism for getting type of a function is flawed, breaks when calling memeber
         * function of type which is located in another struct -> foo.bar.baz();
         *
         */

        let ty = if scope.has_symbol(fn_name.inner()) {
            if let Symbol::Function(_) = scope.resolve_symbol(&fn_name) {
                scope.get_function(&fn_name).ret_type.clone()
            }else {
                self.caller.get_type(scope, ctx).unwrap()
            }
        }else {
            self.caller.get_type(scope, ctx).unwrap()
        };
        let mut is_ptr = false;
        let r#fn = if let Type::FuncPtr(func_ptr) = ty {
            let ptr = self.caller.gen_code(scope, ctx).unwrap();
            func = Some(llvm::Function::from(ctx.builder.create_load(&ptr.get_type().get_base().expect("this should be a pointer by now"), &ptr)));
            is_ptr = true;
            let args = func_ptr.params.iter().map(|arg| {
                FunctionArg{ id: Tagged::new(arg.get_loc().clone(), "".to_owned()), typ: arg.clone() }
            }).collect();
            symbol::Function::new(Tagged::new(self.caller.loc().clone(), "".to_owned()), "".to_owned(), args, *func_ptr.ret_type, true)
        }else {
            scope.get_function(&fn_name).clone()
        };

        if func.is_none() {
            error_msg_label(format!("unknown function `{}`", self.caller.get_value()).as_str(),
                            ErrorLabel::from(self.loc(), "unknown function")
                            );
        }

        if !is_ptr {
            let func = func.as_ref().unwrap();
            if !func.is_var_arg() && func.args().len() != (self.args.len() + if obj_value.is_some() { 1 } else { 0 }) {
                error_msg_label(
                    format!("function `{}` expected `{}` args, but `{}` were supplied",
                        fn_name.inner(), func.args().len(), self.args.len()
                    ).as_str(),
                    ErrorLabel::from(self.loc(), "incorrect number of arguments supplied"),
                );
            }
        }

        let mut args: Vec<llvm::ValueRef> = self.args.iter_mut().map(|arg| {
            let mut val = arg.gen_code(scope, ctx).unwrap();
            if arg.should_load() {
                val = val.try_load(ctx.builder);
            }

            //add try to safely cast args to expected type

            val
        }).collect();

        if let Some(mut obj_value) = obj_value {
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

        let adder = if obj.is_some() { 1 } else { 0 };
        let mut iter = adder;
        while iter < r#fn.args.len() && iter < self.args.len() {
            let expected_type = &r#fn.args[iter].typ;
            if !self.args[iter - adder].get_type(scope, ctx).unwrap().matches(expected_type) {
                error_msg_labels(
                    format!("invalid argument type for function `{}`", fn_name.inner()).as_str(),
                    &[
                        ErrorLabel::from(self.args[iter - adder].loc(), format!("provided value has type: `{}`", self.args[iter - adder].get_type(scope, ctx).unwrap().get_full_name()).as_str()),
                        ErrorLabel::from(r#fn.args[iter - adder].id.loc(), format!("expected type is: `{}`", expected_type.get_full_name()).as_str()),
                    ]
                );
            }

            //typecheck this shit
            iter += 1;
        }

        if is_ptr {
            let typ = &self.caller.get_type(scope, ctx).unwrap();
            let ty = scope.resolve_type(typ, ctx);
            return Some(ctx.builder.create_ptr_call(&ty.get_base().unwrap(), &func.unwrap().into(), &args));
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
        let ty = if scope.has_symbol(fn_name.inner()) { scope.get_function(&fn_name).ret_type.clone() } else { self.caller.get_type(scope, ctx).unwrap() };
        if let Type::FuncPtr(ptr) = ty {
            return Some(*ptr.ret_type.clone());
        }
        return Some(scope.get_function(&fn_name).ret_type.clone());
    }

    fn collect_symbols(&self, _: &mut super::Scope) {

    }
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
        let mut obj = self.obj.gen_code(scope, ctx).unwrap();
        if self.deref {
            obj = obj.try_load(ctx.builder);
        }

        let struct_name = self.obj.get_type(scope, ctx).unwrap().get_name();
        if let AST::CallExpr(call) = &mut *self.r#fn {
            if let AST::Id(id) = &mut *call.caller {
                *id.id.inner_mut() = struct_name + "_" + id.id.inner();
            }
            return call.gen_code_internal(scope, ctx, Some(&self.obj), Some(obj));
        }
        assert!(false, "fn should allways be of type `callexpr`");
        None
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        return self.r#fn.get_type(scope, ctx);
    }

    fn collect_symbols(&self, _: &mut super::Scope) {

    }
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

    fn get_value(&self) -> String { "ret".to_owned() }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        if self.value.is_none() {
            if !ctx.current_function.is_null() {
                if let Some(bb) = unsafe{&(*ctx.current_function).ret_block} {
                    ctx.builder.create_br(bb);
                }
            }
            return None;
        }

        let mut value = self.value.as_mut().unwrap().gen_code(scope, ctx).unwrap();
        if self.value.as_ref().unwrap().should_load() {
            value = value.try_load(ctx.builder);
        }

        if scope.get_return_alloc().is_none() {
            let loc = self.value.as_ref().unwrap().loc().clone();
            error_msg_label(
                format!("invalid return type `{}` for function with return type `void`", self.value.as_ref().unwrap().get_type(scope, ctx).unwrap().get_full_name()).as_str(),
                ErrorLabel::new(loc.file.to_str().unwrap(), loc.start..loc.end, "invalid return type")
            );
        }

        if !ctx.current_function.is_null()  {
            if let Some(bb) = unsafe{(*ctx.current_function).ret_block.as_ref()} {
                let store = ctx.builder.create_store(&value, scope.get_return_alloc().unwrap());
                ctx.builder.create_br(bb);
                return Some(store);
            }
        }

        return Some(ctx.builder.create_store(&value, scope.get_return_alloc().unwrap()));
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&self, _: &mut super::Scope) {
    }
}