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
                void DeclVar(std::string id, bool cnst, llvm::AllocaInst *value);
                void SetRet(llvm::Value *value) { ret = value; }
                llvm:: Value *GetRet() { return ret; }
                bool HasRetValue();
                llvm::AllocaInst *LookupVar(std::string id);
                std::unordered_map<std::string, llvm::AllocaInst *> &GetVars() { return vars; }
                void AddType(std::string id, Type::StructType struct_type);
                //void TypeAddFunction(std::string type, Type::Function func);
                //Type::Function &GetMemberFunction(std::string &type, Type::Function &func);
                llvm::Type *GetType(Type::Type *type);
                Type::StructType &GetStruct(std::string);
                void AddFunction(Function *func);
                Function *GetFunction(std::string &name);
                Ref<Mod> GetMod();
            private:
                Scope *Resolve(std::string id);
                Scope *Resolve(const char *type);
            private:
                Ref<Mod> mod;
                std::unordered_map<std::string, llvm::AllocaInst *> vars;
                std::set<std::string> constants;
                //std::unordered_set<std::string> generics;
                std::unordered_map<std::string, Type::StructType> struct_types;
                Scope *parent = nullptr;
                llvm::Value *ret = nullptr;
        };
    }
}
#endif // _LYGOS_SCOPE_H_
