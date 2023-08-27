use super::super::ctx;
use super::ast::AST::{Block, Exprs, Traverse, AST};

struct MemberExpr {
    obj: AST,
    member: AST,
    deref: bool,
    use_index: bool,
    index: usize,
}

impl MemberExpr {
    pub fn new(obj: AST, member: AST, deref: bool) -> Self {
        Self {
            obj,
            member,
            deref,
            use_index: false,
            index: 0,
        }
    }

    pub fn new_index(obj: AST, index: usize) -> Self {
        Self {
            obj,
            member: AST::Invalid,
            deref: false,
            use_index: true,
            index,
        }
    }
}

impl Traverse for MemberExpr {
    fn get_value(&self) -> String {
        return self.obj.get_value();
    }

    fn gen_code<'a>(&self, scope: &mut super::scope::Scope) -> inkwell::values::AnyValueEnum<'a> {
        let mut obj = self.obj.gen_code(scope);
        //if self.deref {}
    }

    fn lower(&self, parent: &mut AST, scope: &mut super::scope::Scope) {}
}
