#ifndef _LYGOS_AST_H_
#define _LYGOS_AST_H_

#include "../core.h"
#include "scope.h"
#include <memory>

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
            IfExpr,
            ForExpr,
            CallExpr,
            AccessExpr,
            UnaryExpr,
            ResolutionExpr,
            CastExpr,
            ReturnExpr,

            //literals
            StructDef,
            Impl,
            NumberLiteral,
            StringLiteral,
            InitializerList,
            BinaryExpr,
            Id,
        };

        class AST {
        public:
            ASTType type;
            AST(): type(ASTType::Mod) {};
            AST(ASTType type): type(type) {};
            virtual ~AST() {}
            virtual std::string GetValue() { return "NONE"; }
            virtual llvm::Value *GenCode(Scope *scope);
            virtual void Lower();
            virtual void Sanatize();
        };

        bool ShouldLoad(AST *ast);
        std::ostream &operator<<(std::ostream &os, ASTType type);
        std::ostringstream Print(AST *node, u32 depth = 0);
    }
}

#endif // _LYGOS_AST_H_
