#ifndef _LYGOS_AST_ASSIGNMENT_H_
#define _LYGOS_AST_ASSIGNMENT_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct AssignmentExpr : public AST {
            public:
                AssignmentExpr(Ref<AST> assignee, Ref<AST> value);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> assignee;
                Ref<AST> value;
        };
    }
}

#endif // _LYGOS_AST_ASSIGNMENT_H_
