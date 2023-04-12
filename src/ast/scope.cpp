#include "scope.h"

#include "../error/log.h"

#include "function.h"

#include <fmt/format.h>


namespace lygos {
    namespace AST {
        void Scope::DeclVar(std::string id, bool cnst, llvm::AllocaInst *value) {
            Scope *scpoe = this;
            if(scpoe->vars.contains(id))
                Log::Logger::Warn(fmt::format("cannot declare variable `{}` twice", id));

            if(cnst)
                scpoe->constants.insert(id);

            scpoe->vars.insert_or_assign(id, value);
        }

        void Scope::Print() {
            std::cout << "Scope [\n";
            std::cout << "-types:\n";
            for(auto const &pair : struct_types) {
                std::cout << "\t" << PrintType(pair.second.llvm_type) << "\n";
            }
            std::cout << "-vars:\n";
            for(auto const &pair : vars) {
                std::cout << "\t{" << pair.first << " : " << PrintType(pair.second->getType()) << "},\n";
            }
            std::cout << "]" << std::endl;
        }

        llvm::AllocaInst *Scope::LookupVar(std::string id) {
            Scope *scope = this->Resolve(id);
            if(!scope->vars.contains(id))
                Log::Logger::Warn(fmt::format("`{}` is undefined", id));

            return scope->vars.at(id);
        }


        void Scope::AddType(std::string id, Type::StructType struct_type) {
            auto scope = this->Resolve(id.c_str());
            if(scope->struct_types.contains(id))
                Log::Logger::Warn(fmt::format("cannot redeclare `%s`", id));
            this->struct_types.insert({id, struct_type});
        }

        void Scope::TypeAddFunction(std::string type, Type::Function func) {
            auto scope = this->Resolve(type.c_str());
            if(!scope->struct_types.contains(type))
                Log::Logger::Warn(fmt::format("unknown type `{}`", type));

            if(VecContains(scope->struct_types.at(type).functions, func))
                Log::Logger::Warn(fmt::format("cannot redeclare function `{}` in type `{}`", "", type));

            this->struct_types.at(type).functions.push_back(func);
        }

        llvm::Type *Scope::GetType(Type::Type *type) {
            switch (type->kind) {
                case Type::Kind::path: {
                    auto path = static_cast<Type::Path *>(type)->GetPath();
                    if(base_types.contains(path)) return ResolveType(path);
                    Scope *scope = this->Resolve(path.c_str());
                    if(scope->struct_types.contains(path)) {
                        return scope->struct_types.at(path).llvm_type;
                    }
                } break;
                case Type::Kind::ptr:
                    return llvm::PointerType::get(GetType(static_cast<Type::Pointer *>(type)->GetType().get()), 0);
                    break;
                case Type::Kind::arr: {
                    auto arr_type = static_cast<Type::Array *>(type);
                    //error("TODO!, [Arr Type]");
                    return llvm::ArrayType::get(GetType(arr_type->GetType().get()), arr_type->ElemCount());
                } break;
                case Type::Kind::function: {
                    auto fn_type = (Type::FuncPtr *)type;
                    std::vector<llvm::Type *> params;
                    for(auto &par : fn_type->GetParams()) {
                        params.push_back(GetType(par.get()));
                    }
                    auto type = llvm::FunctionType::get(
                        GetType(fn_type->GetRetType().get()),
                        params,
                        false
                    );
                    //error("Unimplemented [FuncPtr]");
                    return llvm::PointerType::get(type, 0);
                    //return type;
                }break;
                case Type::Kind::trait: {

                } break;
            }
            Log::Logger::Warn(fmt::format("unknwon type `{}`", STRINGIFY(type->kind)));
            std::exit(1);
        }

        Type::StructType &Scope::GetStruct(std::string type) {
            Scope *scope = this->Resolve(type.c_str());
            if(scope->struct_types.contains(type)) {
                return scope->struct_types.at(type);
            }

            Log::Logger::Warn(fmt::format("unknwon struct type `{}`", type));
            std::exit(1);
        }

        Scope *Scope::Resolve(std::string var) {
            if(vars.contains(var))
                return this;

            if(!parent)
                Log::Logger::Warn(fmt::format("cannot resolve variable `{}`", var));

            return parent->Resolve(var);
        }

        Scope *Scope::Resolve(const char *type) {
            if(this->struct_types.contains({type}))
                return this;

            if(!this->parent)
                return this;

            return parent->Resolve(type);
        }

        Ref<Mod> Scope::GetMod() {
            if(mod)
                return mod;

            LYGOS_ASSERT(parent && "mod and parent cannot be NULL");

            return parent->GetMod();
        }
    }
}
