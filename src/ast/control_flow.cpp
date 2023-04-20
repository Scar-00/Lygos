#include "control_flow.h"
#include "ast.h"
#include "scope.h"
#include <llvm/IR/Function.h>

namespace lygos {
    namespace AST {
        IfStmt::IfStmt(Ref<AST> cond, std::vector<Ref<AST>> then_body, std::vector<Ref<AST>> else_body, bool has_else_brach):
            AST(ASTType::IfStmt), cond(cond), then_body(then_body), else_body(else_body), has_else_brach(has_else_brach) {

        }

        std::string IfStmt::GetValue() {
            return {};
        }

        // fix returning from if braches
        llvm::Value *IfStmt::GenCode(Scope *scope) {
            llvm::Function *fn = builder->GetInsertBlock()->getParent();

            auto true_block = llvm::BasicBlock::Create(*ctx, "", fn);
            auto false_block = llvm::BasicBlock::Create(*ctx, "", fn);
            auto merge = llvm::BasicBlock::Create(*ctx, "", fn);
            builder->CreateCondBr(cond->GenCode(scope), true_block, false_block);

            builder->SetInsertPoint(true_block);
            Scope then_scope{scope};
            for(const auto &node : then_body) {
                node->GenCode(&then_scope);
            }
            builder->CreateBr(merge);

            //generate else
            //fn->insert(fn->end(), false_block);
            builder->SetInsertPoint(false_block);
            if(has_else_brach) {
                Scope else_scope{scope};
                for(const auto &node : else_body) {
                    std::cout << "test\n";
                    node->GenCode(&else_scope);
                }
            }
            builder->CreateBr(merge);

            builder->SetInsertPoint(merge);
            //Log::Logger::Warn("unimplemented [IfStmt]");
            return nullptr;
        }

        void IfStmt::Lower(AST *parent) {

        }

        void IfStmt::Sanatize() {

        }

        ForStmt::ForStmt(Ref<AST> var, Ref<AST> cond, std::vector<Ref<AST>> body):
            AST(ASTType::ForStmt), var(var), cond(cond), body(body) {

        }

        std::string ForStmt::GetValue() {
            return {};
        }

        llvm::Value *ForStmt::GenCode(Scope *scope) {
            llvm::Function *fn = builder->GetInsertBlock()->getParent();

            auto entry = llvm::BasicBlock::Create(*ctx, "", fn);
            auto block = llvm::BasicBlock::Create(*ctx, "", fn);
            //auto cond = llvm::BasicBlock::Create(*ctx, "", fn);
            auto merge = llvm::BasicBlock::Create(*ctx, "", fn);

            //builder->CreateCondBr(this->cond->GenCode(scope), block, merge);

            Scope loop_scope{scope};
            var->GenCode(&loop_scope);
            builder->CreateCondBr(this->cond->GenCode(&loop_scope), block, merge);
            //this->var->GenCode(&loop_scope);
            builder->SetInsertPoint(entry);
            builder->CreateCondBr(this->cond->GenCode(&loop_scope), block, merge);
            builder->SetInsertPoint(block);
            for(const auto &item : body)
                item->GenCode(&loop_scope);
            builder->CreateBr(entry);

            builder->SetInsertPoint(merge);

            return nullptr;
        }

        void ForStmt::Lower(AST *parent) {

        }

        void ForStmt::Sanatize() {

        }
    }
}
