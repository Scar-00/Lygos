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
            for(size_t j = 0; j < arms.size(); j++) {
                auto body = std::get<1>(arms[j]);
                for(size_t i = 0; i < body.Body().size(); i++) {
                    ast_root->SetCurrentBlock(&body);
                    body.Body()[i]->Lower(this);
                    body.Increment();
                }
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
            std::cout << fmt::format("arm = {}\n", arm);
            const auto [conds, block] = arms[arm];
            std::vector<Ref<AST>> body = block.Body();
            //traverse all subexprs and replace macro var with param
            for(size_t j = 0; j < conds.size(); j++) {
                const auto &[name, type] = conds[j];
                for(size_t i = 0; i < body.size(); i++) {
                    if(body[i]->type == ASTType::Id) {
                        auto iden = std::static_pointer_cast<Identifier>(body[i]);
                        if(iden->GetId() == name) {
                            VecReplaceAt(body, i, args[j]);
                        }
                    }
                }
            }
            //Log::Logger::Warn(fmt::format("arm = {}", arm));
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
            std::filesystem::path curr = std::filesystem::current_path();
            auto file_content = IO::ReadFile(curr / file);
            if(!file_content) {
                Log::Logger::Warn(fmt::format("Could not read file: `{}`", file));
            }
            Lexer lexer(file_content);
            Parser::Parser parser(lexer);
            auto ast = parser.BuildAst();
            //ast->Lower(nullptr);
            Mod *root = (Mod *)ast.get();
            //std::cout << Print(root->Body()[0].get()).str() << "\n";
            Block block = root->Body();
            ast_root->Replace(block.Body());
        }

        void MacroInclude::Sanatize() {

        }
    }
}
