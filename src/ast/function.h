#ifndef _LYGOS_AST_FUNCTION_H_
#define _LYGOS_AST_FUNCTION_H_

#include "ast.h"
#include <bits/utility.h>
#include <vector>

namespace lygos {
    namespace AST {
        struct Impl;
        struct Function : public AST {
            using Arg = std::tuple<std::string, Ref<Type::Type>>;
            public:
                Function(std::string name, Ref<Impl> obj, std::vector<Arg> args, Block body, Ref<Type::Type> ret_type, bool is_def);
                Block &Body() { return body; }
                std::string &GetName();
                bool IsMember();
                std::vector<Arg> GetArgs() { return args; }
                Ref<Type::Type> GetRetType() { return ret_type; }
                void SetRetBlock(llvm::BasicBlock *block);
                llvm::BasicBlock * GetRetBlock() { return return_block; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                std::string mangeled_name;
                Ref<Impl> obj;
                std::vector<Arg> args;
                Block body;
                Ref<Type::Type> ret_type;
                bool is_definition;
                bool is_var_arg = false;
                llvm::BasicBlock *return_block = nullptr;
        };

        struct Closure : public AST {
        };
    }
}

#endif // _LYGOS_AST_FUNCTION_H_
