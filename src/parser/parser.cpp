#include "parser.h"
#include "../error/log.h"
#include <cstdlib>
#include <memory>
#include <vector>

namespace lygos {
    namespace Parser {
        #define PEEK(offset) this->tokens[this->index + offset]

        Ref<AST::AST> Parser::BuildAst() {
            Ref<AST::Mod> program = MakeRef<AST::Mod>();
            while (At().type != TokenType::Eof) {
                program->Body().push_back(ParseGlobals());
            }
            return program;
        }

        Ref<AST::AST> Parser::ParseGlobals() {
            switch (At().type) {
                case TokenType::KwStruct: return ParseStructDecl();
                case TokenType::KwFn: return ParseFunc();
                case TokenType::KwImpl: return ParseImpl();
                case TokenType::KwStatic: return ParseStatic();
                case TokenType::KwTrait: return ParseTrait();
                case TokenType::KwMacro: return ParseMacro();
                default: return ParseStmt();
            }
        }

        Ref<AST::AST> Parser::ParseStatic() {
            Eat();
            auto assignemnt = ParseAssignmentExpr();
            auto type = ((AST::AssignmentExpr *)assignemnt.get())->Rhs()->type;
            if(!(type == AST::ASTType::StringLiteral || type == AST::ASTType::NumberLiteral))
                Log::Logger::Warn("can only assign literal values to static declarations");
            return MakeRef<AST::StaticLiterial>(assignemnt);
        }

        Ref<AST::AST> Parser::ParseImpl() {
            Eat();

            auto id = Eat();

            if(id.type != TokenType::Id)
                Log::Logger::Warn(At(), "expected identifier after keyword `impl`");

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{`");

            auto impl = MakeRef<AST::Impl>(id.value, std::vector<Ref<AST::AST>>());

            current_impl = impl;
            while (At().type != TokenType::CurlyRight) {
                impl->Body().push_back(ParseFunc());
            }

            if(Eat().type != TokenType::CurlyRight)
                Log::Logger::Warn(PEEK(-1), "expected `}`");
            current_impl = nullptr;
            return impl;
        }

        Ref<AST::AST> Parser::ParseTrait() {
            Log::Logger::Warn("unimplemented [ParseTrait]");
            Eat();

            auto id = Eat();

            if(id.type != TokenType::Id)
                Log::Logger::Warn(At(), "expected identifier after keyword `trait`");

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{`");

            auto trait = MakeRef<AST::Trait::Trait>(id.value, std::vector<Ref<AST::Function>>());
            current_trait = trait;
            while (At().type != TokenType::CurlyRight) {
                trait->Functions().push_back(std::static_pointer_cast<AST::Function>(ParseFunc()));
            }

            if(Eat().type != TokenType::CurlyRight)
                Log::Logger::Warn(PEEK(-1), "expected `}`");
            current_trait = nullptr;
            return trait;
        }

        Ref<AST::AST> Parser::ParseMacro() {
            Eat();

            auto id = Eat();
            if(id.type != TokenType::Id)
                Log::Logger::Warn(id, "expected identifier after keyword `macro`");

            /*-------------------*/
            //parse args
            Eat();
            Eat();
            /*-------------------*/

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after function signature");

            std::vector<Ref<AST::AST>> body;
            while (At().type != TokenType::CurlyRight) {
                body.push_back(ParseStmt());
            }
            Eat();

            return MakeRef<AST::Macro>(id.value, body);
        }

        Ref<AST::AST> Parser::ParseStmt() {
            Ref<AST::AST> node = NULL;
            switch(At().type) {
            case TokenType::KwIf:
                node = ParseIfExpr();
                break;
            case TokenType::KwFor:
                node = ParseForExpr();
                break;
            case TokenType::KwMatch:
                node = ParseMatchExpr();
                break;
            default:
                node = ParseExpr();
                if(Eat().type != TokenType::Semi) {
                    Log::Logger::Warn(PEEK(-1), "expected `;` at the end of expression");
                }
                break;
            }
            assert(node != NULL && "Can never return NULL from ParseStmt");
            return node;
        }

        AST::StructDef::Field Parser::ParseFieldDecl() {
            auto id = this->Eat();

            if(id.type != TokenType::Id)
                Log::Logger::Warn(PEEK(-1), "expected identifier in field declaration");

            if(Eat().type != TokenType::Colon)
                Log::Logger::Warn(PEEK(-1), fmt::format("field `{}` requires a type", PEEK(-2).value));

            auto type = this->ParseTypeSpec();

            if(Eat().type != TokenType::Semi)
                Log::Logger::Warn(PEEK(-1), "expected `;` after field declaration");

            return AST::StructDef::Field{type, id.value};
        }

