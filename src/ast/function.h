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
                std::vector<Ref<AST>> &Body() { return body.Body(); }
                std::string &GetName() { return name; }
                bool IsMember() { return obj.get() != nullptr && std::get<0>(args[0]) == "self"; }
                std::vector<Arg> GetArgs() { return args; }
                Ref<Type::Type> GetRetType() { return ret_type; }
            public:
                std::string GetValue() override{ return name; }
                llvm::Value *GenCode(Scope *scope) override;
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
        };
    }
}

#endif // _LYGOS_AST_FUNCTION_H_
