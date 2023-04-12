#include "binary.h"
#include "ast.h"
#include "llvm/IR/Instructions.h"

namespace lygos {
    namespace AST {
        BinaryExpr::BinaryExpr(Ref<AST> lhs, Ref<AST> rhs, std::string op):
            AST(ASTType::BinaryExpr), lhs(lhs), rhs(rhs), op(op) {

        }

        std::string BinaryExpr::GetValue() {
            return {};
        }

        llvm::Value *BinaryExpr::GenCode(Scope *scope) {
            auto lhs = this->lhs->GenCode(scope);
            auto rhs = this->rhs->GenCode(scope);
            if(!lhs || !rhs)
                Log::Logger::Warn("could not generate binary expr");

            if(ShouldLoad(this->lhs.get()))
                lhs = LoadOrIgnore(lhs);
            if(ShouldLoad(this->rhs.get()))
                rhs = LoadOrIgnore(rhs);

            if(op == "+") return builder->CreateAdd(lhs, rhs);
            if(op == "-") return builder->CreateSub(lhs, rhs);
            if(op == "*") return builder->CreateMul(lhs, rhs);
            if(op == "/") return builder->CreateSDiv(lhs, rhs);
            if(op == "==") return builder->CreateCmp(llvm::ICmpInst::ICMP_EQ, lhs, rhs);
            if(op == "<") return builder->CreateICmpSLT(lhs, rhs);
            if(op == ">") return builder->CreateICmpSGE(lhs, rhs);
            Log::Logger::Warn(fmt::format("unknow binary operator `{}`", op));
            std::exit(1);
        }

        void BinaryExpr::Lower(AST *parent) {

        }

        void BinaryExpr::Sanatize() {

        }
    }
}
