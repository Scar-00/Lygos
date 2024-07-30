use crate::ast::{AST, Generate};
use crate::types::{Type, Path};
use crate::lexer::Tagged;
use crate::log::{ErrorLabel, error_msg_label_info, error_msg_label};

#[derive(Debug)]
pub struct MemberExpr {
    obj: Box<AST>,
    pub member: Option<Box<AST>>,
    deref: bool,
    use_index: bool,
    index: usize,
}

impl MemberExpr {
    pub fn new(obj: Box<AST>, member: Box<AST>, deref: bool) -> Self {
        Self {
            obj,
            member: Some(member),
            deref,
            use_index: false,
            index: 0,
        }
    }

    pub fn new_index(obj: Box<AST>, index: usize) -> Self {
        Self {
            obj,
            member: None,
            deref: false,
            use_index: true,
            index,
        }
    }
}

impl Generate for MemberExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        self.obj.loc()
    }

    fn get_value(&self) -> String {
        self.obj.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let mut obj = self.obj.gen_code(scope, ctx).unwrap();
        let obj_ty = self.obj.get_type(scope, ctx).unwrap();
        if self.deref {
            if let Some(base) = obj_ty.get_base() {
                obj = obj.try_load(&scope.resolve_type(&base, ctx), ctx.builder);
            }
        }

        if let Type::Pointer(ptr) = &obj_ty {
            if ptr.is_ref {
                let base = &ptr.typ;
                obj = obj.try_load(&scope.resolve_type(base, ctx), ctx.builder);
            }
        }
        let type_name = obj_ty.get_name();
        let struct_fields = scope.get_struct(&Tagged::new(self.obj.loc().clone(), type_name.clone()));
        let index = if !self.use_index {
            let mut index_internal = None;
            let member_name = self.member.as_ref().unwrap().get_value();
            for (i, field) in struct_fields.fields.iter().enumerate() {
                if field.id.inner().clone() == member_name {
                    index_internal = Some(i);
                }
            }

            if index_internal.is_none() {
                let mut fields_avail = "available fieds: [".to_string();
                for (i, field) in struct_fields.fields.iter().enumerate() {
                    fields_avail += &("`".to_string() + field.id.inner() + "`");
                    if i + 1 != struct_fields.fields.len() {
                        fields_avail += ", ";
                    }
                }
                fields_avail += "]";
                error_msg_label_info(
                    format!("unknown field `{}` in type `{}`", member_name, type_name).as_str(),
                    ErrorLabel::from(self.member.as_ref().unwrap().loc(), "unknown field"),
                    &fields_avail
                );
            }
            index_internal.unwrap()
        }else {
            self.index
        };

        if let Some(mem) = &self.member {
            if let AST::Id(_) = **mem {} else {
                if !self.use_index {
                    self.member.as_mut().unwrap().gen_code(scope, ctx);
                }
            }
        }

        if !obj.get_type().is_pointer_ty() {
            let alloc = ctx.builder.create_alloca(&obj.get_type(), None);
            ctx.builder.create_store(&obj, &alloc);
            obj = alloc;
        }

        let base: Option<Type> = if self.deref {
            let tmp = self.obj.get_type(scope, ctx).unwrap();
            tmp.get_base().cloned()
        }else if let Type::Pointer(ptr) = &obj_ty {
            if ptr.is_ref {
                Some(*ptr.typ.clone())
            }else {
                Some(obj_ty)
            }
        }else {
            Some(obj_ty)
        };
        if let Some(ty) = base {
            if ty.get_base().is_some() {
                /*
                *  FIXME(S): provide a better error & help message this does not cut it XD
                *
                */
                error_msg_label_info(
                    "invalid level of indirection",
                    ErrorLabel::from(self.loc(), &format!("cannot access member of type `{}`", self.obj.get_type(scope, ctx).unwrap().get_full_name())),
                    "try dereferencing using `->` instead of `.`"
                );
            }
            return Some(ctx.builder.create_struct_gep(&scope.resolve_type(&ty, ctx), &obj, index as u32));
        }

        error_msg_label(
            "cannot deref value type",
            ErrorLabel::from(self.loc(), format!("cannot deref value type `{}`", self.obj.get_type(scope, ctx).unwrap().get_full_name()).as_str())
        );
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<crate::types::Type> {
        let obj_ty = self.obj.get_type(scope, ctx).unwrap();
        let struct_fields = &scope.get_struct(&Tagged::new(self.obj.loc().clone(), obj_ty.get_name())).fields;
        let index = if !self.use_index {
            let mut index_internal = None;
            let member_name = self.member.as_ref().unwrap().get_value();
            for (i, field) in struct_fields.iter().enumerate() {
                if field.id.inner().clone() == member_name {
                    index_internal = Some(i);
                }
            }

            if index_internal.is_none() {
                let mut fields_avail = "available fieds: [".to_string();
                for (i, field) in struct_fields.iter().enumerate() {
                    fields_avail += &("`".to_string() + field.id.inner() + "`");
                    if i + 1 != struct_fields.len() {
                        fields_avail += ", ";
                    }
                }
                fields_avail += "]";
                error_msg_label_info(
                    format!("unknown field `{}` in type `{}`", member_name, obj_ty.get_name()).as_str(),
                    ErrorLabel::from(self.member.as_ref().unwrap().loc(), "unknown field"),
                    &fields_avail
                );
            }
            index_internal.unwrap()
        }else {
            self.index
        };
        return Some(struct_fields[index].typ.clone());
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct AccessExpr {
    obj: Box<AST>,
    index: Box<AST>,
}

impl AccessExpr {
    pub fn new(obj: Box<AST>, index: Box<AST>) -> Self {
        Self{ obj, index }
    }
}

impl Generate for AccessExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        self.obj.loc()
    }

    fn get_value(&self) -> String {
        self.obj.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let mut obj = self.obj.gen_code(scope, ctx).unwrap();
        /*if !crate::types::is_array_type(&obj.get_type()) {
            obj = obj.try_load(ctx.builder);
        }*/
        /*if let Type::Array(arr) = self.obj.get_type(scope, ctx).unwrap() {
            obj = obj.try_load(&scope.resolve_type(&arr.typ, ctx), ctx.builder);
        }*/

        let mut index = self.index.gen_code(scope, ctx).unwrap();
        if self.index.should_load() {
            let base = self.index.get_type(scope, ctx).unwrap();
            index = index.try_load(&scope.resolve_type(&base, ctx), ctx.builder);
        }

        let zero = llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 64), 0);

        let mut idx_list = vec![index];
        if let Type::Array(_) = self.obj.get_type(scope, ctx).unwrap() {
            idx_list.insert(0, zero);
        }

        //if let Some(ty) = self.obj.get_type(scope, ctx).unwrap().get_base() {
        let base = self.obj.get_type(scope, ctx).unwrap();
        return Some(ctx.builder.create_gep(&scope.resolve_type(&base, ctx), &obj, &idx_list, true));
        //}

        //error_msg_label(
        //    "cannot deref value type",
        //    ErrorLabel::from(self.loc(), format!("cannot deref value type `{}`", self.obj.get_type(scope, ctx).unwrap().get_full_name()).as_str())
        //);
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<crate::types::Type> {
        match self.obj.get_type(scope, ctx).unwrap() {
            Type::Array(arr) => return Some(*arr.typ),
            Type::Pointer(ptr) => return Some(*ptr.typ),
            ty => return Some(ty),
        }
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct ResolutionExpr {
    obj: Box<AST>,
    member: Box<AST>,
}

impl ResolutionExpr {
    pub fn new(obj: Box<AST>, member: Box<AST>) -> Self {
        Self{ obj, member }
    }
}

impl Generate for ResolutionExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        self.obj.loc()
    }

    fn get_value(&self) -> String {
        self.obj.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let member_value = self.member.get_value();
        let tagged = Tagged::new(self.obj.loc().clone(), self.obj.get_value());
        if scope.is_enum(&tagged) {
            let ev = scope.get_enum(&tagged);
            for (i, var) in ev.variants.iter().enumerate() {
                if *var == member_value {
                    return Some(llvm::ConstantInt::get(&scope.resolve_type(&ev.typ, ctx), i as i32));
                }
            }
            error_msg_label(
                format!("unknown enum variant `{}` in enum `{}`", member_value, tagged.inner()).as_str(),
                ErrorLabel::from(self.member.loc(), "unknown enum variant"),
            );
        }

        if let AST::CallExpr(call) = &mut *self.member {
            return call.gen_code_internal(scope, ctx, Some((&self.obj, true)), None);
        }

        //provide an actual error essage
        error_msg_label(
            format!("resolution expr err").as_str(),
            ErrorLabel::from(self.member.loc(), "unknown resolution expr"),
        );
    }

    fn get_type(&self, scope: &mut super::Scope, _: &crate::GenerationContext) -> Option<crate::types::Type> {
        let tagged = Tagged::new(self.obj.loc().clone(), self.obj.get_value());
        if scope.is_enum(&tagged) {
            return Some(Type::Path(Path::new(self.obj.loc().clone(), self.obj.get_value())));
        }
        let strct = scope.get_struct(&tagged);
        let func = strct.get_function(self.member.loc(), self.member.get_value());
        return Some(func.ret_type.clone());
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}
