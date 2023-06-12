#ifndef _LYGOS_AST_CALL_H_
#define _LYGOS_AST_CALL_H_

#include "ast.h"
#include <vector>

namespace lygos {
    namespace AST {
        struct CallExpr : public AST {
            public:
                CallExpr(Ref<AST> caller, std::vector<Ref<AST>> args);
                Ref<AST> &GetCaller() { return caller; }
                std::vector<Ref<AST>> &Args() { return args; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> caller;
                std::vector<Ref<AST>> args;
                bool deref_self = false;
        };

        struct ReturnExpr : public AST {
            public:
                ReturnExpr(Ref<AST> value);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> value;
        };
    }
}

#endif // _LYGOS_AST_CALL_H_
