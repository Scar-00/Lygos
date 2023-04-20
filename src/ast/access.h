#ifndef _LYGOS_AST_ACCESS_H_
#define _LYGOS_AST_ACCESS_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        //add deref operator [->]
        struct MemberExpr : public AST {
            public:
                MemberExpr(Ref<AST> obj, Ref<AST> member, bool deref);
                Ref<AST> Member() { return member; }
                Ref<AST> Obj() { return obj; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> member;
                bool deref;
        };

        struct AccessExpr : public AST {
            public:
                AccessExpr(Ref<AST> obj, Ref<AST> index);
                Ref<AST> &Obj() { return obj; }
                Ref<AST> &Index() { return index; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
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
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> member;
        };
    }
}

#endif // _LYGOS_AST_ACCESS_H_
