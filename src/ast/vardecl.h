#ifndef _LYGOS_AST_VARDECL_H_
#define _LYGOS_AST_VARDECL_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct VarDecl : public AST {
            public:
                VarDecl(std::string id, bool cnst, Ref<Type::Type> type, Ref<AST> value);
                std::string &Id() { return id; }
                Ref<AST> &Value() { return value; }
                Ref<Type::Type> &Type() { return type; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string id;
                bool cnst;
                Ref<Type::Type> type;
                Ref<AST> value;
        };
    }
}

#endif // _LYGOS_AST_VARDECL_H_
