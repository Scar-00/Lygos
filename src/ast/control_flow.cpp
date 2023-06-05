#include "control_flow.h"
#include "ast.h"
#include "scope.h"
#include "mod.h"
#include "function.h"
#include <llvm/ADT/Twine.h>
#include <llvm/Support/raw_ostream.h>
#include <vector>

namespace lygos {
    namespace AST {
        IfStmt::IfStmt(Ref<AST> cond, Block then_body, Block else_body, bool has_else_brach):
            AST(ASTType::IfStmt), cond(cond), then_body(then_body), else_body(else_body), has_else_brach(has_else_brach) {

        }

        std::string IfStmt::GetValue() {
            return {};
        }

        //fix non early return
        llvm::Value *IfStmt::GenCode(Scope *scope) {
            llvm::Function *fn = builder->GetInsertBlock()->getParent();

            if(then_body.Returns() || else_body.Returns())
                ast_root->GetCurrentFunction()->SetRetBlock(llvm::BasicBlock::Create(*ctx, "ret", fn));
            auto ret_block = ast_root->GetCurrentFunction()->GetRetBlock();

            auto true_block = llvm::BasicBlock::Create(*ctx, "if.then", fn, ret_block);
            auto false_block = llvm::BasicBlock::Create(*ctx, "if.else", fn, ret_block);
            auto merge = llvm::BasicBlock::Create(*ctx, "if.end", fn, ret_block);
            builder->CreateCondBr(cond->GenCode(scope), true_block, has_else_brach ? false_block : merge);

            builder->SetInsertPoint(true_block);
            Scope then_scope{scope};
            for(const auto &node : then_body.Body()) {
                node->GenCode(&then_scope);
            }
            if(!true_block->getTerminator())
                builder->CreateBr(merge);

            //generate else
            builder->SetInsertPoint(false_block);
            if(has_else_brach) {
                Scope else_scope{scope};
                for(const auto &node : else_body.Body()) {
                    node->GenCode(&else_scope);
                }
                if(!false_block->getTerminator())
                    builder->CreateBr(merge);
            }else if(false_block->hasNUses(0)){
                false_block->removeFromParent();
            }

            //maybe try and remove merge block and all of its children
            if(merge->hasNUses(0))
                merge->removeFromParent();
            builder->SetInsertPoint(merge);

            return nullptr;
        }

        void IfStmt::Lower(AST *parent) {
            this->cond->Lower(this);
            for(size_t i = 0; i < then_body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&then_body);
                then_body.Body()[i]->Lower(this);
                then_body.Increment();
            }
            if(has_else_brach) {
                for(size_t i = 0; i < else_body.Body().size(); i++) {
                    ast_root->SetCurrentBlock(&else_body);
                    else_body.Body()[i]->Lower(this);
                    else_body.Increment();
                }
            }
        }

        void IfStmt::Sanatize() {

        }

        ForStmt::ForStmt(Ref<AST> var, Ref<AST> cond, Block body):
            AST(ASTType::ForStmt), var(var), cond(cond), body(body) {

        }

        std::string ForStmt::GetValue() {
            return {};
        }

        //fix returning -> see if_stmt
        llvm::Value *ForStmt::GenCode(Scope *scope) {
            llvm::Function *fn = builder->GetInsertBlock()->getParent();

            auto cond = llvm::BasicBlock::Create(*ctx, "for.cond", fn);
            auto loop_body = llvm::BasicBlock::Create(*ctx, "for.block", fn);
            auto merge = llvm::BasicBlock::Create(*ctx, "for.end", fn);

            //builder->CreateCondBr(this->cond->GenCode(scope), block, merge);

            Scope loop_scope{scope};
            var->GenCode(&loop_scope);
            builder->CreateBr(cond);

            //cond block
            builder->SetInsertPoint(cond);
            builder->CreateCondBr(this->cond->GenCode(&loop_scope), loop_body, merge);
            //body
            builder->SetInsertPoint(loop_body);
            for(const auto &expr : body.Body())
                expr->GenCode(&loop_scope);
            builder->CreateBr(cond);

            //end
            builder->SetInsertPoint(merge);

            return nullptr;
        }

        void ForStmt::Lower(AST *parent) {
            this->cond->Lower(this);
            this->var->Lower(this);
            for(size_t i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&body);
                body.Body()[i]->Lower(this);
                body.Increment();
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
                for(const auto &node : body.Body())
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
            for(auto &[cond, body] : cases) {
                cond->Lower(this);
                for(size_t i = 0; i < body.Body().size(); i++) {
                    ast_root->SetCurrentBlock(&body);
                    body.Body()[i]->Lower(this);
                    body.Increment();
                }
            }
        }

        void MatchStmt::Sanatize() {

        }
    }
}
