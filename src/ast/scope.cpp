#include "scope.h"

#include "../error/log.h"
#include "macro.h"

#include "function.h"

#include <fmt/core.h>
#include <fmt/format.h>
#include <memory>


namespace lygos {
    namespace AST {
        void Scope::DeclVar(std::string id, bool cnst, Type::Variable type) {
            Scope *scpoe = this;
            if(scpoe->vars.contains(id))
                Log::Logger::Warn(fmt::format("cannot declare variable `{}` twice", id));

            if(cnst)
                scpoe->constants.insert(id);

            scpoe->vars.insert({id, type});
        }

        void Scope::Print() {
            std::cout << "Scope [\n";
            std::cout << "-types:\n";
            for(auto const &pair : struct_types) {
                std::cout << "\t" << PrintType(pair.second.llvm_type) << "\n";
            }
            std::cout << "-vars:\n";
            for(auto const &[name, alloca] : vars) {
                std::cout << "\t{" << name << " : " << PrintType(alloca.alloca->getType()) << "},\n";
            }
            std::cout << "]" << std::endl;
        }

        llvm::Value *Scope::GetRet() {
            if(ret != nullptr)
                return ret;

            if(parent == nullptr)
                return ret;

            return parent->GetRet();
        }

        bool Scope::HasRetValue() {
            if(ret != nullptr)
                return true;

            if(parent == nullptr)
                return false;

            return parent->HasRetValue();
        }

        Type::Variable Scope::LookupVar(std::string id) {
            Scope *scope = this->Resolve(id);
            if(!scope->vars.contains(id))
                Log::Logger::Warn(fmt::format("`{}` is undefined", id));

            return scope->vars.at(id);
        }

        void Scope::RegisterFunction(Type::Function function) {
            if(functions.contains(function.name))
                Log::Logger::Warn("");
            functions.insert({function.name, function});
        }

        Type::Function Scope::GetFunction(std::string name) {
            if(!functions.contains(name))
                Log::Logger::Warn("");
            return functions.at(name);
        }

        void Scope::AddStructType(std::string id, Type::StructType struct_type) {
            auto scope = this->Resolve(id.c_str());
            if(scope->struct_types.contains(id))
                Log::Logger::Warn(fmt::format("cannot redeclare type `%s`", id));
            this->struct_types.insert({id, struct_type});
        }

        void Scope::AddEnumType(std::string id, Type::EnumType enum_type) {
            auto scope = this->Resolve(id.c_str());
            if(scope->enum_types.contains(id))
                Log::Logger::Warn(fmt::format("cannot redeclare type `%s`", id));
            this->enum_types.insert({id, enum_type});
        }

        llvm::Type *Scope::GetType(Type::Type *type) {
            switch (type->kind) {
                case Type::Kind::path: {
                    auto path = static_cast<Type::Path *>(type)->GetPath();
                    if(base_types.contains(path)) return ResolveType(path);
                    Scope *scope = this->Resolve(path.c_str());
                    if(scope->struct_types.contains(path)) {
                        Type::StructType &typ = scope->struct_types.at(path);
                        //handle potential generics of the type
                        for(const auto &type : ((Type::Path *)type)->GetArgs()) {
                            fmt::print("{}\n", type->GetName());
                        }
                        return typ.llvm_type;
                    }
                    if(scope->enum_types.contains(path))
                        return GetType(scope->enum_types.at(path).type.get());
                } break;
                case Type::Kind::ptr:
                    return llvm::PointerType::get(GetType(static_cast<Type::Pointer *>(type)->GetType().get()), 0);
                    break;
                case Type::Kind::arr: {
                    auto arr_type = static_cast<Type::Array *>(type);
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
                    return llvm::PointerType::get(type, 0);
                }break;
                case Type::Kind::trait: {

                } break;
            }
            Log::Logger::Warn(fmt::format("unknwon type `{}`", type->GetName()));
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

        Option<Type::EnumType> Scope::GetEnum(std::string type) {
            Scope *scope = this->Resolve(type.c_str());
            if(scope->enum_types.contains(type))
                return Some(scope->enum_types.at(type));
            return None;
        }

        Scope *Scope::Resolve(std::string var) {
            if(vars.contains(var))
                return this;

            if(!parent)
                Log::Logger::Warn(fmt::format("cannot resolve variable `{}`", var));

            return parent->Resolve(var);
        }

        Scope *Scope::Resolve(const char *type) {
            if(this->struct_types.contains({type}) || this->enum_types.contains({type}))
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
