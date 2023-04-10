#ifndef _LYGOS_AST_CASTING_H_
#define _LYGOS_AST_CASTING_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct UnaryExpr : public AST {
            public:
                UnaryExpr(Ref<AST> obj, std::string op);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                std::string op;
        };

        struct CastExpr : public AST {
            public:
                CastExpr(Ref<AST> obj, Ref<Type::Type> target_type);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<Type::Type> target_type;
        };
    }
}

#endif // _LYGOS_AST_CASTING_H_
