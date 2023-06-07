#include "initializer.h"
#include "../error/log.h"
#include "access.h"
#include "assignment.h"
#include "ast.h"
#include "call.h"
#include "literals.h"
#include "mod.h"
#include "function.h"
#include "vardecl.h"
#include <memory>

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
            std::vector<Ref<AST>> exprs;
            Ref<AST> lhs_value = nullptr;
            switch(parent->type) {
                case ASTType::AssignmentExpr: {
                    lhs_value = ((AssignmentExpr *)parent)->Lhs();
                } break;
                case ASTType::VarDecl: {
                    auto decl = (VarDecl *)parent;
                    if(!decl->Type().get())
                        Log::Logger::Warn(fmt::format("variable `{}` has to declare type when using initializer list", decl->Id()));
                    exprs.push_back(MakeRef<VarDecl>(decl->Id(), false, decl->Type(), nullptr));
                    lhs_value = MakeRef<Identifier>(decl->Id());
                } break;
                /*case ASTType::ReturnExpr: {
                    auto ret = (ReturnExpr *)parent;
                    ret.
                } break;*/
                default: Log::Logger::Warn("invalid lhs to initializer list");
            }

            LYGOS_ASSERT(lhs_value.get() != nullptr);
            u32 idx = 0;
            for(const auto &[name, value] : initializers) {
                Ref<AST> lhs = name == ""
                    ? std::static_pointer_cast<AST>(MakeRef<MemberExpr>(lhs_value, idx))
                    : std::static_pointer_cast<AST>(MakeRef<MemberExpr>(lhs_value, MakeRef<Identifier>(name), false));
                idx++;
                exprs.push_back(MakeRef<AssignmentExpr>(lhs, value));
            }

            ast_root->Replace(exprs);
            return;
        }

        void InitializerList::Sanatize() {

        }
    }
}
