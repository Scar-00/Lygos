use crate::types::Type;
use crate::lexer::Tagged;
use crate::ast::{Block, Generate};
use crate::ast::{symbol, symbol::Symbol};
use crate::types::containers::Pointer;

#[derive(Debug)]
pub struct Trait {
    pub id: Tagged<String>,
    pub funcs: Block,
}

impl Trait {
    pub fn new(id: Tagged<String>, funcs: Block) -> Self {
        Self{ id, funcs }
    }
}

impl Generate for Trait {
    fn loc(&self) -> &crate::lexer::Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().to_string()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, _: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        scope.add_symbol(self.id.inner().clone(), Symbol::Trait(symbol::Trait::new(Pointer::from(self))));
        None
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&self, _: &mut super::Scope) {}
}
