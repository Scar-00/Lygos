fn LLVMContextCreate() -> *i8;
fn LLVMModuleCreateWithNameInContext(name: *i8, ctx: *i8) -> *i8;
fn LLVMCreateBuilderInContext(ctx: *i8) -> *i8;
fn LLVMInt8Type() -> *i8;
fn LLVMInt32Type() -> *i8;
fn LLVMPointerType(typ: *i8, addr_space: u32) -> *i8;
fn LLVMFunctionType(ret: *i8, param_types: *i8, param_count: i32, is_var_arg: i8) -> *i8;
fn LLVMAddFunction(mod: *i8, name: *i8, fn_type: *i8) -> *i8;

fn LLVMDumpModule(mod: *i8);

fn isdigit(c: i8) -> i32;

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
        for let curr = self->curr in isdigit(self->curr) == 1 {
            (*self).advance();
            len = len + 1;
        }
        printf("len -> %d\n", len);
        printf("bool -> %d\n", isdigit(self->curr));
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


    LLVMDumpModule(ctx.mod);

    let lexer = Lexer::new("123", 3);
    lexer.lex_number();
    printf("%s\n", lexer.src);
    for let i = 0 in i < lexer.len {
        printf("%c", lexer.src[i]);
        i = i + 1;
    }
    printf("\n");

    return 0;
}
