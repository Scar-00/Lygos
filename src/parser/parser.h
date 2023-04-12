#ifndef _LYGOS_PARSER_H_
#define _LYGOS_PARSER_H_

//all AST types
#include "../ast/ast.h"
#include "../ast/access.h"
#include "../ast/assignment.h"
#include "../ast/binary.h"
#include "../ast/call.h"
//#include "../ast/cfg.h"
#include "../ast/function.h"
#include "../ast/literals.h"
#include "../ast/mod.h"
#include "../ast/scope.h"
#include "../ast/struct.h"
#include "../ast/vardecl.h"
#include "../ast/initializer.h"
#include "../ast/impl.h"
#include "../ast/casting.h"

#include "../lex/lexer.h"

namespace lygos {
    namespace Parser {
        class Parser {
        public:
            Parser(Lexer &lexer): tokens(lexer.GetTokens()), index(0) {
                tokens.push_back(Token{"", TokenType::Eof, 0});
            }
            Ref<AST::AST> BuildAst();
        private:
            Token& At() { return tokens[index]; }
            Token& Eat() { auto& token = tokens.at(index); index++; return token; }
            Ref<AST::AST> ParseGlobals();
            Ref<AST::AST> ParseImpl();
            Ref<AST::AST> ParseStmt();
            AST::StructDef::Field ParseFieldDecl();
            Ref<AST::AST> ParseStructDecl();
            Ref<AST::AST> ParseVarDecl();
            Ref<AST::AST> ParseFunc();
            Ref<AST::AST> ParseRetExpr();
            Ref<AST::AST> ParseIfExpr();
            Ref<AST::AST> ParseForExpr();
            Ref<AST::AST> ParseExpr();
            Ref<AST::AST> ParseParanExpr();
            Ref<AST::AST> ParseCondExpr();
            Ref<AST::AST> ParseAssignmentExpr();
            Ref<AST::AST> ParseAdditiveExpr();
            Ref<AST::AST> ParseMultExpr();
            Ref<AST::AST> ParseMemberExpr();
            Ref<AST::AST> ParseResolutionExpr();
            Ref<AST::AST> ParseCallExpr();
            Ref<AST::AST> ParseCastExpr();
            Ref<AST::AST> ParseInitializerExpr();
            Ref<AST::AST> ParseUnaryExpr();
            Ref<AST::AST> ParseIndexExpr();
            Ref<AST::AST> ParsePrimaryExpr();
            Ref<Type::Type> ParseTypeSpec();
            std::vector<Token> tokens;
            s32 index;
        };
    }
}

#endif // _LYGOS_PARSER_H_
