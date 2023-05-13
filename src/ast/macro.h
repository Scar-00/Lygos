#ifndef _LYGOS_AST_MACRO_H_
#define _LYGOS_AST_MACRO_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Macro : public AST {
            public:
                Macro(std::string name, Block exprs);
                std::vector<Ref<AST>> &Body() { return body.Body(); }
                std::string &GetName() { return name; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
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
    }
}

#endif // _LYGOS_AST_MACRO_H_
