#ifndef _LYGOS_AST_CALL_H_
#define _LYGOS_AST_CALL_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct CallExpr : public AST {
            CallExpr(AST *caller, std::vector<AST *> args): AST(ASTType::CallExpr), caller(caller), args(args) {}
            AST *caller;
            std::vector<AST *> args;
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct ReturnExpr : public AST {
            ReturnExpr(AST *value): AST(ASTType::ReturnExpr), value(value) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
            AST *value;
        };
    }
}

#endif // _LYGOS_AST_CALL_H_
