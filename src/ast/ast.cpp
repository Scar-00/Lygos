#include "ast.h"
#include "../error/log.h"

namespace lygos {
    namespace AST {
        bool ShouldLoad(AST *ast) {
            return ast->type == ASTType::Id
                || ast->type == ASTType::MemberExpr
                || ast->type == ASTType::AccessExpr;
                //|| ast->type == ASTType::UnaryExpr;
        }

        std::ostream &operator<<(std::ostream &os, ASTType type) {
            switch(type) {
                case ASTType::Program: os << "Program"; break;
                case ASTType::Function: os << "Function"; break;
                case ASTType::Closure: os << "Closure"; break;
                case ASTType::VarDecl: os << "VarDecl"; break;
                case ASTType::FunctionDecl: os << "FunctionDecl"; break;
                case ASTType::AssignmentExpr: os << "AssignmentExpr"; break;
                case ASTType::MemberExpr: os << "MemberExpr"; break;
                case ASTType::IfExpr: os << "IfExpr"; break;
                case ASTType::ForExpr: os << "ForExpr"; break;
                case ASTType::CallExpr: os << "CallExpr"; break;
                case ASTType::AccessExpr: os << "AccessExpr"; break;
                case ASTType::UnaryExpr: os << "UnaryExpr"; break;
                case ASTType::StructDef: os << "StructDef"; break;
                case ASTType::Impl: os << "Impl"; break;
                case ASTType::ObjectLiteral: os << "ObjectLiteral"; break;
                case ASTType::NumberLiteral: os << "NumberLiteral"; break;
                case ASTType::StringLiteral: os << "StringLiteral"; break;
                case ASTType::RangeLiteral: os << "RangeLiteral"; break;
                case ASTType::BinaryExpr: os << "BinaryExpr"; break;
                case ASTType::Id: os << "Identifier"; break;
                case ASTType::ResolutionExpr: os << "ResolutionExpr"; break;
                case ASTType::CastExpr: os << "CastExpr"; break;
                case ASTType::ReturnExpr: os << "ReturnExpr"; break;
            }
            return os;
        }
    }
}
