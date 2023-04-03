#include "binary.h"
#include "../error/log.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string UnaryExpr::GetValue() {
            return {};
        }

        Val *UnaryExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(op == "*")
                return builder->CreateLoad(TryGetPointerBase(obj->getType()), obj);
            if(op == "&")
                return obj;

            Log::Logger::Warn(fmt::format("unknown unary operator [`{}`]", op));
            std::exit(1);
        }

        std::string CastExpr::GetValue() {
            return obj->GetValue();
        }

        Val *CastExpr::GenCode(Scope *scope) {
            auto val = this->obj->GenCode(scope);
            if(ShouldLoad(this->obj))
                val = LoadOrIgnore(val);

            auto dest_type = scope->GetType(this->target_type);
            auto src_type = val->getType();
            auto op = GetCastOp(src_type, dest_type);
            return builder->CreateCast(op, val, dest_type);
        }

        std::string BinaryExpr::GetValue() {
            return {};
        }

        Val *BinaryExpr::GenCode(Scope *scope) {
            auto lhs = this->lhs->GenCode(scope);
            auto rhs = this->rhs->GenCode(scope);
            if(!lhs || !rhs)
                Log::Logger::Warn("could not generate binary expr");

            if(ShouldLoad(this->lhs)) {
                lhs = LoadOrIgnore(lhs);
            }
            if(ShouldLoad(this->rhs)) {
                rhs = LoadOrIgnore(rhs);
            }

            //expand this to account for type conversion etc.
            if(op == "+") return builder->CreateAdd(lhs, rhs);
            if(op == "-") return builder->CreateSub(lhs, rhs);
            if(op == "*") return builder->CreateMul(lhs, rhs);
            if(op == "/") return builder->CreateSDiv(lhs, rhs);
            if(op == "==") return builder->CreateCmp(llvm::ICmpInst::ICMP_EQ, lhs, rhs);
            if(op == "<") return builder->CreateICmpSLT(lhs, rhs);
            if(op == ">") return builder->CreateICmpSGE(lhs, rhs);
            Log::Logger::Warn(fmt::format("unknwon operator `{}`", op));
            std::exit(1);
        }
    }
}
