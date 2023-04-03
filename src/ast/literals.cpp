#include "literals.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string NumberLiteral::GetValue() {
            return value;
        }

        Val *NumberLiteral::GenCode(Scope *scope) {
            //rewrite this to support more types
            if(data_type == "Integer") return llvm::ConstantInt::get(*ctx, llvm::APInt(32, std::atoi(value.c_str())));
            return llvm::ConstantFP::get(llvm::Type::getDoubleTy(*ctx), std::atof(value.c_str()));
        }

        std::string StringLiteral::GetValue() {
            return value;
        }

        Val *StringLiteral::GenCode(Scope *scope) {
            auto global = builder->CreateGlobalStringPtr(value);
            return global;
        }

        std::string Identifier::GetValue() {
            return value;
        }

        Val *Identifier::GenCode(Scope *scope) {
            auto var = scope->LookupVar(value);
            return var;
        }
    }
}
