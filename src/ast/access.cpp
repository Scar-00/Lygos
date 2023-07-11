#include "access.h"
#include "ast.h"
#include "call.h"
#include "literals.h"
#include "mod.h"
#include <fmt/core.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <tuple>
#include <vector>

namespace lygos {
    namespace AST {
        MemberExpr::MemberExpr(Ref<AST> obj, Ref<AST> member, bool deref):
            AST(ASTType::MemberExpr), obj(obj), member(member), deref(deref) {

        }

        MemberExpr::MemberExpr(Ref<AST> obj, u32 index):
            AST(ASTType::MemberExpr), obj(obj), member(nullptr), deref(false), use_index(true), index(index) {

        }

        std::string MemberExpr::GetValue() {
            return obj->GetValue();
        }

        llvm::Value *MemberExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(deref)
                obj = LoadOrIgnore(obj);

            //FIXME: function chain calling
            //check if function is actually a member and not static
            if(!use_index && member->type == ASTType::CallExpr) {
                std::string struct_name = static_cast<llvm::StructType *>(TryGetPointerBase(obj->getType()))->getName().data();
                auto call = (CallExpr *)member.get();
                switch (call->GetCaller()->type) {
                    case ASTType::Id: {
                        std::string &fn_name = static_cast<Identifier *>(call->GetCaller().get())->GetId();
                        fn_name = struct_name + "_" + fn_name;
                    } break;
                    default:
                        LYGOS_ASSERT(false && "?????");
                    break;
                }
                return member->GenCode(scope);
            }

            size_t index = 100000;
            std::string type_name = static_cast<llvm::StructType *>(TryGetPointerBase(obj->getType()))->getName().data();
            auto struct_fields = scope->GetStruct(type_name).fields;
            if(!use_index) {
                std::string member_name = member->GetValue();
                bool contains = false;
                for(size_t i = 0; i < struct_fields.size(); i++) {
                    if(std::get<0>(struct_fields[i]) == member_name) {
                        contains = true;
                        break;
                    }
                }
                if(!contains)
                    Log::Logger::Warn(fmt::format("unknown field `{}` in struct `{}`", member_name, type_name));
                for(size_t i = 0; i < struct_fields.size(); i++)
                    if(std::get<0>(struct_fields[i]) == member_name)
                       index = i;
            }else {
                index = this->index;
                LYGOS_ASSERT(index <= struct_fields.size() && "out of bounds index in strcut gep");
            }

            if(!use_index && member->type != ASTType::Id)
                member->GenCode(scope);

            return builder->CreateStructGEP(TryGetPointerBase(obj->getType()), obj, index);
        }

        Ref<Type::Type> MemberExpr::GetType(Scope *scope) {
            auto type = obj->GetType(scope);
            auto struct_fields = scope->GetStruct(type->GetName()).fields;
            size_t index = 0;
            for(size_t i = 0; i < struct_fields.size(); i++)
                if(std::get<0>(struct_fields[i]) == member->GetValue())
                    index = i;
            if(member->type != ASTType::Id)
                return member->GetType(scope);
            return std::get<1>(struct_fields.at(index));
        }

        void MemberExpr::Lower(AST *parent) {
            obj->Lower(this);

            if(!use_index) {
                if(member->type == ASTType::CallExpr) {
                    auto call = (CallExpr *)member.get();
                    call->Args().insert(call->Args().cbegin(), this->obj);
                }

                member->Lower(this);
            }
        }

        void MemberExpr::Sanatize() {

        }

        AccessExpr::AccessExpr(Ref<AST> obj, Ref<AST> index):
            AST(ASTType::AccessExpr), obj(obj), index(index) {

        }

        std::string AccessExpr::GetValue() {
            return obj->GetValue();
        }

        llvm::Value *AccessExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(!IsArrayType(obj->getType()))
                obj = LoadOrIgnore(obj);

            /*if(obj->getType()->isStructTy()) {
                auto struct_name = ((llvm::StructType *)obj->getType())->getName().data();
                if(scope->GetStruct(struct_name).ImplementsTrait("Index")) {
                    auto iden = MakeRef<Identifier>("index");
                    std::vector<Ref<AST>> args = {index};
                    auto expr = MemberExpr{this->obj, MakeRef<CallExpr>(iden, args), true};
                    return expr.GenCode(scope);
                }
                Log::Logger::Warn(fmt::format("type `{}` does not implement `Index`", struct_name));
            }*/

            auto index = this->index->GenCode(scope);
            if(ShouldLoad(this->index.get()))
                index = LoadOrIgnore(index);

            auto *zero = llvm::ConstantInt::get(llvm::Type::getInt32PtrTy(*ctx), 0);

            llvm::ArrayRef<llvm::Value *> idx_list = {zero, index};
            if(!IsArrayType(obj->getType()))
                idx_list = idx_list.drop_front();

            return builder->CreateGEP(TryGetPointerBase(obj->getType()), obj, idx_list, "", true);
        }

        Ref<Type::Type> AccessExpr::GetType(Scope *scope) {
            return obj->GetType(scope);
        }

        void AccessExpr::Lower(AST *parent) {

        }

        void AccessExpr::Sanatize() {

        }

        ResolutionExpr::ResolutionExpr(Ref<AST> obj, Ref<AST> member):
            AST(ASTType::ResolutionExpr), obj(obj), member(member) {

        }

        std::string ResolutionExpr::GetValue() {
            return obj->GetValue();
        }

        //check for static -> cant call static functions on an object
        llvm::Value *ResolutionExpr::GenCode(Scope *scope) {
            if (scope->IsEnum(obj->GetValue())) {
                Type::EnumType e = scope->GetEnum(obj->GetValue());
                for(size_t i = 0; i < e.variants.size(); i++) {
                    if(e.variants[i] == this->member->GetValue()){
                        return llvm::ConstantInt::get(scope->GetType(e.type.get()), i);
                    }
                }
                Log::Logger::Warn(fmt::format("unknown enum variant `{}` in enum `{}`", member->GetValue(), e.name));
            }

            auto fn = (CallExpr *)member.get();
            ((Identifier *)fn->GetCaller().get())->GetId() = scope->GetStruct(obj->GetValue()).GetFunction(fn->GetCaller()->GetValue()).name_mangeled;
            return member->GenCode(scope);
        }

        Ref<Type::Type> ResolutionExpr::GetType(Scope *scope) {
            return member->GetType(scope);
        }

        void ResolutionExpr::Lower(AST *parent) {

        }

        void ResolutionExpr::Sanatize() {

        }
    }
}
