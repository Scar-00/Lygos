#ifndef _LYGOS_AST_VARDECL_H_
#define _LYGOS_AST_VARDECL_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct VarDecl : public AST {
            Type::Type *data_type;
            bool cnst;
            std::string id;
            std::shared_ptr<AST*> value;
            VarDecl(std::string id, std::shared_ptr<AST*> value, bool cnst, Type::Type *data_type): AST(ASTType::VarDecl), data_type(data_type), cnst(cnst), id(id), value(value) {};
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_VARDECL_H_
