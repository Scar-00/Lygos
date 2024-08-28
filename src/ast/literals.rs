use crate::lexer::{Tagged, Loc};
use crate::ast::{AST, Generate, Block};
use crate::{types, types::{Type, Path}};
use crate::ast::{symbol, symbol::Symbol};

/*
 *  TODO(S):
 *  find out a better way to determine if a referece should be dereferenced
 *
 */

#[derive(Debug)]
pub struct Identifier {
    pub id: Tagged<String>,
    pub deref: bool,
}

impl Identifier {
    pub fn new(id: Tagged<String>) -> Self {
        Self{ id, deref: true }
    }
}

impl Generate for Identifier {
    fn loc(&self) -> &Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().to_string()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let var = scope.get_variable(&self.id);
        if self.deref {
            if let Type::Pointer(ptr) = &var.typ {
                if ptr.is_ref {
                    return Some(ctx.builder.create_load(&scope.resolve_type(&var.typ, ctx), &var.alloca));
                }
            }
        }
        return Some(var.alloca.clone());
    }

    fn get_type(&self, scope: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        let var = scope.get_variable(&self.id);
        if self.deref {
            if let Type::Pointer(ptr) = &var.typ {
                if ptr.is_ref {
                    return Some(*ptr.typ.clone());
                }
            }
        }
        return Some(var.typ.clone());
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct StringLiteral {
    value: Tagged<String>,
}

impl StringLiteral {
    pub fn new(value: Tagged<String>) -> Self {
        Self{ value }
    }
}

impl Generate for StringLiteral {
    fn loc(&self) -> &Loc {
        self.value.loc()
    }

    fn get_value(&self) -> String {
        self.value.inner().clone()
    }

    fn gen_code(&mut self, _scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        /*
         *  FIXME(S):
         *  add more escape cases or best case figure out how to unescape shit propely idk
         *
         */
        let unescaped_value = self.value.inner().replace("\\n", "\n");
        return Some(llvm::ConstantStruct::get(
            llvm::StructTypeRef::get(&ctx.ctx, &[ llvm::TypeRef::get_ptr(llvm::TypeRef::get_int(&ctx.ctx, 8), 0), llvm::TypeRef::get_int(&ctx.ctx, 64)], false).into(),
            &[
                ctx.builder.create_global_string_pointer(&unescaped_value),
                llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 64), unescaped_value.len() as i32)
            ]
        ));
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        return Some(Type::Path(Path::new(self.value.loc().clone(), "str".into())));
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}


#[derive(Debug)]
pub enum NumberType {
    Int,
    Char,
    Float,
    Double,
}

#[derive(Debug)]
pub struct NumberLiteral {
    value: Tagged<String>,
    typ: NumberType,
}

impl NumberLiteral {
    pub fn new(value: Tagged<String>, typ: NumberType) -> Self {
        Self{ value, typ }
    }
}

impl Generate for NumberLiteral {
    fn loc(&self) -> &Loc {
        self.value.loc()
    }

    fn get_value(&self) -> String {
        self.value.inner().clone()
    }

    fn gen_code(&mut self, _scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        return match self.typ {
            NumberType::Int => {
                let value = self.value.inner().parse::<i32>().unwrap();
                Some(llvm::ConstantInt::get(&llvm::TypeRef::get_int(&ctx.ctx, 32), value))
            },
            NumberType::Char => {
                let value = self.value.inner().clone().into_bytes()[0] as i32;
                Some(llvm::ConstantInt::get(&llvm::TypeRef::get_int(&ctx.ctx, 8), value as i32))
            },
            NumberType::Float => {
                let value = self.value.inner().parse::<f64>().unwrap();
                Some(llvm::ConstantFP::get(&llvm::FloatTypeRef::get(ctx.ctx).into(), value))
            },
            _ => {
                let value = self.value.inner().parse::<f64>().unwrap();
                Some(llvm::ConstantFP::get(&llvm::DoubleTypeRef::get(ctx.ctx).into(), value))
            },
        }
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        return match self.typ {
            NumberType::Int => Some(Type::Path(types::Path::new(Loc::new("internal".into(), 0, 1), "i32".into()))),
            NumberType::Char => Some(Type::Path(types::Path::new(Loc::new("internal".into(), 0, 1), "i8".into()))),
            NumberType::Float => Some(Type::Path(types::Path::new(Loc::new("internal".into(), 0, 1), "f32".into()))),
            _ => Some(Type::Path(types::Path::new(Loc::new("internal".into(), 0, 1), "f64".into()))),
        }
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct StaticLiteral {
    id: Tagged<String>,
    typ: Type,
    value: Option<Box<AST>>
}

impl StaticLiteral {
    pub fn new(id: Tagged<String>, typ: Type, value: Option<Box<AST>>) -> Self {
        Self{ id, typ, value }
    }
}

impl Generate for StaticLiteral {
    fn loc(&self) -> &Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().clone()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let v = self.value.as_mut().map(|v| v.gen_code(scope, ctx).unwrap());
        let glob = llvm::GlobalVariable::new(ctx.module, &scope.resolve_type(&self.typ, ctx), v.as_ref(), false);
        scope.add_symbol(self.id.inner().clone(), Symbol::Variable(symbol::Variable::new(self.id.loc().clone(), self.typ.clone(), glob.clone().into(), true)));
        return Some(glob.into());
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        return Some(self.typ.clone());
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) { /*TODO: what do i do here ??*/ }
}

#[derive(Debug)]
pub struct TypeAlias {
    id: Tagged<String>,
    typ: Type,
}

impl TypeAlias {
    pub fn new(id: Tagged<String>, typ: Type) -> Self {
        Self{ id, typ }
    }
}

impl Generate for TypeAlias {
    fn loc(&self) -> &Loc {
        self.id.loc()
    }

