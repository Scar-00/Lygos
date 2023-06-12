#ifndef _LYGOS_AST_H_
#define _LYGOS_AST_H_

#include "../core.h"
#include "scope.h"
#include <memory>
#include <vector>

namespace lygos {
        namespace AST {
        enum class ASTType {
            //statements
            Mod,
            Function,
            Closure,
            VarDecl,

            //expr
            AssignmentExpr,
            MemberExpr,
            IfStmt,
            ForStmt,
            MatchStmt,
            CallExpr,
            AccessExpr,
            UnaryExpr,
            ResolutionExpr,
            CastExpr,
            ReturnExpr,

            //literals
            StructDef,
            EnumDef,
            Impl,
            Trait,
            Macro,
            MacroCall,
            MacroInclude,
            MacroSizeOf,
            TypeAlias,
            NumberLiteral,
            StringLiteral,
            InitializerList,
            StaticLiterial,
            BinaryExpr,
            Id,
        };

        class AST {
        public:
            ASTType type;
            AST(): type(ASTType::Mod) {}
            AST(ASTType type): type(type) {}
            virtual ~AST() {}
            virtual std::string GetValue() { return "NONE"; }
            virtual llvm::Value *GenCode(Scope *scope) { return nullptr; }
            virtual Ref<Type::Type> GetType(Scope *scope) { return nullptr; }
            virtual void Lower(AST *parent) {}
            virtual void Sanatize() {}
        };

        struct Block {
        using Content = std::vector<Ref<AST>>;
        public:
            Block();
            Block(Content body);
            Content &Body() { return body; }
            const Content &Body() const { return body; }
            void Increment() { index++; }
            s64 GetIndex() { return index; }
            void Insert(Content &exprs);
            void Insert(Ref<AST> &expr);
            void Replace(Content &exprs);
            void Replace(Ref<AST> &expr);
            bool Returns() { return returns; }
            void SetReturn(bool ret) { returns = ret; }
            void AddDropTarget();
        private:
            Content body;
            s64 index;
            bool returns;
        };

        bool ShouldLoad(AST *ast);
        std::ostream &operator<<(std::ostream &os, ASTType type);
        std::ostringstream Print(AST *node, u32 depth = 0);
    }
}

#endif // _LYGOS_AST_H_
