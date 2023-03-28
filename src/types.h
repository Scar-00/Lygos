#pragma once

#include "global.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include <set>
#include <string>
#include <map>
#include <llvm/IR/Type.h>
#include <unordered_map>
#include <unordered_set>
#include <llvm/IR/DerivedTypes.h>
#include <vector>

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
    Range, // 1..10

    //general
    Equals, // =
    Arrow, // ->
    Dot, // .
    Comma, //,
    Semi, // ;
    Colon, // :
    Ampercent, // &
    Hash, // #
    Pipe, // |
    Bang, // !

    //operators
    OpPlus, // +
    OpMinus, // -
    OpMul, // *
    OpDiv, // /
    OpMod, // %

    OpEqEq, // ==
    OpLe, // <
    OpGr, // >

    OpScope, // ::

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
    KwImpl,
    KwType,

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
    {"impl", TokenType::KwImpl},
    {"type", TokenType::KwType},
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

    //empty type
    {"void"},
};

namespace llc {
struct Function {
    bool operator==(const Function &other) { return name == other.name; }
    std::string name;
    llvm::Function *llvm_function;
};

struct StructType {
    std::string name;
    llvm::StructType *llvm_type;
    std::vector<std::string> fields;
    std::vector<Function> functions;
};
}

namespace Type {
    enum Kind {
        path,
        ptr,
        arr,
        function,
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

    struct Array : public Type {
        public:
        Array(Type *type, u32 count): type(type), elems(count) {
            this->kind = Kind::arr;
        }
        Type *GetType() { return type; }
        u32 ElemCount() { return elems; }
        private:
        Type *type;
        u32 elems;
    };

    struct FuncPtr : public Type {
        public:
            FuncPtr(std::vector<Type *> params, Type *ret_type): params(params), return_type(ret_type) {this->kind = Kind::function;}
            std::vector<Type *> &GetParams() { return params; }
            Type *GetRetType() { return return_type; }
        private:
            std::vector<Type *> params;
            Type *return_type;
    };
}
