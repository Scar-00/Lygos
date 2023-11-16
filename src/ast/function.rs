use crate::types::{Type, containers, FuncPtr};
use crate::lexer::{Tagged, Loc};
use crate::ast::{symbol, Impl, symbol::{Symbol, Variable}, Block, Generate};

#[derive(Debug, Clone)]
pub struct FunctionArg {
    pub id: Tagged<String>,
    pub typ: Type,
}

#[derive(Debug)]
pub struct Function {
    id: Tagged<String>,
    name_mangeled: String,
    obj: Option<Impl>,
    args: Vec<FunctionArg>,
    body: Block,
    pub ret_type: Type,
    is_def: bool,
    is_var_arg: bool,
    pub ret_block: Option<llvm::BasicBlock>,
}

impl Function {
    pub fn new(id: Tagged<String>, obj: Option<Impl>, args: Vec<FunctionArg>, body: Block, ret_type: Type, is_def: bool, is_var_arg: bool) -> Self {
        Self{ id: id.clone(), name_mangeled: id.inner().to_string(), obj, args, body, ret_type, is_def, is_var_arg, ret_block: None }
    }
}

impl Generate for Function {
    fn loc(&self) -> &crate::lexer::Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().clone()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        self.body.scope.set_parent(scope);

        if let Some(obj) = &self.obj {
            self.name_mangeled = obj.typ.inner().to_owned() + "_" + self.id.inner();
        }

        let func = ctx.module.get_function(&self.name_mangeled).unwrap_or_else(|| {
            let mut params = Vec::new();
            for param in &self.args {
                params.push(self.body.scope.resolve_type(&param.typ, ctx));
            }

            let fn_type = llvm::FunctionTypeRef::get(self.body.scope.resolve_type(&self.ret_type, ctx), &params, self.is_var_arg);

            return llvm::Function::create(fn_type, &self.name_mangeled, &ctx.module);
        });

        scope.add_symbol(self.name_mangeled.clone(), Symbol::Function(symbol::Function::new(self.id.clone(), self.name_mangeled.clone(), self.args.clone(), self.ret_type.clone(), self.is_def)));


        if !self.is_def {
            return None;
        }

        let bb = llvm::BasicBlock::new(&ctx.ctx, "", Some(&func), None);
        ctx.builder.set_insert_point(&bb);

        for i in 0..func.args().len() {
            let arg = &func.args()[i];
            let alloca = ctx.builder.create_alloca(&arg.get_type(), None);
            ctx.builder.create_store(arg, &alloca);
            self.body.scope.add_symbol(self.args[i].id.inner(), Symbol::Variable(Variable::new(self.args[i].id.loc().clone(), self.args.get(i).unwrap().typ.clone(), alloca, false)));
        }

        /*for (i, arg) in func.args().iter().enumerate() {
            let alloca = ctx.builder.create_alloca(&arg.get_type(), None);
            ctx.builder.create_store(arg, &alloca);
            self.body.scope.add_symbol(self.args[i].id.inner(), Symbol::Variable(Variable::new(self.args.get(i).unwrap().typ.clone(), alloca, false)));
        }*/

        let create_alloc = if let Type::Path(path) = &self.ret_type {
            if path.path == "void" {
                false
            }else { true }
        }else { true };

        if create_alloc {
            self.body.scope.set_return_alloc(ctx.builder.create_alloca(&self.body.scope.resolve_type(&self.ret_type, ctx), None));
        }

        unsafe{ containers::to_mut(ctx).current_function = self as *mut Function };
        for expr in &mut self.body.body {
            expr.gen_code(&mut self.body.scope, ctx);
        }

        if let Some(bb) = &self.ret_block {
            ctx.builder.set_insert_point(bb);
        }

        if let Some(alloc) = self.body.scope.get_return_alloc() {
            ctx.builder.create_ret(Some(&alloc.try_load(ctx.builder)));
        }else {
            ctx.builder.create_ret(None);
        }

        func.verify();
        None
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&self, _scope: &mut super::Scope) {}
}

impl Into<symbol::Function> for &Function {
    fn into(self) -> symbol::Function {
        symbol::Function::new(self.id.clone(),
                                self.name_mangeled.clone(),
                                self.args.clone(),
                                self.ret_type.clone(),
                                self.is_def
                            )
    }
}

impl Into<symbol::Function> for &mut Function {
    fn into(self) -> symbol::Function {
        symbol::Function::new(self.id.clone(),
                                self.name_mangeled.clone(),
                                self.args.clone(),
                                self.ret_type.clone(),
                                self.is_def
                            )
    }
}

#[derive(Debug)]
pub struct ClosureExpr {
    loc: Loc,
    inner: Function,
}

impl ClosureExpr {
    pub fn new(loc: Loc, inner: Function) -> Self {
        Self{ loc, inner }
    }
}

impl Generate for ClosureExpr {
    fn loc(&self) -> &Loc {
        &self.loc
    }

    fn get_value(&self) -> String { "closure".to_owned() }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let refs: Vec<llvm::TypeRef> = self.inner.args.iter().map(|i| {
            scope.resolve_type(&i.typ, ctx)
        }).collect();

        let ty = llvm::FunctionTypeRef::get(scope.resolve_type(&self.inner.ret_type, ctx), &refs, false);
        let func = llvm::Function::create(ty, "", ctx.module);
        self.inner.gen_code(scope, ctx);
        return Some(func.into());
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        let arg_tys = self.inner.args.iter().map(|i| {
            i.typ.clone()
        }).collect();
        return Some(Type::FuncPtr(FuncPtr::new(self.loc.clone(), arg_tys, self.inner.ret_type.clone())));
    }

    fn collect_symbols(&self, _: &mut super::Scope) {}
}
