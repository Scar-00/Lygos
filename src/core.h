#ifndef _LYGOS_CORE_H_
#define _LYGOS_CORE_H_

//lygos headers
#include "containers.h"
#include "types.h"
#include "error/error.h"
#include "util/io.h"

//llvm headers
#include "llvm.h"

//cpp core
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
}

#endif // _LYGOS_CORE_H_