        Ref<AST::AST> Parser::ParseStructDecl() {
            Eat();

            auto struct_id = Eat();

            if(struct_id.type != TokenType::Id)
                Log::Logger::Warn(struct_id, "expected identifier after keyword `struct`");

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after struct identifier");

            std::vector<AST::StructDef::Field> fields;

            while (At().type != TokenType::CurlyRight) {
                fields.push_back(ParseFieldDecl());
            }
            Eat();

            if(Eat().type != TokenType::Semi)
                Log::Logger::Warn(PEEK(-1), "expected, `;` after struct declaration");

            return MakeRef<AST::StructDef>(struct_id.value, fields);
        }

        AST::Function::Arg Parser::ParseFuncArg() {
            auto id = Eat();

            if(id.value == "&" || id.value == "mut" || id.value == "self") {
                if(!current_impl)
                    Log::Logger::Warn("member function can only be declared in an impl or trait block");
                Ref<Type::Type> type = nullptr;
                if(id.value == "&") {
                    id = Eat();
                    bool mut = false;
                    if(id.value == "mut") {
                        id = Eat();
                        mut = true;
                    }
                    type = MakeRef<Type::Pointer>(MakeRef<Type::Path>(current_impl->Type()), mut);
                }

                if(id.value != "self")
                    Log::Logger::Warn(id, "expected keyword `self`");

                return {"self", type};
            }

            if(id.type != TokenType::Id)
                Log::Logger::Warn(id, "expected identifier in function signature");

            if(Eat().type != TokenType::Colon)
                Log::Logger::Warn(PEEK(-1), "expected type for function parameter");

            auto type = this->ParseTypeSpec();

            return {id.value, type};
        }

        Ref<AST::AST> Parser::ParseFunc() {
            Eat();

            auto id = Eat();
            if(id.type != TokenType::Id)
                Log::Logger::Warn(PEEK(-1), "expected identifier after keyword `fn`");

            std::vector<AST::Function::Arg> args;
            //bool is_var_arg = false;

            if(Eat().type != TokenType::ParanLeft)
                Log::Logger::Warn(PEEK(-1), "expected `(`");

            while (At().type != TokenType::ParanRight) {
                args.push_back(ParseFuncArg());

                if(At().type == TokenType::ParanRight)
                    break;

                if(At().type != TokenType::Comma)
                    Log::Logger::Warn(At(), "expected `;` or `->` at the end of function decl");
                else Eat();
            }
            Eat();

            Ref<Type::Type> ret_type = MakeRef<Type::Path>("void");

            if(At().type == TokenType::Arrow) {
                Eat();
                ret_type = this->ParseTypeSpec();
            }

            //"mangle" function name
            if(current_impl)
                id.value = current_impl->Type() + "_" + id.value;

            if(At().type == TokenType::Semi) {
                Eat();
                return MakeRef<AST::Function>(id.value, current_impl, args, std::vector<Ref<AST::AST>>(), ret_type, false);
            }

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after function signature");

            std::vector<Ref<AST::AST>> body;
            while (At().type != TokenType::CurlyRight) {
                body.push_back(ParseStmt());
            }
            Eat();

            return MakeRef<AST::Function>(id.value, current_impl, args, body, ret_type, true);
        }

        Ref<AST::AST> Parser::ParseRetExpr() {
            Eat();
            if (At().type == TokenType::Semi) {
                return MakeRef<AST::ReturnExpr>(nullptr);
            }
            return MakeRef<AST::ReturnExpr>(ParseExpr());
        }

        Ref<AST::AST> Parser::ParseIfExpr() {
            //return nullptr;
            Eat();
            auto cond = ParseExpr();
            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after if statement");

            std::vector<Ref<AST::AST>> then_branch;
            while (At().type != TokenType::CurlyRight) {
                then_branch.push_back(ParseStmt());
            }
            Eat();

            if(At().type == TokenType::KwElse) {
                Eat();
                if(Eat().type != TokenType::CurlyLeft)
                    Log::Logger::Warn(PEEK(-1), "expected `{` after else statement");

                std::vector<Ref<AST::AST>> else_branch;
                while(At().type != TokenType::CurlyRight) {
                    else_branch.push_back(ParseStmt());
                }
                Eat();
                return MakeRef<AST::IfStmt>(cond, then_branch, else_branch, true);
            }
            return MakeRef<AST::IfStmt>(cond, then_branch);
        }

