#include "struct.h"
#include "ast.h"
#include "mod.h"
#include <unordered_map>
#include <vector>

namespace lygos {
    namespace AST {
        StructDef::StructDef(std::string id, std::vector<Field> fields, std::vector<Type::Generic> generics):
            AST(ASTType::StructDef), id(id), fields(fields), generics(generics) {

        }

        std::string StructDef::GetValue() {
            return id;
        }

        llvm::Value *StructDef::GenCode(Scope *scope) {
            //scope->AddType(id, {});
            /*std::vector<llvm::Type *> field_types;
            std::vector<std::tuple<std::string, Ref<Type::Type>>> struct_fields;
            for(const auto &field : fields) {
                //check that is type is self it is a pointer
                if(this->generics.size() < 0)
                    field_types.push_back(scope->GetType(field.type.get()));
                struct_fields.push_back({field.id, field.type});
            }

            auto struct_type = llvm::StructType::create(
                *ctx,
                field_types,
                id,
                false
            );

            std::unordered_map<std::string, Type::Generic> generics;
            for(const auto &gen : this->generics) {
                generics.insert({gen.name, gen});
            }*/

            return nullptr;
        }

        void StructDef::Lower(AST *parent) {
            std::vector<std::tuple<std::string, Ref<Type::Type>>> struct_fields;
            for(const auto &field : fields) {
                struct_fields.push_back({field.id, field.type});
            }
            std::unordered_map<std::string, Type::Generic> generics;
            for(const auto &gen : this->generics) {
                generics.insert({gen.name, gen});
            }
            ast_root->GetCurrentBlock()->Scope().AddStructType(id, {id, {}, struct_fields, {}, generics, {}});
            for(const auto &name : this->generics) {
                fmt::print("generic -> {}\n", name.name);
            }
        }

        void StructDef::Sanatize() {

        }

        EnumDef::EnumDef(std::string id, std::vector<std::string> variants, Ref<Type::Type> type):
            AST(ASTType::EnumDef), id(id), variants(variants), type(type) {

        }

        std::string EnumDef::GetValue() {
            return id;
        }

        llvm::Value *EnumDef::GenCode(Scope *scope) {
            scope->AddEnumType(id, {id, variants, type});
            return nullptr;
        }

        void EnumDef::Lower(AST *parent) {

        }

        void EnumDef::Sanatize() {

        }

    }
}
