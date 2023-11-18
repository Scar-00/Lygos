use crate::types::Type;
use crate::lexer::Tagged;
use crate::ast::{Block, Generate, AST};
use crate::ast::symbol;

#[derive(Debug)]
pub struct Impl {
    pub typ: Tagged<String>,
    pub body: Block,
    pub trat: Option<Tagged<String>>,
}

impl Impl {
    pub fn new(typ: Tagged<String>, body: Block, trat: Option<Tagged<String>>) -> Self {
        Self{ typ, body, trat }
    }
}

impl Generate for Impl {
    fn loc(&self) -> &crate::lexer::Loc {
        self.typ.loc()
    }

    fn get_value(&self) -> String {
        self.typ.inner().to_string()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        /*
         *  TODO(S): create dummy struct in the scope and see if the struct &| trait are resolved
         *  at a later stage -> this can then be moved into `collect_symbols`
         *
         */

        if let Some(t) = &self.trat {
            let strct = scope.get_struct(&self.typ);
            strct.register_trait_impl(t);
        }

        for func in &mut self.body.body {
            if let AST::Function(func) = func {
                func.gen_code(scope, ctx);
            }
        }
        None
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&mut self, scope: &mut super::Scope) {
        for func in &mut self.body.body {
            if let AST::Function(func) = func {
                if let Some(strct) = scope.try_resolve_symbol(&self.typ) {
                    if let symbol::Symbol::Struct(strct) = strct {
                        let mut func_sym: symbol::Function = func.into();
                        func_sym.name_mangeled = strct.name.inner().to_owned() + "_" + func_sym.name.inner();
                        strct.register_function(func_sym);
                        continue;
                    }
                }
                scope.add_symbol(self.typ.inner(), symbol::Symbol::Struct(symbol::Struct::new_dummy(self.typ.clone())));
                let strct = scope.get_struct(&self.typ);
                let mut func_sym: symbol::Function = func.into();
                func_sym.name_mangeled = strct.name.inner().to_owned() + "_" + func_sym.name.inner();
                strct.register_function(func_sym);
            }
        }
    }
}
