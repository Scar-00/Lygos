#include "vardecl.h"
#include "mod.h"
#include "function.h"
#include <llvm/IR/DerivedTypes.h>

namespace lygos {
    namespace AST {
        VarDecl::VarDecl(std::string id, bool cnst, Ref<Type::Type> type, Ref<AST> value):
            AST(ASTType::VarDecl), id(id), cnst(cnst), type(type), value(value) {

        }

        std::string VarDecl::GetValue() {
            return id;
        }

        llvm::Value *VarDecl::GenCode(Scope *scope) {
            if(value.get() == nullptr) {
                auto alloca = builder->CreateAlloca(scope->GetType(type.get()));
                scope->DeclVar(id, cnst, alloca);
                return alloca;
            }
            auto val = value->GenCode(scope);
            if(ShouldLoad(value.get()) /*&& value->type != ASTType::UnaryExpr()*/)
                val = LoadOrIgnore(val);

            if(type.get()) {
                auto type = scope->GetType(this->type.get());
                val = builder->CreateCast(GetCastOp(val->getType(), type), val, type);
            }

            if(val->getType()->isVoidTy())
                Log::Logger::Warn("cannot assign `void` value to variable");

            auto alloca = builder->CreateAlloca(val->getType());
            builder->CreateStore(val, alloca);
            scope->DeclVar(id, cnst, alloca);
            return alloca;
        }

        void VarDecl::Lower(AST *parent) {
            if(value != nullptr) {
                this->value->Lower(this);
            }
        }

        void VarDecl::Sanatize() {

        }
    }
}
