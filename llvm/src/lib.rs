#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
use libc::*;
use std::ffi::CString;

//TODO(S): derive copy on every llvm::..Ref struct and pass them all by value instead of ref, to avoid
//unnessesary indirection

#[repr(C)]
struct FFIString {
    data: *mut u8,
    len: u64,
}

impl Into<String> for FFIString {
    fn into(self) -> String {
        return unsafe { String::from_raw_parts(self.data, (self.len - 1) as usize, self.len as usize) };
    }
}

type CStr = *const c_char;

#[repr(C)]
struct FuncArgs(*mut *mut (), usize);

#[repr(C)]
pub enum CastOps {
    SExt,
    ZExt,
    FPExt,
    Trunc,
    FPToSI,
    FPToUI,
    SIToFP,
    UIToFP,
    BitCast,
    FPTrunc,
    IntToPtr,
    PtrToInt,
    AddrSpaceCast,
}

extern "C" {
    fn CreateContext() -> *mut ();
    fn DestroyContext(_: *mut ());
    fn ContextSetOpaquePointers(ctx: *mut (), enable: bool);
    fn GetTargetTriiple() -> FFIString;
    fn LookUpTarget(tt: CStr) -> *mut ();
    fn CreateTargetMachine(target: *mut (), tt: CStr, cpu: CStr, features: CStr) -> *mut ();
    fn CreateModule(name: CStr, ctx: *mut ()) -> *mut ();
    fn DestroyModule(_: *mut ());
    fn ModuleSetDataLayout(m: *mut (), machine: *mut ());
    fn ModuleSetTargetTripple(m: *mut (), tt: CStr);
    fn ModuleGetDataLayout(m: *mut ()) -> *mut ();

    fn DataLayoutGetTypeAllocSizeInBits(dl: *mut (), ty: *mut ()) -> usize;

    fn ModuleGetFunction(module: *mut (), name: CStr) -> *mut ();

    fn CreateIRBuilder(ctx: *mut ()) -> *mut ();
    fn DestroyIRBuilder(_: *mut ());

    fn BuilderSetInsertPoint(builder: *mut (), bb: *mut ());
    fn BuilderGetInsertBlock(builder: *mut ()) -> *mut ();
    fn BuilderCreateStore(builder: *mut (), value: *mut (), ptr: *mut ()) -> *mut ();
    fn BuilderCreateLoad(builder: *mut (), ty: *mut (), value: *mut ()) -> *mut ();
    fn BuilderCreateAlloca(builder: *mut (), ty: *mut (), array_size: *mut ()) -> *mut ();
    fn BuilderCreateRet(builder: *mut (), value: *mut ()) -> *mut ();
    fn BuilderCreateRetVoid(builder: *mut ()) -> *mut ();
    fn BuilderCreatePtrCall(builder: *mut (), ty: *mut (), callee: *mut (), args: *mut *mut (), args_size: usize) -> *mut ();
    fn BuilderCreateCall(builder: *mut (), callee: *mut (), args: *mut *mut (), args_size: usize) -> *mut ();
    fn BuilderCreateGEP(builder: *mut (), base: *mut (), val: *mut (), idx_list: *mut *mut (), idx_count: usize, in_bounds: bool) -> *mut ();
    fn BuilderCreateStructGEP(builder: *mut (), base: *mut (), val: *mut (), index: u32) -> *mut ();
    fn BuilderCreateXorVV(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateXorVL(builder: *mut (), lhs: *mut (), rhs: u64) -> *mut ();
    fn BuilderCreateCast(builder: *mut (), op: CastOps, src: *mut (), dest_ty: *mut ()) -> *mut ();
    fn BuilderCreatePointerCast(builder: *mut (), value: *mut (), dest_ty: *mut ()) -> *mut ();
    fn BuilderCreateAdd(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateSub(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateMul(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateDiv(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateRem(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateICmpEQ(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateICmpNE(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateICmpSLT(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateICmpSLE(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateICmpSGT(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateICmpSGE(builder: *mut (), lhs: *mut (), rhs: *mut ()) -> *mut ();
    fn BuilderCreateGlobalStringPointer(builder: *mut (), string: CStr) -> *mut ();


    fn BuilderCreateBr(builder: *mut (), bb: *mut ()) -> *mut ();
    fn BuilderCreateCondBr(builder: *mut (), cond: *mut (), true_bb: *mut (), false_bb: *mut ()) -> *mut ();

    fn GetPointerType(ty: *mut(), address_space: u32) -> *mut ();

    fn GetIntType(ctx: *mut (), width: usize) -> *mut ();
    fn GetConstantInt(typ: *mut (), value: i32) -> *mut ();
    fn GetConstantFP(ty: *mut (), value: f64) -> *mut ();
    fn GetConstantStruct(ty: *mut (), constatns: *mut *mut (), constatns_len: usize) -> *mut ();

    fn FunctionTypeGet(ret: *mut (), params: *mut *mut (), len: usize, is_var_arg: bool) -> *mut ();

    fn StructTypeCreate(elems: *mut *mut (), len: usize, name: CStr, packed: bool) -> *mut ();
    fn StructTypeGet(ctx: *mut (), elems: *mut *mut (), elems_count: usize, packed: bool) -> *mut ();

    fn ArrayTypeGet(ty: *mut (), num_elems: usize) -> *mut ();

    fn GetVoidType(ctx: *mut ()) -> *mut ();

    fn FloatTypeGet(ctx: *mut ()) -> *mut ();
    fn DoubleTypeGet(ctx: *mut ()) -> *mut ();

    fn TypeIsPointerType(ty: *mut ()) -> bool;
    fn TypeIsIntType(ty: *mut ()) -> bool;
    fn TypeIsFloatingPointType(ty: *mut ()) -> bool;
    fn TypeIsFloatType(ty: *mut ()) -> bool;
    fn TypeIsDoubleType(ty: *mut ()) -> bool;
    fn TypeIsStructType(ty: *mut ()) -> bool;
    fn TypeIsArrayType(ty: *mut ()) -> bool;
    fn TypeCanLossLesslyBitCast(ty: *mut (), dest: *mut ()) -> bool;
    fn TypeGetIntBitWidth(ty: *mut ()) -> u32;

    fn TypeTryGetPointerBase(ty: *mut ()) -> *mut ();

    fn FunctionCreate(typ: *mut (), name: CStr, module: *mut ()) -> *mut ();
    fn FunctionGetArgs(func: *mut ()) -> FuncArgs;
    fn FunctionVerify(func: *mut ()) -> bool;
    fn FunctionIsVarArg(func: *mut ()) -> bool;


    fn GlobalVariableCreate(m: *mut (), ty: *mut (), is_constant: bool, val: *mut ()) -> *mut ();


    fn CreateBasicBlock(ctx: *mut (), name: CStr, parent: *mut (), before: *mut ()) -> *mut ();
    fn BasicBlockGetParent(bb: *mut ()) -> *mut ();
    fn BasicBlockGetTerminator(bb: *mut ()) -> *mut ();
    fn BasicBlockRemoveFromParent(bb: *mut ());
    fn BasicBlockHasNUses(bb: *mut (), uses: usize) -> bool;

    fn PrintModule(m: *mut ()) -> FFIString;

    fn PrintValue(value: *mut ()) -> FFIString;
    fn ValueType(value: *mut ()) -> *mut ();

    fn PrintType(ty: *mut ()) -> FFIString;

    fn EmitObjFile(path: CStr, m: *mut (), target_machine: *mut ()) -> bool;

    fn InitAll();
}

macro_rules! to_cstr {
    ($s: expr) => {
        {
            let str = CString::new($s).unwrap().into_raw();
            str
        }
    };
}

#[repr(C)]
#[derive(Debug, Clone)]
pub struct TypeRef(*mut ());

#[derive(Debug)]
pub enum LoadingError {
    InvalidLevelOfIndirection,
}

impl TypeRef {
    fn new(x: *mut ()) -> Self {
        Self{ 0: x }
    }

    pub fn get_int(ctx: &Context, width: usize) -> Self {
        return Self{ 0: unsafe{ GetIntType(ctx.ptr, width) } };
    }

    pub fn get_void(ctx: &Context) -> Self {
        Self::new(unsafe{GetVoidType(ctx.ptr)})
    }

    pub fn get_ptr(base: Self, addr_space: u32) -> Self {
        Self{ 0: unsafe{ GetPointerType(base.0, addr_space) } }
    }

    pub fn is_pointer_ty(&self) -> bool {
        return unsafe{ TypeIsPointerType(self.0) };
    }

    pub fn is_int_ty(&self) -> bool {
        return unsafe{ TypeIsIntType(self.0) };
    }

    pub fn is_float_ty(&self) -> bool {
        return unsafe{ TypeIsFloatType(self.0) };
    }

    pub fn is_double_ty(&self) -> bool {
        return unsafe{ TypeIsDoubleType(self.0) };
    }

    pub fn is_floating_point_ty(&self) -> bool {
        return unsafe{ TypeIsFloatingPointType(self.0) };
    }

    pub fn is_struct_ty(&self) -> bool {
        return unsafe{ TypeIsStructType(self.0) };
    }

    pub fn is_array_ty(&self) -> bool {
        return unsafe{ TypeIsArrayType(self.0) };
    }

    pub fn can_losslessly_bit_cast_to(&self, dest: &TypeRef) -> bool {
        return unsafe{ TypeCanLossLesslyBitCast(self.0, dest.0) };
    }

    pub fn get_int_bit_width(&self) -> u32 {
        return unsafe{ TypeGetIntBitWidth(self.0) };
    }

    pub fn get_base(&self) -> Result<TypeRef, LoadingError> {
        let res = unsafe{ TypeTryGetPointerBase(self.0) };
        if res.is_null() {
            return Err(LoadingError::InvalidLevelOfIndirection);
        }
        return Ok(TypeRef::new(res));
    }

    pub fn print(&self) -> String {
        return unsafe{ PrintType(self.0) }.into();
    }
}

#[repr(C)]
#[derive(Debug, Clone)]
pub struct ValueRef(*mut ());
impl ValueRef {
    fn new(x: *mut ()) -> Self {
        Self{ 0: x }
    }

    pub fn print(&self) -> String {
        return unsafe{ PrintValue(self.0) }.into();
    }

    pub fn get_type(&self) -> TypeRef {
        return TypeRef::new(unsafe{ ValueType(self.0) });
    }

    pub fn try_load(&self, builder: &IRBuilder) -> ValueRef {
        if self.get_type().is_pointer_ty() {
            return builder.create_load(&self.get_type().get_base().expect("cannot happen"), &self);
        }
        return ValueRef::new(self.0.clone());
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct FunctionTypeRef(*mut ());

impl FunctionTypeRef {
    pub fn get(ret_type: TypeRef, params: &[TypeRef], is_var_arg: bool) -> Self {
        let mut params_ptr: Vec<*mut ()> = params.iter().map(|p| p.0).collect();
        return FunctionTypeRef{ 0: unsafe{ FunctionTypeGet(ret_type.0, params_ptr.as_mut_ptr(), params_ptr.len(), is_var_arg) } };
    }
}

impl Into<TypeRef> for FunctionTypeRef {
    fn into(self) -> TypeRef {
        TypeRef{ 0: self.0 }
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct StructTypeRef(*mut ());

impl StructTypeRef {
    pub fn create(name: &str, elems: &[TypeRef], packed: bool) -> Self {
        let mut elems: Vec<*mut ()> = elems.iter().map(|p| p.0).collect();
        return Self{ 0: unsafe{ StructTypeCreate(elems.as_mut_ptr(), elems.len(), to_cstr!(name), packed) } };
    }

    pub fn get(ctx: &Context, elems: &[TypeRef], packed: bool) -> Self {
        let mut elems: Vec<*mut ()> = elems.iter().map(|p| p.0).collect();
        return Self{ 0: unsafe{ StructTypeGet(ctx.ptr, elems.as_mut_ptr(), elems.len(), packed) } };
    }
}

impl Into<TypeRef> for StructTypeRef {
    fn into(self) -> TypeRef {
        TypeRef{ 0: self.0 }
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct ArrayTypeRef(*mut ());

impl ArrayTypeRef {
    pub fn get(ty: &TypeRef, elems_count: usize) -> Self {
        return Self{ 0: unsafe{ ArrayTypeGet(ty.0, elems_count) } };
    }
}

impl Into<TypeRef> for ArrayTypeRef {
    fn into(self) -> TypeRef {
        TypeRef{ 0: self.0 }
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct FloatTypeRef(*mut ());

impl FloatTypeRef {
    pub fn get(ctx: &Context) -> Self {
        return Self{ 0: unsafe{ FloatTypeGet(ctx.ptr) } };
    }
}

impl Into<TypeRef> for FloatTypeRef {
    fn into(self) -> TypeRef {
        TypeRef{ 0: self.0 }
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct DoubleTypeRef(*mut ());

impl DoubleTypeRef {
    pub fn get(ctx: &Context) -> Self {
        return Self{ 0: unsafe{ DoubleTypeGet(ctx.ptr) } };
    }
}

impl Into<TypeRef> for DoubleTypeRef {
    fn into(self) -> TypeRef {
        TypeRef{ 0: self.0 }
    }
}


#[repr(C)]
#[derive(Debug)]
pub struct Function(*mut ());

impl Function {
    pub fn create(typ: FunctionTypeRef, name: &str, module: &Module) -> Self {
        Self{ 0: unsafe{ FunctionCreate(typ.0, to_cstr!(name), module.ptr) } }
    }

    pub fn args(&self) -> Vec<ValueRef> {
        let ret = unsafe{FunctionGetArgs(self.0)};
        let vec = unsafe{Vec::from_raw_parts(ret.0, ret.1, ret.1)};
        return vec.iter().map(|i| ValueRef::new(*i)).collect();
    }

    pub fn verify(&self) -> bool {
        return unsafe{ FunctionVerify(self.0) };
    }

    pub fn is_var_arg(&self) -> bool {
        return unsafe{ FunctionIsVarArg(self.0) };
    }
}

impl Into<ValueRef> for Function {
    fn into(self) -> ValueRef {
        ValueRef{ 0: self.0 }
    }
}

impl From<ValueRef> for Function {
    fn from(value: ValueRef) -> Self {
        //TODO(S): check if this is actually a function ty
        //debug_assert(value.get_type())!
        return Self{ 0: value.0 };
    }
}

#[repr(C)]
#[derive(Debug, Clone)]
pub struct GlobalVariable(*mut ());

impl GlobalVariable {
    pub fn new(m: &Module, typ: &TypeRef, value: Option<&ValueRef>, is_constant: bool) -> Self {
        let val = if let Some(v) = value { v.0 } else { std::ptr::null_mut() };
        Self{ 0: unsafe{ GlobalVariableCreate(m.ptr, typ.0, is_constant, val) } }
    }
}

impl Into<ValueRef> for GlobalVariable {
    fn into(self) -> ValueRef {
        ValueRef{ 0: self.0 }
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct BasicBlock(*mut ());

impl BasicBlock {
    pub fn new(ctx: &Context, name: &str, parent: Option<&Function>, insert_before: Option<&BasicBlock>) -> Self {
        let parent = if let Some(func) = parent { func.0 } else { std::ptr::null_mut() };
        let insert_before = if let Some(bb) = insert_before { bb.0 } else { std::ptr::null_mut() };
        return Self{ 0: unsafe{ CreateBasicBlock(ctx.ptr, to_cstr!(name), parent, insert_before) } }
    }

    pub fn get_parent(&self) -> Function {
        Function{ 0: unsafe{ BasicBlockGetParent(self.0) } }
    }

    pub fn get_terminator(&self) -> Option<ValueRef> {
        let ret = unsafe{BasicBlockGetTerminator(self.0)};
        if ret.is_null() {
            return None
        }else {
            return Some(ValueRef::new(ret));
        }
    }

    pub fn remove_from_parent(&self) {
        unsafe{BasicBlockRemoveFromParent(self.0)};
    }

    pub fn has_n_uses(&self, uses: usize) -> bool {
        unsafe{BasicBlockHasNUses(self.0, uses)}
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct TargetRef(*mut ());
#[repr(C)]
#[derive(Debug)]
pub struct TargetMachineRef(*mut ());
#[repr(C)]
#[derive(Debug)]
pub struct DataLayoutRef(*mut ());

impl DataLayoutRef {
    pub fn get_type_size_in_bits(&self, ty: &TypeRef) -> usize {
        return unsafe{ DataLayoutGetTypeAllocSizeInBits(self.0, ty.0) }
    }
}

pub struct Context {
    ptr: *mut (),
}

impl Context {
    pub fn new() -> Self {
        return Self{ ptr: unsafe { CreateContext() } };
    }

    pub fn set_opaque_pointers(&self, enable: bool) {
        unsafe{ ContextSetOpaquePointers(self.ptr, enable) };
    }
}

impl Drop for Context {
    fn drop(&mut self) {
        unsafe { DestroyContext(self.ptr) };
    }
}

pub struct Module<'a> {
    ctx: &'a Context,
    ptr: *mut (),
}

impl<'a> Module<'a> {
    pub fn new(name: &str, ctx: &'a Context) -> Self {
        return Self{ ptr: unsafe { CreateModule(to_cstr!(name), ctx.ptr) }, ctx };
    }

    pub fn print(&self) -> String {
        return unsafe{ PrintModule(self.ptr) }.into();
    }

    pub fn set_data_layout(&mut self, machine: &TargetMachineRef) {
        unsafe{ ModuleSetDataLayout(self.ptr, machine.0) };
    }

    pub fn set_target_triple(&mut self, tt: &String) {
        unsafe{ ModuleSetTargetTripple(self.ptr, to_cstr!(tt.as_str())) };
    }

    pub fn get_function(&self, name: &str) -> Option<Function> {
        let ret = unsafe{ ModuleGetFunction(self.ptr, to_cstr!(name)) };
        if ret.is_null() {
            return None;
        }else {
            return Some(Function{ 0: ret });
        }
    }

    pub fn get_data_layout(&self) -> DataLayoutRef {
        DataLayoutRef{ 0: unsafe{ ModuleGetDataLayout(self.ptr) }}
    }
}

impl<'a> Drop for Module<'a> {
    fn drop(&mut self) {
        unsafe { DestroyModule(self.ptr) };
    }
}


pub struct IRBuilder<'a> {
    ctx: &'a Context,
    ptr: *mut (),
}

impl<'a> IRBuilder<'a> {
    pub fn new(ctx: &'a Context) -> Self {
        return Self{ ptr: unsafe { CreateIRBuilder(ctx.ptr) }, ctx };
    }

    pub fn set_insert_point(&self, bb: &BasicBlock) {
        unsafe{ BuilderSetInsertPoint(self.ptr, bb.0) };
    }

    pub fn get_insert_block(&self, ) -> BasicBlock {
        BasicBlock{ 0: unsafe{ BuilderGetInsertBlock(self.ptr) } }
    }

    pub fn create_store(&self, value: &ValueRef, ptr: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateStore(self.ptr, value.0, ptr.0) });
    }

    pub fn create_load(&self, ty: &TypeRef, value: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateLoad(self.ptr, ty.0, value.0) });
    }

    pub fn create_alloca(&self, ty: &TypeRef, array_size: Option<&ValueRef>) -> ValueRef {
        let parent = if let Some(v) = array_size { v.0 } else { std::ptr::null_mut() };
        return ValueRef::new(unsafe{ BuilderCreateAlloca(self.ptr, ty.0, parent) });
    }

    pub fn create_ret(&self, value: Option<&ValueRef>) -> ValueRef {
        return ValueRef::new(if let Some(value) = value {
            unsafe{ BuilderCreateRet(self.ptr, value.0) }
        } else {
            unsafe{ BuilderCreateRetVoid(self.ptr) }
        });
    }

    pub fn create_call(&self, func: &ValueRef, args: &[ValueRef]) -> ValueRef {
        let mut args: Vec<*mut ()> = args.iter().map(|arg| arg.0).collect();
        return ValueRef::new(unsafe{BuilderCreateCall(self.ptr, func.0, args.as_mut_ptr(), args.len())});
    }

    pub fn create_ptr_call(&self, ty: &TypeRef, func: &ValueRef, args: &[ValueRef]) -> ValueRef {
        let mut args: Vec<*mut ()> = args.iter().map(|arg| arg.0).collect();
        return ValueRef::new(unsafe{BuilderCreatePtrCall(self.ptr, ty.0, func.0, args.as_mut_ptr(), args.len())});
    }

    pub fn create_gep(&self, base: &TypeRef, val: &ValueRef, idx_list: &[ValueRef], in_bounds: bool) -> ValueRef {
        let mut idx_list: Vec<*mut ()> = idx_list.iter().map(|arg| arg.0).collect();
        return ValueRef::new(unsafe{ BuilderCreateGEP(self.ptr, base.0, val.0, idx_list.as_mut_ptr(), idx_list.len(), in_bounds) });
    }

    pub fn create_struct_gep(&self, base: &TypeRef, val: &ValueRef, index: u32) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateStructGEP(self.ptr, base.0, val.0, index) });
    }

    pub fn create_xor_vv(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateXorVV(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_xor_vl(&self, lhs: &ValueRef, rhs: u64) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateXorVL(self.ptr, lhs.0, rhs) });
    }

    pub fn create_cast(&self, op: CastOps, src: &ValueRef, dest_ty: &TypeRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateCast(self.ptr, op, src.0, dest_ty.0) });
    }

    pub fn create_pointer_cast(&self, value: &ValueRef, dest_ty: &TypeRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreatePointerCast(self.ptr, value.0, dest_ty.0) });
    }

    pub fn create_br(&self, bb: &BasicBlock) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateBr(self.ptr, bb.0) });
    }

    pub fn create_cond_br(&self, cond: &ValueRef, true_bb: &BasicBlock, false_bb: &BasicBlock) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateCondBr(self.ptr, cond.0, true_bb.0, false_bb.0) });
    }

    pub fn create_add(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        ValueRef::new(unsafe{BuilderCreateAdd(self.ptr, lhs.0, rhs.0)})
    }

    pub fn create_sub(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        ValueRef::new(unsafe{BuilderCreateSub(self.ptr, lhs.0, rhs.0)})
    }

    pub fn create_mul(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        ValueRef::new(unsafe{BuilderCreateMul(self.ptr, lhs.0, rhs.0)})
    }

    pub fn create_div(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        ValueRef::new(unsafe{BuilderCreateDiv(self.ptr, lhs.0, rhs.0)})
    }

    pub fn create_rem(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        ValueRef::new(unsafe{BuilderCreateRem(self.ptr, lhs.0, rhs.0)})
    }

    pub fn create_icmp_eq(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateICmpEQ(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_icmp_ne(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateICmpNE(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_icmp_slt(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateICmpSLT(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_icmp_sle(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateICmpSLE(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_icmp_sgt(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateICmpSGT(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_icmp_sge(&self, lhs: &ValueRef, rhs: &ValueRef) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateICmpSGE(self.ptr, lhs.0, rhs.0) });
    }

    pub fn create_global_string_pointer<S: AsRef<str>>(&self, s: S) -> ValueRef {
        return ValueRef::new(unsafe{ BuilderCreateGlobalStringPointer(self.ptr, to_cstr!(s.as_ref())) });
    }
}

impl<'a> Drop for IRBuilder<'a> {
    fn drop(&mut self) {
        unsafe { DestroyIRBuilder(self.ptr) };
    }
}

pub struct ConstantInt;
impl ConstantInt {
    pub fn get(typ: &TypeRef, value: i32) -> ValueRef {
        return ValueRef{ 0: unsafe{ GetConstantInt(typ.0, value) } };
    }
}

pub struct ConstantFP;
impl ConstantFP {
    pub fn get(typ: &TypeRef, value: f64) -> ValueRef {
        return ValueRef{ 0: unsafe{ GetConstantFP(typ.0, value) } };
    }
}

pub struct ConstantStruct;
impl ConstantStruct {
    pub fn get(typ: TypeRef, constants: &[ValueRef]) -> ValueRef {
        let mut constants: Vec<*mut ()> = constants.iter().map(|arg| arg.0).collect();
        return ValueRef{ 0: unsafe{ GetConstantStruct(typ.0, constants.as_mut_ptr(), constants.len()) } };
    }
}

pub fn get_default_target_triple() -> String {
    return unsafe { GetTargetTriiple() }.into();
}

pub fn lookup_target(tt: &String) -> TargetRef {
    let str = CString::new(tt.clone()).unwrap();
    return TargetRef{ 0: unsafe{ LookUpTarget(str.as_c_str().as_ptr()) }};
}

pub fn create_target_machine<S: AsRef<str>>(target: TargetRef, tt: S, cpu: S, features: S) -> TargetMachineRef {
    let tt = to_cstr!(tt.as_ref());
    let cpu = to_cstr!(cpu.as_ref());
    let features = to_cstr!(features.as_ref());
    return TargetMachineRef{ 0: unsafe { CreateTargetMachine(target.0, tt, cpu, features) } }
}

pub fn emit_obj_file<P: AsRef<str>>(p: P, m: &Module, tm: &TargetMachineRef) -> bool {
    return unsafe{ EmitObjFile(to_cstr!(p.as_ref()), m.ptr, tm.0) };
}

pub fn init_all() {
    unsafe { InitAll() };
}
