#ifndef _LYGOS_AST_BINOP_H_
#define _LYGOS_AST_BINOP_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct UnaryExpr : public AST {
            UnaryExpr(AST *obj, std::string op): AST(ASTType::UnaryExpr), obj(obj), op(op) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
            AST *obj;
            std::string op;
        };

        struct CastExpr : public AST {
            Type::Type *target_type;
            AST *obj;
            CastExpr(AST *obj, Type::Type *target_type): AST(ASTType::CallExpr), target_type(target_type), obj(obj) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct BinaryExpr : public AST {
            AST *lhs, *rhs;
            std::string op;
            BinaryExpr(AST *lhs, AST *rhs, std::string op): AST(ASTType::BinaryExpr), lhs(lhs), rhs(rhs), op(op) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_BINOP_H_
