#ifndef _LYGOS_AST_GENERIC_H_
#define _LYGOS_AST_GENERIC_H_

#include "../core.h"

#include <string>

namespace lygos {
    struct Generic {
        std::string name;
        Type::Type *type;
    };
}

#endif // _LYGOS_AST_GENERIC_H_
