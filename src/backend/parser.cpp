#include "parser.h"
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <memory>
#include <stdio.h>
#include <string>
#include <tuple>
#include <vector>
#include <iostream>
#include "../util.h"
#include "ast.h"
#include "lexer.h"

#define LOG(tok) std::cout << #tok << " -> " << tok.value << std::endl

AST *Parser::BuildAst() {
    Program *program = new Program();
    while (At().type != TokenType::Eof) {
        program->body.push_back(ParseStmt());
    }
    return program;
}

AST *Parser::ParseStmt() {
    switch (At().type) {
        case TokenType::KwStruct: return ParseStructDecl();
        case TokenType::KwFn: return ParseFunc();
        default:
            return ParseExpr();
    }
}

Field Parser::ParseFieldDecl() {
    auto id = this->Eat();

    if(id.type != TokenType::Id)
        error("Expected id in field declaration");

    auto type = this->Eat();

    if(type.type != TokenType::TypeDef)
        error("Field %s requires type", type.value.c_str());

    if(Eat().type != TokenType::Semi)
        error("Expected ';' after field declaration");

    return Field{id.value, type.value};
}

AST *Parser::ParseStructDecl() {
    Eat();

    auto struct_id = Eat();

    if(struct_id.type != TokenType::Id)
        error("Exprected Identifier after 'struct' keyword");

    if(Eat().type != TokenType::CurlyLeft)
        error("Expected '{' after struct Identifier");

    std::vector<Field> fields;

    while (At().type != TokenType::CurlyRight) {
        fields.push_back(ParseFieldDecl());
    }
    Eat();

    if(Eat().type != TokenType::Semi)
        error("Expected ';' at the end of struct decl");

    //insert type into local types

    return new StructDef{struct_id.value, fields};
}

AST *Parser::ParseFunc() {
    Eat();

    auto id = Eat();
    if(id.type != TokenType::Id)
        error("Expected 'Identifier' after 'fn' keyword");

    std::vector<std::tuple<std::string, std::string>> args;

    if(Eat().type != TokenType::ParanLeft)
        error("Exprected '('");

    while (At().type != TokenType::ParanRight) {
        auto id = Eat();
        if(id.type != TokenType::Id)
            error("Expected identifier, found %s", id.value.c_str());

        auto type = Eat();
        if(type.type != TokenType::TypeDef)
            error("Exprected type after function parameter, found %s", type.value.c_str());

        args.push_back({id.value, type.value});

        if(At().type == TokenType::ParanRight)
            break;

        if(At().type != TokenType::Comma)
            error("Expected ';'");
        else Eat();
    }
    Eat();

    std::string ret_type = {"void"};

    if(At().type == TokenType::FunctionType) {
        ret_type = Eat().value;
    }

    //add function def here -> ignore body and check for semi
    if(At().type == TokenType::Semi) {
        Eat();
        return new FunctionDecl(id.value, ret_type, args);
    }

    if(Eat().type != TokenType::CurlyLeft)
        error("Expected '{' after function declaration");

    std::vector<AST *> body;
    while (At().type != TokenType::CurlyRight) {
        body.push_back(ParseExpr());
    }
    Eat();

    return new Function(id.value, body, ret_type, args);
}

AST *Parser::ParseRetExr() {
    Eat();
    auto val = ParseExpr();
    if(At().type != TokenType::Semi)
        error("Expected ';' after return expr, found '%s'", At().value.c_str());
    else Eat();

    return new ReturnExpr{val};
}

AST *Parser::ParseVarDecl() {
    Eat();
    bool is_const = true;
    bool has_type = false;
    std::string data_type = {};
    Token token = Eat();
    if(token.type == TokenType::KwMut) {
        is_const = false;
        token = Eat();
    }

    if(token.type != TokenType::Id) {
        printf("Expected Identifier after 'let' statement; Found %s\n", token.value.c_str());
        std::fflush(stdout);
        std::exit(1);
    }

    auto type = Eat();

    if(type.type == TokenType::TypeDef) {
        has_type = true;
        data_type = type.value;
        type = Eat();
    }

    switch (type.type) {
        case TokenType::Semi: {
            if (is_const) {
                printf("Constant value %s needs to be assinged\n", token.value.c_str());
                std::fflush(stdout);
                std::exit(1);
            }
            return new VarDecl{token.value, nullptr, false, data_type};
        }
        case TokenType::Equals: {
            auto decl = new VarDecl{token.value, std::make_shared<AST*>(ParseExpr()), is_const, data_type}; //TODO figure out data type
            if(Eat().type != TokenType::Semi) {
                error("Expected ';' after variable declaration");
            }
            return decl;
        }
        default:
            error("Expected '=' or ';' after variable declaration");
            std::exit(1);
    }
}

AST *Parser::ParseExpr() {
    switch (At().type) {
        case TokenType::KwLet: return ParseVarDecl();
        case TokenType::KwRet: return ParseRetExr();
        default: return ParseCondExpr();
    }
}

