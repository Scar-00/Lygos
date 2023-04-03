#include "parser.h"
#include "../error/log.h"

namespace lygos {
    namespace Parser {
        #define PEEK(offset) this->tokens[this->index + offset]

        AST::AST *Parser::BuildAst() {
            AST::Program *program = new AST::Program();
            while (At().type != TokenType::Eof) {
                program->body.push_back(ParseGlobals());
            }
            return program;
        }

        AST::AST *Parser::ParseGlobals() {
            switch (At().type) {
                case TokenType::KwStruct: return ParseStructDecl();
                case TokenType::KwFn: return ParseFunc();
                case TokenType::KwImpl: return ParseImpl();
                default: return ParseStmt();
            }
        }

        AST::AST *Parser::ParseImpl() {
            Eat();

            auto id = Eat();

            if(id.type != TokenType::Id)
                Log::Logger::Warn(At(), "expected identifier after keyword `impl`");

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{`");

            std::vector<AST::AST *> nodes;
            while (At().type != TokenType::CurlyRight) {
                nodes.push_back(ParseFunc());
            }

            if(Eat().type != TokenType::CurlyRight)
                Log::Logger::Warn(PEEK(-1), "expected `}`");

            return new AST::Impl(id.value, nodes);
        }

        AST::AST *Parser::ParseStmt() {
            AST::AST *node = NULL;
            switch(At().type) {
            case TokenType::KwIf:
                node = ParseIfExpr();
                break;
            case TokenType::KwFor:
                node = ParseForExpr();
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

        AST::Field Parser::ParseFieldDecl() {
            auto id = this->Eat();

            if(id.type != TokenType::Id)
                Log::Logger::Warn(PEEK(-1), "expected identifier in field declaration");

            if(Eat().type != TokenType::Colon)
                Log::Logger::Warn(PEEK(-1), fmt::format("field `{}` requires a type", PEEK(-2).value));

            auto type = this->ParseTypeSpec();

            if(Eat().type != TokenType::Semi)
                Log::Logger::Warn(PEEK(-1), "expected `;` after field declaration");

            return AST::Field{id.value, type};
        }

        AST::AST *Parser::ParseStructDecl() {
            Eat();

            auto struct_id = Eat();

            if(struct_id.type != TokenType::Id)
                Log::Logger::Warn(PEEK(-1), "expected identifier after keyword 'struct'");

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after struct identifier");

            std::vector<AST::Field> fields;

            while (At().type != TokenType::CurlyRight) {
                fields.push_back(ParseFieldDecl());
            }
            Eat();

            if(Eat().type != TokenType::Semi)
                Log::Logger::Warn(PEEK(-1), "expected, `;` after struct declaration");

            return new AST::StructDef{struct_id.value, fields};
        }

        AST::AST *Parser::ParseFunc() {
            Eat();

            auto id = Eat();
            if(id.type != TokenType::Id)
                Log::Logger::Warn(PEEK(-1), "expected identifier after keyword `fn`");

            std::vector<std::tuple<std::string, Type::Type *>> args;

            if(Eat().type != TokenType::ParanLeft)
                Log::Logger::Warn(PEEK(-1), "expected `(`");

            while (At().type != TokenType::ParanRight) {
                auto id = Eat();
                if(id.type != TokenType::Id)
                    Log::Logger::Warn(id, "expected identifier in function signature");

                if(Eat().type != TokenType::Colon)
                    Log::Logger::Warn(PEEK(-1), "expected type for function parameter");

                auto type = this->ParseTypeSpec();

                args.push_back({id.value, type});

                if(At().type == TokenType::ParanRight)
                    break;

                if(At().type != TokenType::Comma)
                    Log::Logger::Warn(At(), "expected `;` at the end of function decl");
                else Eat();
            }
            Eat();

            Type::Type * ret_type = new Type::Path("void");

            if(At().type == TokenType::Arrow) {
                Eat();
                ret_type = this->ParseTypeSpec();
            }

            if(At().type == TokenType::Semi) {
                Eat();
                return new AST::FunctionDecl(id.value, ret_type, args);
            }

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after function signature");

            std::vector<AST::AST *> body;
            while (At().type != TokenType::CurlyRight) {
                body.push_back(ParseStmt());
            }
            Eat();

            return new AST::Function(id.value, body, ret_type, args);
        }

        AST::AST *Parser::ParseRetExr() {
            Eat();
            if (At().type == TokenType::Semi) {
                return new AST::ReturnExpr(NULL);
            }
            return new AST::ReturnExpr{ParseExpr()};
        }

        AST::AST *Parser::ParseIfExpr() {
            Eat();
            auto cond = ParseExpr();

            if(Eat().type != TokenType::CurlyLeft)
                Log::Logger::Warn(PEEK(-1), "expected `{` after if statement");

            std::vector<AST::AST *> then_branch;
            while (At().type != TokenType::CurlyRight) {
                then_branch.push_back(ParseStmt());
            }
            Eat();

            std::shared_ptr<std::vector<AST::AST *>> else_branch = NULL;
            if(At().type == TokenType::KwElse) {
                Eat();
                if(Eat().type != TokenType::CurlyLeft)
                    Log::Logger::Warn(PEEK(-1), "expected `{` after else statement");

                else_branch = std::make_unique<std::vector<AST::AST *>>();
                while(At().type != TokenType::CurlyRight) {
                    else_branch->push_back(ParseStmt());
                }
                Eat();
            }
            return new AST::IfExpr(cond, then_branch, else_branch);
        }

        //TODO!!!!!!!
        AST::AST *Parser::ParseForExpr() {
            Eat();
            auto var = ParseExpr();
            //change this [can be any lvalue]
            if(var->type != AST::ASTType::Id)
                Log::Logger::Warn(PEEK(-1), "expected expression after keyword `fn`");
            if(Eat().type != TokenType::KwIn)
                Log::Logger::Warn(PEEK(-1), "expected `in` after expression");

            auto iter = ParseExpr();

            std::vector<AST::AST *> body;

            Log::Logger::Warn("NOT YET IMPL");
            return new AST::ForExpr(var, iter, body);
        }

        AST::AST *Parser::ParseVarDecl() {
            Eat();
            bool is_const = true;
            //bool has_type = false;
            Type::Type *data_type = nullptr;
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
            }
            switch (operation.type) {
                case TokenType::Semi: {
                    if (is_const)
                        Log::Logger::Warn(token, fmt::format("constant value {} needs to be assigned", token.value));
                    return new AST::VarDecl{token.value, nullptr, false, data_type};
                }
                //FIXME: FIX THIS SHIT!!! WHY IS IT NOT WORKING ??? :(((((
                case TokenType::Equals: {
                    Eat();
                    //std::cout << At() << "\n";
                    //error("DEBUG");
                    auto decl = new AST::VarDecl{token.value, std::make_shared<AST::AST*>(ParseExpr()), is_const, data_type};
                    return decl;
                }
                default:
                    Log::Logger::Warn(At(), "expected `=` or `;` after variable declaration");
                    std::exit(1);
            }
        }

        AST::AST *Parser::ParseExpr() {
            switch (At().type) {
                case TokenType::KwLet: return ParseVarDecl();
                case TokenType::KwRet: return ParseRetExr();
                default: return ParseCondExpr();
            }
        }

        AST::AST *Parser::ParseCondExpr() {
            auto lhs = ParseAssignmentExpr();

            if(At().type == TokenType::OpEqEq
            || At().type == TokenType::OpLe
            || At().type == TokenType::OpGr) {
                auto op = Eat().value;
                auto rhs = ParseAssignmentExpr();
                return new AST::BinaryExpr{lhs, rhs, op};
            }
            return lhs;
        }

        AST::AST *Parser::ParseAssignmentExpr() {
            AST::AST *lhs = ParseAdditiveExpr();

            if(At().type == TokenType::Equals) {
                Eat();

                AST::AST *rhs = ParseAssignmentExpr();

                return new AST::AssignmentExpr{lhs, rhs, "Unknown"}; //TODO figure out data type
            }

            return lhs;
        }

        AST::AST *Parser::ParseAdditiveExpr() {
            AST::AST *lhs = ParseMultExpr();
            while (At().type == TokenType::OpPlus || At().type == TokenType::OpMinus) {
                auto op = Eat().value;
                AST::AST *rhs = ParseMultExpr();
                lhs = new AST::BinaryExpr{lhs, rhs, op};
            }
            return lhs;
        }

        AST::AST *Parser::ParseMultExpr() {
            AST::AST *lhs = ParseCallExpr();
            while (At().type == TokenType::OpMul || At().type == TokenType::OpDiv || At().type == TokenType::OpMod) {
                auto op = Eat().value;
                AST::AST *rhs = ParseCallExpr();
                lhs = new AST::BinaryExpr(lhs, rhs, op);
            }
            return lhs;
        }

        AST::AST *Parser::ParseCallExpr() {
            auto callee = ParseMemberExpr();

            if(At().type == TokenType::ParanLeft) {
                Eat();
                std::vector<AST::AST *> args;
                while (At().type != TokenType::ParanRight) {
                    args.push_back(ParseExpr());
                    if(At().type == TokenType::ParanRight)
                        break;

                    if(Eat().type != TokenType::Comma)
                        Log::Logger::Warn(PEEK(-1), "function parameters need to be comma seperated");
                }
                Eat();

                return new AST::CallExpr(callee, args);
            }
            return callee;
        }

        AST::AST *Parser::ParseMemberExpr() {
            auto obj = ParseResolutionExpr();
            while (At().type == TokenType::Dot) {
                Eat();
                //auto member = ParseExpr();
                auto member = ParsePrimaryExpr();
                if(member->type != AST::ASTType::Id)
                    Log::Logger::Warn(member, "member expression has to be an identifier"); //VERRRRRY temporary probably :)
                obj = new AST::MemberExpr{obj, member};
            }

            return obj;
        }

        AST::AST *Parser::ParseResolutionExpr() {
            auto obj = ParseCastExpr();
            while (At().type == TokenType::OpScope) {
                Eat();
                auto member = ParseExpr();
                obj = new AST::ResolutionExpr(obj, member);
            }
            return obj;
        }

       AST::AST *Parser::ParseCastExpr() {
            if(At().type == TokenType::ParanLeft) {
                Eat();
                auto type = ParseTypeSpec();
                if(Eat().type != TokenType::ParanRight)
                    Log::Logger::Warn(PEEK(-1), "expected `(`");

                auto obj = ParseExpr();
                return new AST::CastExpr(obj, type);
            }
            return ParseUnaryExpr();
        }

        AST::AST *Parser::ParseUnaryExpr() {
            if(At().type == TokenType::Ampercent
            || At().type == TokenType::OpMul) {
                auto op = Eat().value;
                auto obj = ParseExpr();
                //auto obj = ParseIndexExpr();
                return new AST::UnaryExpr(obj, op);
            }
            return ParseIndexExpr();
        }

        AST::AST *Parser::ParseIndexExpr() {
            auto obj = ParsePrimaryExpr();
            while (At().type == TokenType::BraceLeft) {
                Eat();
                //auto index = ParsePrimaryExpr();
                auto index = ParseExpr();
                if(Eat().type != TokenType::BraceRight)
                    Log::Logger::Warn(PEEK(-1), "expected closing bracket `]`");

                obj = new AST::AccessExpr(obj, index);
            }
            return obj;
        }

//presc
//
//Expr
//Cond
//AssignmentExpr
//Additive
//Mutlipl
//Call
//Member
//Index
//Primary

        AST::AST *Parser::ParsePrimaryExpr() {
            auto& token = At();
            switch (token.type) {
                case TokenType::Id: {
                    return new AST::Identifier{Eat().value, "Unknown"}; //TODO figure out data type
                }
                case TokenType::Integer: {
                    return new AST::NumberLiteral{Eat().value, "Integer"};
                }
                case TokenType::Float: {
                    return new AST::NumberLiteral{Eat().value, "Float"};
                }
                case TokenType::String: {
                    return new AST::StringLiteral{Eat().value, "String"};
                }
                case TokenType::ParanLeft: {
                    Eat();
                    AST::AST *value = ParseExpr();
                    auto &token = Eat();
                    if(token.type != TokenType::ParanRight)
                        Log::Logger::Warn(token, "unknown token");
                    return value;
                }
                default:
                    Log::Logger::Warn(Eat(), "unknown token found");
                    return nullptr;
            }
        }

        Type::Type *Parser::ParseTypeSpec() {
            Type::Type *spec = nullptr;
            Type::Type *origin = nullptr;
            //handle pointers;
            while(At().type == TokenType::OpMul || At().type == TokenType::Ampercent) {
                Eat();
                bool mut = false;
                if(At().value == "mut") {
                    Eat();
                    mut = true;
                }

                if(!spec) {
                    origin = spec = new Type::Pointer(nullptr, mut);
                }
                else {
                    auto ptr = new Type::Pointer(nullptr, mut);
                    static_cast<Type::Pointer *>(spec)->SetType(ptr);
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

                return new Type::Array(type, count);
            }

            //handle function pointers
            if(At().type == TokenType::KwFn) {
                Eat();
                if(Eat().type != TokenType::ParanLeft)
                    Log::Logger::Warn(PEEK(-1), "expected `(` after keyword `fn`");

                std::vector<Type::Type *> params;
                while (At().type != TokenType::ParanRight) {
                    params.push_back(ParseTypeSpec());
                    if(At().type == TokenType::ParanRight)
                        break;
                    if(Eat().type != TokenType::Comma)
                        Log::Logger::Warn(PEEK(-1), "function params have to be comma seperated");
                }
                Eat();

                Type::Type *ret_type = new Type::Path("void");

                if(At().type == TokenType::Arrow) {
                    Eat();
                    ret_type = ParseTypeSpec();
                }

                return new Type::FuncPtr(params, ret_type);
            }

            if(At().type != TokenType::Id)
                Log::Logger::Warn(At(), "expected type");

            if(!spec) {
                origin = new Type::Path(Eat().value);
            }else {
                static_cast<Type::Pointer *>(spec)->SetType(new Type::Path(Eat().value));
            }

            return origin;
        }
    }
}
