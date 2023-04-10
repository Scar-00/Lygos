#include "mod.h"
#include "ast.h"
#include <cstddef>

namespace lygos {
    namespace AST {
        void Mod::Insert(std::vector<Ref<AST>> &elems) {
            VecInsertAt(body, instr_index - 1, elems);
            instr_index += elems.size();
        }

        void Mod::SetCurrentFunction(Ref<Function> &func) {
            current_func = func.get();
        }

        Function *Mod::GetCurrentFunction() {
            return current_func;
        }

        void Mod::Lower() {
            for(const auto &item : body) {
                IncrInstr();
                item->Lower();
            }
        }

        void Mod::Sanatize() {
            LYGOS_ASSERT(name != "" && "Module name cannot be `\"\"`");
            LYGOS_ASSERT(body.size() > 0 && "Empty Module");
            LYGOS_ASSERT(instr_index != 0 && "Failed to lower the ast");
            LYGOS_ASSERT(current_func != NULL && "No Function in Module");
        }
    }
}
