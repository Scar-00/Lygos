#include "ast/ast.h"
#include "ast/assignment.h"
#include "ast/call.h"
#include "ast/mod.h"
#include "containers.h"
#include <memory>
#include <vector>

namespace lygos {
    namespace Test {
        void test() {
            auto root = std::make_shared<AST::Mod>();
            root->Body().push_back(std::make_shared<AST::AssignmentExpr>(nullptr, nullptr));
            root->Body().push_back(std::make_shared<AST::AssignmentExpr>(nullptr, nullptr));

            std::vector<Ref<AST::AST>> vec;
            vec.push_back(std::make_shared<AST::CallExpr>(nullptr, std::vector<Ref<AST::AST>>()));

            std::cout << AST::Print(root.get()).str() << std::endl;
            VecInsertAt(root->Body(), 1, vec);
            std::cout << AST::Print(root.get()).str() << std::endl;
        }
    }
}
