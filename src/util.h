#pragma once
#include "types.h"
#include <llvm/Support/raw_os_ostream.h>

void error(const char *format, ...);
llvm::raw_string_ostream &Log();
void PrintLog();

void print_type(llvm::Type *type);

llvm::Type *resolve_type(std::string &type);

/*! @brief
 *  Checks if the llvm::Type* is a pointer. If it is a pointer it
 *  returns the contained type, otherwise it just returns the type
 *
 *  @param[in] type The type you want to try and convert.
 *  @return the contained type or itself
 */
llvm::Type *TryGetPointerBase(llvm::Type *type);

/*! @brief
 *  Checks if the llvm::Type* is a pointer. If it is a pointer it
 *  returns the contained type, otherwise it just returns the type
 *
 *  @param[in] value The type you want to try and convert.
 *  @return the contained type or itself
 */
llvm::Value *LoadOrIgnore(llvm::Value *value);
