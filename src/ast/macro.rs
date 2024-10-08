use crate::types::{Type, Path};
use crate::lexer::{Tagged, Loc, Token};
use crate::ast::{Generate, Scope};
use crate::GenerationContext;

use lazy_static::lazy_static;
use std::collections::HashMap;

type IntrinsicCall = fn(call: &MacroCall, scope: &mut Scope, ctx: &GenerationContext) -> llvm::ValueRef;
lazy_static! {
    pub static ref IntrinsicMarcos: HashMap<&'static str, IntrinsicCall> = {
        let mut map: HashMap<&'static str, IntrinsicCall> = HashMap::new();
        map.insert("format_args", crate::ast::intrinsics::macro_format);
        map.insert("sizeof", crate::ast::intrinsics::macro_sizeof);
        map.insert("file", crate::ast::intrinsics::macro_file);
        map.insert("line", crate::ast::intrinsics::macro_line);
        map.insert("impl_debug", crate::ast::intrinsics::impl_debug);
        map.insert("test_macro", crate::ast::intrinsics::test_macro);

        map
    };
}

#[derive(Debug, PartialEq, Eq, Clone)]
pub enum MacroArgType {
    Single,
    Variadic,
}

#[derive(Debug, Clone)]
pub struct MacroArg {
    pub id: Tagged<String>,
    pub typ: MacroArgType,
}

#[derive(Debug, Clone)]
pub struct MacroArm {
    pub conds: Vec<MacroArg>,
    pub tokens: Vec<Token>
}

#[derive(Debug, Clone)]
pub struct Macro {
    pub id: Tagged<String>,
    pub arms: Vec<MacroArm>,
}

impl Macro {
    pub fn new(id: Tagged<String>, arms: Vec<MacroArm>) -> Self {
        Self{ id, arms }
    }
}

#[derive(Debug)]
pub struct MacroCall {
    pub id: Tagged<String>,
    pub args: Vec<Vec<Token>>,
}

impl MacroCall {
    pub fn new(id: Tagged<String>, args: Vec<Vec<Token>>,) -> Self {
        Self{ id, args }
    }
}

impl Generate for MacroCall {
    fn loc(&self) -> &Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().clone()
    }

    fn gen_code(&mut self, scope: &mut Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        return Some((IntrinsicMarcos.get(self.id.inner().as_str()).unwrap())(self, scope, ctx));
    }

    fn get_type(&self, _: &mut Scope, _: &crate::GenerationContext) -> Option<Type> {
        match self.id.inner().as_str() {
            "format_args" => Some(Type::Path(Path::new(self.id.loc().clone(), "Arguments".into()))),
            "sizeof" => Some(Type::Path(Path::new(self.id.loc().clone(), "size_t".into()))),
            "test_macro" => Some(Type::FuncPtr(crate::types::FuncPtr::new(self.id.loc().clone(), vec![
                Type::Pointer(crate::types::Pointer::new(self.id.loc().clone(), Box::new(Type::Path(Path::new(self.id.loc().clone(), "i8".to_string()))), true, false)),
                Type::Pointer(crate::types::Pointer::new(self.id.loc().clone(), Box::new(Type::Path(Path::new(self.id.loc().clone(), "Formatter".to_string()))), true, false)),
            ], Type::Path(Path::new(self.id.loc().clone(), "u32".into()))))),
            _ => unreachable!(),
        }
    }

    fn collect_symbols(&mut self, _: &mut Scope) {}
}