        Ref<AST::AST> Parser::ParseForExpr() {
            Eat();
            auto var = ParseExpr();
            //change this [can be any lvalue]
            if(var->type != AST::ASTType::VarDecl)
                Log::Logger::Warn(PEEK(-1), "expected expression after keyword `for`");
            if(Eat().type != TokenType::KwIn)
                Log::Logger::Warn(PEEK(-1), "expected `in` after expression");

            auto cond = ParseExpr();

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after if statement");

            std::vector<Ref<AST::AST>> body;
            while (At().type != TokenType::CurlyRight) {
                body.push_back(ParseStmt());
            }
            Eat();

            return MakeRef<AST::ForStmt>(var, cond, body);
        }

        AST::MatchStmt::Case Parser::ParseMatchCase() {
            auto value = ParsePrimaryExpr();

            if(Eat().type != TokenType::Arrow)
                Log::Logger::Warn(PEEK(-1), "expected `->` after case identifier");

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after case identifier");

            std::vector<Ref<AST::AST>> body;
            while (At().type != TokenType::CurlyRight) {
                body.push_back(ParseStmt());
            }
            Eat();

            return {value, body};
        }

        Ref<AST::AST> Parser::ParseMatchExpr() {
            Eat();

            auto id = ParseExpr();

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after match statement");

            std::vector<AST::MatchStmt::Case> cases;
            while (At().type != TokenType::CurlyRight) {
                cases.push_back(ParseMatchCase());
            }
            Eat();

            return MakeRef<AST::MatchStmt>(id, cases);
        }

        Ref<AST::AST> Parser::ParseVarDecl() {
            Eat();
            bool is_const = true;
            //bool has_type = false;
            Ref<Type::Type> data_type = nullptr;
            Token token = Eat();
            if(token.type == TokenType::KwMut) {
                is_const = false;
                token = Eat();
            }

            if(token.type != TokenType::Id)
                Log::Logger::Warn(token, "expected identifier after keyword `let`");

            auto operation = Eat();

            if(operation.type == TokenType::Colon) {
                data_type = ParseTypeSpec();
                operation = At();
                if(operation.type == TokenType::Equals)
                    Eat();
            }

            switch (operation.type) {
                case TokenType::Semi: {
                    if (is_const)
                        Log::Logger::Warn(token, fmt::format("constant value {} needs to be assigned", token.value));
                    return MakeRef<AST::VarDecl>(token.value, false, data_type, nullptr);
                }
                case TokenType::Equals: {
                    Ref<AST::AST> test = ParseExpr();
                    auto decl = MakeRef<AST::VarDecl>(token.value, is_const, data_type, test);
                    return decl;
                }
                default:
                    Log::Logger::Warn(At(), "expected `=` or `;` after variable declaration");
                    std::exit(1);
            }
        }

        Ref<AST::AST> Parser::ParseExpr() {
            switch (At().type) {
                case TokenType::KwLet: return ParseVarDecl();
                case TokenType::KwRet: return ParseRetExpr();
                default: return ParseCondExpr();
            }
        }

        Ref<AST::AST> Parser::ParseParanExpr() {
            if(At().type == TokenType::ParanLeft) {
                Eat();
                if(At().type == TokenType::Colon) {
                    Eat();
                    auto type = ParseTypeSpec();
                    if(Eat().type != TokenType::ParanRight)
                        Log::Logger::Warn(PEEK(-1), "expected closing paran `)`");
                    return MakeRef<AST::CastExpr>(ParseExpr(), type);
                }
                auto node = ParseExpr();
                if(Eat().type != TokenType::ParanRight)
                    Log::Logger::Warn(PEEK(-1), "expected closing paran `)`");
                return node;
            }
            return ParsePrimaryExpr();
        }

        Ref<AST::AST> Parser::ParseCondExpr() {
            auto lhs = ParseAdditiveExpr();

            while(At().type == TokenType::OpEqEq
            || At().type == TokenType::OpLe
            || At().type == TokenType::OpGr
            || At().type == TokenType::OpOr) {
                auto op = Eat().value;
                auto rhs = ParseAdditiveExpr();
                lhs = MakeRef<AST::BinaryExpr>(lhs, rhs, op);
            }
            return lhs;
        }

