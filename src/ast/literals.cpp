#include "literals.h"
#include "assignment.h"
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
            return scope->LookupVar(id).alloca;
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
                //auto reg = std::regex("\\\\[A-Za-z0-9 ]");
                //auto unescaped = std::regex_replace(value, reg, "$1");
                return llvm::ConstantInt::get(*ctx, llvm::APInt(8, value.c_str()[0]));
            }
            return llvm::ConstantFP::get(llvm::Type::getDoubleTy(*ctx), std::atof(value.c_str()));
        }

        void NumberLiteral::Lower(AST *parent) {

        }

        void NumberLiteral::Sanatize() {

        }

        StaticLiterial::StaticLiterial(std::string name, Ref<Type::Type> type):
            AST(ASTType::StaticLiterial), name(name), type(type) {
        }

        std::string StaticLiterial::GetValue() {
            return name;
        }

        llvm::Value *StaticLiterial::GenCode(Scope *scope) {
            //auto glob = new llvm::GlobalVariable(scope->GetType(type.get()), false, llvm::GlobalVariable::InternalLinkage);
            //Log::Logger::Warn("unimplemented [Statics]");
            mod->getOrInsertGlobal(name, scope->GetType(type.get()));
            //mod->getNamedGlobal(name)->setLinkage(llvm::GlobalVariable::InternalLinkage);
            scope->DeclVar(this->name, false, {type, (llvm::AllocaInst *)mod->getNamedGlobal(name)});
            return mod->getNamedGlobal(name);
        }

        void StaticLiterial::Lower(AST *parent) {

        }

        void StaticLiterial::Sanatize() {

        }
    }
}
