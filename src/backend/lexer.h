#pragma once

#include "../types.h"
#include <vector>

class Token {
public:
    std::string value;
    TokenType type;
    Token(const char *value, TokenType type): value(value), type(type) {}
    Token(std::string value, TokenType type): value(value), type(type) {}
};

class Lexer {
public:
    Lexer(const char *program);
    std::vector<Token> GetTokens();
private:
    void Advance() { index++; curr = src[index]; }
    Token LexNumber();
    Token LexString();
    Token LexId();
    Token AdvanceToken(Token token);
    Token TryParseType();
    Token TryParseFunctionType();
    Token NextToken();
    const char *src;
    char curr;
    s32 index;
};
