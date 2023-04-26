#include "lexer.h"
#include "../error/log.h"

namespace lygos {
    std::ostream &operator<<(std::ostream &os, const Token &token) {
        os << STRINGIFY(token.type) << ": " << token.value;
        return os;
    }

    Lexer::Lexer(const char *program): src(program), curr(program[0]), index(0), line(1) {}

    std::vector<Token> Lexer::GetTokens() {
        Token token = {"", TokenType::Arrow, line};
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
            return {value, TokenType::Float, line};

        return {value, TokenType::Integer, line};
    }

    Token Lexer::LexString() {
        std::string value;
        while (curr != '\"') {
            value.push_back(curr);
            Advance();
        }
        Advance();
        return {std::move(value), TokenType::String, line};
    }

    Token Lexer::LexChar() {
        std::string value;
        while (curr != '\'') {
            value.push_back(curr);
            Advance();
        }
        Advance();
        return {std::move(value), TokenType::Char, line};
    }

    Token Lexer::LexId() {
        std::string value = {0};
        while (std::isalpha(curr) || std::isdigit(curr) ||curr == '_'){
            value.push_back(curr);
            Advance();
        }
        value.erase(0, 1);
        if(KeyWords.contains(value)) {
            return {value, KeyWords.at(value), line};
        }

        return {value, TokenType::Id, line};
    }

    Token Lexer::NextToken() {
        while (curr != '\0') {
            while (std::isspace(curr)) {
                if(curr == '\n') line++;
                Advance();
            }

            switch (curr) {
                case '.': return AdvanceToken({".", TokenType::Dot, line});
                case ',': return AdvanceToken({",", TokenType::Comma, line});
                case ';': return AdvanceToken({";", TokenType::Semi, line});
                case ':': {
                    switch (src[index + 1]) {
                        case ':': Advance(); return AdvanceToken({"::", TokenType::OpScope, line});
                        default: return AdvanceToken({":", TokenType::Colon, line});
                    }
                }
                case '+': return AdvanceToken({"+", TokenType::OpPlus, line});
                case '-': {
                    switch (src[index + 1]) {
                        case '>': Advance(); return AdvanceToken({"->", TokenType::Arrow, line});;
                        default: return AdvanceToken({"-", TokenType::OpMinus, line});
                    }
                }
                case '*': return AdvanceToken({"*", TokenType::OpMul, {line}});
                case '/': return AdvanceToken({"/", TokenType::OpDiv, line});
                case '%': return AdvanceToken({"%", TokenType::OpMod, line});
                case '[': return AdvanceToken({"[", TokenType::BraceLeft, line});
                case ']': return AdvanceToken({"]", TokenType::BraceRight, line});
                case '{': return AdvanceToken({"{", TokenType::CurlyLeft, line});
                case '}': return AdvanceToken({"}", TokenType::CurlyRight, line});
                case '(': return AdvanceToken({"(", TokenType::ParanLeft, line});
                case ')': return AdvanceToken({")", TokenType::ParanRight, line});
                case '<': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({"<=", TokenType::OpEqEq, line});
                        default: return AdvanceToken({"<", TokenType::OpGr, line});
                    }
                }
                case '>': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({">=", TokenType::OpEqEq, line});
                        default: return AdvanceToken({">", TokenType::Bang, line});
                    }
                }
                case '&': {
                    switch (src[index + 1]) {
                        case '&': Advance(); return AdvanceToken({"&&", TokenType::OpAnd, line});
                        default: return AdvanceToken({"&", TokenType::Ampercent, line});
                    }
                }               case '#': return AdvanceToken({"#", TokenType::Hash, line});
                case '|': {
                    switch (src[index + 1]) {
                        case '|': Advance(); return AdvanceToken({"||", TokenType::OpOr, line});
                        default: return AdvanceToken({"|", TokenType::Pipe, line});
                    }
                }
                case '!': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({"!=", TokenType::OpEqEq, line});
                        default: return AdvanceToken({"!", TokenType::Bang, line});
                    }
                }
                case '=': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({"==", TokenType::OpEqEq, line});
                        default: return AdvanceToken({"=", TokenType::Equals, line});
                    }
                }
                case '\"': Advance(); return LexString();
                case '\'': Advance(); return LexChar();
                case '\0': return {"", TokenType::Eof, line};
                default:
                    if(std::isdigit(curr))
                        return LexNumber();
                    if(std::isalpha(curr))
                        return LexId();

                Log::Logger::Abort(fmt::format("found unknown char `{}`", (int)curr));
            }
        }
        return {"", TokenType::Eof, 0};
    }
}
