#include "backend/ast.h"
#include "backend/scope.h"
#include "global.h"
#include "./backend/lexer.h"
#include "./backend/parser.h"
#include "types.h"
#include "util.h"
#include "llvm/ADT/Optional.h"
#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/OptimizationLevel.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"

#include <cstddef>
#include <cstdlib>
#include <llvm/IR/PassManager.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Bitstream/BitstreamWriter.h>
#include <llvm/IR/Mangler.h>
#include <math.h>
#include <sstream>
#include <unordered_map>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/LegacyPassManagers.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Target/TargetMachine.h>
#include <llvm/MC/TargetRegistry.h>

std::shared_ptr<llvm::LLVMContext> ctx;
std::shared_ptr<llvm::Module> mod;
std::shared_ptr<llvm::IRBuilder<>> builder;

void llvm_init() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargets();
    llvm::InitializeAllTargetMCs();
    llvm::InitializeAllAsmPrinters();
    llvm::InitializeAllAsmParsers();
    auto target_tripple = llvm::sys::getDefaultTargetTriple();

    std::string err;
    auto target = llvm::TargetRegistry::lookupTarget(target_tripple, err);
    if(!target)
        error("%s", err.c_str());

    auto cpu = "generic";
    auto features = "";

    llvm::TargetOptions opt;
    auto rm = llvm::Optional<llvm::Reloc::Model>();
    auto target_machine = target->createTargetMachine(target_tripple, cpu, features, opt, rm);

    ctx = std::make_shared<llvm::LLVMContext>();
    mod = std::make_shared<llvm::Module>("test_mod", *ctx);
    builder = std::make_shared<llvm::IRBuilder<>>(*ctx);

    ctx->setOpaquePointers(false);

    mod->setDataLayout(target_machine->createDataLayout());
    mod->setTargetTriple(target_tripple);
}

int main() {
    llvm_init();

    std::ifstream istream;
    istream.open("test.txt");
    istream.seekg(0, std::ios::end);
    size_t length = istream.tellg();
    istream.seekg(0, std::ios::beg);
    std::string buffer(length, ' ');
    istream.read(&buffer[0], length);

    std::cout << buffer << "\n";

    Lexer lexer{buffer.c_str()};
    Parser parser{lexer};
    auto ast = parser.BuildAst();

    auto type = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(*ctx),
        {
            llvm::Type::getInt8PtrTy(*ctx),
        },
        true
    );

    llvm::Function::Create(type, llvm::Function::LinkageTypes::ExternalLinkage, "printf", *mod);

    ast->GenCode({});

    llvm::legacy::PassManager pass_manager;

    pass_manager.add(llvm::createPromoteMemoryToRegisterPass());
    pass_manager.add(llvm::createReassociatePass());
    pass_manager.add(llvm::createNewGVNPass());
    pass_manager.add(llvm::createCFGSimplificationPass());

    pass_manager.run(*mod);

    llvm::verifyModule(*mod, &llvm::errs());

    std::error_code e;
    llvm::raw_fd_ostream os{"tmp/main.ll", e};
    mod->print(os, nullptr);
    os.flush();

    std::system("clang -o tmp/main tmp/main.ll -mllvm -opaque-pointers std/libstd.a -lc");


    /*
    std::string mod_ir;
    llvm::raw_string_ostream ir_stream{mod_ir};
    mod->print(ir_stream, nullptr);
    ir_stream.flush();
    */
    PrintLog();
    return 0;
}














/*
 * //Reference
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <memory>
#include <fstream>
#include <iostream>
#include <ostream>
#include <system_error>

int main(void) {
    std::shared_ptr<llvm::LLVMContext> context = std::make_shared<llvm::LLVMContext>();
    auto mod = std::make_shared<llvm::Module>("my_mod", *context);

    llvm::FunctionType *main_type = llvm::FunctionType::get(
        llvm::Type::getVoidTy(*context),
        {
            //llvm::Type::getVoidTy(*context),
        },
        false
    );

    llvm::Function *main = llvm::Function::Create(main_type, llvm::Function::ExternalLinkage, "main", *mod);
    llvm::BasicBlock *main_bb = llvm::BasicBlock::Create(*context, "", main);
    llvm::IRBuilder<> main_builder{main_bb};
    main_builder.CreateRetVoid();

    llvm::verifyFunction(*main);

    llvm::FunctionType *fttype = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(*context),
        {
            llvm::Type::getInt32Ty(*context),
            llvm::Type::getInt32Ty(*context),
        },
        false
    );

    llvm::Function *func = llvm::Function::Create(fttype, llvm::Function::ExternalLinkage, "add", *mod);
    llvm::Function::arg_iterator args = func->arg_begin();
    llvm::Value *arg1 = &*args++;
    llvm::Value *arg2 = &*args++;

    llvm::BasicBlock *bb = llvm::BasicBlock::Create(*context, "", func);

    llvm::IRBuilder<> builder{bb};

    llvm::Value *sum = builder.CreateAdd(arg1, arg2);
    builder.CreateRet(sum);

    llvm::verifyFunction(*func);

    std::error_code ec;
    llvm::raw_fd_ostream os{"main.ll", ec};

    mod->print(os, nullptr);
    os.flush();

    return 0;
}
*/
