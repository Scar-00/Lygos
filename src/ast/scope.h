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
                //void SetRetBlock(llvm::BasicBlock *block);
                //llvm::BasicBlock *GetRetBlock();
                bool HasRetValue();
                Type::Variable LookupVar(std::string id);
                //std::unordered_map<std::string, llvm::AllocaInst *> &GetVars() { return vars; }
                void RegisterFunction(Type::Function function);
                Type::Function GetFunction(std::string name);
                void AddType(std::string id, Type::StructType struct_type);
                llvm::Type *GetType(Type::Type *type);
                Type::StructType &GetStruct(std::string);
                Ref<Mod> GetMod();
            private:
                Scope *Resolve(std::string id);
                Scope *Resolve(const char *type);
            private:
                Ref<Mod> mod;
                //add own type for more info
                //std::unordered_map<std::string, std::tuple<llvm::AllocaInst *, Ref<Type::Type>>> vars;
                std::unordered_map<std::string, Type::Variable> vars;
                std::set<std::string> constants;
                std::unordered_map<std::string, Type::StructType> struct_types;
                std::unordered_map<std::string, Type::Function> functions;
                Scope *parent = nullptr;
                llvm::Value *ret = nullptr;
                //llvm::BasicBlock *ret_block = nullptr;
        };
    }
}
#endif // _LYGOS_SCOPE_H_
