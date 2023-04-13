#include "initializer.h"
#include "../error/log.h"
#include "access.h"
#include "assignment.h"
#include "literals.h"
#include "mod.h"
#include "function.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        InitializerList::InitializerList(Initializers initializers, InitializerList::Kind kind):
            AST(ASTType::InitializerList), kind(kind), initializers(initializers) {

        }

        std::string InitializerList::GetValue() {
            return {};
        }

        Val *InitializerList::GenCode(Scope *scope) {
            Log::Logger::Warn("[InitializerList] codegen");
            return nullptr;
        }

        void InitializerList::Lower(AST *parent) {
            if(parent->type != ASTType::AssignmentExpr)
                return;

            auto assignment = (AssignmentExpr *)parent;

            std::vector<Ref<AST>> assignments;
            for(const auto &[name, value] : initializers) {
                auto lhs = MakeRef<MemberExpr>(assignment->Lhs(), MakeRef<Identifier>(name));
                assignments.push_back(MakeRef<AssignmentExpr>(lhs, value));
            }

            // this should work but i think insert function is brocken
            ast_root->GetCurrentFunction()->Insert(assignments);
            return;
        }

        void InitializerList::Sanatize() {

        }
    }
}
