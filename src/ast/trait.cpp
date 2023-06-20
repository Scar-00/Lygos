#include "trait.h"
#include "mod.h"

namespace lygos {
    namespace AST {
        namespace Trait {
            Trait::Trait(std::string name, Block functions):
                AST(ASTType::Trait), name(name), functions(functions) {

            }

            std::string Trait::GetValue() {
                return name;
            }

            llvm::Value *Trait::GenCode(Scope *scope) {
                //Log::Logger::Warn("unimplemented [Trait::CodeGen()]");
                return nullptr;
            }

            void Trait::Lower(AST *parent) {
                ast_root->GetCurrentBlock()->Scope().DeclTrait(this);
            }

            void Trait::Sanatize() {

            }
        }
    }
}
