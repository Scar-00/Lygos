#ifndef _LYGOS_AST_TRAIT_H_
#define _LYGOS_AST_TRAIT_H_

#include "function.h"

namespace lygos {
    namespace AST {
        namespace Trait {
            struct Trait : public AST {
                public:
                    Trait(std::string name, std::vector<Ref<Function>> functions);
                    std::vector<Ref<Function>> &Functions() { return functions; }
                public:

                private:
                    std::string name;
                    std::vector<Ref<Function>> functions;
            };
        }
    }
}

#endif // _LYGOS_AST_TRAIT_H_
