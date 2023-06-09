#ifndef _LYGOS_AST_ACCESS_H_
#define _LYGOS_AST_ACCESS_H_

#include "ast.h"
#include <llvm/ADT/ArrayRef.h>

namespace lygos {
    namespace AST {
        struct MemberExpr : public AST {
            public:
                MemberExpr(Ref<AST> obj, Ref<AST> member, bool deref);
                MemberExpr(Ref<AST> obj, u32 index);
                Ref<AST> Member() { return member; }
                Ref<AST> Obj() { return obj; }
                bool Deref() { return deref; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> member;
                bool deref;
                bool use_index = false;
                u32 index;
        };

        struct AccessExpr : public AST {
            public:
                AccessExpr(Ref<AST> obj, Ref<AST> index);
                Ref<AST> &Obj() { return obj; }
                Ref<AST> &Index() { return index; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
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
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> obj;
                Ref<AST> member;
        };
    }
}

#endif // _LYGOS_AST_ACCESS_H_
