#include "call.h"
#include "access.h"
#include "ast.h"
#include "mod.h"
#include "function.h"
#include "access.h"
#include <ios>
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
            auto callee = mod->getFunction(fn_name);
            if(!callee || !fn) {
                Log::Logger::Warn(fmt::format("unknown function `{}`", caller->GetValue()));
            }

            if(!callee->isVarArg() && callee->arg_size() != args.size())
                Log::Logger::Warn(fmt::format("function `{}` expected `{}` args but only `{}` were supplied", fn_name, callee->arg_size(), args.size()));

            std::vector<llvm::Value *> arg_values;
            u64 i = 0;
            for(const auto &arg : args) {
                auto val = arg->GenCode(scope);
                if(ShouldLoad(arg.get()) && !(i == 0 && fn->IsMember()))
                    val = LoadOrIgnore(val);
                //add implicit casting
                arg_values.push_back(val);
                i++;
            }
            return builder->CreateCall(callee, arg_values);
        }

        void CallExpr::Lower(AST *parent) {
            /*if(caller->type == ASTType::MemberExpr) {
                std::vector<Ref<AST>> elems;
                auto call = MakeRef<CallExpr>(static_cast<MemberExpr *>(caller.get())->Member(), args);
                auto member = MakeRef<MemberExpr>(static_cast<MemberExpr *>(caller.get())->Obj(), call);

                elems.push_back(member);

                ast_root->GetCurrentFunction()->Insert(elems);
            }*/
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
