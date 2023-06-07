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
fn isalpha(c: i32) -> i32;
fn isspace(c: i32) -> i32;

fn strlen(str: *i8) -> i32;

fn exit(code: i32);

fn malloc(size: u32) -> *i8;
fn realloc(ptr: *i8, size: u32) -> *i8;
fn free(block: *i8);
fn memcpy(dest: *i8, src: *i8, size: u32) -> *i8;
fn strlen(str: *i8) -> u32;
fn strcpy(dest: *i8, src: *i8) -> *i8;

macro println {
    () -> {
        printf("\n");
    }
    (string: $) -> {
        printf("%s\n", $string);
    }

    (fmt: $, args: $[]) -> {
        printf($fmt, $args);
        printf("\n");
    }
}

macro Vec {
    (typ: $) -> {
        struct Vec##$typ {
            data: *$typ;
            cap: u32;
            len: u32;
        };

        impl Vec##$typ {
            fn new() -> Vec##$typ {
                let this: Vec##$typ = {
                    .cap = 0,
                    .len = 0,
                };
                return this;
            }

            fn may_grow(&mut self) {
                if self->cap == self->len {
                    self->cap = self->cap * 2;
                    let size: i32 = sizeof($typ);
                    realloc((:*i8)self->data, self->cap * size);
                }
            }

            fn push(&mut self, value: $typ) {
                self->may_grow();
                self->data[self->len] = value;
                self->len = self->len + 1;
            }

            fn pop(&mut self) -> $typ {
                self->len = self->len - 1;
                return self->data[self->len];
            }
        }
    }
}

struct String {
    data: *i8;
    len: u32;
    cap: u32;
};

impl String {
    fn new(size: i32) -> String {
        let str: String = {
            .data = malloc(size),
            .len = 0,
            .cap = size,
        };
        return str;
    }

    fn from(ptr: *i8) -> String {
        let len = strlen(ptr);
        let str = String::new(len);
        strcpy(str.data, ptr);
        str.len = len;
        return str;
    }

    fn push(&mut self, char: i8) {
        self->data[self->len] = char;
        self->len = self->len + 1;
        if self->len == self->cap {
            self->cap = self->cap * 2;
            realloc(self->data, self->cap);
        }
        self->data[self->len] = (:i8)0;
    }

    fn eq(&self, other: String) -> bool {
        if self->len != other.len {
            return (:bool)0;
        }
        for let i = 0 in i < self->len {
            if self->data[i] != other.data[i] {
                return (:bool)0;
            }
        }
        return (:bool)1;
    }
}

Vec$(String);

enum TokenType {
    String,
    Integer,
    Float,
    Id,
    Char,

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

    Eof,
}

struct Token {
    typ: TokenType;
    value: String;
};

impl Token {
    fn new(value: String, typ: u32) -> Token {
        let mut this: Token = {
            .value = value,
            .typ = typ,
        };
        return this;
    }
}

Vec$(Token);

struct Lexer {
    src: *i8;
    len: u32;
    curr: i8;
    index: u32;
};

impl Lexer {
    fn new(src: *i8, src_len: u32) -> Lexer {
        let mut this: Lexer = {
            .src = src,
            .len = src_len,
            .index = 0,
            .curr = src[0],
        };
        return this;
    }

    fn advance(&mut self) {
        self->index = self->index + 1;
        self->curr = self->src[self->index];
    }

    fn advance_token(&mut self, token: Token) -> Token {
        self->advance();
        return token;
    }

    fn lex_number(&self) -> Token {
        let start = self->index;
        let mut str = String::new(2);
        for let curr = self->curr in isdigit((:i32)self->curr) != 0 {
            str.push(self->curr);
            self->advance();
        }
        return Token::new(str, TokenType::Integer);
    }

    fn lex_string(&self) -> Token {
        let start = self->index;
        let mut str = String::new(0);
        for let curr = self->curr in self->curr != (:i8)34 {
            str.push(self->curr);
            self->advance();
        }
        return Token::new(str, TokenType::String);
    }

    fn lex_char(&self) -> Token {
        printf("unimplemented [`lex_char()`]");
        exit(1);
    }

    fn lex_id(&self) -> Token {
        let start = self->index;
        let mut str = String::new(2);
        for let curr = self->curr in isalpha((:i32)self->curr) != 0 {
            str.push(self->curr);
            self->advance();
        }
        return Token::new(str, TokenType::Id);
    }

