use crate::lexer::{Tagged, Loc};
use crate::ast::mir::AST;
use crate::{types, types::{Type, Path}};
use crate::ast::{symbol, symbol::Symbol};

#[derive(Debug, Clone)]
pub struct Identifier {
    pub id: Tagged<String>,
    pub deref: bool,
}

impl Identifier {
    pub fn new(id: Tagged<String>) -> Self {
        Self{ id, deref: true }
    }
}

#[derive(Debug)]
pub struct StringLiteral {
    value: Tagged<String>,
}

impl StringLiteral {
    pub fn new(value: Tagged<String>) -> Self {
        Self{ value }
    }
}

#[derive(Debug)]
pub enum NumberType {
    Int,
    Char,
    Float,
    Double,
}

#[derive(Debug)]
pub struct NumberLiteral {
    value: Tagged<String>,
    typ: NumberType,
}

impl NumberLiteral {
    pub fn new(value: Tagged<String>, typ: NumberType) -> Self {
        Self{ value, typ }
    }
}

#[derive(Debug)]
pub struct StaticLiteral {
    id: Tagged<String>,
    typ: Type,
    value: Option<Box<AST>>
}

impl StaticLiteral {
    pub fn new(id: Tagged<String>, typ: Type, value: Option<Box<AST>>) -> Self {
        Self{ id, typ, value }
    }
}

#[derive(Debug)]
pub struct TypeAlias {
    id: Tagged<String>,
    typ: Type,
}

impl TypeAlias {
    pub fn new(id: Tagged<String>, typ: Type) -> Self {
        Self{ id, typ }
    }
}