    fn get_value(&self) -> String {
        self.id.inner().clone()
    }

    fn gen_code(&mut self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        None
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        return Some(self.typ.clone());
    }

    fn collect_symbols(&mut self, scope: &mut super::Scope) {
        scope.add_symbol(self.id.inner().clone(), Symbol::TypeAlias(symbol::TypeAlias::new(self.id.clone(), self.typ.clone())));
    }
}


#[derive(Debug)]
pub struct BlockExpr {
    loc: Loc,
    body: Block,
    ret: Option<Type>
}

impl BlockExpr {
    pub fn new(body: Block, ret: Option<Type>) -> Self {
        Self{ loc: Loc::new("".into(), 0, 1), body, ret }
    }
}

impl Generate for BlockExpr {
    fn loc(&self) -> &Loc {
        &self.loc
    }

    fn get_value(&self) -> String {
        "".into()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        self.body.scope.set_parent(scope);
        if let Some(ret_ty) = &self.ret {
            let (tail, body) = if let Some((tail, body)) = self.body.body.split_last_mut() {
                (tail, body)
            }else {
                todo!("BlockExpr is expected to return a value but has a empty body");
            };

            for expr in body {
                expr.gen_code(&mut self.body.scope, ctx);
            }

            let mut value = tail.gen_code(&mut self.body.scope, ctx).unwrap();
            let tail_type = tail.get_type(&mut self.body.scope, ctx).unwrap();
            if tail.should_load() {
                value = value.try_load(&self.body.scope.resolve_type(&ret_ty, ctx), ctx.builder);
            }

            if !tail_type.matches(&ret_ty) {
                crate::log::error_msg_labels("invalid return type in block", &[
                    crate::log::ErrorLabel::from(&ret_ty.get_loc(), &format!("type `{}` declared here", ret_ty.get_full_name())),
                    crate::log::ErrorLabel::from(tail.loc(), &format!("but return value has type `{}`", tail_type.get_full_name())),
                ]);
            }

            let tmp = ctx.builder.create_alloca(&self.body.scope.resolve_type(&ret_ty, ctx), None);
            ctx.builder.create_store(&value, &tmp);

            return Some(tmp);
        }



        for expr in &mut self.body.body {
            expr.gen_code(&mut self.body.scope, ctx);
        }
        None
    }

    fn get_type(&self, _scope: &mut super::Scope, _ctx: &crate::GenerationContext) -> Option<Type> {
        self.ret.clone()
    }

    fn collect_symbols(&mut self, _: &mut super::Scope) {}
}

/*
#[derive(Debug)]
pub struct ClaimExpr {
    loc: Loc,
    value: Box<AST>,
}

impl ClaimExpr {
    pub fn new(loc: Loc, value: Box<AST>) -> Self {
        Self{ loc, value }
    }
}

impl Generate for ClaimExpr {
    fn loc(&self) -> &Loc {
        &self.loc
    }

    fn get_value(&self) -> String { "ret".to_owned() }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let mut value = self.value.as_mut().gen_code(scope, ctx).unwrap();
        if self.value.as_ref().should_load() {
            value = value.try_load(ctx.builder);
        }
        return Some(value);
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        return self.value.get_type(scope, ctx);
    }

    fn collect_symbols(&self, _: &mut super::Scope) {
    }
}*/
