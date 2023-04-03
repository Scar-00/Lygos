#include "function.h"
#include "../types.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string Function::GetValue() {
            return id;
        }

        Val *Function::GenCode(Scope *scope) {
            Scope curr_scope{scope};

            auto fn = mod->getFunction(id);
            if(fn == NULL) {
                std::vector<llvm::Type *> args_type;
                for(auto &arg : this->args) {
                    args_type.push_back(curr_scope.GetType(std::get<1>(arg)));
                }

                auto fn_type = llvm::FunctionType::get(
                    curr_scope.GetType(this->return_type),
                    args_type,
                    false
                );

                fn = llvm::Function::Create(
                    fn_type,
                    llvm::Function::LinkageTypes::ExternalLinkage,
                    id,
                    *mod
                );
            }

            //maybe remove this ?
            fn->setDSOLocal(true);

            auto bb = llvm::BasicBlock::Create(*ctx, "", fn);
            builder->SetInsertPoint(bb);
            auto args = fn->arg_begin();
            for(size_t i = 0; i < fn->arg_size(); i++) {
                auto arg = &*args + i;
                auto alloca = builder->CreateAlloca(arg->getType());
                builder->CreateStore(arg, alloca);
                curr_scope.DeclVar(std::get<0>(this->args.at(i)), true, alloca);
            }

            if(!(return_type->kind == Type::Kind::path && static_cast<Type::Path *>(return_type)->GetPath() == "void"))
                curr_scope.SetRet(builder->CreateAlloca(fn->getReturnType()));

            for(auto &node : this->block)
                node->GenCode(&curr_scope);

            curr_scope.GetRet() ? builder->CreateRet(LoadOrIgnore(curr_scope.GetRet())) : builder->CreateRetVoid();

            llvm::verifyFunction(*fn);
            //curr_scope.Print();
            return nullptr;
        }

        std::string FunctionDecl::GetValue() {
            return id;
        }

        Val *FunctionDecl::GenCode(Scope *scope) {
            std::vector<llvm::Type *> args_type;
            for(auto &arg : this->params) {
                args_type.push_back(scope->GetType(std::get<1>(arg)));
            }

            auto fn_type = llvm::FunctionType::get(
                scope->GetType(this->return_type),
                args_type,
                false
            );

            auto fn = llvm::Function::Create(
                fn_type,
                llvm::Function::LinkageTypes::ExternalLinkage,
                id,
                *mod
            );

            llvm::verifyFunction(*fn, &llvm::errs());
            return nullptr;
        }
    }
}
