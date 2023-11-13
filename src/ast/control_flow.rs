use crate::ast::{AST, Block, Generate};
use crate::log::{error_msg, error_msg_label, ErrorLabel};
use crate::types::containers;
use crate::lexer::Loc;

/*
 *  TODO(S):
 *  type check the control flow of the program
 *  -> does function return in all valid paths?
 *  -> ignore unreachable parts of the program
 *
 */


#[derive(Debug)]
pub struct IfStmt {
    cond: Box<AST>,
    then_body: Block,
    else_body: Option<Block>,
}

impl IfStmt {
    pub fn new(cond: Box<AST>, then_body: Block, else_body: Option<Block>) -> Self {
        Self{ cond, then_body, else_body }
    }
}

impl Generate for IfStmt {
    fn loc(&self) -> &crate::lexer::Loc {
        error_msg("unreachable", "unreachable");
    }

    fn get_value(&self) -> String {
        error_msg("unreachable", "unreachable");
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let func = ctx.builder.get_insert_block().get_parent();

        if (self.then_body.returns || (self.else_body.is_some() && self.else_body.as_ref().unwrap().returns)) && unsafe{(*ctx.current_function).ret_block.is_none()} {
            unsafe{(*ctx.current_function).ret_block = Some(llvm::BasicBlock::new(ctx.ctx, "ret", Some(&func), None))};
        }

        let true_block = llvm::BasicBlock::new(ctx.ctx, "t", Some(&func), None);
        let false_block = llvm::BasicBlock::new(ctx.ctx, "f", Some(&func), None);
        let merge_block = llvm::BasicBlock::new(ctx.ctx, "m", Some(&func), None);

        let mut cond = self.cond.gen_code(scope, ctx).unwrap();
        if self.cond.should_load() {
            cond = cond.try_load(ctx.builder);
        }

        ctx.builder.create_cond_br(&cond, &true_block, if self.else_body.is_some() {
            &false_block
        }else {
            &merge_block
        });

        ctx.builder.set_insert_point(&true_block);
        self.then_body.scope.set_parent(scope);
        for expr in &mut self.then_body.body {
            expr.gen_code(&mut self.then_body.scope, ctx);
        }

        if true_block.get_terminator().is_none() || ctx.builder.get_insert_block().get_terminator().is_none() {
            ctx.builder.create_br(&merge_block);
        }

        if let Some(body) = &mut self.else_body {
            ctx.builder.set_insert_point(&false_block);
            body.scope.set_parent(scope);
            for expr in &mut body.body {
                expr.gen_code(&mut body.scope, ctx);
            }

            if false_block.get_terminator().is_none() || ctx.builder.get_insert_block().get_terminator().is_none() {
                ctx.builder.create_br(&merge_block);
            }
        }else {
            false_block.remove_from_parent();
        }

        if merge_block.has_n_uses(0) {
            merge_block.remove_from_parent();
        }else {
            ctx.builder.set_insert_point(&merge_block);
        }

        None
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<crate::types::Type> {
        None
    }

    fn collect_symbols(&self, _scope: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct ForStmt {
    cond: Box<AST>,
    var: Box<AST>,
    body: Block,
}

impl ForStmt {
    pub fn new(cond: Box<AST>, var: Box<AST>, body: Block) -> Self {
        Self{ cond, var, body }
    }
}

impl Generate for ForStmt {
    fn loc(&self) -> &crate::lexer::Loc {
        error_msg("unreachable", "unreachable");
    }

    fn get_value(&self) -> String {
        error_msg("unreachable", "unreachable");
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let func = ctx.builder.get_insert_block().get_parent();

        let cond_block = llvm::BasicBlock::new(ctx.ctx, "", Some(&func), None);
        let body_block = llvm::BasicBlock::new(ctx.ctx, "", Some(&func), None);
        let mut merge_block = llvm::BasicBlock::new(ctx.ctx, "", Some(&func), None);

        self.body.scope.set_parent(scope);
        self.var.gen_code(&mut self.body.scope, ctx);
        ctx.builder.create_br(&cond_block);

        ctx.builder.set_insert_point(&cond_block);

        let mut cond = self.cond.gen_code(&mut self.body.scope, ctx).unwrap();
        if self.cond.should_load() {
            cond = cond.try_load(ctx.builder);
        }

        ctx.builder.create_cond_br(&cond, &body_block, &merge_block);

        ctx.builder.set_insert_point(&body_block);
        unsafe{ containers::to_mut(ctx).current_break_point.push(&mut merge_block as *mut llvm::BasicBlock) };
        for expr in &mut self.body.body {
            expr.gen_code(&mut self.body.scope, ctx);
        }
        unsafe{ containers::to_mut(ctx).current_break_point.pop() };

        ctx.builder.create_br(&cond_block);

        ctx.builder.set_insert_point(&merge_block);
        return None;
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<crate::types::Type> {
        None
    }

    fn collect_symbols(&self, _scope: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct BreakExpr {
    loc: Loc,
}

impl BreakExpr {
    pub fn new(loc: Loc) -> Self {
        Self{ loc }
    }
}

impl Generate for BreakExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        &self.loc
    }

    fn get_value(&self) -> String {
        error_msg("unreachable", "unreachable");
    }

    fn gen_code(&mut self, _: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        if let Some(bb) = ctx.current_break_point.last() {
            ctx.builder.create_br(unsafe{bb.as_ref().unwrap()});
        }else {
            error_msg_label(
                format!("invalid break point").as_str(),
                ErrorLabel::from(&self.loc, "invalid break point"),
            );
        }

        return None;
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<crate::types::Type> {
        None
    }

    fn collect_symbols(&self, _scope: &mut super::Scope) {}
}
