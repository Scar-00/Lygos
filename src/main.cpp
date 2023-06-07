#include "ast/ast.h"
#include "ast/mod.h"
#include "ast/scope.h"
#include "core.h"
#include "error/log.h"
#include "cli/options.h"
#include "lex/lexer.h"
#include "parser/parser.h"
#include "types.h"
#include "util/io.h"
#include <memory>

namespace lygos {
    namespace Test {
        void test();
    }
    llvm::LLVMContext *ctx;
    llvm::Module *mod;
    llvm::IRBuilder<> *builder;
    llvm::TargetMachine *target_machine;
    Ref<AST::Mod> ast_root = nullptr;

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

    //lygos::Test::test();
    //return 0;

    auto file_content = lygos::IO::ReadFile(input_file);
    if(!file_content) {
        std::cout << "Could not read file: `" << input_file << "`" << std::endl;
        return 1;
    }

    lygos::Lexer lexer(file_content);
    lygos::Parser::Parser parser(lexer);
    auto root = parser.BuildAst();
    lygos::ast_root = std::static_pointer_cast<lygos::AST::Mod>(root);
    assert(lygos::ast_root && "ast root cannot be null");
    std::cout << "original:\n" << lygos::AST::Print(root.get()).str() << std::endl;
    root->Lower(nullptr);
    std::cout << "lowered:\n" << lygos::AST::Print(root.get()).str() << std::endl;

    auto type = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(*lygos::ctx),
        {
            llvm::Type::getInt8PtrTy(*lygos::ctx),
        },
        true
    );

    llvm::Function::Create(type, llvm::Function::LinkageTypes::ExternalLinkage, "printf", *lygos::mod);
    lygos::AST::Function func{"printf", nullptr, std::vector<lygos::AST::Function::Arg>(), std::vector<Ref<lygos::AST::AST>>(), nullptr, false};
    lygos::ast_root->AddFunction(&func);
    root->GenCode({});

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
