use lazy_static::lazy_static;
use std::collections::HashMap;
use crate::Loc;

#[derive(Debug, PartialEq, Clone)]
pub enum TokenType {
    //types
    String,
    Integer, //any integer
    Float,   //every float is trated as double pres
    Id,
    Char,

    //general
    Equals,
    Arrow,
    Dot,
    Comma,
    Semi,
    Colon,
    Ampercent,
    Hash,
    Dollar,
    Pipe,
    Bang,

    //operators
    OpPlus,
    OpMinus,
    OpMul,
    OpDiv,
    OpMod,

    OpEqEq,
    OpNeEq,
    OpLeEq,
    OpGrEq,
    OpOr,
    OpAnd,

    OpScope,
    OpVarArg,

    BraceLeft,
    BraceRight,
    CurlyLeft,
    CurlyRight,
    AngleLeft,
    AngleRight,
    ParanLeft,
    ParanRight,

    //keywords
    KwLet,
    KwMut,
    KwConst,
    KwStruct,
    KwIf,
    KwElse,
    KwFor,
    KwWhile,
    KwFn,
    KwRet,
    KwIn,
    KwInclude,
    KwImpl,
    KwType,
    KwStatic,
    KwMatch,
    KwTrait,
    KwMacro,
    KwEnum,
    KwBreak,
    KwContinue,
    //KwClaim,

    Eof,
}

lazy_static! {
    pub static ref KeyWords: HashMap<&'static str, TokenType> = {
        let mut map = HashMap::new();
        map.insert("let", TokenType::KwLet);
        map.insert("mut", TokenType::KwMut);
        map.insert("const", TokenType::KwConst);
        map.insert("struct", TokenType::KwStruct);
        map.insert("if", TokenType::KwIf);
        map.insert("else", TokenType::KwElse);
        map.insert("for", TokenType::KwFor);
        map.insert("while", TokenType::KwWhile);
        map.insert("fn", TokenType::KwFn);
        map.insert("return", TokenType::KwRet);
        map.insert("in", TokenType::KwIn);
        map.insert("include", TokenType::KwInclude);
        map.insert("impl", TokenType::KwImpl);
        map.insert("type", TokenType::KwType);
        map.insert("static", TokenType::KwStatic);
        map.insert("match", TokenType::KwMatch);
        map.insert("trait", TokenType::KwTrait);
        map.insert("macro", TokenType::KwMacro);
        map.insert("enum", TokenType::KwEnum);
        map.insert("break", TokenType::KwBreak);
        map.insert("continue", TokenType::KwContinue);
        //map.insert("claim", TokenType::KwClaim);

        map
    };
}

lazy_static! {
    pub static ref BaseTypes: Vec<&'static str> = {
        let mut vec = Vec::new();
        vec.push("i8");
        vec.push("i16");
        vec.push("i32");
        vec.push("i64");

        vec.push("u8");
        vec.push("u16");
        vec.push("u32");
        vec.push("u64");

        vec.push("f32");
        vec.push("f64");

        vec.push("bool");

        vec.push("str");

        vec.push("void");

        vec
    };
}

pub fn base_to_type<'s>(ty: &'s str, ctx: &crate::GenerationContext) -> Option<llvm::TypeRef> {
    if !BaseTypes.contains(&ty) {
        return None;
    }

    return match ty {
        "i8" => Some(llvm::TypeRef::get_int(&ctx.ctx, 8)),
        "i16" => Some(llvm::TypeRef::get_int(&ctx.ctx, 16)),
        "i32" => Some(llvm::TypeRef::get_int(&ctx.ctx, 32)),
        "i64" => Some(llvm::TypeRef::get_int(&ctx.ctx, 64)),

        "u8" => Some(llvm::TypeRef::get_int(&ctx.ctx, 8)),
        "u16" => Some(llvm::TypeRef::get_int(&ctx.ctx, 16)),
        "u32" => Some(llvm::TypeRef::get_int(&ctx.ctx, 32)),
        "u64" => Some(llvm::TypeRef::get_int(&ctx.ctx, 64)),

        "f32" => Some(llvm::FloatTypeRef::get(&ctx.ctx).into()),
        "f64" => Some(llvm::DoubleTypeRef::get(&ctx.ctx).into()),

        "bool" => Some(llvm::TypeRef::get_int(&ctx.ctx, 1)),
        "str" => {
            Some(llvm::StructTypeRef::get(&ctx.ctx,
                        &[
                            llvm::TypeRef::get_ptr(llvm::TypeRef::get_int(&ctx.ctx, 8), 0),
                            llvm::TypeRef::get_int(&ctx.ctx, 64)
                        ],
                        false).into())
        },

        "void" => Some(llvm::TypeRef::get_void(&ctx.ctx)),

        _ => None,
    }
}

