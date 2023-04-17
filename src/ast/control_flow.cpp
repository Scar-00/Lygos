#include "control_flow.h"
#include <llvm/IR/Function.h>

namespace lygos {
    namespace AST {
        IfStmt::IfStmt(Ref<AST> cond, std::vector<Ref<AST>> then_body, std::vector<Ref<AST>> else_body, bool has_else_brach):
            AST(ASTType::IfStmt), cond(cond), then_body(then_body), else_body(else_body), has_else_brach(has_else_brach) {

        }

        std::string IfStmt::GetValue() {
            return {};
        }

        llvm::Value *IfStmt::GenCode(Scope *scope) {
            llvm::Function *fn = builder->GetInsertBlock()->getParent();

            auto true_block = llvm::BasicBlock::Create(*ctx, "", fn);
            auto false_block = llvm::BasicBlock::Create(*ctx, "", fn);
            auto merge_block = llvm::BasicBlock::Create(*ctx, "", fn);
            builder->CreateCondBr(cond->GenCode(scope), true_block, false_block);

            builder->SetInsertPoint(true_block);
            Scope then_scope{scope};
            for(const auto &node : then_body) {
                node->GenCode(&then_scope);
            }
            builder->CreateBr(merge_block);

            //generate else
            //fn->insert(fn->end(), false_block);
            builder->SetInsertPoint(false_block);
            if(has_else_brach) {
                Scope else_scope{scope};
                for(const auto &node : then_body) {
                    std::cout << "test\n";
                    node->GenCode(&else_scope);
                }
            }
            builder->CreateBr(merge_block);


            //fn->insert(fn->end(), merge_block);
            builder->SetInsertPoint(merge_block);

            //Log::Logger::Warn("unimplemented [IfStmt]");
            return nullptr;
        }

        void IfStmt::Lower(AST *parent) {

        }

        void IfStmt::Sanatize() {

        }
    }
}
