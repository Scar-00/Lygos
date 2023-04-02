#include "cli/options.h"
#include "core.h"

namespace lygos {
    llvm::LLVMContext *ctx;
    llvm::Module *mod;
    llvm::IRBuilder<> *builder;

    void init_llvm(std::string &mod_name) {
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
        auto rm = llvm::Optional<llvm::Reloc::Model>();
        auto target_machine = target->createTargetMachine(target_tripple, cpu, features, opt, rm);

        ctx = new llvm::LLVMContext();
        mod = new llvm::Module(mod_name.c_str(), *ctx);
        builder = new llvm::IRBuilder<>(*ctx);

        ctx->setOpaquePointers(false);

        mod->setDataLayout(target_machine->createDataLayout());
        mod->setTargetTriple(target_tripple);
    }
}

int main(int argc, char **argv) {
    lygos::Cli::Options cli_options(argc, argv);

    std::string input_file = cli_options.InputFile().Expect("error: no input file provided");
    lygos::init_llvm(input_file);


    std::string output_file = cli_options.OutputFile().UnwrapOrDefault("out.ll");

    return 0;
}
