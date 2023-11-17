use crate::ast::{Block, Generate};
use crate::lexer::{Loc, Tagged};
use crate::types::{Type, Path, Pointer};
use crate::ast::symbol::{Symbol, Struct};
use crate::ast::StructField;

#[derive(Debug)]
pub struct Mod {
    loc: Loc,
    pub body: Block,
}

impl Mod {
    pub fn new() -> Self {
        Self { body: Block::new(), loc: Loc::new("internal".into(), 0, 1) }
    }
}

impl Generate for Mod {
    fn loc(&self) -> &crate::lexer::Loc {
        &self.loc
    }

    fn get_value(&self) -> String { "root".to_owned() }

    fn gen_code(&mut self, _: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        println!("{:#?}", self.body.scope);

        for expr in &mut self.body.body {
            expr.gen_code(&mut self.body.scope, ctx);
        }
        None
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&mut self, _: &mut super::Scope) {
        let chars_ty = Pointer::new(Loc::new("internal".into(), 0, 1), Box::new(Type::Path(Path::new(Loc::new("internal".into(), 0, 1), "i8".to_owned()))), false, false);
        let len_ty = Path::new(Loc::new("internal".into(), 0, 1), "u64".to_owned());
        let fields = vec![
                        StructField{ id: Tagged::new(Loc::new("internal".into(), 0, 1), "".into()), typ: Type::Pointer(chars_ty) },
                        StructField{ id: Tagged::new(Loc::new("internal".into(), 0, 1), "".into()), typ: Type::Path(len_ty) }
        ];
        let strct = Struct::new(Tagged::new(Loc::new("internal".into(), 0, 1), "str".to_owned()), fields);
        self.body.scope.add_symbol("str", Symbol::Struct(strct));

        for expr in &mut self.body.body {
            expr.collect_symbols(&mut self.body.scope);
        }

        self.body.scope.check_structs();
    }
}
