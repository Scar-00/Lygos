#pragma once

#include "global.h"
#include "llvm/IR/Type.h"
#include <set>
#include <string>
#include <map>
#include <llvm/IR/Type.h>
#include <unordered_map>

//singed types
typedef double              f64;
typedef float               f32;
typedef long long int       s64;
typedef int                 s32;
typedef short int           s16;
typedef signed char         s8;

//unsigned types
typedef unsigned long long  u64;
typedef unsigned int        u32;
typedef unsigned short      u16;
typedef unsigned char       u8;

enum class TokenType {
    //types
    String,
    Integer,
    Float,
    Id,
    Range,

    //general
    Equals,
    Arrow,
    Dot,
    Comma,
    Semi,
    Colon,
    Ampercent,
    Hash,
    //TypeDef,
    //FunctionType,

    //operators
    OpPlus,
    OpMinus,
    OpMul,
    OpDiv,
    OpMod,

    OpEqEq,
    OpLe,
    OpGr,

    BraceLeft,
    BraceRight,
    CurlyLeft,
    CurlyRight,
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

    Eof,
};

static std::map<std::string, TokenType> KeyWords = {
    {"let", TokenType::KwLet},
    {"mut", TokenType::KwMut},
    {"const", TokenType::KwConst},
    {"struct", TokenType::KwStruct},
    {"if", TokenType::KwIf},
    {"else", TokenType::KwElse},
    {"for", TokenType::KwFor},
    {"while", TokenType::KwWhile},
    {"fn", TokenType::KwFn},
    {"return", TokenType::KwRet},
    {"in", TokenType::KwIn},
    {"include", TokenType::KwInclude},
};

static std::set<std::string> base_types = {
    //signed types
    {"i8"},
    {"i16"},
    {"i32"},
    {"i64"},
    //unsigned types
    {"u8"},
    {"u16"},
    {"u32"},
    {"u64"},

    //floating point types
    {"f32"},
    {"f64"},

    {"void"},
};

/*struct TypeSpec {
    std::string name;
    bool mut;
    bool ptr;
};*/

namespace Type {
    enum Kind {
        path,
        ptr,
    };

    struct Type {
        Kind kind;
    };

    struct Path : public Type {
        public:
        Path(std::string path): path(path) {
            this->kind = Kind::path;
        }
        std::string &GetPath() { return path; }
        private:
        std::string path;
    };

    struct Pointer : public Type {
        public:
        Pointer(Type *type, bool mut): type(type), mut(mut) {
            this->kind = Kind::ptr;
        }
        Type *GetType() { return type; }
        bool IsMut() { return mut; }
        void SetType(Type *type) { this->type = type; }
        private:
        Type* type;
        bool mut;
    };
}
