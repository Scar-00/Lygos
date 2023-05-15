#include "mod.h"
#include "function.h"
#include "macro.h"

namespace lygos {
    namespace AST {
        Mod::Mod(): AST(ASTType::Mod) {

        }

        void Mod::Insert(Ref<AST> &expr) {
            current_block->Insert(expr);
        }

        void Mod::Insert(Block::Content &exprs) {
            current_block->Insert(exprs);
        }

        void Mod::Replace(Ref<AST> &expr) {
            current_block->Replace(expr);
        }

        void Mod::Replace(Block::Content &exprs) {
            assert(current_block && "???");
            current_block->Replace(exprs);
        }

        void Mod::SetCurrentBlock(Block *block) {
            current_block = block;
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

        void Mod::DeclMacro(Macro *macro) {
            if(macros.contains(macro->GetName()))
                Log::Logger::Warn(fmt::format("cannot redeclare macro `{}`", macro->GetName()));
            macros.insert({macro->GetName(), macro});
        }

        Macro *Mod::GetMacro(std::string &name) {
            if(!macros.contains(name))
                Log::Logger::Warn(fmt::format("cannot find macro named `{}`", name));
            return macros.at(name);
        }

        std::string Mod::GetValue() {
            return name;
        }

        llvm::Value *Mod::GenCode(Scope *scope) {
            Scope global{};
            for(const auto &item : body.Body()) {
                item->GenCode(&global);
            }
            return nullptr;
        }

        void Mod::Lower(AST *parent) {
            for(u64 i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&body);
                body.Body()[i]->Lower(this);
                body.Increment();
            }
        }

        void Mod::Sanatize() {
            LYGOS_ASSERT(name != "" && "Module name cannot be `\"\"`");
            LYGOS_ASSERT(body.Body().size() > 0 && "Empty Module");
            LYGOS_ASSERT(current_func != NULL && "No Function in Module");
        }
    }
}
