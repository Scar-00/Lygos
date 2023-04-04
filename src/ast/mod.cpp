#include "mod.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;

        std::string Program::GetValue() {
            return mod->getName().str();
        }

        Val *Program::GenCode(Scope *scope) {
            Val *curr;
            Scope global{};
            for(auto node : body) {
                curr = node->GenCode(&global);
            }
            return curr;
        }
    }
}
