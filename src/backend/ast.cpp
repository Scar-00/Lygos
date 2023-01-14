#include "ast.h"
#include "../global.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/APSInt.h"
#include "llvm/ADT/FoldingSet.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Format.h"
#include <bits/ranges_util.h>
#include <cerrno>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include "../util.h"
#include "scope.h"
#include <iostream>
#include <ostream>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

using Val = llvm::Value;

std::string Program::GetValue() {
    return {};
}

Val *Program::GenCode(Scope *scope) {
    Val *curr;
    Scope global{};
    for(auto node : body) {
        curr = node->GenCode(&global);
    }
    return curr;
}

std::string Function::GetValue() {
    return id;
}

Val *Function::GenCode(Scope *scope) {
    Scope curr_scope{scope};

    auto fn = mod->getFunction(id);
    if(fn == NULL) {
        std::vector<llvm::Type *> args_type;
        for(auto &arg : this->args) {
            args_type.push_back(curr_scope.GetType(std::get<1>(arg)));
        }

        auto fn_type = llvm::FunctionType::get(
            curr_scope.GetType(this->return_type),
            args_type,
            false
        );

        fn = llvm::Function::Create(
            fn_type,
            llvm::Function::LinkageTypes::ExternalLinkage,
            id,
            *mod
        );
    }

    //maybe remove this
    fn->setDSOLocal(true);
    auto bb = llvm::BasicBlock::Create(*ctx, "", fn);
    builder->SetInsertPoint(bb);
    auto args = fn->arg_begin();
    for(size_t i = 0; i < fn->arg_size(); i++) {
        auto arg = &*args + i;
        auto alloca = builder->CreateAlloca(arg->getType());
        builder->CreateStore(arg, alloca);
        curr_scope.DeclVar(std::get<0>(this->args.at(i)), true, alloca);
    }

    for(auto &node : this->block)
        node->GenCode(&curr_scope);

    llvm::verifyFunction(*fn);
    return nullptr;
}

std::string VarDecl::GetValue() {
    return {};
}

Val *VarDecl::GenCode(Scope *scope) {
    if(!value) {
        auto var_type = scope->GetType(this->data_type);
        auto alloca = builder->CreateAlloca(var_type);
        scope->DeclVar(id, cnst, alloca);
        return alloca;
    }
    auto val = (*value)->GenCode(scope);

    //if(this->data_type != "Unknown")
        //val->getType()->

    auto alloca = builder->CreateAlloca(val->getType(), 0, "");
    builder->CreateStore(val, alloca);
    scope->DeclVar(id, cnst, alloca);
    return alloca;
}

std::string FunctionDecl::GetValue() {
    return {};
}

Val *FunctionDecl::GenCode(Scope *scope) {
    std::vector<llvm::Type *> args_type;
    for(auto &arg : this->params) {
        args_type.push_back(scope->GetType(std::get<1>(arg)));
    }

    auto fn_type = llvm::FunctionType::get(
        scope->GetType(this->return_type),
        args_type,
        false
    );

    auto fn = llvm::Function::Create(
        fn_type,
        llvm::Function::LinkageTypes::ExternalLinkage,
        id,
        *mod
    );

    llvm::verifyFunction(*fn, &Log());
    return nullptr;
}

std::string AssignmentExpr::GetValue() {
    return {};
}

Val *AssignmentExpr::GenCode(Scope *scope) {
    //change this to scope->LookupVar ?
    if(!scope->GetVars().contains(id->GetValue()))
        error("Cannot assign to %s", id->GetValue().c_str());

    if(scope->GetConstants().contains(id->GetValue()))
        error("Cannot assign to immutale variable %s", id->GetValue().c_str());

    //id->GenCode(scope);
    /*if(this->id->type == ASTType::MemberExpr) {
        auto t = id->GenCode(scope);

        if(!t->getType()->isPointerTy())
            t->mutateType(llvm::PointerType::get(t->getType(), 0));

        //error("%s", t->getName().data());
        auto res = builder->CreateStore(value->GenCode(scope), t);
        return res;
    }*/

    auto val = id->GenCode(scope);

    //builder->CreateStore(value->GenCode(scope), scope->GetVars().at(id->GetValue()));
    builder->CreateStore(value->GenCode(scope), val);
    return scope->GetVars().at(id->GetValue());
}

std::string MemberExpr::GetValue() {
    return obj->GetValue();
}

Val *MemberExpr::GenCode(Scope *scope) {
    auto obj = (llvm::AllocaInst *)this->obj->GenCode(scope);

    auto gep = builder->CreateStructGEP(obj->getAllocatedType(), obj, 0);
    //auto load = builder->CreateLoad(llvm::Type::getInt32Ty(*ctx), gep);

    //gep->getType()->getStructElementType(0);

    //if(this->property->type == ASTType::MemberExpr) {
    //    this->property->GenCode(scope);
    //}

    return gep;
    //error("TODO!");
    //return nullptr;
}

std::string IfExpr::GetValue() {
    return {};
}

