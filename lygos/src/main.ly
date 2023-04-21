fn LLVMContextCreate() -> *i8;
fn LLVMModuleCreateWithNameInContext(name: *i8, ctx: *i8) -> *i8;
fn LLVMCreateBuilderInContext(ctx: *i8) -> *i8;
fn LLVMInt8Type() -> *i8;
fn LLVMInt32Type() -> *i8;
fn LLVMPointerType(typ: *i8, addr_space: u32) -> *i8;
fn LLVMFunctionType(ret: *i8, param_types: *i8, param_count: i32, is_var_arg: i8) -> *i8;
fn LLVMAddFunction(mod: *i8, name: *i8, fn_type: *i8) -> *i8;

fn LLVMDumpModule(mod: *i8);

fn isdigit(c: i32) -> i32;
fn strlen(str: *i8) -> i32;

fn malloc(size: u32) -> *i8;
fn memcpy(dest: *i8, src: *i8, size: u32) -> *i8;
fn strlen(str: *i8) -> u32;
fn strcpy(dest: *i8, src: *i8) -> *i8;

struct String {
    data: *i8;
    len: u32;
    cap: u32;
};

impl String {
    fn new(size: i32) -> String {
        let mut str: String;
        str.data = malloc(size);
        str.len = 0;
        str.cap = size;
        return str;
    }

    fn from(ptr: *i8) -> String {
        let len = strlen(ptr);
        let str = String::new(*len);
        strcpy(str.data, ptr);
        str.len = len;
        return str;
    }

    fn push(&mut self, char: i8) {
        self->data[self->len] = char;
        self->len = self->len + 1;
    }
}

struct Token {
    typ: u32;
    value: *i8;
};

impl Token {
    fn new(value: *i8, typ: u32) -> Token {
        let mut this: Token;
        this.value = value;
        this.typ = typ;
        return this;
    }
}

struct Lexer {
    src: *i8;
    len: u32;
    curr: i8;
    index: u32;
};

impl Lexer {
    fn new(src: *i8, src_len: u32) -> Lexer {
        let mut this: Lexer;
        this.src = src;
        this.len = src_len;
        this.index = 0;
        this.curr = src[0];
        return this;
    }

    fn advance(&mut self) {
        self->index = self->index + 1;
        self->curr = self->src[self->index];
    }

    fn advance_token(&mut self, token: Token) -> Token {
        (*self).advance();
        return token;
    }

    fn lex_number(&self) -> Token {
        let start = self->index;
        let mut len = 0;
        for let curr = self->curr in isdigit((:i32)self->curr) != 0 {
            (*self).advance();
            len = len + 1;
        }
        printf("len -> %d\n", len);
    }
}

struct Ctx {
    name: *i8;
    ctx: *i8;
    mod: *i8;
    builder: *i8;
};

impl Ctx {
    fn init(name: *i8) -> Ctx {
        let mut this: Ctx;
        this.name = name;
        this.ctx = LLVMContextCreate();
        this.mod = LLVMModuleCreateWithNameInContext(name, this.ctx);
        this.builder = LLVMCreateBuilderInContext(this.ctx);
        return this;
    }

    fn add_function(&self, name: *i8, typ: *i8) -> *i8 {
        return LLVMAddFunction(self->mod, name, typ);
    }
}

fn main(argc: i32, argv: **i8) -> i32 {
    let tt = "x86_64-pc-linux-gnu";

    let ctx = Ctx::init("test");

    let mut types: [*i8; 1];
    let t = LLVMPointerType(LLVMInt8Type(), 0);
    let false: i8 = 0;
    let fn_type = LLVMFunctionType(LLVMInt32Type(), t, 1, false);
    ctx.add_function("test", fn_type);

    let lexer = Lexer::new("hfghf123", 3);
    printf("%s\n", lexer.src);
    for let i = 0 in i < lexer.len {
        printf("%c", lexer.src[i]);
        i = i + 1;
    }
    printf("\n");

    return 0;
}
