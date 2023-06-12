#ifndef _LYGOS_AST_CONTROL_FLOW_H_
#define _LYGOS_AST_CONTROL_FLOW_H_

#include "ast.h"
#include <tuple>
#include <vector>

namespace lygos {
    namespace AST {
        struct IfStmt : public AST {
            public:
                IfStmt(Ref<AST> cond, Block then_body, Block else_body = {}, bool has_else_brach = false);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> cond;
                Block then_body;
                Block else_body;
                bool has_else_brach;
        };

        struct ForStmt : public AST {
            public:
                ForStmt(Ref<AST> var, Ref<AST> cond, Block body);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> var;
                Ref<AST> cond;
                Block body;
        };

        struct MatchStmt : public AST {
            public:
                using Case = std::tuple<Ref<AST>, Block>;
            public:
                MatchStmt(Ref<AST> value, std::vector<Case> cases);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                Ref<AST> value;
                std::vector<Case> cases;
        };
    }
}

#endif // _LYGOS_AST_CONTROL_FLOW_H_