        Ref<AST::AST> Parser::ParseAssignmentExpr() {
            Ref<AST::AST> lhs = ParseIndexExpr();

            if(At().type == TokenType::Equals) {
                Eat();

                //AssignmentExpr
                Ref<AST::AST> rhs = ParseExpr();

                return MakeRef<AST::AssignmentExpr>(lhs, rhs);
            }

            return lhs;
        }

        Ref<AST::AST> Parser::ParseAdditiveExpr() {
            Ref<AST::AST> lhs = ParseMultExpr();
            while (At().type == TokenType::OpPlus || At().type == TokenType::OpMinus) {
                auto op = Eat().value;
                Ref<AST::AST> rhs = ParseMultExpr();
                lhs = MakeRef<AST::BinaryExpr>(lhs, rhs, op);
            }
            return lhs;
        }

        Ref<AST::AST> Parser::ParseMultExpr() {
            Ref<AST::AST> lhs = ParseAssignmentExpr();
            while (At().type == TokenType::OpMul || At().type == TokenType::OpDiv || At().type == TokenType::OpMod) {
                auto op = Eat().value;
                Ref<AST::AST> rhs = ParseAssignmentExpr();
                lhs = MakeRef<AST::BinaryExpr>(lhs, rhs, op);
            }
            return lhs;
        }

        Ref<AST::AST> Parser::ParseCallExpr() {
            bool is_macro = false;
            auto callee = ParseResolutionExpr();
            std::cout << At() << "\n";
            if(At().type == TokenType::Dollar) {
                Eat();
                is_macro = true;
                std::cout << "test" << "\n";
            }
            if(At().type == TokenType::ParanLeft) {
                Eat();
                std::vector<Ref<AST::AST>> args;
                while (At().type != TokenType::ParanRight) {
                    args.push_back(ParseExpr());
                    if(At().type == TokenType::ParanRight)
                        break;

                    if(Eat().type != TokenType::Comma)
                        Log::Logger::Warn(PEEK(-1), "function parameters need to be comma seperated");
                }
                Eat();

                if(is_macro)
                    return MakeRef<AST::MacroCall>(callee->GetValue(), std::vector<Ref<AST::AST>>());
                return MakeRef<AST::CallExpr>(callee, args);
            }
            return callee;
        }

        Ref<AST::AST> Parser::ParseMemberExpr() {
            //auto obj = ParseResolutionExpr();
            auto obj = ParseCallExpr();
            while(At().type == TokenType::Dot
                ||At().type == TokenType::Arrow) {
                auto op = Eat();
                //auto member = ParsePrimaryExpr();
                auto member = ParseCallExpr();
                //if(member->type != AST::ASTType::Id)
                //   Log::Logger::Warn("member expression has to be an identifier"); //VERRRRRY temporary probably :)
                obj = MakeRef<AST::MemberExpr>(obj, member, op.type == TokenType::Arrow ? true : false);
            }
            return obj;
        }

        Ref<AST::AST> Parser::ParseResolutionExpr() {
            auto obj = ParseUnaryExpr();
            while (At().type == TokenType::OpScope) {
                Eat();
                auto member = ParseExpr();
                obj = MakeRef<AST::ResolutionExpr>(obj, member);
            }
            return obj;
        }

        Ref<AST::AST> Parser::ParseInitializerExpr() {
            if(At().type == TokenType::CurlyLeft) {
                Eat();
                AST::InitializerList::Initializers values;
                while(At().type != TokenType::CurlyRight) {
                    Token name = {"", TokenType::Eof, Location(0)};

                    if(At().type == TokenType::Dot) {
                        Eat();
                        name = Eat();
                        if(name.type != TokenType::Id)
                            Log::Logger::Warn(name, "expected `identifier` after `.` in initializer list");

                        if(Eat().type != TokenType::Equals)
                            Log::Logger::Warn(PEEK(-1), "expected `=` between member and value");
                    }

                    values.push_back({name.value, ParseExpr()});
                    if(At().type == TokenType::CurlyRight)
                        break;

                    if(Eat().type != TokenType::Comma)
                        Log::Logger::Warn(PEEK(-1), "initializer list values need to be comma `,` seperated");
                }
                Eat();
                return MakeRef<AST::InitializerList>(values, AST::InitializerList::Kind::Anonymus);
            }
            return ParseParanExpr();
        }

        Ref<AST::AST> Parser::ParseCastExpr() {
            if(At().type == TokenType::ParanLeft) {
                Eat();
                auto type = ParseTypeSpec();
                if(Eat().type != TokenType::ParanRight)
                    Log::Logger::Warn(PEEK(-1), "expected closing paran `)`");

                auto obj = ParseExpr();
                return MakeRef<AST::CastExpr>(obj, type);
            }
            return ParsePrimaryExpr();
        }

