#include "access.h"
#include "call.h"
#include "literals.h"
#include "../error/log.h"
#include "llvm/ADT/ArrayRef.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
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

        std::string AccessExpr::GetValue() {
            return obj->GetValue();
        }

        Val *AccessExpr::GenCode(Scope *scope) {
            auto obj = this->obj->GenCode(scope);
            if(!IsArrayType(obj->getType()))
                obj = LoadOrIgnore(obj);

            auto index = this->index->GenCode(scope);
            if(ShouldLoad(this->index))
                index = LoadOrIgnore(index);

            auto *zero = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx), 0);

            llvm::ArrayRef<Val *> idx_list = {zero, index};
            if(!IsArrayType(obj->getType()))
                idx_list = idx_list.drop_front();

            std::cout << "arr? -> " << IsArrayType(obj->getType()) << "\n";
            std::cout << PrintType(obj->getType()) << "\n";
            auto gep = builder->CreateGEP(TryGetPointerBase(obj->getType()), obj, idx_list, "", true);
            //auto load = builder->CreateLoad(TryGetPointerBase(gep->getType()), gep);
            //std::cout << PrintValue(gep) << "\n";
            return gep;
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
    }
}
