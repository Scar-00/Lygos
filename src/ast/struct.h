#ifndef _LYGOS_AST_STRUCT_H_
#define _LYGOS_AST_STRUCT_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct StructDef : public AST {
            struct Field {
                Ref<Type::Type> type;
                std::string id;
            };
            public:
                StructDef(std::string id, std::vector<Field> fields);
            public:
            std::string GetValue() override;
            llvm::Value *GenCode(Scope *scope) override;
            void Lower(AST *parent) override;
            void Sanatize() override;
            private:
                std::string id;
                std::vector<Field> fields;
        };
    }
}

#endif // _LYGOS_AST_STRUCT_H_
