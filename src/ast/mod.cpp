#include "mod.h"
#include "function.h"

namespace lygos {
    namespace AST {
        Mod::Mod(): AST(ASTType::Mod) {

        }

        void Mod::Insert(std::vector<Ref<AST>> &elems) {
            VecReplaceAt(body, instr_index, elems);
            IncrInstr();
        }

        void Mod::SetCurrentFunction(Function *func) {
            current_func = func;
        }

        Function *Mod::GetCurrentFunction() {
            return current_func;
        }

        Function *Mod::GetFunction(std::string &name) {
            if(!functions.contains(name))
                Log::Logger::Warn(fmt::format("unknown function `{}`", name));

            return functions.at(name);
        }

        void Mod::AddFunction(Function *func) {
            functions.insert({func->GetName(), func});
        }

        std::string Mod::GetValue() {
            return name;
        }

        llvm::Value *Mod::GenCode(Scope *scope) {
            Scope global{};
            for(const auto &item : body) {
                item->GenCode(&global);
                IncrInstr();
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
