#include "literals.h"
#include "assignment.h"
#include <llvm/IR/GlobalValue.h>
#include <llvm/IR/GlobalVariable.h>
#include <regex>

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

        void Identifier::Lower(AST *parent) {

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
            auto reg = std::regex("\\\\n");
            auto unescaped = std::regex_replace(value, reg, "\n");
            return builder->CreateGlobalStringPtr(unescaped);
        }

        void StringLiteral::Lower(AST *parent) {

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
            if(type == "Char") {
                auto reg = std::regex("\\\\0");
                auto unescaped = std::regex_replace(value, reg, "\n");
                return llvm::ConstantInt::get(*ctx, llvm::APInt(8, unescaped.c_str()[0]));
            }
            return llvm::ConstantFP::get(llvm::Type::getDoubleTy(*ctx), std::atof(value.c_str()));
        }

        void NumberLiteral::Lower(AST *parent) {

        }

        void NumberLiteral::Sanatize() {

        }

        StaticLiterial::StaticLiterial(Ref<AST> value):
            AST(ASTType::StaticLiterial), value(value) {
            name = ((AssignmentExpr *)value.get())->Lhs()->GetValue();
        }

        std::string StaticLiterial::GetValue() {
            return name;
        }

        llvm::Value *StaticLiterial::GenCode(Scope *scope) {
            Log::Logger::Warn("unimplemented [Statics]");
            return nullptr;
        }

        void StaticLiterial::Lower(AST *parent) {

        }

        void StaticLiterial::Sanatize() {

        }
    }
}
