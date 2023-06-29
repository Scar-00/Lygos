#ifndef _LYGOS_SCOPE_H_
#define _LYGOS_SCOPE_H_

#include "../core.h"

#include <string_view>
#include <unordered_map>
#include <unordered_set>

namespace lygos {
    namespace AST {
        struct Mod;
        struct Function;
        struct Macro;
        namespace Trait {
            struct Trait;
        }
        struct Scope {
            public:
                Scope(Scope *parent = nullptr, Ref<Mod> mod = nullptr): mod(mod), parent(parent) {}
                void Print();
                void DeclVar(std::string id, bool cnst, Type::Variable type);
                void SetRet(llvm::Value *value) { ret = value; }
                llvm:: Value *GetRet();
                bool HasRetValue();
                Type::Variable LookupVar(std::string id);
                void RegisterFunction(Type::Function function);
                void AddStructType(std::string id, Type::StructType struct_type);
                void AddEnumType(std::string id, Type::EnumType enum_type);
                void AddTypeAlias(std::string name, Ref<Type::Type> ref_type);
                void DeclMacro(Macro *macro);
                void DeclTrait(Trait::Trait *trait);

                bool IsEnum(std::string_view name);
                bool IsStruct(std::string_view name);
                bool IsMacro(std::string_view name);
                bool IsTrait(std::string_view name);

                Type::Function &GetFunction(std::string name);
                Type::StructType &GetStruct(std::string name);
                Type::EnumType &GetEnum(std::string);
                Macro &GetMacro(std::string &name);
                Trait::Trait &GetTrait(std::string &name);

                std::unordered_map<std::string, Type::StructType> &GetStructTypes() { return struct_types; }
                std::unordered_map<std::string, Type::EnumType> &GetEnumTypes() { return enum_types; }
                std::unordered_map<std::string, Type::Function> &GetFunctions() { return functions; }
                std::unordered_map<std::string, Ref<Type::Type>> &GetTypeAliases() { return type_aliases; }
                std::unordered_map<std::string, Macro*> &GetMacros() { return macros; }
                std::unordered_map<std::string, Trait::Trait *> &GetTraits() { return traits; }

                llvm::Type *GetType(Type::Type *type);
                Ref<Mod> GetMod();
                void SetParent(Scope *parent) { this->parent = parent; }
            private:
                Scope *Resolve(std::string id);
                Scope *Resolve(const char *type);
            private:
                Ref<Mod> mod;
                std::unordered_map<std::string, Type::Variable> vars;
                std::set<std::string> constants;
                std::unordered_map<std::string, Type::StructType> struct_types;
                std::unordered_map<std::string, Type::EnumType> enum_types;
                std::unordered_map<std::string, Type::Function> functions;
                std::unordered_map<std::string, Ref<Type::Type>> type_aliases;
                std::unordered_map<std::string, Macro*> macros;
                std::unordered_map<std::string, Trait::Trait *> traits;
                Scope *parent = nullptr;
                llvm::Value *ret = nullptr;
        };
    }
}
#endif // _LYGOS_SCOPE_H_
