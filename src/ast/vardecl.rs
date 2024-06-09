use crate::types::Type;
use crate::lexer::Tagged;
use crate::ast::{AST, Generate};
use crate::ast::symbol::{Symbol, Variable};

#[derive(Debug)]
pub struct VarDecl {
    id: Tagged<String>,
    cnst: bool,
    typ: Option<Type>,
    value: Option<Box<AST>>,
}

impl VarDecl {
    pub fn new(id: Tagged<String>, cnst: bool, typ: Option<Type>, value: Option<Box<AST>>) -> Self {
        Self{ id, cnst, typ, value }
    }
}

impl Generate for VarDecl {
    fn loc(&self) -> &crate::lexer::Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().clone()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        if let Some(value) = &mut self.value {
            if let AST::InitializerList(list) = &mut **value {
                list.set_typ(self.typ.clone());
            }

            let value_ty = value.get_type(scope, ctx).unwrap();
            let mut val = value.gen_code(scope, ctx).unwrap();
            if value.should_load() {
                val = val.try_load(&scope.resolve_type(&value_ty, ctx), ctx.builder);
            }

            if let Some(ty) = &self.typ {
                let typ = scope.resolve_type(ty, ctx);
                val = ctx.builder.create_cast(
                    crate::ast::get_cast_ops(value.loc(), &val.get_type(), &ty.get_loc(), &typ), &val, &typ);
            }

            let ty = if let Some(ty) = &self.typ { ty.clone() } else { value.get_type(scope, ctx).unwrap() };

            let alloca = ctx.builder.create_alloca(&val.get_type(), None);
            ctx.builder.create_store(&val, &alloca);
            scope.add_symbol(self.id.inner(), Symbol::Variable(Variable::new(self.id.loc().clone(), ty, alloca.clone(), self.cnst)));
            return Some(alloca);
        }else {
            let alloca = ctx.builder.create_alloca(&scope.resolve_type(self.typ.as_ref().unwrap(), ctx), None);
            scope.add_symbol(self.id.inner(), Symbol::Variable(Variable::new(self.id.loc().clone(), self.typ.as_ref().unwrap().clone(), alloca.clone(), self.cnst)));
            return Some(alloca);
        }
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        None
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}
