#include "trait.h"

namespace lygos {
    namespace AST {
        namespace Trait {
            Trait::Trait(std::string name, std::vector<Ref<Function>> functions):
                AST(ASTType::Trait), name(name), functions(functions) {

            }
        }
    }
}
