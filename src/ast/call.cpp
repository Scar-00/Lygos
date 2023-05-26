#include "call.h"
#include "access.h"
#include "ast.h"
#include "mod.h"
#include "function.h"
#include "access.h"
#include <fmt/core.h>
#include <ios>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Instructions.h>
#include <vector>

namespace lygos {
    namespace AST {
        CallExpr::CallExpr(Ref<AST> caller, std::vector<Ref<AST>> args):
            AST(ASTType::CallExpr), caller(caller), args(args) {

        }

        std::string CallExpr::GetValue() {
            return caller->GetValue();
        }

        llvm::Value *CallExpr::GenCode(Scope *scope) {
            //std::cout << this->GetCaller()->type << "\n";
            auto fn_name = caller->GetValue();
            auto fn = ast_root->GetFunction(fn_name);
            llvm::Function *callee = mod->getFunction(fn_name);
            bool is_ptr = false;
            if(!callee || !fn) {
                auto test = caller->GenCode(scope);
                if(!IsFunctionType(test->getType()))
                    Log::Logger::Warn(fmt::format("unknown function `{}`", caller->GetValue()));
                fmt::print("test -> {}\n", PrintValue(test));
                //callee = (llvm::Function *)builder->CreateLoad(TryGetPointerBase(test->getType()), test);
                callee = (llvm::Function *)test;
                fmt::print("load -> {}\n", PrintValue(callee));
                fmt::print("type -> {}\n", PrintType(callee->getType()));
                is_ptr = true;
            }
            //llvm::FunctionCallee c = {(llvm::FunctionType *)callee->getType(), callee};
            if(!is_ptr)
                if(!callee->isVarArg() && callee->arg_size() != args.size())
                    Log::Logger::Warn(fmt::format("function `{}` expected `{}` args but only `{}` were supplied", fn_name, callee->arg_size(), args.size()));

            std::vector<llvm::Value *> arg_values;
            u64 i = 0;
            for(const auto &arg : args) {
                auto val = arg->GenCode(scope);
                if(ShouldLoad(arg.get()) && (!(i == 0 && fn->IsMember()) || (i == 0 && deref_self)))
                    val = LoadOrIgnore(val);
                /*if(ShouldLoad(arg.get()))
                    if(!is_ptr && (!(i == 0 && fn->IsMember()) || (i == 0 && deref_self)))
                        val = LoadOrIgnore(val);*/
                //add implicit casting
                arg_values.push_back(val);
                i++;
            }
            //c.getFunctionType()->isVarArg();
            //Log::Logger::Warn("test");
            return builder->CreateCall(callee, arg_values);
        }

        void CallExpr::Lower(AST *parent) {
            if(parent->type == ASTType::MemberExpr) {
                deref_self = ((MemberExpr *)parent)->Deref();
            }
            //TODO: make args into a Block
            Block b = args;
            fmt::print("size -> {}\n", b.Body().size());
            for(u64 i = 0; i < b.Body().size(); i++) {
                ast_root->SetCurrentBlock(&b);
                b.Body()[i]->Lower(this);
                b.Increment();
            }
            args = b.Body();
        }

        void CallExpr::Sanatize() {

        }

        ReturnExpr::ReturnExpr(Ref<AST> value):
            AST(ASTType::ReturnExpr), value(value) {

        }

        std::string ReturnExpr::GetValue() {
            return value->GetValue();
        }

        llvm::Value *ReturnExpr::GenCode(Scope *scope) {
            if(value == NULL) {
                //if(scope->GetRetBlock() != nullptr)
                //    builder->CreateBr(scope->GetRetBlock());
                return NULL;
            }


            auto val = value->GenCode(scope);
            if(ShouldLoad(value.get()))
                val = LoadOrIgnore(val);

            if(!scope->HasRetValue())
                Log::Logger::Warn(fmt::format("invalid return type `{}` for function with return type `void`", PrintType(val->getType())));

            if(scope->GetRetBlock() != nullptr) {
                auto store = builder->CreateStore(val, scope->GetRet());
                builder->CreateBr(scope->GetRetBlock());
                return store;
            }

            return builder->CreateStore(val, scope->GetRet());
        }

        void ReturnExpr::Lower(AST *parent) {

        }

        void ReturnExpr::Sanatize() {

        }
    }
}
