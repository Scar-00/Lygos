use crate::types::Type;
use crate::lexer::{Tagged, Lexer, Token};
use crate::ast::Generate;
use crate::ast::symbol::{Symbol, Struct, Enum};

#[derive(Debug, Clone)]
pub struct StructField {
    pub id: Tagged<String>,
    pub typ: Type,
}

#[derive(Debug)]
pub struct StructDef {
    id: Tagged<String>,
    fields: Vec<StructField>,
}

impl StructDef {
    pub fn new(id: Tagged<String>, fields: Vec<StructField>) -> Self {
        Self{ id, fields }
    }

    pub fn generate_formatter(&self) -> Vec<Token> {
        let mut formatting_function = format!("
            impl Debug for {} {{
                fn fmt_debug(&self, fmt: &mut Formatter) -> FormattingError {{
                    let mut debug = fmt.debug_struct(\"{}\");", self.id.inner(), self.id.inner());
        for field in &self.fields {
            formatting_function += match &field.typ {
                Type::Path(_) => format!("debug.field(\"{}\", format_args$(\"{{:?}}\", self.{}));", field.id.inner(), field.id.inner()),
                Type::Pointer(ptr) => format!("
                    if self.{} != (:*{})0 {{
                        debug.field(\"{}\", format_args$(\"{{:?}}\", self.{}));
                    }}
                ", field.id.inner(), ptr.typ.get_full_name(), field.id.inner(), field.id.inner()),
                Type::Array(_) => format!(""),
                _ => format!(""),
            }.as_str();
        }
        formatting_function += "debug.finish();}}";

        let mut lexer = Lexer::from(&formatting_function, &"internal".into());
        return lexer.get_tokens();
    }
}

impl Generate for StructDef {
    fn loc(&self) -> &crate::lexer::Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().to_string()
    }

    fn gen_code(&mut self, _scope: &mut super::Scope, _ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        return None;
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&mut self, scope: &mut super::Scope) {
        if let Some(strct) = scope.try_resolve_symbol(&self.id) {
            if let Symbol::Struct(strct) = strct {
                strct.resolve(self.id.clone(), self.fields.clone());
            }
        }else {
            let r#struct = Struct::new(self.id.clone(), self.fields.clone());
            scope.add_symbol(self.id.inner(), Symbol::Struct(r#struct));
        }
    }
}

#[derive(Debug)]
pub struct EnumDef {
    id: Tagged<String>,
    variants: Vec<String>,
    typ: Type,
}

impl EnumDef {
    pub fn new(id: Tagged<String>, variants: Vec<String>, typ: Type) -> Self {
        Self{ id, variants, typ }
    }
}

impl Generate for EnumDef {
    fn loc(&self) -> &crate::lexer::Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().to_string()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, _ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        return None;
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> { None }

    fn collect_symbols(&mut self, scope: &mut super::Scope) {
        scope.add_symbol(self.id.inner().clone(), Symbol::Enum(Enum::new(self.id.clone(), self.variants.clone(), self.typ.clone())));
    }
}
