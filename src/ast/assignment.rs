use crate::types::Type;
use crate::lexer::Loc;
use crate::ast::{AST, Generate};
use crate::log::{ErrorLabel, error_msg_labels};

#[derive(Debug)]
pub struct AssignmentExpr {
    loc: Loc,
    lhs: Box<AST>,
    rhs: Box<AST>,
}

impl AssignmentExpr {
    pub fn new(lhs: Box<AST>, rhs: Box<AST>) -> Self {
        Self{ loc: lhs.loc().clone() + rhs.loc().clone(), lhs, rhs }
    }
}

impl Generate for AssignmentExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        &self.loc
    }

    fn get_value(&self) -> String {
        self.lhs.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let var = self.lhs.gen_code(scope, ctx).unwrap();

        if let AST::InitializerList(list) = &mut *self.rhs {
            list.set_typ(self.lhs.get_type(scope, ctx));
        }

        let mut value = self.rhs.gen_code(scope, ctx).unwrap();

        if self.rhs.should_load() {
            value = value.try_load(ctx.builder);
        }

        let lhs_ty = self.lhs.get_type(scope, ctx).unwrap();
        let rhs_ty = self.rhs.get_type(scope, ctx).unwrap();
        if !lhs_ty.matches(&rhs_ty) {
            error_msg_labels("missmatched types", &[
                ErrorLabel::from(self.lhs.loc(), format!("expected type `{}`", lhs_ty.get_full_name()).as_str()),
                ErrorLabel::from(self.rhs.loc(), format!("but value has type `{}`", rhs_ty.get_full_name()).as_str()),
            ]);
        }

        ctx.builder.create_store(&value, &var);
        return Some(var);
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        self.lhs.get_type(scope, ctx)
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}
