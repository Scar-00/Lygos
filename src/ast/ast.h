#ifndef _LYGOS_AST_H_
#define _LYGOS_AST_H_

#include "../core.h"
#include "scope.h"

namespace lygos {
    namespace AST {
        enum class ASTType {
            //statements
            Program,
            Function,
            Closure,
            VarDecl,
            FunctionDecl,

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
            ObjectLiteral,
            NumberLiteral,
            StringLiteral,
            RangeLiteral,
            BinaryExpr,
            Id,
        };

        class AST {
        public:
            ASTType type;
            AST(): type(ASTType::Program) {};
            AST(ASTType type): type(type) {};
            virtual ~AST() {}
            virtual std::string GetValue() { return "NONE"; }
            virtual llvm::Value *GenCode(Scope *scope) { return nullptr; }
        };

        bool ShouldLoad(AST *ast);
        std::ostream &operator<<(std::ostream &os, ASTType type);
        std::ostringstream Print(AST *node, u32 depth = 0);
    }
}

#endif // _LYGOS_AST_H_
