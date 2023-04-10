#include "literals.h"

namespace lygos {
    namespace AST {
        Identifier::Identifier(std::string id):
            AST(ASTType::Id), id(id) {

        }

        std::string Identifier::GetValue() {
            return id;
        }

        llvm::Value *Identifier::GenCode(Scope *scope) {
            return scope->LookupVar(id);
        }

        void Identifier::Lower() {

        }

        void Identifier::Sanatize() {

        }

        StringLiteral::StringLiteral(std::string value):
            AST(ASTType::StringLiteral), value(value) {

        }

        std::string StringLiteral::GetValue() {
            return value;
        }

        llvm::Value *StringLiteral::GenCode(Scope *scope) {
            return builder->CreateGlobalStringPtr(value);
        }

        void StringLiteral::Lower() {

        }

        void StringLiteral::Sanatize() {

        }

        NumberLiteral::NumberLiteral(std::string value, std::string type):
            AST(ASTType::NumberLiteral), value(value), type(type) {

        }

        std::string NumberLiteral::GetValue() {
            return value;
        }

        llvm::Value *NumberLiteral::GenCode(Scope *scope) {
            if(type == "Integer") return llvm::ConstantInt::get(*ctx, llvm::APInt(32, std::atoi(value.c_str())));
            return llvm::ConstantFP::get(llvm::Type::getDoubleTy(*ctx), std::atof(value.c_str()));
        }

        void NumberLiteral::Lower() {

        }

        void NumberLiteral::Sanatize() {

        }
    }
}