Val *IfExpr::GenCode(Scope *scope) {
    auto cond = this->cond->GenCode(scope);

    auto func = builder->GetInsertBlock()->getParent();

    auto then_bb = llvm::BasicBlock::Create(*ctx, "", builder->GetInsertBlock()->getParent());
    auto else_bb = llvm::BasicBlock::Create(*ctx, "");
    auto merge = llvm::BasicBlock::Create(*ctx, "");

    builder->CreateCondBr(cond, then_bb, else_bb);

    builder->SetInsertPoint(then_bb);
    for(auto node : then_branch)
        node->GenCode(scope);

    builder->CreateBr(merge);

    func->getBasicBlockList().push_back(else_bb);
    builder->SetInsertPoint(else_bb);
    for(auto node : *else_branch)
        node->GenCode(scope);
    builder->CreateBr(merge);

    func->getBasicBlockList().push_back(merge);
    builder->SetInsertPoint(merge);
    return nullptr;
}

std::string ForExpr::GetValue() {
    return {};
}

Val *ForExpr::GenCode(Scope *scope) {
    auto header = llvm::BasicBlock::Create(*ctx, "", builder->GetInsertBlock()->getParent());


    auto body = llvm::BasicBlock::Create(*ctx);
    auto end = llvm::BasicBlock::Create(*ctx);

    error("TODO! for_expr");
    return NULL;
}

std::string CallExpr::GetValue() {
    return {};
}

Val *CallExpr::GenCode(Scope *scope) {
    auto callee = mod->getFunction(this->caller->GetValue());
    if(!callee)
        error("Unknown function '%s'", caller->GetValue().c_str());

    if(!callee->isVarArg() && callee->arg_size() != this->args.size())
        error("Expected %d args, only %d were supplied", callee->arg_size(), this->args.size());

    std::vector<Val *> arg_values;
    for(auto &arg : this->args) {
        arg_values.push_back(arg->GenCode(scope));
    }

    return builder->CreateCall(callee, arg_values);
}

std::string StructDef::GetValue() {
    return {};
}

Val *StructDef::GenCode(Scope *scope) {
    std::vector<llvm::Type *> data_fields;
    std::vector<std::tuple<std::string, llvm::Type *>> struct_member;
    for(auto &field : this->fields) {
        auto type = scope->GetType(field.data_type);
        data_fields.push_back(type);
        struct_member.push_back({field.id, type});
    }

    llvm::StructType *struct_type = llvm::StructType::create(
        *ctx,
        data_fields,
        id,
        false
    );

    scope->AddType(id, struct_type, struct_member);
    return nullptr;
}

std::string NumberLiteral::GetValue() {
    return value;
}

Val *NumberLiteral::GenCode(Scope *scope) {
    //rewrite this to support more types
    if(data_type == "Integer") return llvm::ConstantInt::get(*ctx, llvm::APInt(32, std::atoi(value.c_str())));
    return llvm::ConstantFP::get(*ctx, llvm::APFloat(std::atof(value.c_str())));
}

std::string StringLiteral::GetValue() {
    return value;
}

Val *StringLiteral::GenCode(Scope *scope) {
    Log() << value << "\n";
    auto global = builder->CreateGlobalStringPtr(value);
    return global;
}

std::string Identifier::GetValue() {
    return value;
}

Val *Identifier::GenCode(Scope *scope) {
    auto var = scope->LookupVar(value);
    //return builder->CreateLoad(var->getAllocatedType(), var);
    return var;
}

std::string ReturnExpr::GetValue() {
    return {};
}

Val *ReturnExpr::GenCode(Scope *scope) {
    /*auto val = value->GenCode(scope);
    auto type = val->getType();
    if(type->isPointerTy()) {
        type = static_cast<llvm::PointerType *>(type)->getContainedType(0);
        auto load = builder->CreateLoad(type, val);
        return builder->CreateRet(load);
    }

    return builder->CreateRet(val);
    */
    return builder->CreateRet(LoadOrIgnore(value->GenCode(scope)));
}

std::string BinaryExpr::GetValue() {
    return {};
}

Val *BinaryExpr::GenCode(Scope *scope) {
    auto lhs = this->lhs->GenCode(scope);
    auto rhs = this->rhs->GenCode(scope);
    if(!lhs || !rhs)
        error("Error generating binary expr");

    auto lhs_type = lhs->getType();
    auto rhs_type = rhs->getType();
    if(lhs->getType()->isPointerTy() && rhs->getType()->isPointerTy()) {
        lhs_type = static_cast<llvm::PointerType *>(lhs->getType())->getContainedType(0);
        rhs_type = static_cast<llvm::PointerType *>(rhs->getType())->getContainedType(0);
    }

    lhs = builder->CreateLoad(lhs_type, lhs);
    rhs = builder->CreateLoad(rhs_type, rhs);

    //expand this tp account for type conversion etc.
    if(op == "+") return builder->CreateAdd(lhs, rhs);
    if(op == "-") return builder->CreateSub(lhs, rhs);
    if(op == "*") return builder->CreateMul(lhs, rhs);
    if(op == "/") return builder->CreateSDiv(lhs, rhs);
    if(op == "==") return builder->CreateCmp(llvm::ICmpInst::ICMP_EQ, lhs, rhs);
    if(op == "<") return builder->CreateICmpSLT(lhs, rhs);
    if(op == ">") return builder->CreateICmpSGE(lhs, rhs);
    error("Unknown operator %s", op.c_str());
    std::exit(1);
}
