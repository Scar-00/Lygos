#include "casting.h"
#include "ast.h"
#include "../types.h"
#include <fmt/core.h>

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
            if(op == "*") {
                if(!obj->getType()->isPointerTy())
                    Log::Logger::Warn(fmt::format("cannot deref non pointer"));
                return this->obj->type == ASTType::MemberExpr ? obj :  builder->CreateLoad(TryGetPointerBase(obj->getType()), obj);
            }
            if(op == "&") return obj;
                //return builder->CreateBitCast(obj, llvm::PointerType::get(obj->getType(), 0));
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

        Ref<Type::Type> UnaryExpr::GetType(Scope *scope) {
            auto type = obj->GetType(scope);
            if(op == "*") { return ((Type::Pointer *)type.get())->GetType(); }
            if(op == "&") { return MakeRef<Type::Pointer>(type, false); }
            if(op == "!") { return MakeRef<Type::Path>("bool"); }
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
            //std::cout << "src -> " << PrintType(src_type) << "\n";
            //std::cout << "dest -> " << PrintType(dest_type) << "\n";
            //if(TryGetPointerBase(src_type)->isArrayTy() && dest_type->isPointerTy())
            //    return builder->CreateConstGEP1_32(TryGetPointerBase(obj->getType()), obj, 0);
            return builder->CreateCast(GetCastOp(src_type, dest_type), obj, dest_type);
        }

        Ref<Type::Type> CastExpr::GetType(Scope *scope) {
            return target_type;
        }

        void CastExpr::Lower(AST *parent) {

        }

        void CastExpr::Sanatize() {

        }
    }
}
