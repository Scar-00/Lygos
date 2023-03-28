#pragma once


#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Instructions.h"
#include <string>
#include <tuple>
#include <unordered_map>
#include <llvm/IR/Value.h>
#include <vector>
#include "../types.h"

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
    void AddType(std::string id, llc::StructType struct_type);
    void TypeAddFunction(std::string type, llc::Function func);
    llvm::Type *GetType(Type::Type *type);
    std::vector<std::string> &GetStruct(std::string);
private:
    Scope *Resolve(std::string id);
    Scope *Resolve(const char *type);
    std::unordered_map<std::string, llvm::AllocaInst *> vars;
    std::set<std::string> constants;
    std::unordered_map<std::string, llc::StructType> struct_types;
    Scope *parent = nullptr;
    llvm::Value *ret = nullptr;
};