#[derive(Debug, Clone)]
pub struct Path {
    pub loc: Loc,
    pub path: String,
}

impl Path {
    pub fn new(loc: Loc, path: String) -> Path {
        Self{ loc, path }
    }
}

#[derive(Debug, Clone)]
pub struct Pointer {
    pub loc: Loc,
    pub typ: Box<Type>,
    pub is_ref: bool,
    pub is_mut: bool,
}

impl Pointer {
    pub fn new(loc: Loc, typ: Box<Type>, is_ref: bool, is_mut: bool) -> Pointer {
        Self{ loc, typ, is_ref, is_mut }
    }

    pub fn set_type(&mut self, typ: Type) {
        *self.typ = typ;
    }
}

#[derive(Debug, Clone)]
pub struct Array {
    pub loc: Loc,
    pub typ: Box<Type>,
    pub elems: usize,
}

impl Array {
    pub fn new(loc: Loc, typ: Type, elems: usize) -> Array {
        Self{ loc, typ: Box::new(typ), elems }
    }
}

#[derive(Debug, Clone)]
pub struct FuncPtr {
    pub loc: Loc,
    pub params: Vec<Type>,
    pub ret_type: Box<Type>,
}

impl FuncPtr {
    pub fn new(loc: Loc, params: Vec<Type>, ret_type: Type) -> FuncPtr {
        Self{ loc, params, ret_type: Box::new(ret_type) }
    }
}

#[derive(Debug, Clone)]
pub struct ArraySlice {
    pub loc: Loc,
    pub typ: Box<Type>,
}

impl ArraySlice {
    pub fn new(loc: Loc, typ: Type) -> ArraySlice {
        Self{ loc, typ: Box::new(typ) }
    }
}

#[derive(Debug, Clone)]
pub enum Type {
    Path(Path),
    Pointer(Pointer),
    Array(Array),
    FuncPtr(FuncPtr),
    Slice(ArraySlice),
}

impl Type {
    pub fn get_loc(&self) -> Loc {
        return match self {
            Type::Path(p) => p.loc.clone(),
            Type::Pointer(ptr) => ptr.loc.clone(),
            Type::Array(arr) => arr.loc.clone(),
            Type::Slice(slice) => slice.loc.clone(),
            Type::FuncPtr(fn_ptr) => fn_ptr.loc.clone(),
        };
    }

    pub fn get_name(&self) -> String {
        match self {
            Type::Path(p) => p.path.clone(),
            Type::Pointer(ptr) => ptr.typ.get_name(),
            Type::Array(arr) => arr.typ.get_name(),
            Type::Slice(slice) => slice.typ.get_name(),
            Type::FuncPtr(_) => todo!(),
        }
    }

    pub fn get_full_name(&self) -> String {
        match self {
            Type::Path(p) => p.path.clone(),
            Type::Pointer(ptr) => {
                let prefix = if ptr.is_ref { "&" } else { "*" }.to_owned();
                prefix + &ptr.typ.get_full_name()
            },
            Type::Array(arr) => {
                format!("[{};{}]", arr.typ.get_full_name(), arr.elems)
            },
            Type::Slice(slice) => {
                "[".to_owned() + &slice.typ.get_full_name() + "]"
            },
            Type::FuncPtr(_) => todo!(),
        }
    }

    pub fn matches(&self, rhs: &Type) -> bool {
        match (self, rhs) {
            (Type::Pointer(lhs), Type::Pointer(rhs)) => {
                return lhs.typ.matches(&rhs.typ);
            }
            _ => return self.get_full_name() == rhs.get_full_name(),
        }
    }

