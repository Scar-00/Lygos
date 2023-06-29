#include "scope.h"

#include "../error/log.h"
#include "macro.h"

#include "trait.h"

#include <fmt/core.h>
#include <fmt/format.h>
#include <memory>
#include <string_view>
#include <vector>


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
            std::cout << "[funcs]:\n";
            for(const auto &func : this->functions) {
                std::cout << "    " << func.first << "\n";
            }
            std::cout << "[macros]:\n";
            for(const auto &macro : this->macros) {
                std::cout << "    " << macro.first << "\n";
            }
            std::cout << "[structs]:\n";
            for(const auto &strct : this->struct_types) {
                std::cout << "    " << strct.first << "\n";
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
                Log::Logger::Warn(fmt::format("Cannot redeclare function `{}`", function.name));
            functions.insert({function.name, function});
        }

        bool Scope::IsEnum(std::string_view name) {
            Scope *scope = this->Resolve(name.data());
            return scope->enum_types.contains(name.data());
        }

        bool Scope::IsStruct(std::string_view name) {
            Scope *scope = this->Resolve(name.data());
            return scope->struct_types.contains(name.data());
        }

        bool Scope::IsMacro(std::string_view name) {
            Scope *scope = this->Resolve(name.data());
            return scope->macros.contains(name.data());
        }

        bool Scope::IsTrait(std::string_view name) {
            Scope *scope = this->Resolve(name.data());
            return scope->traits.contains(name.data());
        }

        Type::Function& Scope::GetFunction(std::string name) {
            Scope *scope = this->Resolve(name.c_str());
            if(!scope->functions.contains(name))
                Log::Logger::Warn(fmt::format("unknown function `{}`", name));
            return scope->functions.at(name);
        }

        //TODO: check in every function weather another type with the same name exists
        void Scope::AddStructType(std::string id, Type::StructType struct_type) {
            auto scope = this->Resolve(id.c_str());
            if(scope->struct_types.contains(id))
                Log::Logger::Warn(fmt::format("cannot redeclare type `{}`", id));
            this->struct_types.insert({id, struct_type});
        }

        void Scope::AddEnumType(std::string id, Type::EnumType enum_type) {
            auto scope = this->Resolve(id.c_str());
            if(scope->enum_types.contains(id))
                Log::Logger::Warn(fmt::format("cannot redeclare type `{}`", id));
            this->enum_types.insert({id, enum_type});
        }

        void Scope::AddTypeAlias(std::string name, Ref<Type::Type> ref_type) {
            Scope *scope = this->Resolve(name.c_str());
            if(scope->type_aliases.contains(name))
                Log::Logger::Warn(fmt::format("cannot redeclare type alias `{}`", name));
            scope->type_aliases.insert({name, ref_type});
        }

        void Scope::DeclMacro(Macro *macro) {
            if(macros.contains(macro->GetName()))
                Log::Logger::Warn(fmt::format("cannot redeclare macro `{}`", macro->GetName()));
            macros.insert({macro->GetName(), macro});
        }

        Macro &Scope::GetMacro(std::string &name) {
            Scope *scope = this->Resolve(name.c_str());
            if(!scope->macros.contains(name))
                Log::Logger::Warn(fmt::format("unknown macro `{}`", name));
            return *scope->macros.at(name);
        }

        void Scope::DeclTrait(Trait::Trait *trait) {
            if(traits.contains(trait->GetValue()))
                Log::Logger::Warn(fmt::format("cannot redeclare trait `{}`", trait->GetValue()));
            traits.insert({trait->GetValue(), trait});
        }

        Trait::Trait &Scope::GetTrait(std::string &name) {
            Scope *scope = this->Resolve(name.c_str());
            if(!scope->traits.contains(name))
                Log::Logger::Warn(fmt::format("unknown trait `{}`", name));
            return *scope->traits.at(name);
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
                        //fmt::print("gen -> {}\n", typ.generics.size());
                        //fmt::print("args -> {}\n", ((Type::Path *)type)->GetArgs().size());
                        if(typ.generics.size() != ((Type::Path *)type)->GetArgs().size())
                            Log::Logger::Warn(fmt::format("incorrect number of args supplied to type", typ.name));
                        if(typ.generics.size() > 0) {
                            std::string name = typ.name;
                            std::vector<llvm::Type *> types;
                            for(const auto &type : ((Type::Path *)type)->GetArgs()) {
                                fmt::print("arg -> {}\n", type->GetName());
                                types.push_back(GetType(type.get()));
                                name += "_" + type->GetFullName();
                            }
                            if(!typ.variants.contains(name)) {
                                typ.variants.insert({name, llvm::StructType::create(
                                    *ctx,
                                    types,
                                    name,
                                    false
                                )});
                            }

                            return typ.variants.at(name);
                        }
                        if(!typ.variants.contains(typ.name)) {
                            std::vector<llvm::Type *> types;
                            for(const auto &[name, type] : typ.fields) {
                                types.push_back(GetType(type.get()));
                            }
                            typ.variants.insert({typ.name, llvm::StructType::create(
                                *ctx,
                                types,
                                typ.name,
                                false
                            )});
                        }

                        return typ.variants.at(typ.name);
                    }
                    if(scope->enum_types.contains(path))
                        return GetType(scope->enum_types.at(path).type.get());
                    if(scope->type_aliases.contains(path))
                        return GetType(scope->type_aliases.at(path).get());
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
            if(!scope->struct_types.contains(type))
                Log::Logger::Warn(fmt::format("unknown struct type `{}`", type));
            return scope->struct_types.at(type);
        }

        Type::EnumType &Scope::GetEnum(std::string type) {
            Scope *scope = this->Resolve(type.c_str());
            if(!scope->enum_types.contains(type))
                Log::Logger::Warn(fmt::format("unknown enum type `{}`", type));
            return scope->enum_types.at(type);
        }

        Scope *Scope::Resolve(std::string var) {
            if(vars.contains(var))
                return this;

            if(!parent)
                Log::Logger::Warn(fmt::format("cannot resolve variable `{}`", var));

            return parent->Resolve(var);
        }

        Scope *Scope::Resolve(const char *type) {
            std::string type_string{type};
            if(this->struct_types.contains(type_string)
            || this->enum_types.contains(type_string)
            || this->functions.contains(type_string)
            || this->type_aliases.contains(type_string)
            || this->macros.contains(type_string)
            || this->traits.contains(type_string)
            ) return this;

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
