#ifndef _LYGOS_AST_ASSIGNMENT_H_
#define _LYGOS_AST_ASSIGNMENT_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct AssignmentExpr : public AST {
            std::string data_type;
            AST *id;
            AST *value;
            AssignmentExpr(AST *id, AST *value, std::string data_type): AST(ASTType::AssignmentExpr), data_type(data_type), id(id), value(value) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_ASSIGNMENT_H_
