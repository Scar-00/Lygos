use crate::lexer::{Tagged, Loc};
use crate::ast::{AST, Generate};
use crate::types::{Type, Path};
use crate::log::{ErrorLabel, error_msg_label, error_msg_labels};

#[derive(Debug)]
pub struct BinaryExpr {
    loc: Loc,
    pub lhs: Box<AST>,
    pub rhs: Box<AST>,
    pub op: Tagged<String>,
}

impl BinaryExpr {
    pub fn new(lhs: Box<AST>, rhs: Box<AST>, op: Tagged<String>) -> Self {
        Self{ loc: lhs.loc().clone() + rhs.loc().clone() , lhs, rhs, op }
    }
}

impl Generate for BinaryExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        &self.loc
    }

    fn get_value(&self) -> String {
        self.lhs.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let mut lhs = self.lhs.gen_code(scope, ctx).unwrap();
        let mut rhs = self.rhs.gen_code(scope, ctx).unwrap();

        if self.lhs.should_load() {
            lhs = lhs.try_load(ctx.builder);
        }

        if self.rhs.should_load() {
            rhs = rhs.try_load(ctx.builder);
        }

        let lhs_ty = self.lhs.get_type(scope, ctx).unwrap();
        let rhs_ty = self.rhs.get_type(scope, ctx).unwrap();
        if !lhs_ty.matches(&rhs_ty) {
            error_msg_labels(
                format!("invalid operant to binary operator `{}`", self.op.inner()).as_str(), &[
                    ErrorLabel::from(self.lhs.loc(), format!("left hand side has type `{}`", lhs_ty.get_full_name())),
                    ErrorLabel::from(self.rhs.loc(), format!("right hand side has type `{}`", rhs_ty.get_full_name())),
                ]
            )
        }

        return match self.op.inner().as_str() {
            "+" => Some(ctx.builder.create_add(&lhs, &rhs)),
            "-" => Some(ctx.builder.create_sub(&lhs, &rhs)),
            "*" => Some(ctx.builder.create_mul(&lhs, &rhs)),
            "/" => Some(ctx.builder.create_div(&lhs, &rhs)),
            "%" => Some(ctx.builder.create_rem(&lhs, &rhs)),
            "==" => Some(ctx.builder.create_icmp_eq(&lhs, &rhs)),
            "!=" => Some(ctx.builder.create_icmp_ne(&lhs, &rhs)),
            "<" => Some(ctx.builder.create_icmp_slt(&lhs, &rhs)),
            "<=" => Some(ctx.builder.create_icmp_sle(&lhs, &rhs)),
            ">" => Some(ctx.builder.create_icmp_sgt(&lhs, &rhs)),
            ">=" => Some(ctx.builder.create_icmp_sge(&lhs, &rhs)),
            _ => error_msg_label(
                    format!("unknown binary operator `{}`", self.op.inner()).as_str(),
                    ErrorLabel::from(&self.op.loc(), "unknown binary operator"),
            ),
        };
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        match self.op.inner().as_str() {
            "==" | "!=" | "<" | ">" | "<=" | ">=" => return Some(Type::Path(Path::new(self.loc.clone(), "bool".to_owned()))),
            _ => self.lhs.get_type(scope, ctx),
        }
    }

    fn collect_symbols(&self, _scope: &mut super::Scope) {}
}
