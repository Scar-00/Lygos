#include "ast/ast.h"
#include "core.h"
#include "error/log.h"
#include "cli/options.h"
#include "lex/lexer.h"
#include "parser/parser.h"
#include "util/io.h"

namespace lygos {
    llvm::LLVMContext *ctx;
    llvm::Module *mod;
    llvm::IRBuilder<> *builder;
    llvm::TargetMachine *target_machine;

    void init_llvm(std::string mod_name) {
        llvm::InitializeAllTargetInfos();
        llvm::InitializeAllTargets();
        llvm::InitializeAllTargetMCs();
        llvm::InitializeAllAsmPrinters();
        llvm::InitializeAllAsmParsers();
        auto target_tripple = llvm::sys::getDefaultTargetTriple();

        std::string err;
        auto target = llvm::TargetRegistry::lookupTarget(target_tripple, err);
        if(!target)
            std::cout << err << std::endl;

        auto cpu = "generic";
        auto features = "";

        llvm::TargetOptions opt;
        auto rm = llvm::Reloc::PIC_;
        target_machine = target->createTargetMachine(target_tripple, cpu, features, opt, rm);

        ctx = new llvm::LLVMContext();
        mod = new llvm::Module(mod_name.c_str(), *ctx);
        builder = new llvm::IRBuilder<>(*ctx);

        ctx->setOpaquePointers(false);

        mod->setDataLayout(target_machine->createDataLayout());
        mod->setTargetTriple(target_tripple);
    }
}

using Path = std::filesystem::path;

int main(int argc, char **argv) {
    lygos::Log::Logger::Init();
    lygos::Cli::Options cli_options(argc, argv);

    Path input_file = cli_options.InputFile().Expect("error: no input file provided");
    lygos::init_llvm(input_file.string());

    auto file_content = lygos::IO::ReadFile(input_file);
    if(file_content.size() < 1) {
        std::cout << "Could not read file: `" << input_file << "`" << std::endl;
        return 1;
    }

    lygos::Lexer lexer(file_content.c_str());
    lygos::Parser::Parser parser(lexer);
    auto root = parser.BuildAst();

    auto type = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(*lygos::ctx),
        {
            llvm::Type::getInt8PtrTy(*lygos::ctx),
        },
        true
    );

    llvm::Function::Create(type, llvm::Function::LinkageTypes::ExternalLinkage, "printf_ln", *lygos::mod);

    root->GenCode({});
    std::cout << lygos::AST::Print(root).str() << std::endl;

    llvm::verifyModule(*lygos::mod, &llvm::errs());

    Path output_file = cli_options.OutputFile().UnwrapOrDefault(input_file.replace_extension(".o").string());
    if(cli_options.EmitExe()) {
        lygos::IO::EmitExec(output_file);
    }else {
        lygos::IO::EmitObj(output_file);
    }

    if(cli_options.EmitIr()) {
        lygos::IO::EmitIr(output_file);
    }

    return 0;
}
