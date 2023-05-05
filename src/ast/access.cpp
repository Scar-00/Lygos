#include "access.h"
#include "ast.h"
#include "call.h"
#include "literals.h"

namespace lygos {
    namespace AST {
        MemberExpr::MemberExpr(Ref<AST> obj, Ref<AST> member, bool deref):
            AST(ASTType::MemberExpr), obj(obj), member(member), deref(deref) {

        }

        std::string MemberExpr::GetValue() {
            return obj->GetValue();
        }

        llvm::Value *MemberExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(deref)
                obj = LoadOrIgnore(obj);

            //check if function is actually a member and not static
            if(member->type == ASTType::CallExpr) {
                std::string struct_name = static_cast<llvm::StructType *>(TryGetPointerBase(obj->getType()))->getName().data();
                auto call = (CallExpr *)member.get();
                call->Args().insert(call->Args().cbegin(), this->obj);
                switch (call->GetCaller()->type) {
                    case ASTType::Id: {
                        std::string &fn_name = static_cast<Identifier *>(call->GetCaller().get())->GetId();
                        fn_name = struct_name + "_" + fn_name;
                    } break;
                    default:
                        std::cout << "????" << std::endl;
                    break;
                }
                return member->GenCode(scope);
            }

            size_t index;
            std::string type_name = static_cast<llvm::StructType *>(TryGetPointerBase(obj->getType()))->getName().data();
            auto struct_fields = scope->GetStruct(type_name).fields;
            std::string member_name = member->GetValue();
            if(!VecContains(struct_fields, member_name)) {
                Log::Logger::Warn(fmt::format("unknown field `{}` in struct `{}`", member_name, type_name));
            }
            for(size_t i = 0; i < struct_fields.size(); i++)
                if(struct_fields[i] == member_name)
                    index = i;

            if(member->type != ASTType::Id)
                member->GenCode(scope);

            return builder->CreateStructGEP(TryGetPointerBase(obj->getType()), obj, index);
        }

        void MemberExpr::Lower(AST *parent) {
            member->Lower(this);
            obj->Lower(this);
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

            auto index = this->index->GenCode(scope);
            if(ShouldLoad(this->index.get()))
                index = LoadOrIgnore(index);

            auto *zero = llvm::ConstantInt::get(llvm::Type::getInt32PtrTy(*ctx), 0);

            llvm::ArrayRef<llvm::Value *> idx_list = {zero, index};
            if(!IsArrayType(obj->getType()))
                idx_list = idx_list.drop_front();

            return builder->CreateGEP(TryGetPointerBase(obj->getType()), obj, idx_list, "", true);
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
            auto fn = (CallExpr *)member.get();
            std::string fn_name = obj->GetValue() + "_" + fn->GetCaller()->GetValue();
            ((Identifier *)fn->GetCaller().get())->GetId() = fn_name;
            return member->GenCode(scope);
        }

        void ResolutionExpr::Lower(AST *parent) {

        }

        void ResolutionExpr::Sanatize() {

        }
    }
}
