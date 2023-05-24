#ifndef _LYGOS_TYPES_H_
#define _LYGOS_TYPES_H_

#include "llvm.h"
#include <tuple>
#include <unordered_map>

template<typename T>
using Ref = std::shared_ptr<T>;

#include <map>
#include <set>
#include <string>
#include <vector>

namespace lygos {
    #define STRINGIFY(type) #type

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
        Char,
        //Range, // 1..10

        //general
        Equals, // =
        Arrow, // ->
        Dot, // .
        Comma, //,
        Semi, // ;
        Colon, // :
        Ampercent, // &
        Hash, // #
        Dollar, // $
        Pipe, // |
        Bang, // !

        //operators
        OpPlus, // +
        OpMinus, // -
        OpMul, // *
        OpDiv, // /
        OpMod, // %

        OpEqEq, // ==
        OpNeEq, // !=
        OpLeEq, // <=
        OpGrEq, // >=
        OpOr, // ||
        OpAnd, // &&

        OpScope, // ::
        OpVarArg, // ...

        BraceLeft,
        BraceRight,
        CurlyLeft,
        CurlyRight,
        AngleLeft, // <
        AngleRight, // >
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
        {"static", TokenType::KwStatic},
        {"match", TokenType::KwMatch},
        {"trait", TokenType::KwTrait},
        {"macro", TokenType::KwMacro},
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

        {"bool"},

        //empty type
        {"void"},
    };

    std::string PrintType(llvm::Type *type);
    std::string PrintValue(llvm::Value *val);
    llvm::Type *ResolveType(std::string &type);

    /*! @brief
    *  Checks if the llvm::Type* is a pointer. If it is a pointer it
    *  returns the contained type, otherwise it just returns the type
    *
    *  @param[in] type The type you want to try and convert.
    *  @return the contained type or itself
     */
    llvm::Type *TryGetPointerBase(llvm::Type *type);

    /*! @brief
    *  Checks if the llvm::Type* is a pointer. If it is a pointer it
    *  returns the contained type, otherwise it just returns the type
    *
    *  @param[in] value The type you want to try and convert.
    *  @return the contained type or itself
    */
    llvm::Value *LoadOrIgnore(llvm::Value *value);
    llvm::Instruction::CastOps GetCastOp(llvm::Type *src, llvm::Type *dest);
    bool IsCastable(llvm::Type *src, llvm::Type *dest);
    llvm::Value *TryCast(llvm::Value *val, llvm::Type *dest);
    bool IsFunctionType(llvm::Type *type);
    bool IsArrayType(llvm::Type *type);
    bool IsStructType(llvm::Type *type);
    std::string &MangleName(std::string &name, std::string &obj, std::string &spec);

    namespace Type {
        struct Generic {
            std::string name;
            std::vector<Ref<struct Type>> constraints;
        };

        struct Variable {
            Ref<struct Type> type;
            llvm::AllocaInst *alloca;
        };

        struct Function {
            bool operator==(const Function &other) { return name == other.name; }
            std::string name;
            std::string name_mangeled;
            std::vector<std::tuple<std::string, Ref<struct Type>>> args;
            Ref<struct Type> ret_type;
        };

        struct StructType {
            std::string name;
            llvm::StructType *llvm_type;
            std::vector<std::string> fields;
            std::unordered_map<std::string, Function> functions;
            std::unordered_map<std::string, Generic> generics;
            std::set<std::string> traits;
            void AddFunction(Function function);
            Function GetFunction(std::string name);
            void RegisterTraitImpl(std::string trait);
            bool ImplementsTrait(std::string trait) { return traits.contains(trait); }
        };

        struct Macro {
            std::string name;
        };

        enum Kind {
            path,
            ptr,
            arr,
            function,
            trait,
        };

        struct Type {
            Kind kind;
            bool Matches(Ref<Type> other);
            std::string &GetName();
        };

        struct Path : public Type {
        public:
            Path(std::string path): path(path) {
                this->kind = Kind::path;
            }
            std::string &GetPath() { return path; }
            std::vector<Ref<Type>> &GetArgs() { return args; }
        private:
            std::string path;
            std::vector<Ref<Type>> args;
        };

        struct Pointer : public Type {
        public:
            Pointer(Ref<Type> type, bool mut, bool is_ref = false): type(type), is_ref(is_ref), mut(mut) {
                this->kind = Kind::ptr;
            }
            Ref<Type> GetType() { return type; }
            bool IsMut() { return mut; }
            bool IsRef() { return is_ref; }
            void SetType(Ref<Type> type) { this->type = type; }
        private:
            Ref<Type> type;
            bool is_ref;
            bool mut;
        };

        struct Array : public Type {
        public:
            Array(Ref<Type> type, u32 count): type(type), elems(count) {
                this->kind = Kind::arr;
            }
            Ref<Type> GetType() { return type; }
            u32 ElemCount() { return elems; }
        private:
            Ref<Type> type;
            u32 elems;
        };

        struct FuncPtr : public Type {
        public:
            FuncPtr(std::vector<Ref<Type>> params, Ref<Type> ret_type): params(params), return_type(ret_type) {this->kind = Kind::function;}
            std::vector<Ref<Type>> &GetParams() { return params; }
            Ref<Type> GetRetType() { return return_type; }
        private:
            std::vector<Ref<Type>> params;
            Ref<Type> return_type;
        };

        /*struct Trait : public Type {
            public:
                Trait(std::string name): name(name) {this->kind = Kind::trait;}
                std::string &GetName() { return name; }
            private:
                std::string name;
        };*/
    }
}

#endif // _LYGOS_TYPES_H_
