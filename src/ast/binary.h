#ifndef _LYGOS_AST_BINARY_H_
#define _LYGOS_AST_BINARY_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct BinaryExpr : public AST {
            public:
                BinaryExpr(Ref<AST> lhs, Ref<AST> rhs, std::string op);
                Ref<AST> Lhs() { return lhs; }
                Ref<AST> Rhs() { return rhs; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> lhs;
                Ref<AST> rhs;
                std::string op;
        };
    }
}

#endif // _LYGOS_AST_BINARY_H_
