#include "struct.h"
#include "function.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
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
    }
}
