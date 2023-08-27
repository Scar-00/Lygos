use super::ast::AST::Exprs;

#[derive(Debug)]
pub struct Mod {
    pub body: Exprs,
}

impl Mod {
    pub fn new() -> Self {
        Self { body: Vec::new() }
    }
}
