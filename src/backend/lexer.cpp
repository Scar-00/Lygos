#include "lexer.h"
#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <ostream>
#include <stdio.h>
#include <vector>

#include "../util.h"

std::ostream &operator<<(std::ostream &os, const Location &loc) {
    //os << "Location -> " << loc.GetFile() << ":" << loc.GetLine() << "\n";
    return os;
}

std::ostream &operator<<(std::ostream &os, const Token &token) {
    os << "Type -> " << (int)token.type << "\n";
    os << "Value -> " << token.value << "\n";
    return os;
}

Lexer::Lexer(const char *program): src(program), curr(program[0]), index(0) {}

std::vector<Token> Lexer::GetTokens() {
    Token token = {"", TokenType::Arrow};
    std::vector<Token> tokens;
    while ((token = NextToken()).type != TokenType::Eof) {
        tokens.push_back(token);
    }
    return tokens;
}

Token Lexer::AdvanceToken(Token token) {
    Advance();
    return token;
}

Token Lexer::LexNumber() {
    std::string value = {0};
    while (std::isdigit(curr) || curr == '.') {
        value.push_back(curr);
        Advance();
    }
    value.erase(0, 1);
    if(value.find('.') != std::string::npos)
        return {value, TokenType::Float};

    return {value, TokenType::Integer};
}

Token Lexer::LexString() {
    std::string value;
    while (curr != '\"') {
        value.push_back(curr);
        Advance();
    }
    Advance();
    return {std::move(value), TokenType::String};
}

Token Lexer::LexId() {
    std::string value = {0};
    while (std::isalpha(curr) || std::isdigit(curr) ||curr == '_'){
        value.push_back(curr);
        Advance();
    }
    value.erase(0, 1);
    if(KeyWords.contains(value)) {
        return {value, KeyWords.at(value)};
    }

    return {value, TokenType::Id};
}

//add support for '*', '&' and "mut"/"const" for type specifier
Token Lexer::TryParseType() {
    Advance();
    while (std::isspace(curr)) {
        Advance();
    }

    if(std::isalpha(curr) || std::isdigit(curr)) {
        std::string value;
        while (std::isalpha(curr) || std::isdigit(curr)) {
            value.push_back(curr);
            Advance();
        }
        return {value, TokenType::TypeDef};
    }
    return {":", TokenType::Colon};
}

Token Lexer::TryParseFunctionType() {
    Advance();
    while (std::isspace(curr)) {
        Advance();
    }

    if(std::isalpha(curr) || std::isdigit(curr)) {
        std::string value;
        while (std::isalpha(curr) || std::isdigit(curr)) {
            value.push_back(curr);
            Advance();
        }
        return {value, TokenType::FunctionType};
    }
    return {"->", TokenType::Arrow};
}

Token Lexer::NextToken() {
    while (curr != '\0') {
        while (std::isspace(curr)) {
            Advance();
        }

        switch (curr) {
            case '.': return AdvanceToken({".", TokenType::Dot});
            case ',': return AdvanceToken({",", TokenType::Comma});
            case ';': return AdvanceToken({";", TokenType::Semi});
            case ':': return TryParseType();
            case '+': return AdvanceToken({"+", TokenType::OpPlus});
            case '-': {
                switch (src[index + 1]) {
                    case '>': Advance(); return TryParseFunctionType();
                    default: return AdvanceToken({"-", TokenType::OpMinus});
                }
            }
            case '*': return AdvanceToken({"*", TokenType::OpMul});
            case '/': return AdvanceToken({"/", TokenType::OpDiv});
            case '%': return AdvanceToken({"%", TokenType::OpMod});
            case '[': return AdvanceToken({"[", TokenType::BraceLeft});
            case ']': return AdvanceToken({"]", TokenType::BraceRight});
            case '{': return AdvanceToken({"{", TokenType::CurlyLeft});
            case '}': return AdvanceToken({"}", TokenType::CurlyRight});
            case '(': return AdvanceToken({"(", TokenType::ParanLeft});
            case ')': return AdvanceToken({")", TokenType::ParanRight});
            case '<': return AdvanceToken({"<", TokenType::OpLe});
            case '>': return AdvanceToken({">", TokenType::OpGr});
            case '&': return AdvanceToken({"&", TokenType::Ampercent});
            case '#': return AdvanceToken({"#", TokenType::Hash});
            case '=': {
                switch (src[index + 1]) {
                    case '=': Advance(); return AdvanceToken({"==", TokenType::OpEqEq});
                    default: return AdvanceToken({"=", TokenType::Equals});
                }
            }
            case '\"': Advance(); return LexString();
            case '\0': return {"", TokenType::Eof};
            default:
                if (std::isdigit(curr))
                    return LexNumber();
                if(std::isalpha(curr))
                    return LexId();

            error("Unknown char '%c' found", curr);
        }
    }
    return {"", TokenType::Eof};
}
