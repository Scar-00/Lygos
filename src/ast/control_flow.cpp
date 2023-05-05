#include "control_flow.h"
#include "ast.h"
#include "scope.h"
#include <llvm/ADT/Twine.h>
#include <vector>

namespace lygos {
    namespace AST {
        IfStmt::IfStmt(Ref<AST> cond, std::vector<Ref<AST>> then_body, std::vector<Ref<AST>> else_body, bool has_else_brach):
            AST(ASTType::IfStmt), cond(cond), then_body(then_body), else_body(else_body), has_else_brach(has_else_brach) {

        }

        std::string IfStmt::GetValue() {
            return {};
        }

        //fix non early return
        llvm::Value *IfStmt::GenCode(Scope *scope) {
            llvm::Function *fn = builder->GetInsertBlock()->getParent();

            if(has_else_brach)
                scope->SetRetBlock(llvm::BasicBlock::Create(*ctx, "", fn));
            auto ret_block = scope->GetRetBlock();

            auto true_block = llvm::BasicBlock::Create(*ctx, "", fn, ret_block);
            auto false_block = llvm::BasicBlock::Create(*ctx, "", fn, ret_block);
            auto merge = llvm::BasicBlock::Create(*ctx, "", fn, ret_block);
            builder->CreateCondBr(cond->GenCode(scope), true_block, has_else_brach ? false_block : merge);

            builder->SetInsertPoint(true_block);
            Scope then_scope{scope};
            for(const auto &node : then_body) {
                node->GenCode(&then_scope);
            }
            if(!true_block->getTerminator())
                builder->CreateBr(merge);

            //generate else
            builder->SetInsertPoint(false_block);
            if(has_else_brach) {
                Scope else_scope{scope};
                for(const auto &node : else_body) {
                    node->GenCode(&else_scope);
                }
                if(!false_block->getTerminator())
                    builder->CreateBr(merge);
            }else if(false_block->hasNUses(0)){
                false_block->removeFromParent();
            }

            //maybe try and remove merge block and all of its children
            //if(!merge->hasNUses(0))
            builder->SetInsertPoint(merge);

            return nullptr;
        }

        void IfStmt::Lower(AST *parent) {
            this->cond->Lower(this);
            for(const auto &item : this->then_body) {
                item->Lower(this);
            }
            for(const auto &item : this->else_body) {
                item->Lower(this);
            }
        }

        void IfStmt::Sanatize() {

        }

        ForStmt::ForStmt(Ref<AST> var, Ref<AST> cond, std::vector<Ref<AST>> body):
            AST(ASTType::ForStmt), var(var), cond(cond), body(body) {

        }

        std::string ForStmt::GetValue() {
            return {};
        }

        //fix returning -> see if_stmt
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
            this->cond->Lower(this);
            this->var->Lower(this);
            for(const auto &item : this->body) {
                item->Lower(this);
            }
        }

        void ForStmt::Sanatize() {

        }

        MatchStmt::MatchStmt(Ref<AST> value, std::vector<Case> cases):
            AST(ASTType::MatchStmt), value(value), cases(cases) {

        }

        std::string MatchStmt::GetValue() {
            return value->GetValue();
        }

        //fix returning -> see if_stmt
        //add `default case` eg. -> x/_ -> {...}
        llvm::Value *MatchStmt::GenCode(Scope *scope) {
            auto val = value->GenCode(scope);
            if(ShouldLoad(value.get()))
                val = LoadOrIgnore(val);


            auto fn = builder->GetInsertBlock()->getParent();
            auto merge = llvm::BasicBlock::Create(*ctx, "", fn);
            auto sw = builder->CreateSwitch(val, merge);
            std::vector<std::tuple<llvm::Value *, llvm::BasicBlock *>> branches;
            for(const auto &[value, body] : cases) {
                Scope scope_local{scope};
                auto bb = llvm::BasicBlock::Create(*ctx, "", fn, merge);
                builder->SetInsertPoint(bb);
                    for(const auto &node : body)
                        node->GenCode(&scope_local);
                builder->CreateBr(merge);
                branches.push_back({value->GenCode(scope), bb});
            }

            for(const auto &[value, bb] : branches) {
                sw->addCase((llvm::ConstantInt *)value, bb);
            }

            builder->SetInsertPoint(merge);
            return nullptr;
        }

        void MatchStmt::Lower(AST *parent) {
            value->Lower(this);
            for(const auto &[cond, body] : cases) {
                cond->Lower(this);
                for(const auto &item : body) {
                    item->Lower(this);
                }
            }
        }

        void MatchStmt::Sanatize() {

        }
    }
}
