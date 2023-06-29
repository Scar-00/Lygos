#include "mod.h"
#include "function.h"
#include "macro.h"
#include "trait.h"

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

        std::string Mod::GetValue() {
            return name;
        }

        llvm::Value *Mod::GenCode(Scope *scope) {
            for(const auto &item : body.Body()) {
                item->GenCode(&body.Scope());
            }
            return nullptr;
        }

        Ref<Type::Type> Mod::GetType(Scope *scope) {
            return nullptr;
        }

        void Mod::Lower(AST *parent) {
            if(body.Scope().GetFunctions().contains("printf")) {
                auto type = llvm::FunctionType::get(
                    llvm::Type::getInt32Ty(*lygos::ctx),
                    {
                        llvm::Type::getInt8PtrTy(*lygos::ctx),
                    },
                    true
                );

                llvm::Function::Create(type, llvm::Function::LinkageTypes::ExternalLinkage, "printf", *lygos::mod);
                Type::Function printf{"printf", {}, {{"", MakeRef<Type::Pointer>(MakeRef<Type::Path>("i8"), false)}}, MakeRef<Type::Path>("i32"), false};
                body.Scope().RegisterFunction(printf);
            }
            for(u64 i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&body);
                body.Body()[i]->Lower(this);
                body.Increment();
            }
        }

        void Mod::Sanatize() {
            LYGOS_ASSERT(name != "" && "Module cannot be named `\"\"`");
            LYGOS_ASSERT(body.Body().size() > 0 && "Empty Module");
            LYGOS_ASSERT(current_func != NULL && "No Function in Module");
        }
    }
}
