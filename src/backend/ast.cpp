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
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Format.h"
#include <bits/ranges_util.h>
#include <cerrno>
#include <climits>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include "../util.h"
#include "scope.h"
#include <iostream>
#include <ostream>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
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

    //maybe remove this ?
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

    if(!(return_type->kind == Type::Kind::path && static_cast<Type::Path *>(return_type)->GetPath() == "void"))
        curr_scope.SetRet(builder->CreateAlloca(fn->getReturnType()));

    for(auto &node : this->block)
        node->GenCode(&curr_scope);

    curr_scope.GetRet() ? builder->CreateRet(LoadOrIgnore(curr_scope.GetRet())) : builder->CreateRetVoid();

    llvm::verifyFunction(*fn);
    //curr_scope.Print();
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
    if(ShouldLoad(*this->value) && (*this->value)->type != ASTType::UnaryExpr)
        val = LoadOrIgnore(val);

    if(this->data_type) {
        auto llvm_type = scope->GetType(data_type);
        Log() << static_cast<llvm::IntegerType *>(llvm_type)->getSignBit() << "\n";
        val = builder->CreateCast(GetCastOp(val->getType(), llvm_type), val, llvm_type);
    }

    //std::numeric_limits<int64_t>::max() < (1LL << intType->getBitWidth()

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

    auto id = this->id->GenCode(scope);
    auto val = this->value->GenCode(scope);
    if(ShouldLoad(value)) {
        val = LoadOrIgnore(val);
    }

    builder->CreateStore(val, id);
    return id;
}

std::string MemberExpr::GetValue() {
    return obj->GetValue();
}

Val *MemberExpr::GenCode(Scope *scope) {
    auto obj = this->obj->GenCode(scope);

    auto member = scope->GetStruct(static_cast<llvm::StructType *>(TryGetPointerBase(obj->getType()))->getName().data());
    size_t index;
    for(size_t i = 0; i < member.size(); i++) {
        if(member[i] == property->GetValue())
            index = i;
    }

    if(this->property->type == ASTType::MemberExpr) {
        this->property->GenCode(scope);
    }

    auto gep = builder->CreateStructGEP(TryGetPointerBase(obj->getType()), obj, index);
    return gep;
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
    if(this->else_branch)
        for(auto &node : *else_branch)
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
    //auto header = llvm::BasicBlock::Create(*ctx, "", builder->GetInsertBlock()->getParent());


    //auto body = llvm::BasicBlock::Create(*ctx);
    //auto end = llvm::BasicBlock::Create(*ctx);

    error("TODO! for_expr");
    return NULL;
}

std::string CallExpr::GetValue() {
    return this->caller->GetValue();
}

Val *CallExpr::GenCode(Scope *scope) {
    auto callee = mod->getFunction(this->caller->GetValue());
    if(!callee)
        error("Unknown function '%s'", caller->GetValue().c_str());

    if(!callee->isVarArg() && callee->arg_size() != this->args.size())
        error("Expected %d args, only %d were supplied", callee->arg_size(), this->args.size());

    std::vector<Val *> arg_values;
    for(auto &arg : this->args) {
        auto val = arg->GenCode(scope);
        if(ShouldLoad(arg) && arg->type != ASTType::UnaryExpr)
            val = LoadOrIgnore(val);
        arg_values.push_back(val);
    }
    return builder->CreateCall(callee, arg_values);
}

std::string AccessExpr::GetValue() {
    return obj->GetValue();
}

Val *AccessExpr::GenCode(Scope *scope) {
    auto obj = this->obj->GenCode(scope);
    if(ShouldLoad(this->obj))
        obj = LoadOrIgnore(obj);
    auto index = this->index->GenCode(scope);
    if(ShouldLoad(this->index))
        index = LoadOrIgnore(index);

    auto gep = builder->CreateGEP(TryGetPointerBase(obj->getType()), obj, {index}, "", true);
    return gep;
}

std::string UnaryExpr::GetValue() {
    return {};
}

