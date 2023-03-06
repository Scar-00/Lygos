#pragma once

#include "../types.h"
#include "ast.h"
#include "lexer.h"
#include <vector>

enum class TypeConstraints {
    Var,
    Function,
    Field,
};

class Parser {
public:
    Parser(Lexer &lexer): tokens(lexer.GetTokens()), index(0) {
        tokens.push_back(Token{"", TokenType::Eof});
    }
    AST *BuildAst();
private:
    Token& At() { return tokens[index]; }
    Token& Eat() { auto& token = tokens.at(index); index++; return token; }
    AST *ParseGlobals();
    AST *ParseStmt();
    Field ParseFieldDecl();
    AST *ParseStructDecl();
    AST *ParseVarDecl();
    AST *ParseFunc();
    AST *ParseRetExr();
    AST *ParseIfExpr();
    AST *ParseExpr();
    AST *ParseCondExpr();
    AST *ParseAssignmentExpr();
    AST *ParseAdditiveExpr();
    AST *ParseMultExpr();
    AST *ParseMemberExpr();
    AST *ParseCallExpr();
    AST *ParseUnaryExpr();
    AST *ParseIndexExpr();
    AST *ParsePrimaryExpr();
    Type::Type *ParseTypeSpec(TypeConstraints constr);
    std::vector<Token> tokens;
    s32 index;
};
