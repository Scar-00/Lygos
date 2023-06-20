#ifndef _LYGOS_AST_IMPL_H_
#define _LYGOS_AST_IMPL_H_

#include "ast.h"
#include <vector>

namespace lygos {
    namespace AST {
        struct Impl : public AST {
            public:
                Impl(std::string type, Block body, std::vector<Type::Generic> generics, std::string trait = "");
                Block &Body() { return body; }
                std::string &Type() { return type; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string type;
                Block body;
                std::vector<Type::Generic> generics;
                std::string trait;
        };
    }
}

#endif // _LYGOS_AST_IMPL_H_
