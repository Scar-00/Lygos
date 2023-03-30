#pragma once

#include "ast.h"

namespace llc {
    namespace astpasses {
        void ResolveTypes(Program *root);
        void TypeCheck(Program *root);
    }
}
