use inkwell::values::{AnyValueEnum, BasicValueEnum};
use lazy_static::lazy_static;
use std::collections::HashMap;

use crate::ctx::{get_builder, get_ctx};

#[derive(Debug, PartialEq, Clone)]
pub enum TokenType {
    //types
    String,
    Integer, //any integer
    Float,   //every float is trated as double pres
    Id,
    Char,

    //general
    Equals,
    Arrow,
    Dot,
    Comma,
    Semi,
    Colon,
    Ampercent,
    Hash,
    Dollar,
    Pipe,
    Bang,

    //operators
    OpPlus,
    OpMinus,
    OpMul,
    OpDiv,
    OpMod,

    OpEqEq,
    OpNeEq,
    OpLeEq,
    OpGrEq,
    OpOr,
    OpAnd,

    OpScope,
    OpVarArg,

    BraceLeft,
    BraceRight,
    CurlyLeft,
    CurlyRight,
    AngleLeft,
    AngleRight,
    ParanLeft,
    ParanRight,

    //keywords
    KwLet,
    KwMut,
    KwConst,
    KwStruct,
    KwIf,
    KwElse,
    KwFor,
    KwWhile,
    KwFn,
    KwRet,
    KwIn,
    KwInclude,
    KwImpl,
    KwType,
    KwStatic,
    KwMatch,
    KwTrait,
    KwMacro,
    KwEnum,
    KwSizeOf,

    Eof,
}

lazy_static! {
    #[allow(non_upper_case_globals)]
    pub static ref KeyWords: HashMap<&'static str, TokenType> = {
        let mut map = HashMap::new();
        map.insert("let", TokenType::KwLet);
        map.insert("mut", TokenType::KwMut);
        map.insert("const", TokenType::KwConst);
        map.insert("struct", TokenType::KwStruct);
        map.insert("if", TokenType::KwIf);
        map.insert("else", TokenType::KwElse);
        map.insert("for", TokenType::KwFor);
        map.insert("while", TokenType::KwWhile);
        map.insert("fn", TokenType::KwFn);
        map.insert("return", TokenType::KwRet);
        map.insert("in", TokenType::KwIn);
        map.insert("include", TokenType::KwInclude);
        map.insert("impl", TokenType::KwImpl);
        map.insert("type", TokenType::KwType);
        map.insert("static", TokenType::KwStatic);
        map.insert("match", TokenType::KwStatic);
        map.insert("trait", TokenType::KwStatic);
        map.insert("macro", TokenType::KwStatic);
        map.insert("enum", TokenType::KwStatic);
        map.insert("sizeof", TokenType::KwStatic);

        map
    };
}

pub fn try_get_pointer_base(typ: &inkwell::types::AnyTypeEnum) -> &inkwell::types::AnyTypeEnum {
    if let inkwell::types::AnyTypeEnum::PointerType(ptr) = typ {
        //return inkwell::types::PointerType::;
    }
}

pub fn load<'a>(value: &inkwell::values::AnyValueEnum<'a>) -> inkwell::values::AnyValueEnum<'a> {
    if value.get_type().is_pointer_type() {
        return get_builder()
            .build_load(value.get_type().into_pointer_type().get_element_type(), "")
            .into();
    }
    return *value;
}
