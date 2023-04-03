#ifndef _LYGOS_SCOPE_H_
#define _LYGOS_SCOPE_H_

#include "../core.h"

namespace lygos {
    namespace AST {
        struct Scope {
            public:
                Scope(Scope *parent = nullptr): parent(parent) {}
                void Print();
                void DeclVar(std::string id, bool cnst, llvm::AllocaInst *value);
                void SetRet(llvm::Value *value) { ret = value; }
                llvm:: Value *GetRet() { return ret; }
                llvm::AllocaInst *LookupVar(std::string id);
                std::unordered_map<std::string, llvm::AllocaInst *> &GetVars() { return vars; }
                std::set<std::string> &GetConstants() { return constants; }
                void AddType(std::string id, StructType struct_type);
                void TypeAddFunction(std::string type, Function func);
                llvm::Type *GetType(Type::Type *type);
                std::vector<std::string> &GetStruct(std::string);
            private:
                Scope *Resolve(std::string id);
                Scope *Resolve(const char *type);
                std::unordered_map<std::string, llvm::AllocaInst *> vars;
                std::set<std::string> constants;
                std::unordered_map<std::string, StructType> struct_types;
                Scope *parent = nullptr;
                llvm::Value *ret = nullptr;
        };
    }
}

#endif // _LYGOS_SCOPE_H_
