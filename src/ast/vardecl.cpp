#include "vardecl.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string VarDecl::GetValue() {
            return {};
        }

        Val *VarDecl::GenCode(Scope *scope) {
            if(!value) {
                auto var_type = scope->GetType(this->data_type);
                auto alloca = builder->CreateAlloca(var_type);
                scope->DeclVar(id, cnst, alloca);
                return alloca;
            }

            auto val = (*value)->GenCode(scope);
            if(ShouldLoad(*this->value) && (*this->value)->type != ASTType::UnaryExpr)
                val = LoadOrIgnore(val);

            //convert value to declated type if possible
            if(this->data_type) {
                auto llvm_type = scope->GetType(data_type);
                val = builder->CreateCast(GetCastOp(val->getType(), llvm_type), val, llvm_type);
            }

            auto alloca = builder->CreateAlloca(val->getType(), 0, "");
            builder->CreateStore(val, alloca);
            scope->DeclVar(id, cnst, alloca);
            return alloca;
        }
    }
}
