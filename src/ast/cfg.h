#ifndef _LYGOS_AST_CFG_H_
#define _LYGOS_AST_CFG_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct IfExpr : public AST {
            AST *cond;
            std::vector<AST*> then_branch;
            std::shared_ptr<std::vector<AST*>> else_branch;
            IfExpr(AST *cond, std::vector<AST*> then_branch, std::shared_ptr<std::vector<AST*>> else_branch): AST(ASTType::IfExpr), cond(cond), then_branch(then_branch), else_branch(else_branch) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct ForExpr : public AST {
            AST *variable;
            AST *iter;
            std::vector<AST *>body;
            ForExpr(AST *variable, AST *iter, std::vector<AST *> body): AST(ASTType::ForExpr), variable(variable), iter(iter), body(body) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_CFG_H_
