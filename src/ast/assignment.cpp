#include "assignment.h"

namespace lygos {
    namespace AST {
        AssignmentExpr::AssignmentExpr(Ref<AST> assignee, Ref<AST> value):
            AST(ASTType::AssignmentExpr), assignee(assignee), value(value) {

        }

        std::string AssignmentExpr::GetValue() {
            return assignee->GetValue();
        }

        llvm::Value *AssignmentExpr::GenCode(Scope *scope) {
            auto var = assignee->GenCode(scope);
            auto val = value->GenCode(scope);

            //std::cout << assignee->GetValue() << "\n";
            //std::cout << PrintValue(val) << "\n";
            if(ShouldLoad(value.get()))
                val = LoadOrIgnore(val);

            //type check

            builder->CreateStore(val, var);
            return var;
        }

        void AssignmentExpr::Lower(AST *parent) {
            assignee->Lower(this);
            value->Lower(this);
        }

        void AssignmentExpr::Sanatize() {

        }
    }
}
