#ifndef _LYGOS_AST_CONTROL_FLOW_H_
#define _LYGOS_AST_CONTROL_FLOW_H_

#include "ast.h"
#include <vector>

namespace lygos {
    namespace AST {
        struct IfStmt : public AST {
            public:
                IfStmt(Ref<AST> cond, std::vector<Ref<AST>> then_body, std::vector<Ref<AST>> else_body = {}, bool has_else_brach = false);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> cond;
                std::vector<Ref<AST>> then_body;
                std::vector<Ref<AST>> else_body;
                bool has_else_brach;
        };
    }
}

#endif // _LYGOS_AST_CONTROL_FLOW_H_
