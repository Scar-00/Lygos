#ifndef _LYGOS_AST_BINARY_H_
#define _LYGOS_AST_BINARY_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct BinaryExpr : public AST {
            public:
                BinaryExpr(Ref<AST> lhs, Ref<AST> rhs, std::string op);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> lhs;
                Ref<AST> rhs;
                std::string op;
        };
    }
}

#endif // _LYGOS_AST_BINARY_H_
