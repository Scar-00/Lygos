#include "scope.h"
#include "../util.h"
#include "../global.h"
#include "ast.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include <cerrno>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <ratio>
#include <tuple>
#include <unordered_map>
#include <vector>

void Scope::DeclVar(std::string id, bool cnst, llvm::AllocaInst *value) {
    Scope *scpoe = this;
    if(scpoe->vars.contains(id))
        error("Cannot declare variable '%s' twice", id.c_str());

    if(cnst)
        scpoe->constants.insert(id);

    scpoe->vars.insert_or_assign(id, value);
}

void Scope::Print() {
    std::cout << "Scope [\n";
    std::cout << "-types:\n";
    for(auto const &pair : struct_types) {
        std::cout << "\t"; print_type(pair.second);
    }
    std::cout << "-vars:\n";
    for(auto const &pair : vars) {
        std::cout << "\t{" << pair.first << " : " << pair.second->getName().data() << "},\n";
    }
    std::cout << "]" << std::endl;
}

llvm::AllocaInst *Scope::LookupVar(std::string id) {
    Scope *scope = this->Resolve(id);
    if(!scope->vars.contains(id))
        error("%s is undefined", id.c_str());

    return scope->vars.at(id);
}

void Scope::AddType(std::string id, llvm::StructType *type, std::vector<std::string> struct_member) {
    auto scope = this->Resolve(id.c_str());
    if(scope->struct_types.contains(id))
        error("Cannot redeclare '%s'", id.c_str());
    this->struct_types.insert({id, type});
    this->struct_fields.insert({id, struct_member});
}

llvm::Type *Scope::GetType(TypeSpec &type) {
    if(base_types.contains(type.name)) return type.ptr ? llvm::PointerType::get(resolve_type(type.name), 0) : resolve_type(type.name);
    Scope *scope = this->Resolve(type.name.c_str());
    if(scope->struct_types.contains(type.name)) {
        if(type.ptr)
            return llvm::PointerType::get(scope->struct_types.at(type.name), 0);
        return scope->struct_types.at(type.name);
    }
    error("Unknown type '%s'", type.name.c_str());
    std::exit(1);
}

std::vector<std::string> &Scope::GetStruct(std::string type) {
    Scope *scope = this->Resolve(type.c_str());
    if(scope->struct_fields.contains(type)) {
        return scope->struct_fields.at(type);
    }

    error("Unknown struct type '%s'", type.c_str());
    std::exit(1);
}

Scope *Scope::Resolve(std::string var) {
    if(vars.contains(var))
        return this;

    if(!parent)
        error("Cannot resolve variable '%s'. Variable does not exist in current Context", var.c_str());

    return parent->Resolve(var);
}

Scope *Scope::Resolve(const char *type) {
    if(this->struct_types.contains({type}))
        return this;

    if(!this->parent)
        return this;

    return parent->Resolve(type);
}
