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
            /*Type::Variable var = scope->LookupVar(id);
            if(var.type->kind == Type::Kind::ptr) {
                if(((Type::Pointer *)var.type.get())->IsRef()) {
                    Log::Logger::Warn(fmt::format("{} is a ref", id));
                    return builder->CreateLoad(TryGetPointerBase(var.alloca->getType()), var.alloca);
                }
            }
            fmt::print("{} -> {}\n", id, var.type->GetFullName());
            return var.alloca;*/
            return scope->LookupVar(id).alloca;
        }

        Ref<Type::Type> Identifier::GetType(Scope *scope) {
            return scope->LookupVar(id).type;
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

        Ref<Type::Type> StringLiteral::GetType(Scope *scope) {
            return MakeRef<Type::Pointer>(MakeRef<Type::Path>("i8"), false);
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

        Ref<Type::Type> NumberLiteral::GetType(Scope *scope) {
            return MakeRef<Type::Path>("i32");
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

        Ref<Type::Type> StaticLiterial::GetType(Scope *scope) {
            return this->type;
        }

        void StaticLiterial::Lower(AST *parent) {

        }

        void StaticLiterial::Sanatize() {

        }

        TypeAlias::TypeAlias(std::string name, Ref<Type::Type> ref_type):
            AST(ASTType::TypeAlias), name(name), ref_type(ref_type) {
        }

        std::string TypeAlias::GetValue() {
            return name;
        }

        llvm::Value *TypeAlias::GenCode(Scope *scope) {
            scope->AddTypeAlias(name, ref_type);
            return nullptr;
        }

        Ref<Type::Type> TypeAlias::GetType(Scope *scope) {
            return this->ref_type;
        }

        void TypeAlias::Lower(AST *parent) {

        }

        void TypeAlias::Sanatize() {

        }
    }
}
