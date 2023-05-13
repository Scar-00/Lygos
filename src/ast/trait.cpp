#include "trait.h"

namespace lygos {
    namespace AST {
        namespace Trait {
            Trait::Trait(std::string name, std::vector<Ref<Function>> functions):
                AST(ASTType::Trait), name(name), functions(functions) {

            }

            std::string Trait::GetValue() {
                return name;
            }

            llvm::Value *Trait::GenCode(Scope *scope) {
                return nullptr;
            }

            void Trait::Lower(AST *parent) {

            }

            void Trait::Sanatize() {

            }
        }
    }
}
