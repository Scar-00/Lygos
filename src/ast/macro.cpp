#include "macro.h"
#include "ast.h"
#include "literals.h"
#include "mod.h"
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fmt/core.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
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

        Ref<Type::Type> Macro::GetType(Scope *scope) { return nullptr; }

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
            ast_root->GetCurrentBlock()->Scope().DeclMacro(this);
        }

        void Macro::Sanatize() {

        }

        MacroCall::MacroCall(std::string name, std::vector<std::vector<Token>> args):
            AST(ASTType::MacroCall), name(name), args(args) {

        }

        std::string MacroCall::GetValue() {
            return name;
        }

        llvm::Value *MacroCall::GenCode(Scope *scope) {
            (void)scope;
            Log::Logger::Warn(fmt::format("macro `{}` should have been expanded before code generation", this->name));
            return nullptr;
        }

        Ref<Type::Type> MacroCall::GetType(Scope *scope) { return nullptr; }

        void MacroCall::Lower(AST *parent) {
            if (intrinsic_macros.contains(name)) {
                intrinsic_macros.at(name)(this);
                return;
            }

            auto macro = ast_root->GetCurrentBlock()->Scope().GetMacro(name);
            auto arms = macro.GetArms();
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
            }
            auto &[conds, tokens] = arms[arm];
            for(size_t j = 0; j < conds.size(); j++) {
                const auto &[name, type] = conds[j];
                for(size_t i = 0; i < tokens.size(); i++) {
                    if(tokens[i].type == TokenType::Dollar) {
                        if(tokens.size() >= i + 1 && tokens[i + 1].type == TokenType::Id) {
                            if(tokens[i + 1].value == name) {
                                std::vector<Token> toks = args[j];
                                tokens.erase(tokens.begin() + i + 1);
                                if(type == Macro::ArgType::Var) {
                                    //this does not allways expand properly
                                    tokens.erase(tokens.begin() + i);
                                    for(size_t k = j; k < args.size(); k++){
                                        Token tok{",", TokenType::Comma, 0};
                                        VecInsertAt(tokens, i, tok);
                                        VecInsertAt(tokens, i, args[k]);
                                    }
                                    break;
                                }else {
                                    VecReplaceAt(tokens, i, toks);
                                }
                            }
                        }
                    }
                    while(tokens[i + 1].type == TokenType::Hash) {
                        if(tokens[i + 2].type == TokenType::Hash) {
                            if(i > 0 && tokens[i].type != TokenType::Id)
                                Log::Logger::Warn(tokens[i], "expected `identifier` as prefix");
                            tokens.erase(tokens.begin() + i + 1);
                            tokens.erase(tokens.begin() + i + 1);
                            if(tokens[i + 1].type == TokenType::Dollar) {
                                if(tokens.size() >= i + 1 && tokens[i + 2].type == TokenType::Id) {
                                    if(tokens[i + 2].value == name) {
                                        std::vector<Token> toks = args[j];
                                        tokens.erase(tokens.begin() + i + 1);
                                        if(type == Macro::ArgType::Var) {
                                            tokens.erase(tokens.begin() + i);
                                            for(size_t k = j; k < args.size(); k++){
                                                Token tok{",", TokenType::Comma, 0};
                                                VecInsertAt(tokens, i, tok);
                                                VecInsertAt(tokens, i, args[k]);
                                            }
                                            break;
                                        }else {
                                            VecReplaceAt(tokens, i + 1, toks);
                                        }
                                    }
                                }
                            }
                            tokens[i].value.append(tokens[i + 1].value);
                            tokens.erase(tokens.begin() + i + 1);
                        }else {
                            tokens.erase(tokens.begin() + i + 1);
                            if(tokens[i + 1].type == TokenType::Dollar) {
                                if(tokens.size() >= i + 1 && tokens[i + 2].type == TokenType::Id) {
                                    if(tokens[i + 2].value == name) {
                                        std::vector<Token> toks = args[j];
                                        tokens.erase(tokens.begin() + i + 1);
                                        if(type == Macro::ArgType::Var) {
                                            tokens.erase(tokens.begin() + i);
                                            for(size_t k = j; k < args.size(); k++){
                                                Token tok{",", TokenType::Comma, 0};
                                                VecInsertAt(tokens, i, tok);
                                                VecInsertAt(tokens, i, args[k]);
                                            }
                                            break;
                                        }else {
                                            VecReplaceAt(tokens, i + 1, toks);
                                        }
                                    }
                                }
                            }
                            //tokens.erase(tokens.begin() + i);
                            tokens[i].type = TokenType::Id;
                        }
                    }
                }
            }

            //for(const auto &token : tokens) {
            //    std::cout << token << "\n";
            //}

            Ref<Mod> root_original = ast_root;
            tokens.push_back({"", TokenType::Eof, 0});
            Parser::Parser parser{tokens};
            Ref<AST> root = parser.BuildAst();
            ast_root = std::static_pointer_cast<Mod>(root);
            ast_root->Body().Scope().GetStructTypes() = root_original->Body().Scope().GetStructTypes();
            ast_root->Body().Scope().GetEnumTypes() = root_original->Body().Scope().GetEnumTypes();
            ast_root->Body().Scope().GetFunctions() = root_original->Body().Scope().GetFunctions();
            ast_root->Body().Scope().GetMacros() = root_original->Body().Scope().GetMacros();
            ast_root->Body().Scope().GetTraits() = root_original->Body().Scope().GetTraits();

            auto &body = ast_root->Body();
            //body.Scope().SetParent(&ast_root->GetCurrentBlock()->Scope());
            for(size_t i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&body);
                body.Body()[i]->Lower(this);
                body.Increment();
            }

            root_original->Body().Scope().GetStructTypes() = ast_root->Body().Scope().GetStructTypes();
            root_original->Body().Scope().GetEnumTypes() = ast_root->Body().Scope().GetEnumTypes();
            root_original->Body().Scope().GetFunctions() = ast_root->Body().Scope().GetFunctions();
            root_original->Body().Scope().GetMacros() = ast_root->Body().Scope().GetMacros();
            root_original->Body().Scope().GetTraits() = ast_root->Body().Scope().GetTraits();

            /*std::cout << "Body:\n";
            for(const auto &expr : body.Body()) {
                std::cout << Print(expr.get(), 1).str();
            }
            std::cout << std::endl;*/

            ast_root = root_original;
            ast_root->Replace(((Mod *)root.get())->Body().Body());
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

        Ref<Type::Type> MacroInclude::GetType(Scope *scope) { return nullptr; }

        void MacroInclude::Lower(AST *parent) {
            std::filesystem::path curr = std::filesystem::current_path();
            auto file_content = IO::ReadFile(curr / file);
            if(!file_content) {
                Log::Logger::Warn(fmt::format("Could not read file: `{}`", file));
            }
            Lexer lexer(file_content);
            Parser::Parser parser(lexer);
            auto ast = parser.BuildAst();
            Ref<Mod> root = std::static_pointer_cast<Mod>(ast);
            ast_root->Replace(root->Body().Body());
        }

        void MacroInclude::Sanatize() {

        }

        MacroSizeOf::MacroSizeOf(Ref<Type::Type> type):
            AST(ASTType::MacroSizeOf), type(type) {

        }

        std::string MacroSizeOf::GetValue() {
            return {};
        }

        llvm::Value *MacroSizeOf::GenCode(Scope *scope) {
            llvm::Type *type = scope->GetType(this->type.get());
            auto size = mod->getDataLayout().getTypeAllocSizeInBits(type).getFixedSize();
            return llvm::ConstantInt::get(*ctx, llvm::APInt(64, size / 8));
        }

        Ref<Type::Type> MacroSizeOf::GetType(Scope *scope) { return type; }

        void MacroSizeOf::Lower(AST *parent) {

        }

        void MacroSizeOf::Sanatize() {

        }
    }
}
