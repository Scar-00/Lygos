#ifndef _LYGOS_CORE_H_
#define _LYGOS_CORE_H_

//lygos headers
#include "containers.h"
#include "types.h"
#include "error/error.h"
#include "error/log.h"
#include "util/io.h"

//llvm headers
#include "llvm.h"

//cpp core
#include <fmt/core.h>
#include <memory>
#include <fstream>
#include <iostream>
#include <ostream>
#include <sstream>
#include <filesystem>
#define FMT_HEADER_ONLY
#include <fmt/format.h>

namespace lygos {
    extern llvm::LLVMContext *ctx;
    extern llvm::Module *mod;
    extern llvm::IRBuilder<> *builder;
    extern llvm::TargetMachine *target_machine;

    template<typename T>
    using Ref = std::shared_ptr<T>;

    template<typename T, class ..._Types>
    Ref<T> MakeRef(_Types... args) {
        return std::make_shared<T>(args...);
    }

    template<typename T>
    using Weak = std::weak_ptr<T>;

    namespace AST {
        struct Mod;
    }
    extern Ref<AST::Mod> ast_root;
}

#ifdef LYGOS_DEBUG
#define LYGOS_ASSERT assert
#else
#define LYGOS_ASSERT
#endif

#endif // _LYGOS_CORE_H_
