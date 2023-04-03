#ifndef _LYGOS_AST_ACCESS_H_
#define _LYGOS_AST_ACCESS_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct MemberExpr : public AST {
            AST *obj;
            AST *property;
            MemberExpr(AST *obj, AST *property): AST(ASTType::MemberExpr), obj(obj), property(property) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct AccessExpr : public AST {
            AccessExpr(AST *obj, AST *index): AST(ASTType::AccessExpr), obj(obj), index(index) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
            AST *obj;
            AST *index;
        };

        struct ResolutionExpr : public AST {
            AST *obj;
            AST *member;
            ResolutionExpr(AST *obj, AST *member): AST(ASTType::ResolutionExpr), obj(obj), member(member) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_ACCESS_H_
