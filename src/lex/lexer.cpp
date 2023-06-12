#include "lexer.h"
#include "../error/log.h"
#include <cstddef>

namespace lygos {
    std::ostream &operator<<(std::ostream &os, const Token &token) {
        os << STRINGIFY(token.type) << ": " << token.value;
        return os;
    }

    Lexer::Lexer(const char *program): src(program), curr(program[0]), index(0), line(1), line_index(0) {}

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
        size_t start = line_index;
        while (std::isdigit(curr) || curr == '.') {
            value.push_back(curr);
            Advance();
        }
        value.erase(0, 1);
        if(value.find('.') != std::string::npos)
            return {value, TokenType::Float, line};

        return {value, TokenType::Integer, {line, start}};
    }

    Token Lexer::LexString() {
        std::string value;
        size_t start = line_index;
        while (curr != '\"') {
            value.push_back(curr);
            Advance();
        }
        Advance();
        return {std::move(value), TokenType::String, {line, start}};
    }

    Token Lexer::LexChar() {
        std::string value;
        size_t start = line_index;
        while (curr != '\'') {
            value.push_back(curr);
            Advance();
        }
        Advance();
        return {std::move(value), TokenType::Char, {line, start}};
    }

    Token Lexer::LexId() {
        std::string value = {0};
        size_t start = line_index;
        while (std::isalpha(curr) || std::isdigit(curr) ||curr == '_'){
            value.push_back(curr);
            Advance();
        }
        value.erase(0, 1);
        if(KeyWords.contains(value)) {
            return {value, KeyWords.at(value), {line, start}};
        }

        return {value, TokenType::Id, {line, start}};
    }

    Token Lexer::NextToken() {
        while (curr != '\0') {
            while (std::isspace(curr)) {
                if(curr == '\n') { line++; line_index = 0; }
                Advance();
            }

            switch (curr) {
                case '.': return AdvanceToken({".", TokenType::Dot, {line, line_index}});
                case ',': return AdvanceToken({",", TokenType::Comma, {line, line_index}});
                case ';': return AdvanceToken({";", TokenType::Semi, {line, line_index}});
                case ':': {
                    switch (src[index + 1]) {
                        case ':': Advance(); return AdvanceToken({"::", TokenType::OpScope, {line, line_index}});
                        default: return AdvanceToken({":", TokenType::Colon, {line, line_index}});
                    }
                }
                case '+': return AdvanceToken({"+", TokenType::OpPlus, {line, line_index}});
                case '-': {
                    switch (src[index + 1]) {
                        case '>': Advance(); return AdvanceToken({"->", TokenType::Arrow, {line, line_index}});;
                        default: return AdvanceToken({"-", TokenType::OpMinus, {line, line_index}});
                    }
                }
                case '*': return AdvanceToken({"*", TokenType::OpMul, {line, line_index}});
                case '/': {
                    switch (src[index + 1]) {
                        case '/': {
                            while(curr != '\n') {
                                Advance();
                            }
                        } break;
                        default: return AdvanceToken({"/", TokenType::OpDiv, {line, line_index}});
                    }
                }break;
                case '%': return AdvanceToken({"%", TokenType::OpMod, {line, line_index}});
                case '[': return AdvanceToken({"[", TokenType::BraceLeft, {line, line_index}});
                case ']': return AdvanceToken({"]", TokenType::BraceRight, {line, line_index}});
                case '{': return AdvanceToken({"{", TokenType::CurlyLeft, {line, line_index}});
                case '}': return AdvanceToken({"}", TokenType::CurlyRight, {line, line_index}});
                case '(': return AdvanceToken({"(", TokenType::ParanLeft, {line, line_index}});
                case ')': return AdvanceToken({")", TokenType::ParanRight, {line, line_index}});
                case '#': return AdvanceToken({"#", TokenType::Hash, {line, line_index}});
                case '$': return AdvanceToken({"$", TokenType::Dollar, {line, line_index}});
                case '<': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({"<=", TokenType::OpEqEq, {line, line_index}});
                        default: return AdvanceToken({"<", TokenType::AngleLeft, {line, line_index}});
                    }
                }
                case '>': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({">=", TokenType::OpEqEq, {line, line_index}});
                        default: return AdvanceToken({">", TokenType::AngleRight, {line, line_index}});
                    }
                }
                case '&': {
                    switch (src[index + 1]) {
                        case '&': Advance(); return AdvanceToken({"&&", TokenType::OpAnd, {line, line_index}});
                        default: return AdvanceToken({"&", TokenType::Ampercent, {line, line_index}});
                    }
                }
                case '|': {
                    switch (src[index + 1]) {
                        case '|': Advance(); return AdvanceToken({"||", TokenType::OpOr, {line, line_index}});
                        default: return AdvanceToken({"|", TokenType::Pipe, {line, line_index}});
                    }
                }
                case '!': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({"!=", TokenType::OpNeEq, {line, line_index}});
                        default: return AdvanceToken({"!", TokenType::Bang, {line, line_index}});
                    }
                }
                case '=': {
                    switch (src[index + 1]) {
                        case '=': Advance(); return AdvanceToken({"==", TokenType::OpEqEq, {line, line_index}});
                        default: return AdvanceToken({"=", TokenType::Equals, {line, line_index}});
                    }
                }                case '\"': Advance(); return LexString();
                case '\'': Advance(); return LexChar();
                case '\0': return {"", TokenType::Eof, {line, line_index}};
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
