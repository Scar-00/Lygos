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
                Arr,
                Var,
            };
            using Arg = std::tuple<std::string, ArgType, u32>;
            public:
                Macro(std::string name, Arg arg, Block exprs);
                Block &Body() { return body; }
                std::string &GetName() { return name; }
                Arg &GetArg() { return param; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                Arg param;
                Block body;
        };

        struct MacroCall : public AST {
            public:
                MacroCall(std::string name, std::vector<Ref<AST>> args);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                std::vector<Ref<AST>> args;
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
