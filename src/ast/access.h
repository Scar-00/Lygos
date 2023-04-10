#ifndef _LYGOS_AST_ACCESS_H_
#define _LYGOS_AST_ACCESS_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct MemberExpr : public AST {
            public:
                MemberExpr(Ref<AST> obj, Ref<AST> member);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> member;
        };

        struct AccessExpr : public AST {
            public:
                AccessExpr(Ref<AST> obj, Ref<AST> index);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> index;
        };

        struct ResolutionExpr : public AST {
            public:
                ResolutionExpr(Ref<AST> obj, Ref<AST> member);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> member;
        };
    }
}

#endif // _LYGOS_AST_ACCESS_H_
