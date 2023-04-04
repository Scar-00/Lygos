#ifndef _LYGOS_PARSER_H_
#define _LYGOS_PARSER_H_

//all AST types
#include "../ast/ast.h"
#include "../ast/access.h"
#include "../ast/assignment.h"
#include "../ast/binary.h"
#include "../ast/call.h"
#include "../ast/cfg.h"
#include "../ast/function.h"
#include "../ast/literals.h"
#include "../ast/mod.h"
#include "../ast/scope.h"
#include "../ast/struct.h"
#include "../ast/vardecl.h"

#include "../lex/lexer.h"

namespace lygos {
    namespace Parser {
        class Parser {
        public:
            Parser(Lexer &lexer): tokens(lexer.GetTokens()), index(0) {
                tokens.push_back(Token{"", TokenType::Eof, 0});
            }
            AST::AST *BuildAst();
        private:
            Token& At() { return tokens[index]; }
            Token& Eat() { auto& token = tokens.at(index); index++; return token; }
            AST::AST *ParseGlobals();
            AST::AST *ParseImpl();
            AST::AST *ParseStmt();
            AST::Field ParseFieldDecl();
            AST::AST *ParseStructDecl();
            AST::AST *ParseVarDecl();
            AST::AST *ParseFunc();
            AST::AST *ParseRetExr();
            AST::AST *ParseIfExpr();
            AST::AST *ParseForExpr();
            AST::AST *ParseExpr();
            AST::AST *ParseParanExpr();
            AST::AST *ParseCondExpr();
            AST::AST *ParseAssignmentExpr();
            AST::AST *ParseAdditiveExpr();
            AST::AST *ParseMultExpr();
            AST::AST *ParseMemberExpr();
            AST::AST *ParseResolutionExpr();
            AST::AST *ParseCallExpr();
            AST::AST *ParseCastExpr();
            AST::AST *ParseUnaryExpr();
            AST::AST *ParseIndexExpr();
            AST::AST *ParsePrimaryExpr();
            Type::Type *ParseTypeSpec();
            std::vector<Token> tokens;
            s32 index;
        };
    }
}

#endif // _LYGOS_PARSER_H_
