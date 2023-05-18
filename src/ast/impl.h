#ifndef _LYGOS_AST_IMPL_H_
#define _LYGOS_AST_IMPL_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Impl : public AST {
            public:
                Impl(std::string type, Block body, std::string trait = "");
                std::vector<Ref<AST>> &Body() { return body.Body(); }
                std::string &Type() { return type; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string type;
                Block body;
                std::string trait;
        };
    }
}

#endif // _LYGOS_AST_IMPL_H_
