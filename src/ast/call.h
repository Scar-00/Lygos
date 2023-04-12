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
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> caller;
                std::vector<Ref<AST>> args;
        };

        struct ReturnExpr : public AST {
            public:
                ReturnExpr(Ref<AST> value);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> value;
        };
    }
}

#endif // _LYGOS_AST_CALL_H_
