#include "cfg.h"
#include "../error/log.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string IfExpr::GetValue() {
            return {};
        }

        Val *IfExpr::GenCode(Scope *scope) {
            auto cond = this->cond->GenCode(scope);

            auto func = builder->GetInsertBlock()->getParent();

            auto then_bb = llvm::BasicBlock::Create(*ctx, "", builder->GetInsertBlock()->getParent());
            auto else_bb = llvm::BasicBlock::Create(*ctx, "");
            auto merge = llvm::BasicBlock::Create(*ctx, "");

            builder->CreateCondBr(cond, then_bb, else_bb);

            builder->SetInsertPoint(then_bb);
            for(auto node : then_branch)
                node->GenCode(scope);

            builder->CreateBr(merge);

            func->getBasicBlockList().push_back(else_bb);
            builder->SetInsertPoint(else_bb);
            if(this->else_branch)
                for(auto &node : *else_branch)
                    node->GenCode(scope);
            builder->CreateBr(merge);

            func->getBasicBlockList().push_back(merge);
            builder->SetInsertPoint(merge);

            return nullptr;
        }

        std::string ForExpr::GetValue() {
            return {};
        }

        Val *ForExpr::GenCode(Scope *scope) {
            //auto header = llvm::BasicBlock::Create(*ctx, "", builder->GetInsertBlock()->getParent());


            //auto body = llvm::BasicBlock::Create(*ctx);
            //auto end = llvm::BasicBlock::Create(*ctx);

            Log::Logger::Abort("TODO! [ForExpr]");
            return NULL;
        }
    }
}
