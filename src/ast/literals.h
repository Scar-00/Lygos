#ifndef _LYGOS_AST_LITERALS_H_
#define _LYGOS_AST_LITERALS_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct NumberLiteral : public AST {
            std::string value;
            std::string data_type;
            NumberLiteral(std::string value, std::string data_type): AST(ASTType::NumberLiteral), value(value), data_type(data_type) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct StringLiteral : public AST {
            std::string value;
            std::string data_type;
            StringLiteral(std::string value, std::string data_type): AST(ASTType::StringLiteral), value(value), data_type(data_type) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };

        struct Identifier : public AST {
            std::string value;
            std::string data_type;
            Identifier(std::string value, std::string data_type): AST(ASTType::Id), value(value), data_type(data_type) {}
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_LITERALS_H_