    pub fn from_string(src: String) -> Option<Type> {
        let mut s = src.as_str();
        let loc = Loc::new("".into(), 0, 1);
        if s.starts_with('*') || s.starts_with('&') {
            let is_ref = s.starts_with('&');
            s = &s[..1];
            let is_mut = if s.starts_with("mut") {
                s = &s[..3];
                true
            }else {
                false
            };

            if let Some(ty) = Self::from_string(s.to_owned()) {
                return Some(Type::Pointer(Pointer::new(loc, Box::new(ty), is_ref, is_mut)));
            }
            return None;
        }
        return Some(Type::Path(Path::new(loc, s.to_owned())));
    }
}

pub fn is_array_type(ty: &llvm::TypeRef) -> bool {
    if let Ok(ty) = ty.get_base() {
        return is_array_type(&ty);
    }
    return ty.is_array_ty();
}

pub mod containers {
    #[derive(Debug)]
    pub struct Pointer<T: ?Sized> {
        inner: *const T,
    }

    impl<T> Pointer<T> {
        pub fn new() -> Pointer<T> {
            Self{ inner: std::ptr::null() }
        }

        pub fn set_value(&mut self, value: &T) {
            self.inner = value as *const T;
        }

        pub fn is_null(&self) -> bool {
            return self.inner.is_null();
        }

    }

    impl<T> From<&T> for Pointer<T> {
        fn from(value: &T) -> Self {
            Self{ inner: value as *const T }
        }
    }

    impl<T> From<&mut T> for Pointer<T> {
        fn from(value: &mut T) -> Self {
            Self{ inner: value as *const T }
        }
    }

    impl<T> From<&mut &mut T> for Pointer<T> {
        fn from(value: &mut &mut T) -> Self {
            Self{ inner: *value as *const T }
        }
    }

    impl<T> std::ops::Deref for Pointer<T> {
        type Target = T;

        fn deref(&self) -> &Self::Target {
            return unsafe{self.inner.as_ref()}.unwrap();
        }
    }

    impl<T> std::convert::AsRef<T> for Pointer<T> {
        fn as_ref(&self) -> &T {
            return unsafe{ self.inner.as_ref().unwrap() };
        }
    }

    impl<T> std::convert::AsMut<T> for Pointer<T> {
        fn as_mut(&mut self) -> &mut T {
            return unsafe{ self.inner.cast_mut().as_mut().unwrap() };
        }
    }

    impl<T> Clone for Pointer<T> {
        fn clone(&self) -> Self {
            Self{ inner: self.inner.clone() }
        }
    }

    pub unsafe fn to_mut<T>(r: &T) -> &mut T {
        return unsafe{(r as *const T as *mut T).as_mut().unwrap()};
    }

    /*pub struct Buffer {
        data: std::sync::Mutex<std::sync::Arc<[u8; 4096]>>,
        current_alloc: usize,
        next: Option<Box<Buffer>>,
    }

    impl Buffer {
        pub fn new(size: usize) -> Buffer {
            Self{ data: std::sync::Mutex::new(std::sync::Arc::new([0; 4096])), current_alloc: 0, next: None }
        }

        pub fn alloc<T: ?Sized>(&self, layout: std::alloc::Layout) -> *mut u8 {
            todo!();
        }
    }

    pub struct Allocator {
        pub buffer: Option<Buffer>,
    }

    unsafe impl std::alloc::GlobalAlloc for Allocator {
        unsafe fn alloc(&self, layout: std::alloc::Layout) -> *mut u8 {
            todo!();
        }
        unsafe fn dealloc(&self, ptr: *mut u8, layout: std::alloc::Layout) {
            todo!();
        }
        unsafe fn realloc(&self, ptr: *mut u8, layout: std::alloc::Layout, new_size: usize) -> *mut u8 {
            todo!();
        }
        unsafe fn alloc_zeroed(&self, layout: std::alloc::Layout) -> *mut u8 {
            todo!();
        }
    }*/

    /*struct Tree<T> {
        head: TreeNode<T>,
    }

    struct TreeNode<T> {
        data: T,
        children: Vec<TreeNode<T>>,
    }*/
}
