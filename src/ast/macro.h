#ifndef _LYGOS_AST_MACRO_H_
#define _LYGOS_AST_MACRO_H_

#include "ast.h"
#include <vector>

namespace lygos {
    namespace AST {
        struct Macro : public AST {
            public:
            enum class ArgType {
                None,
                Single,
                Var,
            };
            using Cond = std::tuple<std::string, ArgType>;
            //using Arm = std::tuple<std::vector<Cond>, Block>;
            using Arm = std::tuple<std::vector<Cond>, std::vector<Token>>;
            public:
                Macro(std::string name, std::vector<Arm> arms);
                std::string &GetName() { return name; }
                std::vector<Arm> &GetArms() { return arms; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                std::vector<Arm> arms;
        };

        struct MacroCall : public AST {
            public:
                MacroCall(std::string name, std::vector<std::vector<Token>> args);
                std::vector<std::vector<Token>> &GetArgs() { return args; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                std::vector<std::vector<Token>> args;
        };

        struct MacroInclude : public AST {
            public:
                MacroInclude(std::string file);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string file;
        };
    }
}

#endif // _LYGOS_AST_MACRO_H_
