#pragma once

#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Instructions.h"
#include <tuple>
#include <unordered_map>
#include <llvm/IR/Value.h>

struct Scope {
public:
    Scope(Scope *parent = nullptr): parent(parent) {}
    void Print();
    void DeclVar(std::string id, bool cnst, llvm::AllocaInst *value);
    llvm::AllocaInst *LookupVar(std::string id);
    std::unordered_map<std::string, llvm::AllocaInst *> &GetVars() { return vars; }
    std::set<std::string> &GetConstants() { return constants; }
    void AddType(std::string id, llvm::StructType *type, std::vector<std::tuple<std::string, llvm::Type *>> struct_member);
    llvm::Type *GetType(std::string &type);
    std::vector<std::tuple<std::string, llvm::Type *>> &GetStruct(std::string id);
private:
    Scope *Resolve(std::string id);
    Scope *Resolve(const char *type);
    std::unordered_map<std::string, llvm::AllocaInst *> vars;
    std::set<std::string> constants;
    std::unordered_map<std::string, llvm::StructType *> struct_types;
    std::unordered_map<std::string, std::vector<std::tuple<std::string, llvm::Type *>>> struct_fields;
    Scope *parent = nullptr;
};