Val *UnaryExpr::GenCode(Scope *scope) {
    auto obj = this->obj->GenCode(scope);
    if(op == "*")
        return builder->CreateLoad(TryGetPointerBase(obj->getType()), obj);
    if(op == "&")
        return obj;

    error("Unknown Unary operator [%s]", op.c_str());
    std::exit(1);
}

std::string ResolutionExpr::GetValue() {
    return this->obj->GetValue();
}

Val *ResolutionExpr::GenCode(Scope *scope) {
    auto fn = (CallExpr *)this->member;
    std::string fn_name = this->obj->GetValue() + "_" + fn->caller->GetValue();
    ((Identifier*)fn->caller)->value = fn_name;
    return fn->GenCode(scope);
}

std::string CastExpr::GetValue() {
    return obj->GetValue();
}

Val *CastExpr::GenCode(Scope *scope) {
    auto val = this->obj->GenCode(scope);
    if(ShouldLoad(this->obj))
        val = LoadOrIgnore(val);

    auto dest_type = scope->GetType(this->target_type);
    auto src_type = val->getType();
    auto op = GetCastOp(src_type, dest_type);
    return builder->CreateCast(op, val, dest_type);
}

std::string StructDef::GetValue() {
    return {};
}

Val *StructDef::GenCode(Scope *scope) {
    //llvm::StructType *struct_type = llvm::StructType::create(*ctx, id);
    //scope->AddType(id, llvm::StructType *type, std::vector<std::string> struct_member)

    std::vector<llvm::Type *> data_fields;
    std::vector<std::string> struct_member;
    for(auto &field : this->fields) {
        auto type = scope->GetType(field.data_type);
        data_fields.push_back(type);
        struct_member.push_back(field.id);
    }

    llvm::StructType *struct_type = llvm::StructType::create(
        *ctx,
        data_fields,
        id,
        false
    );

    //auto size = mod->getDataLayout().getTypeSizeInBits(struct_type);
    //Log() << id << " -> " << size / 8 << "\n";
    scope->AddType(id, {id, struct_type, struct_member, {}});
    return nullptr;
}

std::string Impl::GetValue() {
    return type;
}

Val *Impl::GenCode(Scope *scope) {
    for(const auto &member : this->body) {
        auto fn = (Function *)member;
        fn->id = this->type + "_" + fn->id;
        member->GenCode(scope);
    }
    return nullptr;
}

std::string NumberLiteral::GetValue() {
    return value;
}

Val *NumberLiteral::GenCode(Scope *scope) {
    //rewrite this to support more types
    if(data_type == "Integer") return llvm::ConstantInt::get(*ctx, llvm::APInt(32, std::atoi(value.c_str())));
    return llvm::ConstantFP::get(llvm::Type::getDoubleTy(*ctx), std::atof(value.c_str()));
}

std::string StringLiteral::GetValue() {
    return value;
}

Val *StringLiteral::GenCode(Scope *scope) {
    auto global = builder->CreateGlobalStringPtr(value);
    return global;
}

std::string Identifier::GetValue() {
    return value;
}

Val *Identifier::GenCode(Scope *scope) {
    auto var = scope->LookupVar(value);
    return var;
}

std::string ReturnExpr::GetValue() {
    return {};
}

Val *ReturnExpr::GenCode(Scope *scope) {
    if(this->value == NULL) {
        return nullptr;
    }

    if(!scope->GetRet())
        error("Invalid return type for funtion with return type 'void'");

    auto val = value->GenCode(scope);
    if(ShouldLoad(value))
        val = LoadOrIgnore(val);

    return builder->CreateStore(val, scope->GetRet());
}

std::string BinaryExpr::GetValue() {
    return {};
}

Val *BinaryExpr::GenCode(Scope *scope) {
    auto lhs = this->lhs->GenCode(scope);
    auto rhs = this->rhs->GenCode(scope);
    if(!lhs || !rhs)
        error("Error generating binary expr");

    if(ShouldLoad(this->lhs)) {
        lhs = LoadOrIgnore(lhs);
    }
    if(ShouldLoad(this->rhs)) {
        rhs = LoadOrIgnore(rhs);
    }

    //expand this to account for type conversion etc.
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
