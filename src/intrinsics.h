#ifndef _LYGOS_INTRINSICS_H_
#define _LYGOS_INTRINSICS_H_

namespace lygos {
    namespace AST {
        struct MacroCall;
    }
    namespace Intrinsics {
        void macro_format_intrinsic(AST::MacroCall *macro);
    }
}

#endif // _LYGOS_INTRINSICS_H_
