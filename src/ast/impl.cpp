#include "impl.h"
#include "ast.h"
#include "function.h"
#include "mod.h"
#include "scope.h"
#include "trait.h"
#include <algorithm>
#include <fmt/core.h>
#include <memory>
#include <vector>

namespace lygos {
    namespace AST {
        Impl::Impl(std::string type, Block body, std::vector<Type::Generic> generics, std::string trait):
            AST(ASTType::Impl), type(type), body(body), generics(generics), trait(trait) {

        }

        std::string Impl::GetValue() {
            return type;
        }

        static void ValidateTraitImpl(Impl *impl, Trait::Trait *trait, Scope *scope) {
            if(scope->GetStruct(impl->Type()).ImplementsTrait(trait->GetValue()))
                Log::Logger::Warn(fmt::format("type `{}` already implements `{}`", impl->Type(), trait->GetValue()));
            //TODO: find the excat function(s) that are not implemented and
            //check args/ret type
            /*(for(size_t i = 0; i < trait->Functions().Body().size(); i++) {
                bool found = false;
                for(size_t j = 0; j < impl->Body().size(); j++) {
                    if(((Function *)trait->Functions().Body()[i].get())->GetName() == ((Function *)impl->Body()[j].get())->GetName()) {
                        found = true;
                }
                if(!found)
                    Log::Logger::Warn("trait impl does not implement all functions");
                }
            }
            auto search = [](Ref<AST> fn) {return false;};
            if(std::find_if(impl->Body().begin(), impl->Body().end(), search) != impl->Body().end()) {

            }*/
            //std::mismatch();
        }

        llvm::Value *Impl::GenCode(Scope *scope) {
            auto &strct = scope->GetStruct(type);
            if(trait != "") {
                ValidateTraitImpl(this, &scope->GetTrait(trait), scope);
                strct.RegisterTraitImpl(trait);
            }
            for(const auto &member : body.Body()) {
                member->GenCode(scope);
            }
            return nullptr;
        }

        Ref<Type::Type> Impl::GetType(Scope *scope) { return nullptr; }

        void Impl::Lower(AST *parent) {
            if(parent->type == ASTType::MacroCall)
                return;
            auto &strct = ast_root->GetCurrentBlock()->Scope().GetStruct(type);
            for(const auto &gen : this->generics) {
                if(!strct.generics.contains(gen.name))
                    Log::Logger::Warn(fmt::format("differing generics for type `{}` in impl. `{}`", strct.name, gen.name));
            }

            for(size_t i = 0; i < body.Body().size(); i++) {
                Function *func = (Function*)body.Body()[i].get();
                std::string name_mangeled = {type + "_" + func->GetName()};
                strct.AddFunction({func->GetName(), name_mangeled, func->GetArgs(), func->GetRetType(), func->IsMember()});
                func->GetName() = name_mangeled;
                func->GetMangledName() = name_mangeled;
            }

            LYGOS_ASSERT(parent->type == ASTType::Mod);
            for(size_t i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&((Mod *)parent)->Body());
                body.Body()[i]->Lower(parent);
                body.Increment();
            }
        }

        void Impl::Sanatize() {

        }
    }
}
