#include "macro.h"
#include "ast.h"
#include "literals.h"
#include "mod.h"
#include <cstdlib>
#include <filesystem>
#include <memory>
#include <vector>

#include "../lex/lexer.h"
#include "../parser/parser.h"

namespace lygos {
    namespace AST {
        Macro::Macro(std::string name, Arg arg, Block body):
            AST(ASTType::Macro), name(name), param(arg), body(body) {

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
            /*auto &[name, type, num] = param;
            std::cout << "----------------\n";
            std::cout << "name: " << name << "\n";
            std::cout << "type: " << (u32)type << "\n";
            std::cout << "num: " << num << "\n";*/
            ast_root->DeclMacro(this);
            for(size_t i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&body);
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
            auto macro = ast_root->GetMacro(name);
            Block &macro_block = macro->Body();
            std::vector<Ref<AST>> body = macro_block.Body();
            //traverse all subexprs and replace macro var with param
            for(size_t i = 0; i < body.size(); i++) {
                if(body[i]->type == ASTType::Id) {
                    auto iden = std::static_pointer_cast<Identifier>(body[i]);
                    if(iden->GetId() == std::get<0>(macro->GetArg())) {
                        VecReplaceAt(body, i, args);
                    }
                }
            }
            ast_root->Replace(body);
        }

        void MacroCall::Sanatize() {

        }

        MacroInclude::MacroInclude(std::string file):
            AST(ASTType::MacroInclude), file(file) {

        }

        std::string MacroInclude::GetValue() {
            return file;
        }

        llvm::Value *MacroInclude::GenCode(Scope *scope) {
            (void)scope;
            Log::Logger::Warn("macro include should have been expanded before code generation");
            return nullptr;
        }

        void MacroInclude::Lower(AST *parent) {
            /*std::filesystem::path curr = std::filesystem::current_path();
            auto file_content = IO::ReadFile(curr / file);
            if(!file_content) {
                Log::Logger::Warn(fmt::format("Could not read file: `{}`", file));
            }
            printf("root %p\n", (void *)ast_root);
            Lexer lexer(file_content);
            Parser::Parser parser(lexer);
            auto ast = parser.BuildAst();
            //ast->Lower(nullptr);
            Mod *root = (Mod *)ast.get();
            //std::cout << Print(root->Body()[0].get()).str() << "\n";
            Block block = root->Body();
            Ref<AST> test = MakeRef<Identifier>("test");
            printf("root %p\n", (void *)ast_root);
            ast_root->Replace(test);*/
            Log::Logger::Warn("unimplemented [MacroInclude::Lower()]");
        }

        void MacroInclude::Sanatize() {

        }
    }
}
