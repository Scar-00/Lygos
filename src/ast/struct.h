#ifndef _LYGOS_AST_STRUCT_H_
#define _LYGOS_AST_STRUCT_H_

#include "ast.h"
#include <vector>

namespace lygos {
    namespace AST {
        struct StructDef : public AST {
            struct Field {
                Ref<Type::Type> type;
                std::string id;
            };
            public:
                StructDef(std::string id, std::vector<Field> fields, std::vector<Type::Generic> generics);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string id;
                std::vector<Field> fields;
                std::vector<Type::Generic> generics;
        };

        struct EnumDef : public AST {
            public:
                EnumDef(std::string id, std::vector<std::string> variants, Ref<Type::Type> type);
                std::vector<std::string> &GetVariants() { return variants; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string id;
                std::vector<std::string> variants;
                Ref<Type::Type> type;
        };
    }
}

#endif // _LYGOS_AST_STRUCT_H_
