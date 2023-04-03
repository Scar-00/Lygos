#include "call.h"
#include "../error/log.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string CallExpr::GetValue() {
            return this->caller->GetValue();
        }

        Val *CallExpr::GenCode(Scope *scope) {
            auto callee = mod->getFunction(this->caller->GetValue());
            if(!callee) {
                /*auto type = TryGetPointerBase(this->caller->GenCode(scope)->getType());
                if(!IsFunctionType(type))
                    error("Unknown function '%s'", caller->GetValue().c_str());
                callee = llvm::Function::Create((llvm::FunctionType *)TryGetPointerBase(type), llvm::Function::InternalLinkage, "f", *mod);
                //callee = (llvm::Function *)builder->CreateLoad(TryGetPointerBase(callee->getType()), callee);
                callee->getType()->print(Log(), true);*/
                Log::Logger::Warn(fmt::format("unknown function `{}`", caller->GetValue()));
            }

            if(!callee->isVarArg() && callee->arg_size() != this->args.size())
                Log::Logger::Warn(fmt::format("expected {} args but only {} were supplied", callee->arg_size(), this->args.size()));

            std::vector<Val *> arg_values;
            for(auto &arg : this->args) {
                auto val = arg->GenCode(scope);
                if(ShouldLoad(arg) && arg->type != ASTType::UnaryExpr)
                    val = LoadOrIgnore(val);

                //add implicit casting
                arg_values.push_back(val);
            }
            return builder->CreateCall(callee, arg_values);
        }

        std::string ReturnExpr::GetValue() {
            return {};
        }

        Val *ReturnExpr::GenCode(Scope *scope) {
            if(this->value == NULL) {
                return nullptr;
            }

            if(!scope->GetRet())
                Log::Logger::Warn("invalid return type for function with return type `void`");

            auto val = value->GenCode(scope);
            if(ShouldLoad(value))
                val = LoadOrIgnore(val);

            return builder->CreateStore(val, scope->GetRet());
        }
    }
}
