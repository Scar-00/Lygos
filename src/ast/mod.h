#ifndef _LYGOS_AST_MOD_H_
#define _LYGOS_AST_MOD_H_

#include "ast.h"

namespace lygos {
    namespace AST {
        struct Program : public AST {
            std::vector<AST*> body;
            Program(): AST() {}
            Program(const Program&) = default;
            virtual std::string GetValue();
            virtual llvm::Value *GenCode(Scope *scope);
        };
    }
}

#endif // _LYGOS_AST_MOD_H_
