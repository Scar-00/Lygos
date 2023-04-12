#include "ast.h"
#include "../error/log.h"
#include "mod.h"
#include "function.h"
#include "binary.h"
#include "impl.h"
#include "vardecl.h"
#include <sstream>

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
                case ASTType::Mod: os << "Program"; break;
                case ASTType::Function: os << "Function"; break;
                case ASTType::Closure: os << "Closure"; break;
                case ASTType::VarDecl: os << "VarDecl"; break;
                case ASTType::AssignmentExpr: os << "AssignmentExpr"; break;
                case ASTType::MemberExpr: os << "MemberExpr"; break;
                case ASTType::IfExpr: os << "IfExpr"; break;
                case ASTType::ForExpr: os << "ForExpr"; break;
                case ASTType::CallExpr: os << "CallExpr"; break;
                case ASTType::AccessExpr: os << "AccessExpr"; break;
                case ASTType::UnaryExpr: os << "UnaryExpr"; break;
                case ASTType::StructDef: os << "StructDef"; break;
                case ASTType::Impl: os << "Impl"; break;
                case ASTType::NumberLiteral: os << "NumberLiteral"; break;
                case ASTType::StringLiteral: os << "StringLiteral"; break;
                case ASTType::BinaryExpr: os << "BinaryExpr"; break;
                case ASTType::Id: os << "Identifier"; break;
                case ASTType::ResolutionExpr: os << "ResolutionExpr"; break;
                case ASTType::CastExpr: os << "CastExpr"; break;
                case ASTType::ReturnExpr: os << "ReturnExpr"; break;
                case ASTType::InitializerList: os << "InitializerList"; break;
            }
            return os;
        }

        static void indent(std::ostream &os, s32 depth) {
            for(s32 i = 0; i < depth; i++) {
                os << "\t";
            }
        }

        std::ostringstream Print(AST *node, u32 depth) {
            if(!node)
                return {};
            std::ostringstream ss;
            indent(ss, depth);
            ss << "[" << node->type << "]";
            switch (node->type) {
                case ASTType::Mod: {
                    ss << ": " << node->GetValue() << '\n';
                    for(const auto &n : ((Mod *)node)->Body())
                        ss << Print(n.get(), depth + 1).str();
                } break;
                case ASTType::Function: {
                    ss << ": " << node->GetValue() << "\n";
                    for(const auto &n : static_cast<Function *>(node)->Body())
                        ss << Print(n.get(), depth + 1).str();
                } break;
                case ASTType::VarDecl: {
                    ss << "\n";
                    indent(ss, depth);
                    ss << "var: " << node->GetValue();
                    auto value = static_cast<VarDecl *>(node)->Value();
                    if(value)
                        ss << " = \n" << Print(value.get(), depth + 1).str();
                    else
                        ss << "\n";
                } break;
                /*case ASTType::BinaryExpr: {
                    auto binop = (BinaryExpr *)node;
                    ss << ": " << binop->op;
                    ss << "\n";
                    auto lhs = Print(binop->lhs, depth + 1).str();
                    ss << lhs;
                    auto rhs = Print(binop->rhs, depth + 1).str();
                    ss << rhs;
                } break;
                case ASTType::NumberLiteral: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::UnaryExpr: {
                    ss << ": " << static_cast<UnaryExpr *>(node)->op << "\n";
                    ss << Print(static_cast<UnaryExpr *>(node)->obj, depth + 1).str() << "\n";
                } break;*/
                case ASTType::Impl: {
                    ss << ": " << node->GetValue() << "\n";
                    for(const auto &item : ((Impl *)node)->Body())
                        ss << Print(item.get(), depth + 1).str();
                } break;
                default: ss << "\n"; break;
            }
            return ss;
        }
    }
}
