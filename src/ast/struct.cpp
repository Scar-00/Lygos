#include "struct.h"
#include "ast.h"
#include <vector>

namespace lygos {
    namespace AST {
        StructDef::StructDef(std::string id, std::vector<Field> fields): AST(ASTType::StructDef), id(id), fields(fields) {

        }

        std::string StructDef::GetValue() {
            return id;
        }

        llvm::Value *StructDef::GenCode(Scope *scope) {
            scope->AddType(id, {});
            std::vector<llvm::Type *> field_types;
            std::vector<std::string> struct_fields;
            for(const auto &field : fields) {
                //check that is type is self it is a pointer
                field_types.push_back(scope->GetType(field.type.get()));
                struct_fields.push_back(field.id);
            }

            auto struct_type = llvm::StructType::create(
                *ctx,
                field_types,
                id,
                false
            );

            scope->AddType(id, {id, struct_type, struct_fields, {}});
            return nullptr;
        }

        void StructDef::Lower() {

        }

        void StructDef::Sanatize() {

        }
    }
}
