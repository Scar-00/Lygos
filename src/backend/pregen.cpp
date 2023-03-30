#include "pregen.h"
#include "../util.h"

namespace llc {
namespace astpasses {
    void ResolveTypes(Program *root) {
        for(u32 i = 0; i < root->body.size(); i++) {
            auto curr = root->body[i];
            switch (curr->type) {
                case ASTType::VarDecl: {
                    //static_cast<VarDecl *>(curr)->data_type;
                } break;
                default: {std::cout << root->type << "\n";} break;
            }
        }
    }

    void TypeCheck(Program *root) {

    }
}
}
