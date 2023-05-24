#include "impl.h"
#include "function.h"
#include "mod.h"
#include "trait.h"
#include <algorithm>
#include <vector>

namespace lygos {
    namespace AST {
        Impl::Impl(std::string type, Block body, std::string trait):
            AST(ASTType::Impl), type(type), body(body), trait(trait) {

        }

        std::string Impl::GetValue() {
            return type;
        }

        static void ValidateTraitImpl(Impl *impl, Trait::Trait *trait) {
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
            if(trait != "")
                ValidateTraitImpl(this, ast_root->GetTrait(trait));
            for(const auto &member : body.Body()) {
                auto func = (Function *)member.get();
                strct.AddFunction({func->GetName(), {this->type + "_" + func->GetName()}, func->GetArgs(), func->GetRetType()});
                func->GetName() = this->type + "_" + func->GetName();
                member->GenCode(scope);
            }
            return nullptr;
        }

        void Impl::Lower(AST *parent) {
            for(size_t i = 0; i < body.Body().size(); i++) {
                body.Body()[i]->Lower(parent);
                body.Increment();
            }
        }

        void Impl::Sanatize() {

        }
    }
}
