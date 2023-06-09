#include "ast.h"
#include "../error/log.h"
#include "access.h"
#include "assignment.h"
#include "call.h"
#include "macro.h"
#include "mod.h"
#include "function.h"
#include "binary.h"
#include "impl.h"
#include "scope.h"
#include "vardecl.h"
#include "casting.h"
#include "struct.h"
#include <fmt/core.h>
#include <sstream>

namespace lygos {
    namespace AST {
        Block::Block(): body({}), index(0) {}
        Block::Block(Content body): body(body), index(0) {}

        void Block::Insert(Content &exprs) {
            VecInsertAt(body, index, exprs);
        }

        void Block::Insert(Ref<AST> &expr) {
            VecInsertAt(body, index, expr);
        }

        void Block::Replace(Content &exprs) {
            VecReplaceAt(body, index, exprs);
        }

        void Block::Replace(Ref<AST> &expr) {
            VecReplaceAt(body, index, expr);
        }

        bool ShouldLoad(AST *ast) {
            if(ast->type == ASTType::MemberExpr && ((MemberExpr *)ast)->Member()->type == ASTType::CallExpr)
                return false;
            if(ast->type == ASTType::UnaryExpr && ((UnaryExpr *)ast)->Op() == "&")
                return false;
            return ast->type == ASTType::Id
                || ast->type == ASTType::MemberExpr
                || ast->type == ASTType::AccessExpr
                || ast->type == ASTType::UnaryExpr;
        }

        std::ostream &operator<<(std::ostream &os, ASTType type) {
            //stringify instead of pushing into os;
            switch(type) {
                case ASTType::Mod: os << "Program"; break;
                case ASTType::Function: os << "Function"; break;
                case ASTType::Closure: os << "Closure"; break;
                case ASTType::VarDecl: os << "VarDecl"; break;
                case ASTType::AssignmentExpr: os << "AssignmentExpr"; break;
                case ASTType::MemberExpr: os << "MemberExpr"; break;
                case ASTType::IfStmt: os << "IfStmt"; break;
                case ASTType::ForStmt: os << "ForStmt"; break;
                case ASTType::MatchStmt: os << "MatchStmt"; break;
                case ASTType::CallExpr: os << "CallExpr"; break;
                case ASTType::AccessExpr: os << "AccessExpr"; break;
                case ASTType::UnaryExpr: os << "UnaryExpr"; break;
                case ASTType::StructDef: os << "StructDef"; break;
                case ASTType::Impl: os << "Impl"; break;
                case ASTType::NumberLiteral: os << "NumberLiteral"; break;
                case ASTType::StringLiteral: os << "StringLiteral"; break;
                case ASTType::StaticLiterial: os << "StaticLiterial"; break;
                case ASTType::BinaryExpr: os << "BinaryExpr"; break;
                case ASTType::Id: os << "Identifier"; break;
                case ASTType::ResolutionExpr: os << "ResolutionExpr"; break;
                case ASTType::CastExpr: os << "CastExpr"; break;
                case ASTType::ReturnExpr: os << "ReturnExpr"; break;
                case ASTType::InitializerList: os << "InitializerList"; break;
                case ASTType::Macro: os << "Macro"; break;
                case ASTType::MacroCall: os << "MacroCall"; break;
                case ASTType::Trait: os << "Trait"; break;
                case ASTType::MacroInclude: os << "MacroInclude"; break;
                case ASTType::MacroSizeOf: os << "MacroSizeOf"; break;
                case ASTType::EnumDef: os << "EnumDef"; break;
                case ASTType::TypeAlias: os << "TypeAlias"; break;
            }
            return os;
        }

        static void indent(std::ostream &os, s32 depth) {
            for(s32 i = 0; i < depth; i++) {
                os << "    ";
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
                    ss << ":" << node->GetValue() << '\n';
                    for(const auto &n : ((Mod *)node)->Body().Body())
                        ss << Print(n.get(), depth + 1).str();
                } break;
                case ASTType::Function: {
                    ss << ": " << node->GetValue() << "\n";
                    for(const auto &n : static_cast<Function *>(node)->Body().Body())
                        ss << Print(n.get(), depth + 1).str();
                } break;
                case ASTType::VarDecl: {
                    ss << " var: " << node->GetValue();
                    auto value = static_cast<VarDecl *>(node)->Value();
                    if(value)
                        ss << " =\n" << Print(value.get(), depth + 1).str();
                    else
                        ss << "\n";
                } break;
                case ASTType::AssignmentExpr: {
                    ss << ": =\n";
                    auto assignment = (AssignmentExpr *)node;
                    auto lhs = Print(assignment->Lhs().get(), depth + 1).str();
                    auto rhs = Print(assignment->Rhs().get(), depth + 1).str();
                    ss << lhs;
                    ss << rhs;
                } break;
                case ASTType::CallExpr: {
                    ss << ": " << node->GetValue() << "\n";
                    ss << Print(((CallExpr *)node)->GetCaller().get(), depth + 1).str();
                    for(const auto &arg : ((CallExpr *)node)->Args()) {
                        ss << Print(arg.get(), depth + 1).str();
                    }
                } break;
                case ASTType::MemberExpr: {
                    ss << "\n";
                    ss << Print(((MemberExpr *) node)->Obj().get(), depth + 1).str();
                    ss << Print(((MemberExpr *) node)->Member().get(), depth + 1).str();
                } break;
                case ASTType::UnaryExpr: {
                    ss << ": " << static_cast<UnaryExpr *>(node)->Op() << "\n";
                    ss << Print(static_cast<UnaryExpr *>(node)->Obj().get(), depth + 1).str();
                } break;
                case ASTType::AccessExpr: {
                    ss << "\n";
                    ss << Print(((AccessExpr *) node)->Obj().get(), depth + 1).str();
                    ss << Print(((AccessExpr *) node)->Index().get(), depth + 1).str();
                } break;
                case ASTType::Impl: {
                    ss << ": " << node->GetValue() << "\n";
                    for(const auto &item : ((Impl *)node)->Body().Body())
                        ss << Print(item.get(), depth + 1).str();
                } break;
                case ASTType::Id: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::Macro: {
                    ss << ": " << node->GetValue() << "\n";
                    //for(const auto &item : ((Macro *)node)->Body().Body())
                    //    ss << Print(item.get(), depth + 1).str();
                } break;
                case ASTType::StructDef: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::Trait: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::NumberLiteral: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::StringLiteral: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::MacroInclude: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::EnumDef: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                case ASTType::MacroCall: {
                    ss << ": " << node->GetValue() << "\n";
                } break;
                default: ss << "\n"; break;
            }
            return ss;
        }
    }
}
