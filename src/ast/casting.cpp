#include "casting.h"
#include "ast.h"
#include "../types.h"

namespace lygos {
    namespace AST {
        UnaryExpr::UnaryExpr(Ref<AST> obj, std::string op):
            AST(ASTType::UnaryExpr), obj(obj), op(op) {

        }

        std::string UnaryExpr::GetValue() {
            return obj->GetValue();
        }

        llvm::Value *UnaryExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(op == "*")
                return this->obj->type == ASTType::MemberExpr ? obj :  builder->CreateLoad(TryGetPointerBase(obj->getType()), obj);
            if(op == "&")
                return obj;
            if(op == "!") {
                if(ShouldLoad(this->obj.get()))
                    obj = LoadOrIgnore(obj);
                auto *zero = llvm::ConstantInt::get(obj->getType(), 0);
                auto ne = builder->CreateICmpNE(obj, zero);
                return builder->CreateXor(ne, true);
            }

            Log::Logger::Warn(fmt::format("unknown unary operator `{}`", op));
            std::exit(1);
        }

        void UnaryExpr::Lower(AST *parent) {

        }

        void UnaryExpr::Sanatize() {

        }

        CastExpr::CastExpr(Ref<AST> obj, Ref<Type::Type> target_type):
            AST(ASTType::CastExpr), obj(obj), target_type(target_type) {

        }

        std::string CastExpr::GetValue() {
            return obj->GetValue();
        }

        llvm::Value *CastExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(ShouldLoad(this->obj.get()))
                obj = LoadOrIgnore(obj);

            auto dest_type = scope->GetType(target_type.get());
            auto src_type = obj->getType();
            return builder->CreateCast(GetCastOp(src_type, dest_type), obj, dest_type);
        }

        void CastExpr::Lower(AST *parent) {

        }

        void CastExpr::Sanatize() {

        }
    }
}
