#pragma once

#include "../types.h"
#include "llvm/IR/Value.h"
#include <float.h>
#include <memory>
#include <string>
#include <tuple>
#include <vector>
#include "scope.h"

enum class DataType : int {
    S32 = 0,
    String = 1,
    Bool = 2,
};

enum class ASTType {
    //statements
    Program,
    Function,
    VarDecl,
    FunctionDecl,

    //expr
    AssignmentExpr,
    MemberExpr,
    IfExpr,
    ForExpr,
    CallExpr,
    AccessExpr,

    //literals
    StructDef,
    ObjectLiteral,
    NumberLiteral,
    StringLiteral,
    RangeLiteral,
    BinaryExpr,
    Id,
};

class AST {
public:
    ASTType type;
    AST(): type(ASTType::Program) {};
    AST(ASTType type): type(type) {};
    virtual ~AST() {}
    virtual std::string GetValue() { return "NONE"; }
    virtual llvm::Value *GenCode(Scope *scope) { return nullptr; }
};

//statements
struct Program : public AST {
    std::vector<AST*> body;
    Program(): AST() {}
    Program(const Program&) = default;
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct Function : public AST {
    Function(std::string id, std::vector<AST *> body, Type::Type *return_type, std::vector<std::tuple<std::string, Type::Type *>> params): AST(ASTType::Function), id(id), block(body), return_type(return_type), args(params) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
    std::string id;
    std::vector<AST *> block;
    Type::Type *return_type;
    std::vector<std::tuple<std::string, Type::Type *>> args;
};

struct VarDecl : public AST {
    Type::Type *data_type;
    bool cnst;
    std::string id;
    std::shared_ptr<AST*> value;
    VarDecl(std::string id, std::shared_ptr<AST*> value, bool cnst, Type::Type *data_type):
        AST(ASTType::VarDecl), data_type(data_type), cnst(cnst), id(id), value(value) {};
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct FunctionDecl : public AST {
    std::string id;
    Type::Type *return_type;
    std::vector<std::tuple<std::string, Type::Type *>> params;
    FunctionDecl(std::string id, Type::Type *return_type, std::vector<std::tuple<std::string, Type::Type *>> params): AST(ASTType::FunctionDecl), id(id), return_type(return_type), params(params) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

//expr
struct AssignmentExpr : public AST {
    std::string data_type;
    AST *id;
    AST *value;
    AssignmentExpr(AST *id, AST *value, std::string data_type): AST(ASTType::AssignmentExpr), data_type(data_type), id(id), value(value) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct MemberExpr : public AST {
    AST *obj;
    AST *property;
    MemberExpr(AST *obj, AST *property): AST(ASTType::MemberExpr), obj(obj), property(property) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct IfExpr : public AST {
    AST *cond;
    std::vector<AST*> then_branch;
    std::shared_ptr<std::vector<AST*>> else_branch;
    IfExpr(AST *cond, std::vector<AST*> then_branch, std::shared_ptr<std::vector<AST*>> else_branch):
        AST(ASTType::IfExpr), cond(cond), then_branch(then_branch), else_branch(else_branch) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct ForExpr : public AST {
    AST *variable;
    AST *iter;
    std::vector<AST *>body;
    ForExpr(AST *variable, AST *iter, std::vector<AST *> body): AST(ASTType::ForExpr), variable(variable), iter(iter), body(body) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct CallExpr : public AST {
    CallExpr(AST *caller, std::vector<AST *> args): AST(ASTType::CallExpr), caller(caller), args(args) {}
    AST *caller;
    std::vector<AST *> args;
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct AccessExpr : public AST {
    AccessExpr(AST *obj, AST *index): AST(ASTType::AccessExpr), obj(obj), index(index) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
    AST *obj;
    AST *index;
};

struct Field {
    Type::Type *data_type;
    std::string id;
    Field(std::string id, Type::Type *data_type): data_type(data_type), id(id) {}
};

struct StructDef : public AST {
    std::string id;
    std::vector<Field> fields;
    StructDef(std::string id, std::vector<Field> fields): AST(ASTType::StructDef), id(id), fields(fields) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

//literals
struct NumberLiteral : public AST {
    std::string value;
    std::string data_type;
    NumberLiteral(std::string value, std::string data_type): AST(ASTType::NumberLiteral), value(value), data_type(data_type) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct StringLiteral : public AST {
    std::string value;
    std::string data_type;
    StringLiteral(std::string value, std::string data_type): AST(ASTType::StringLiteral), value(value), data_type(data_type) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct Identifier : public AST {
    std::string value;
    std::string data_type;
    Identifier(std::string value, std::string data_type): AST(ASTType::Id), value(value), data_type(data_type) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};

struct ReturnExpr : public AST {
    ReturnExpr(AST *value): value(value) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
    AST *value;
};

struct BinaryExpr : public AST {
    AST *lhs, *rhs;
    std::string op;
    BinaryExpr(AST *lhs, AST *rhs, std::string op): AST(ASTType::BinaryExpr), lhs(lhs), rhs(rhs), op(op) {}
    virtual std::string GetValue();
    virtual llvm::Value *GenCode(Scope *scope);
};
