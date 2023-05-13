#include "macro.h"
#include "ast.h"
#include "mod.h"
#include <vector>

namespace lygos {
    namespace AST {
        Macro::Macro(std::string name, Block body):
            AST(ASTType::Macro), name(name), body(body) {

        }

        std::string Macro::GetValue() {
            return name;
        }

        llvm::Value *Macro::GenCode(Scope *scope) {
            (void)scope;
            //Log::Logger::Warn("macro should have been expanded before code generation");
            return nullptr;
        }

        void Macro::Lower(AST *parent) {
            ast_root->DeclMacro(this);
            for(size_t i = 0; i < body.Body().size(); i++) {
                body.Body()[i]->Lower(this);
                body.Increment();
            }
        }

        void Macro::Sanatize() {

        }

        MacroCall::MacroCall(std::string name, std::vector<Ref<AST>> args):
            AST(ASTType::MacroCall), name(name), args(args) {

        }

        std::string MacroCall::GetValue() {
            return name;
        }

        llvm::Value *MacroCall::GenCode(Scope *scope) {
            (void)scope;
            Log::Logger::Warn("macro call should have been expanded before code generation");
            return nullptr;
        }

        void MacroCall::Lower(AST *parent) {
            std::vector<Ref<AST>> body = ast_root->GetMacro(name)->Body();
            ast_root->Replace(body);
        }

        void MacroCall::Sanatize() {

        }
    }
}
