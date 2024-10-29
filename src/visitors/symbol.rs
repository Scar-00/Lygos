use crate::ast::*;

pub struct SymbolCollector;

impl ASTVisitor for SymbolCollector {
    type Output = ();

    fn visit_function(&mut self, node: &Function) -> Self::Output {
        todo!()
    }

    fn visit_assignmentexpr(&mut self, node: &AssignmentExpr) -> Self::Output {
        todo!()
    }

    fn visit_memberexpr(&mut self,node: &MemberExpr) -> Self::Output {
        todo!()
    }

    fn visit_callexpr(&mut self,node: &CallExpr) -> Self::Output {
        todo!()
    }

    fn visit_membercallexpr(&mut self,node: &MemberCallExpr) -> Self::Output {
        todo!()
    }

    fn visit_accessexpr(&mut self,node: &AccessExpr) -> Self::Output {
        todo!()
    }

    fn visit_unaryexpr(&mut self,node: &UnaryExpr) -> Self::Output {
        todo!()
    }

    fn visit_resolutionexpr(&mut self,node: &ResolutionExpr) -> Self::Output {
        todo!()
    }

    fn visit_castexpr(&mut self,node: &CastExpr) -> Self::Output {
        todo!()
    }

    fn visit_returnexpr(&mut self,node: &ReturnExpr) -> Self::Output {
        todo!()
    }

    fn visit_binaryexpr(&mut self,node: &BinaryExpr) -> Self::Output {
        todo!()
    }

    fn visit_breakexpr(&mut self,node: &BreakExpr) -> Self::Output {
        todo!()
    }

    fn visit_closureexpr(&mut self,node: &ClosureExpr) -> Self::Output {
        todo!()
    }

    fn visit_structdef(&mut self,node: &StructDef) -> Self::Output {
        todo!()
    }

    fn visit_macrocall(&mut self,node: &MacroCall) -> Self::Output {
        todo!()
    }

    fn visit_typealias(&mut self,node: &TypeAlias) -> Self::Output {
        todo!()
    }

    fn visit_numberliteral(&mut self,node: &NumberLiteral) -> Self::Output {
        todo!()
    }

    fn visit_stringliteral(&mut self,node: &StringLiteral) -> Self::Output {
        todo!()
    }

    fn visit_initializerlist(&mut self,node: &InitializerListExpr) -> Self::Output {
        todo!()
    }

    fn visit_staticliteral(&mut self,node: &StaticLiteral) -> Self::Output {
        todo!()
    }

    fn visit_mod(&mut self, node: &Mod) -> Self::Output {
        println!("{node:#?}");
        todo!()
    }

    fn visit_vardecl(&mut self,node: &VarDecl) -> Self::Output {
        todo!()
    }

    fn visit_ifstmt(&mut self,node: &IfStmt) -> Self::Output {
        todo!()
    }

    fn visit_forstmt(&mut self,node: &ForStmt) -> Self::Output {
        todo!()
    }

    fn visit_enumdef(&mut self,node: &EnumDef) -> Self::Output {
        todo!()
    }

    fn visit_impl(&mut self,node: &Impl) -> Self::Output {
        todo!()
    }

    fn visit_trait(&mut self,node: &Trait) -> Self::Output {
        todo!()
    }

    fn visit_macro(&mut self,node: &Macro) -> Self::Output {
        todo!()
    }

    fn visit_id(&mut self,node: &Identifier) -> Self::Output {
        todo!()
    }
}
