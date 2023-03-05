#include "util.h"
#include "backend/ast.h"
#include "backend/scope.h"
#include "global.h"
#include "types.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TypeSize.h"
#include "llvm/Support/raw_os_ostream.h"
#include "llvm/Support/raw_ostream.h"

#include <cstddef>
#include <cstdlib>
#include <cwchar>
#include <memory>
#include <ostream>
#include <sstream>
#include <stdarg.h>
#include <stdio.h>
#include <iostream>
#include <string_view>
#include <system_error>

static std::shared_ptr<llvm::raw_string_ostream> err_os;

void error(const char *format, ...) {
    va_list args;
    va_start(args, format);
    vfprintf(stdout, format, args);
    va_end(args);
    std::cout << std::endl;
    PrintLog();
    std::exit(1);
}

void print_type(llvm::Type *type) {
    std::string type_string;
    llvm::raw_string_ostream ros(type_string);
    type->print(ros);
    std::cout << "Type -> " << ros.str() << std::endl;
}

llvm::Type *resolve_type(std::string &type) {
    if(type == "i8" || type == "u8") return llvm::Type::getInt8Ty(*ctx);
    if(type == "i16" || type == "u16") return llvm::Type::getInt16Ty(*ctx);
    if(type == "i32" || type == "u32") return llvm::Type::getInt32Ty(*ctx);
    if(type == "i64" || type == "u64") return llvm::Type::getInt64Ty(*ctx);
    if(type == "f32") return llvm::Type::getFloatTy(*ctx);
    if(type == "f64") return llvm::Type::getDoubleTy(*ctx);
    if(type == "void") return llvm::Type::getVoidTy(*ctx);
    error("Unknown type '%s'", type.c_str());
    std::exit(1);
}

llvm::raw_string_ostream &Log() {
    std::error_code e;
    if(!err_os) {
        static std::string str{};
        err_os = std::make_shared<llvm::raw_string_ostream>(str);
    }
    return *err_os;
}

void PrintLog() {
    if(err_os != NULL)
        std::cout << err_os->str() << std::endl;
}

llvm::Type *TryGetPointerBase(llvm::Type *type) {
    if(type->isPointerTy()) {
        return static_cast<llvm::PointerType *>(type)->getContainedType(0);
    }
    return type;
}

llvm::Value *LoadOrIgnore(llvm::Value *value) {
    if(value->getType()->isPointerTy()) {
        return builder->CreateLoad(TryGetPointerBase(value->getType()), value);
    }
    return value;
}

bool ShouldLoad(AST *ast) {
    return ast->type == ASTType::Id
        || ast->type == ASTType::MemberExpr
        || ast->type == ASTType::AccessExpr;
}