    fn next_token(&mut self) -> Token {
        for let w = 0 in self->index < self->len {
            for let l = 0 in isspace((:i32)self->curr) != 0 {
                self->advance();
            }

            if self -> curr == '.' { return self->advance_token(Token::new(String::from("."), TokenType::Dot)); }
            if self -> curr == ',' { return self->advance_token(Token::new(String::from(","), TokenType::Comma)); }
            if self -> curr == ';' { return self->advance_token(Token::new(String::from(";"), TokenType::Semi)); }
            if self -> curr == ':' {
                if self->src[self->index + 1] == ':' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("::"), TokenType::OpScope));
                }
                return self->advance_token(Token::new(String::from(":"), TokenType::Colon));
            }
            if self -> curr == '+' { return self->advance_token(Token::new(String::from("+"), TokenType::OpPlus)); }
            if self -> curr == '-' {
                if self->src[self->index + 1] == '>' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("->"), TokenType::Arrow));
                }
                return self->advance_token(Token::new(String::from("-"), TokenType::OpMinus));
            }
            if self -> curr == '*' { return self->advance_token(Token::new(String::from("*"), TokenType::OpMul)); }
            if self -> curr == '/' {
                if self->src[self->index + 1] == '/' {
                    //TODO:
                    //for w in self->curr != '\n' {
                    //    self->advance();
                    //}
                }
                return self->advance_token(Token::new(String::from("/"), TokenType::OpDiv));
            }
            if self -> curr == '%' { return self->advance_token(Token::new(String::from("%"), TokenType::OpMod)); }
            if self -> curr == '[' { return self->advance_token(Token::new(String::from("["), TokenType::BraceLeft)); }
            if self -> curr == ']' { return self->advance_token(Token::new(String::from("]"), TokenType::BraceRight)); }
            if self -> curr == '{' { return self->advance_token(Token::new(String::from("{"), TokenType::CurlyLeft)); }
            if self -> curr == '}' { return self->advance_token(Token::new(String::from("}"), TokenType::CurlyRight)); }
            if self -> curr == '(' { return self->advance_token(Token::new(String::from("("), TokenType::ParanLeft)); }
            if self -> curr == ')' { return self->advance_token(Token::new(String::from(")"), TokenType::ParanRight)); }
            if self -> curr == '#' { return self->advance_token(Token::new(String::from("#"), TokenType::Hash)); }
            if self -> curr == '$' { return self->advance_token(Token::new(String::from("$"), TokenType::Dollar)); }
            if self -> curr == '<' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("<="), TokenType::OpLeEq));
                }
                return self->advance_token(Token::new(String::from("<"), TokenType::AngleLeft));
            }
            if self -> curr == '>' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from(">="), TokenType::OpGrEq));
                }
                return self->advance_token(Token::new(String::from(">"), TokenType::AngleRight));
            }
            if self -> curr == '&' {
                if self->src[self->index + 1] == '&' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("&&"), TokenType::OpAnd));
                }
                return self->advance_token(Token::new(String::from("&"), TokenType::Ampercent));
            }
            if self -> curr == '|' {
                if self->src[self->index + 1] == '|' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("||"), TokenType::OpOr));
                }
                return self->advance_token(Token::new(String::from("|"), TokenType::Pipe));
            }
            if self -> curr == '!' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("!="), TokenType::OpNeEq));
                }
                return self->advance_token(Token::new(String::from("!"), TokenType::Bang));
            }
            if self -> curr == '=' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("=="), TokenType::OpEqEq));
                }
                return self->advance_token(Token::new(String::from("="), TokenType::Equals));
            }
            if isdigit((:i32)self->curr) != 0 {
                return self->lex_number();
            }
            if isalpha((:i32)self->curr) != 0 {
                return self->lex_id();
            }
        }
        return Token::new(String::from(""), TokenType::Eof);
    }
}

struct Ctx {
    name: *i8;
    ctx: *i8;
    mod: *i8;
    builder: *i8;
    key_words: VecString;
};

impl Ctx {
    fn init(name: *i8) -> Ctx {
        let mut this: Ctx;
        this.name = name;
        this.ctx = LLVMContextCreate();
        this.mod = LLVMModuleCreateWithNameInContext(name, this.ctx);
        this.builder = LLVMCreateBuilderInContext(this.ctx);
        this.key_words = VecString::new();

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

    let lexer = Lexer::new("let x = 10;", 11);
    printf("%s\n", lexer.src);
    for let mut tok = lexer.next_token() in tok.typ != TokenType::Eof {
        println$("tok -> %s", tok.value.data);
        tok = lexer.next_token();
    }
    return 0;
}
