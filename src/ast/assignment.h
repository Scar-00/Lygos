#ifndef _LYGOS_AST_ASSIGNMENT_H_
#define _LYGOS_AST_ASSIGNMENT_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct AssignmentExpr : public AST {
            public:
                AssignmentExpr(Ref<AST> assignee, Ref<AST> value);
                Ref<AST> Lhs() { return assignee; }
                Ref<AST> Rhs() { return value; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> assignee;
                Ref<AST> value;
        };
    }
}

#endif // _LYGOS_AST_ASSIGNMENT_H_
