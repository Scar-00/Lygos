#include "mod.h"

namespace lygos {
    namespace AST {
        Mod::Mod(): AST(ASTType::Mod) {

        }

        void Mod::Insert(std::vector<Ref<AST>> &elems) {
            VecInsertAt(body, instr_index - 1, elems);
            instr_index += elems.size();
        }

        void Mod::SetCurrentFunction(Function *func) {
            current_func = func;
        }

        Function *Mod::GetCurrentFunction() {
            return current_func;
        }

        std::string Mod::GetValue() {
            return name;
        }

        llvm::Value *Mod::GenCode(Scope *scope) {
            Scope global{};
            for(const auto &item : body) {
                IncrInstr();
                item->GenCode(&global);
            }
            return nullptr;
        }

        void Mod::Lower(AST *parent) {
            for(u64 i = 0; i < body.size(); i++) {
                IncrInstr();
                body[i]->Lower(this);
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
