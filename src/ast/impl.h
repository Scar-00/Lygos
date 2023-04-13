#ifndef _LYGOS_AST_IMPL_H_
#define _LYGOS_AST_IMPL_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Impl : public AST {
            public:
                Impl(std::string type, std::vector<Ref<AST>> body);
                std::vector<Ref<AST>> &Body() { return body; }
                std::string &Type() { return type; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string type;
                std::vector<Ref<AST>> body;
        };
    }
}

#endif // _LYGOS_AST_IMPL_H_
