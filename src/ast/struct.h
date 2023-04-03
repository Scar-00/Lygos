#ifndef _LYGOS_AST_STRUCT_H_
#define _LYGOS_AST_STRUCT_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Field {
            Type::Type *data_type;
            std::string id;
            Field(std::string id, Type::Type *data_type): data_type(data_type), id(id) {}
        };

        struct StructDef : public AST {
            std::string id;
            std::vector<Field> fields;
            StructDef(std::string id, std::vector<Field> fields): AST(ASTType::StructDef), id(id), fields(fields) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct Impl : public AST {
            Impl(std::string type, std::vector<AST *> body): AST(ASTType::Impl), body(body), type(type) {}
            std::vector<AST *> body;
            std::string type;
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_STRUCT_H_
