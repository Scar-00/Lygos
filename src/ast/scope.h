#ifndef _LYGOS_SCOPE_H_
#define _LYGOS_SCOPE_H_

#include "../core.h"

#include <unordered_map>
#include <unordered_set>

namespace lygos {
    namespace AST {
        struct Mod;
        struct Function;
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
                Type::Function GetFunction(std::string name);
                void AddStructType(std::string id, Type::StructType struct_type);
                void AddEnumType(std::string id, Type::EnumType enum_type);
                llvm::Type *GetType(Type::Type *type);
                Type::StructType &GetStruct(std::string);
                Option<Type::EnumType> GetEnum(std::string);
                Ref<Mod> GetMod();
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
                Scope *parent = nullptr;
                llvm::Value *ret = nullptr;
        };
    }
}
#endif // _LYGOS_SCOPE_H_