        Ref<AST::AST> Parser::ParseUnaryExpr() {
            if(At().type == TokenType::Ampercent
            || At().type == TokenType::OpMul
            || At().type == TokenType::Bang) {
                auto op = Eat().value;
                auto obj = ParseExpr();
                //auto obj = ParseIndexExpr();
                return MakeRef<AST::UnaryExpr>(obj, op);
            }
            return ParseInitializerExpr();
        }

        Ref<AST::AST> Parser::ParseIndexExpr() {
            auto obj = ParseMemberExpr();
            while(At().type == TokenType::BraceLeft) {
                Eat();
                //auto index = ParsePrimaryExpr();
                auto index = ParseExpr();
                if(Eat().type != TokenType::BraceRight)
                    Log::Logger::Warn(PEEK(-1), "expected closing bracket `]`");

                obj = MakeRef<AST::AccessExpr>(obj, index);
            }
            return obj;
        }

        Ref<AST::AST> Parser::ParsePrimaryExpr() {
            auto& token = At();
            switch (token.type) {
                case TokenType::Id: {
                    return MakeRef<AST::Identifier>(Eat().value); //TODO figure out data type
                }
                case TokenType::Integer: {
                    return MakeRef<AST::NumberLiteral>(Eat().value, "Integer");
                }
                case TokenType::Float: {
                    return MakeRef<AST::NumberLiteral>(Eat().value, "Float");
                }
                case TokenType::Char: {
                    return MakeRef<AST::NumberLiteral>(Eat().value, "Char");
                }
                case TokenType::String: {
                    return MakeRef<AST::StringLiteral>(Eat().value);
                }
                default:
                    Log::Logger::Warn(Eat(), "unknown token found");
                    return nullptr;
            }
        }

        Ref<Type::Type> Parser::ParseTypeSpec() {
            Ref<Type::Type> spec = nullptr;
            Ref<Type::Type> origin = nullptr;
            //handle pointers;
            while(At().type == TokenType::OpMul || At().type == TokenType::Ampercent) {
                Eat();
                bool mut = false;
                if(At().value == "mut") {
                    Eat();
                    mut = true;
                }

                if(!spec) {
                    origin = spec = MakeRef<Type::Pointer>(nullptr, mut);
                }
                else {
                    auto ptr = MakeRef<Type::Pointer>(nullptr, mut);
                    static_cast<Type::Pointer *>(spec.get())->SetType(ptr);
                    spec = ptr;
                }
            }

            //handle static arrays;
            if(At().type == TokenType::BraceLeft) {
                Eat();
                auto type = ParseTypeSpec();

                if(Eat().type != TokenType::Semi)
                    Log::Logger::Warn(PEEK(-1), "expected `;` after type declaration");

                if(At().type != TokenType::Integer)
                    Log::Logger::Warn(At(), "expected constant value");

                auto count = std::atoi(Eat().value.c_str());

                if(Eat().type != TokenType::BraceRight)
                    Log::Logger::Warn(PEEK(-1), "expected closing brace `]`");

                return MakeRef<Type::Array>(type, count);
            }

            //handle function pointers
            if(At().type == TokenType::KwFn) {
                Eat();
                if(Eat().type != TokenType::ParanLeft)
                    Log::Logger::Warn(PEEK(-1), "expected `(` after keyword `fn`");

                std::vector<Ref<Type::Type>> params;
                while (At().type != TokenType::ParanRight) {
                    params.push_back(ParseTypeSpec());
                    if(At().type == TokenType::ParanRight)
                        break;
                    if(Eat().type != TokenType::Comma)
                        Log::Logger::Warn(PEEK(-1), "function params have to be comma seperated");
                }
                Eat();

                Ref<Type::Type> ret_type = MakeRef<Type::Path>("void");

                if(At().type == TokenType::Arrow) {
                    Eat();
                    ret_type = ParseTypeSpec();
                }

                return MakeRef<Type::FuncPtr>(params, ret_type);
            }

            if(At().type != TokenType::Id)
                Log::Logger::Warn(At(), "expected type");

            if(!spec) {
                origin = MakeRef<Type::Path>(Eat().value);
            }else {
                static_cast<Type::Pointer *>(spec.get())->SetType(MakeRef<Type::Path>(Eat().value));
            }

            return origin;
        }
    }
}
