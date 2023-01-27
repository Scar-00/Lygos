#pragma once

#include "../types.h"
#include <ostream>
#include <vector>

struct Location {
public:
    Location(std::string file, size_t line) {}
    std::string &GetFile() const;
    size_t &GetLine() const;
private:
    std::string file;
    size_t line;
    size_t start, end;
};

std::ostream &operator<<(std::ostream &os, const Location &loc);

class Token {
public:
    std::string value;
    TokenType type;
    Token(const char *value, TokenType type): value(value), type(type) {}
    Token(std::string value, TokenType type): value(value), type(type) {}
};

std::ostream &operator<<(std::ostream &os, const Token &token);

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
