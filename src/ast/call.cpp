#include "call.h"

namespace lygos {
    namespace AST {
        CallExpr::CallExpr(Ref<AST> caller, std::vector<Ref<AST>> args):
            AST(ASTType::CallExpr), caller(caller), args(args) {

        }

        std::string CallExpr::GetValue() {
            return caller->GetValue();
        }

        llvm::Value *CallExpr::GenCode(Scope *scope) {
            auto callee = mod->getFunction(caller->GetValue());
            if(!callee) {
                Log::Logger::Warn(fmt::format("unknown function `{}`", caller->GetValue()));
            }

            if(!callee->isVarArg() && callee->arg_size() != args.size())
                Log::Logger::Warn(fmt::format("expected `{}` args but only `{}` were supplied", callee->arg_size(), args.size()));

            std::vector<llvm::Value *> arg_values;
            for(const auto &arg : args) {
                auto val = arg->GenCode(scope);
                if(ShouldLoad(arg.get()) && arg->type != ASTType::UnaryExpr)
                    val = LoadOrIgnore(val);
                //add implicit casting
                arg_values.push_back(val);
            }

            return builder->CreateCall(callee, arg_values);
        }

        void CallExpr::Lower(AST *parent) {

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
            if(value == NULL)
                return NULL;

            if(!scope->GetRet())
                Log::Logger::Warn("invalid return type for function with return type `void`");

            auto val = value->GenCode(scope);
            if(ShouldLoad(value.get()))
                val = LoadOrIgnore(val);

            return builder->CreateStore(val, scope->GetRet());
        }

        void ReturnExpr::Lower(AST *parent) {

        }

        void ReturnExpr::Sanatize() {

        }
    }
}
