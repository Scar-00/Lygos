use crate::Scope;
use crate::lexer::Loc;
use crate::ast::mir::*;
use crate::types::Type;
use lygos_macros::{Visitor, VisitorImpl};

pub type Exprs = Vec<AST>;

#[derive(Debug, Visitor, VisitorImpl)]
#[visitor(ASTVisitor)]
pub enum AST {
    Mod(Mod),
    Function(Function),
    VarDecl(VarDecl),

    AssignmentExpr(AssignmentExpr),
    MemberExpr(MemberExpr),
    CallExpr(CallExpr),
    MemberCallExpr(MemberCallExpr),
    AccessExpr(AccessExpr),
    UnaryExpr(UnaryExpr),
    ResolutionExpr(ResolutionExpr),
    CastExpr(CastExpr),
    ReturnExpr(ReturnExpr),
    BinaryExpr(BinaryExpr),

    IfStmt(IfStmt),
    ForStmt(ForStmt),
    //MatchStmt(()),
    BreakExpr(BreakExpr),
    ClosureExpr(ClosureExpr),

    StructDef(StructDef),
    EnumDef(EnumDef),
    Impl(Impl),
    Trait(Trait),
    Macro(Macro),
    MacroCall(MacroCall),
    TypeAlias(TypeAlias),
    NumberLiteral(NumberLiteral),
    StringLiteral(StringLiteral),
    InitializerList(InitializerListExpr),
    StaticLiteral(StaticLiteral),
    Id(Identifier),
}
