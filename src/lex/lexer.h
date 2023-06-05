#ifndef _LYGOS_LEXER_H_
#define _LYGOS_LEXER_H_

#include "../core.h"
#include "../types.h"

namespace lygos {
    struct Location {
    public:
        Location(size_t line): line(line) {};
        Location(size_t line, size_t start): line(line), start(start) {}
        size_t &GetLine() { return line; }
    private:
        size_t line;
        size_t start;
    };

    class Token {
    public:
        std::string value;
        TokenType type;
        Location loc;
        Token(const char *value, TokenType type, Location loc): value(value), type(type), loc(loc) {}
        Token(std::string value, TokenType type, Location loc): value(value), type(type), loc(loc) {}
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
        Token LexChar();
        Token LexId();
        Token AdvanceToken(Token token);
        Token NextToken();
        const char *src;
        char curr;
        s32 index;
        size_t line;
    };
}

#endif // _LYGOS_LEXER_H_
