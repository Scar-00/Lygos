#ifndef _LYGOS_INITIALIZER_H_
#define _LYGOS_INITIALIZER_H_

#include "ast.h"
#include <tuple>
#include <vector>

namespace lygos {
    namespace AST {
        struct InitializerList : public AST {
            using Initializers = std::vector<std::tuple<std::string, Ref<AST>>>;
            enum class Kind {
                Named,
                Anonymus,
            }kind;
            public:
                InitializerList(Initializers initializers, InitializerList::Kind kind);
                Initializers &GetInitalizers() { return initializers; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower() override;
                void Sanatize() override;
            private:
                Initializers initializers;
        };
    }
}

#endif // _LYGOS_INITIALIZER_H_
