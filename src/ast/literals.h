#ifndef _LYGOS_AST_LITERALS_H_
#define _LYGOS_AST_LITERALS_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Identifier : public AST {
            public:
                Identifier(std::string id);
                std::string &GetId() { return id; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string id;
        };

        struct StringLiteral : public AST {
            public:
                StringLiteral(std::string value);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string value;
        };

        struct NumberLiteral : public AST {
            public:
                NumberLiteral(std::string value, std::string type);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string value;
                std::string type;
        };

        struct StaticLiterial : public AST {
            public:
                StaticLiterial(std::string name, Ref<Type::Type> type, Ref<AST> value = nullptr);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                Ref<Type::Type> type;
                Ref<AST> value;
        };

        struct TypeAlias : public AST {
            public:
                TypeAlias(std::string name, Ref<Type::Type> ref_type);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                Ref<Type::Type> ref_type;
        };
    }
}

#endif // _LYGOS_AST_LITERALS_H_
