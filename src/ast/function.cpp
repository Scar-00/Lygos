#include "function.h"
#include "llvm/IR/Verifier.h"
#include <vector>

namespace lygos {
    namespace AST {
        Function::Function(std::string name, Ref<Impl> obj, std::vector<Function::Arg> args, std::vector<Ref<AST>> body, Ref<Type::Type> ret_type):
            AST(ASTType::Function), name(name), obj(obj), args(args), body(body), ret_type(ret_type), is_definition(body.size() != 0) {

        }

        void Function::Insert(std::vector<Ref<AST>> &elems) {
            VecInsertAt(body, instr_index, elems);
            instr_index += elems.size();
        }

        llvm::Value *Function::GenCode(Scope *scope) {
            Scope curr_scope{scope};

            auto fn = mod->getFunction(name);
            if(!fn) {
                std::vector<llvm::Type *> arg_types;
                for(const auto &[name, type] : args)
                    arg_types.push_back(curr_scope.GetType(type));

                auto fn_type = llvm::FunctionType::get(
                    curr_scope.GetType(ret_type.get()),
                    arg_types,
                    is_var_arg
                );

                fn = llvm::Function::Create(
                    fn_type,
                    llvm::Function::LinkageTypes::CommonLinkage,
                    name,
                    *mod
                );
            }

            //maybe remove
            fn->setDSOLocal(true);

            auto bb = llvm::BasicBlock::Create(*ctx, "", fn);
            builder->SetInsertPoint(bb);
            auto args = fn->arg_begin();
            for(size_t i = 0; i < fn->arg_size(); i++) {
                auto arg = &*args + i;
                auto alloca = builder->CreateAlloca(arg->getType());
                builder->CreateStore(arg, alloca);
                curr_scope.DeclVar(std::get<0>(this->args.at(i)), false, alloca);
            }

            if(!(ret_type->kind == Type::Kind::path && ((Type::Path *)ret_type.get())->GetPath() == "void"))
                curr_scope.SetRet(builder->CreateAlloca(fn->getReturnType()));

            for(const auto &node : body)
                node->GenCode(&curr_scope);

            curr_scope.GetRet() ? builder->CreateRet(LoadOrIgnore(curr_scope.GetRet())) : builder->CreateRetVoid();

            llvm::verifyFunction(*fn, &llvm::errs());

            return nullptr;
        }

        void Function::Lower() {
            for(const auto &item : body) {
                IncrInstr();
                item->Lower();
            }
        }

        void Function::Sanatize() {
            LYGOS_ASSERT(name != "" && "Unnamed Function");
            LYGOS_ASSERT(ret_type != NULL && "Function needs to have a return type");
        }
    }
}
