#ifndef _LYGOS_AST_FUNCTION_H_
#define _LYGOS_AST_FUNCTION_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Function : public AST {
            Function(std::string id, std::vector<AST *> body, Type::Type *return_type, std::vector<std::tuple<std::string, Type::Type *>> params): AST(ASTType::Function), id(id), block(body), return_type(return_type), args(params) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
            std::string id;
            std::vector<AST *> block;
            Type::Type *return_type;
            std::vector<std::tuple<std::string, Type::Type *>> args;
        };

        struct FunctionDecl : public AST {
            std::string id;
            Type::Type *return_type;
            std::vector<std::tuple<std::string, Type::Type *>> params;
            FunctionDecl(std::string id, Type::Type *return_type, std::vector<std::tuple<std::string, Type::Type *>> params): AST(ASTType::FunctionDecl), id(id), return_type(return_type), params(params) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct Closure : public AST {
            std::vector<std::string> args;
            Closure(): AST(ASTType::Closure) {}
        };
    }
}

#endif // _LYGOS_AST_FUNCTION_H_
