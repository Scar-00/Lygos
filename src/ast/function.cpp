#include "function.h"
#include "ast.h"
#include "mod.h"
#include "impl.h"
#include <cstdio>
#include <llvm/Support/raw_ostream.h>

namespace lygos {
    namespace AST {
        Function::Function(std::string name, Ref<Impl> obj, std::vector<Function::Arg> args, Block body, Ref<Type::Type> ret_type, bool is_def):
            AST(ASTType::Function), name(name), obj(obj), args(args), body(body), ret_type(ret_type), is_definition(is_def) {

        }

        void Function::SetRetBlock(llvm::BasicBlock *block) {
            if(return_block)
                return;
            return_block = block;
        }

        llvm::Value *Function::GenCode(Scope *scope) {
            this->Body().SetParent(scope);

            auto fn = mod->getFunction(name);
            //check if function is already defined
            if(!fn) {
                std::vector<llvm::Type *> arg_types;
                for(const auto &[name, type] : args)
                    arg_types.push_back(body.Scope().GetType(type.get()));

                auto fn_type = llvm::FunctionType::get(
                    body.Scope().GetType(ret_type.get()),
                    arg_types,
                    is_var_arg
                );

                fn = llvm::Function::Create(
                    fn_type,
                    llvm::Function::LinkageTypes::ExternalLinkage,
                    name,
                    *mod
                );
            }
            //if(is_definition)
            ast_root->SetCurrentFunction(this);
            if(!is_definition)
                return nullptr;

            //maybe remove
            fn->setDSOLocal(true);

            auto bb = llvm::BasicBlock::Create(*ctx, "", fn);
            builder->SetInsertPoint(bb);
            auto args = fn->arg_begin();
            for(size_t i = 0; i < fn->arg_size(); i++) {
                auto arg = &*args + i;
                auto alloca = builder->CreateAlloca(arg->getType());
                builder->CreateStore(arg, alloca);
                body.Scope().DeclVar(std::get<0>(this->args.at(i)), false, {std::get<1>(this->args[i]), alloca});
            }

            //curr_scope.SetRetBlock(llvm::BasicBlock::Create(*ctx, "", fn));

            if(!(ret_type->kind == Type::Kind::path && ((Type::Path *)ret_type.get())->GetPath() == "void"))
                body.Scope().SetRet(builder->CreateAlloca(fn->getReturnType()));

            for(const auto &node : body.Body())
                node->GenCode(&body.Scope());

            //fmt::print("? -> {}\n", curr_scope.LookupVar("x").alloca->canBeFreed());

            if(return_block != nullptr)
                builder->SetInsertPoint(return_block);
            body.Scope().GetRet() ? builder->CreateRet(LoadOrIgnore(body.Scope().GetRet())) : builder->CreateRetVoid();

            llvm::verifyFunction(*fn, &llvm::errs());
            //curr_scope.Print();
            //scope->RegisterFunction({name, {}, this->args, ret_type, IsMember()});
            return nullptr;
        }

        Ref<Type::Type> Function::GetType(Scope *scope) {
            return ret_type;
        }

        void Function::Lower(AST *parent) {
            ast_root->GetCurrentBlock()->Scope().RegisterFunction({name, mangeled_name, this->args, ret_type, IsMember()});
            body.Scope().SetParent(&ast_root->GetCurrentBlock()->Scope());
            ast_root->SetCurrentFunction(this);
            for(u64 i = 0; i < body.Body().size(); i++) {
                ast_root->SetCurrentBlock(&body);
                body.Body()[i]->Lower(this);
                body.Increment();
            }
        }

        void Function::Sanatize() {
            LYGOS_ASSERT(name != "" && "Unnamed Function");
            LYGOS_ASSERT(ret_type != NULL && "Function needs to have a return type");
        }
    }
}
