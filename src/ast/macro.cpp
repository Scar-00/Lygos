#include "macro.h"
#include "ast.h"
#include "literals.h"
#include "mod.h"
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <memory>
#include <vector>

#include "../lex/lexer.h"
#include "../parser/parser.h"

namespace lygos {
    namespace AST {
        Macro::Macro(std::string name, std::vector<Arm> arms):
            AST(ASTType::Macro), name(name), arms(arms) {

        }

        std::string Macro::GetValue() {
            return name;
        }

        llvm::Value *Macro::GenCode(Scope *scope) {
            (void)scope;
            //Log::Logger::Warn("macro should have been expanded before code generation");
            return nullptr;
        }

        /*static const char *type_str[] = {
            "None",
            "Single",
            "Var",
        };*/

        void Macro::Lower(AST *parent) {
            /*u32 idx = 0;
            for(const auto &[conds, block] : arms) {
                std::cout << idx << ": {\n";
                if(conds.size() == 0)
                    std::cout << "    type: " << type_str[0] << "\n";
                for(const auto &[n, type] : conds) {
                    std::cout << "    name -> " << n << "\n";
                    std::cout << "    type: " << type_str[(u32)type] << "\n";
                }
                std::cout << "    block: {\n";
                for(const auto &expr : block.Body()) {
                    std::cout << Print(expr.get(), 1).str();
                }
                std::cout << "    }\n";
                std::cout << "}\n";
                idx++;
            }*/
            ast_root->DeclMacro(this);
            /*for(size_t j = 0; j < arms.size(); j++) {
                auto body = std::get<1>(arms[j]);
                for(size_t i = 0; i < body.Body().size(); i++) {
                    ast_root->SetCurrentBlock(&body);
                    body.Body()[i]->Lower(this);
                    body.Increment();
                }
            }*/
        }

        void Macro::Sanatize() {

        }

        MacroVar::MacroVar(std::string name):
            AST(ASTType::MacroVar), name(name) {

        }

        std::string MacroVar::GetValue() {
            return name;
        }

        llvm::Value *MacroVar::GenCode(Scope *scope) {
            (void)scope;
            //Log::Logger::Warn("macro should have been expanded before code generation");
            return nullptr;
        }

        /*static const char *type_str[] = {
            "None",
            "Single",
            "Var",
        };*/

        void MacroVar::Lower(AST *parent) {

        }

        void MacroVar::Sanatize() {

        }

        MacroCall::MacroCall(std::string name, std::vector<std::vector<Token>> args):
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
            auto arms = macro->GetArms();
            size_t arm = 0;
            for(size_t i = 0; i < arms.size(); i++) {
                const auto &[conds, block] = arms[i];
                if(conds.size() == 0 && args.size() == 0) {
                    arm = i;
                    break;
                }
                u32 singe_args = 0;
                if(conds.size() == args.size()) {
                    for(size_t j = 0; j < conds.size(); j++) {
                        if(std::get<1>(conds[j]) == Macro::ArgType::Single)
                            singe_args++;
                    }
                    if(singe_args == conds.size()) {
                        arm = i;
                        break;
                    }
                }
                if(singe_args >= args.size())
                    Log::Logger::Warn("insufficient args supplied to macro");

                arm = i;
                //handle var
            }
            //Log::Logger::Warn(fmt::format("arm = {}", arm));
            //std::cout << fmt::format("arm = {}\n", arm);
            /*const auto [conds, block] = arms[arm];
            std::vector<Ref<AST>> body = block.Body();
            //traverse all subexprs and replace macro var with param
            for(size_t j = 0; j < conds.size(); j++) {
                const auto &[name, type] = conds[j];
                for(size_t i = 0; i < body.size(); i++) {
                    if(body[i]->type == ASTType::MacroVar) {
                        auto iden = std::static_pointer_cast<MacroVar>(body[i]);
                        if(iden->GetValue() == name) {
                            VecReplaceAt(body, i, args[j]);
                        }
                    }
                }
            }*/
            //Log::Logger::Warn(fmt::format("arm = {}", arm));
            //ast_root->Replace(body);
            auto &[conds, tokens] = arms[arm];
            for(size_t j = 0; j < conds.size(); j++) {
                const auto &[name, type] = conds[j];
                for(size_t i = 0; i < tokens.size(); i++) {
                    if(tokens[i].type == TokenType::Dollar) {
                        if(tokens.size() >= i + 1 && tokens[i + 1].type == TokenType::Id) {
                            if(tokens[i + 1].value == name) {
                                std::vector<Token> t = args[j];
                                tokens.erase(tokens.begin() + i + 1);
                                VecReplaceAt(tokens, i, t);
                            }
                        }
                    }
                }
            }
            auto root_original = ast_root;
            tokens.push_back({"", TokenType::Eof, 0});
            Parser::Parser parser{tokens};
            Ref<AST> root = parser.BuildAst();
            ast_root = (Mod *)root.get();
            std::string bar = "bar";
            ast_root->DeclMacro(root_original->GetMacro(bar));
            root->Lower(nullptr);
            ast_root = root_original;
            ast_root->Replace(((Mod *)root.get())->Body());
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
            std::filesystem::path curr = std::filesystem::current_path();
            auto file_content = IO::ReadFile(curr / file);
            if(!file_content) {
                Log::Logger::Warn(fmt::format("Could not read file: `{}`", file));
            }
            Lexer lexer(file_content);
            Parser::Parser parser(lexer);
            auto ast = parser.BuildAst();
            Ref<AST> root = ast;
            ast_root->Replace(((Mod *)root.get())->Body());
        }

        void MacroInclude::Sanatize() {

        }
    }
}