AST *Parser::ParseCondExpr() {
    auto lhs = ParseAssignmentExpr();

    if(At().type == TokenType::OpEqEq
    || At().type == TokenType::OpLe
    || At().type == TokenType::OpGr) {
        auto op = Eat().value;
        auto rhs = ParseAssignmentExpr();
        return new BinaryExpr{lhs, rhs, op};
    }
    return lhs;
}

AST *Parser::ParseAssignmentExpr() {
    AST *lhs = ParseAdditiveExpr();

    if(At().type == TokenType::Equals) {
        Eat();

        AST *rhs = ParseAssignmentExpr();
        auto type = At().type;

        if(type == TokenType::Semi || type == TokenType::Equals)
            Eat();
        else
            error("Exprected ';' at the end of expression");

        return new AssignmentExpr{lhs, rhs, "Unknown"}; //TODO figure out data type
    }

    return lhs;
}

AST *Parser::ParseAdditiveExpr() {
    AST *lhs = ParseMultExpr();
    while (At().type == TokenType::OpPlus || At().type == TokenType::OpMinus) {
        auto op = Eat().value;
        AST *rhs = ParseMultExpr();
        lhs = new BinaryExpr{lhs, rhs, op};
    }
    return lhs;
}

AST *Parser::ParseMultExpr() {
    AST *lhs = ParseCallExpr();
    while (At().type == TokenType::OpMul || At().type == TokenType::OpDiv || At().type == TokenType::OpMod) {
        auto op = Eat().value;
        AST *rhs = ParseCallExpr();
        lhs = new BinaryExpr(lhs, rhs, op);
    }
    return lhs;
}

AST *Parser::ParseCallExpr() {
    //auto type = At().type;
    auto callee = ParseMemberExpr();

    if(At().type == TokenType::ParanLeft) {
        Eat();
        std::vector<AST *> args;
        while (At().type != TokenType::ParanRight) {
            args.push_back(ParseExpr());
            if(At().type == TokenType::ParanRight)
                break;

            if(Eat().type != TokenType::Comma)
                error("Expected ';'");
        }
        Eat();

        return new CallExpr(callee, args);
    }

    return callee;
}

AST *Parser::ParseMemberExpr() {
    auto obj = ParsePrimaryExpr();
    while (At().type == TokenType::Dot) {
        Eat();
        auto member = ParsePrimaryExpr();
        if(member->type != ASTType::Id)
            error("Member expression has to be an identifier");

        obj = new MemberExpr{obj, member};
    }

    return obj;
}

//AST *Parser::ParseCallExpr() {

//}

AST *Parser::ParsePrimaryExpr() {
    auto& token = At();
    switch (token.type) {
        case TokenType::Id: {
            return new Identifier{Eat().value, "Unknown"}; //TODO figure out data type
        }
        case TokenType::Integer: {
            return new NumberLiteral{Eat().value, "Integer"};
        }
        case TokenType::Float: {
            return new NumberLiteral{Eat().value, "Float"};
        }
        case TokenType::String: {
            return new StringLiteral{Eat().value, "String"};
        }
        case TokenType::ParanLeft: {
            Eat();
            AST *value = ParseExpr();
            auto &token = Eat();
            if(token.type != TokenType::ParanRight) {
                printf("Unknown Token found [%s], exprected ')'\n", token.value.c_str());
                std::fflush(stdout);
                std::exit(1);
            }
            return value;
        }
        case TokenType::KwIf: {
            Eat();

            auto cond = ParseExpr();

            if(Eat().type != TokenType::CurlyLeft)
                error("Expected '{' after cond");

            std::vector<AST*> then_branch;
            while (At().type != TokenType::CurlyRight) {
                then_branch.push_back(ParseExpr());
            }
            Eat();

            std::shared_ptr<std::vector<AST*>> else_branch = NULL;
            if(At().type == TokenType::KwElse) {
                Eat();

                if(Eat().type != TokenType::CurlyLeft)
                    error("TODO!");

                else_branch = std::make_shared<std::vector<AST*>>();
                while (At().type != TokenType::CurlyRight) {
                    else_branch->push_back(ParseExpr());
                }
                Eat();
            }

            return new IfExpr{cond, then_branch, else_branch};
        }
        case TokenType::KwFor: {
            Eat();
            auto var = ParseExpr();
            if(var->type != ASTType::Id)
                error("Expected Identifier after for keyword, found '%s'", var->GetValue().c_str());

            auto in = Eat();
            if(in.type != TokenType::KwIn)
                error("Expected 'in' keyword after iterator variable, found '%s'", in.value.c_str());

            auto iter = ParseExpr();
            if(iter->type != ASTType::RangeLiteral)
                error("Expected range literal, found '%s'", iter->GetValue().c_str());

            error("test");

            std::vector<AST *> body;


            error("TODO! parse for expr");
            return new ForExpr(var, iter, body);
        }
        default:
            printf("Unknown Token found [%s]\n", token.value.c_str());
            std::fflush(stdout);
            std::exit(1);
    }
}
