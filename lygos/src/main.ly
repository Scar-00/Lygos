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

fn exit(code: i32);

fn malloc(size: u32) -> *i8;
fn realloc(ptr: *i8, size: u32) -> *i8;
fn free(block: *i8);
fn memcpy(dest: *i8, src: *i8, size: u32) -> *i8;
fn memmove(dest: *i8, src: *i8, len: u32) -> *i8;
fn strlen(str: *i8) -> u32;
fn strcpy(dest: *i8, src: *i8) -> *i8;

trait Drop {
    fn drop(&mut self);
}

trait Clone {
    fn clone(&self) -> Self;
}

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

macro panic {
    (string: $) -> {
        printf("error: %s\n", $string);
        exit(1);
    }
    (fmt: $, args: $[]) -> {
        printf("error: ");
        printf($fmt, $args);
        printf("\n");
    }
}

macro Vec {
    (name: $, typ: $) -> {
        struct Vec##$name {
            data: *$typ;
            cap: u32;
            len: u32;
        };

        impl Vec##$name {
            fn new() -> Vec##$name {
                let size: i32 = sizeof($typ);
                let this: Vec##$name = {
                    .data = (:*$typ)0,
                    .cap = 0,
                    .len = 0,
                };
                return this;
            }

            fn with_size(size: u32) -> Self {
                let typ_size: i32 = sizeof($typ);
                let this: Vec##$name = {
                    .data = (:*$typ)malloc(size * typ_size),
                    .cap = size,
                    .len = 0,
                };
                return this;
            }

            fn may_grow(&mut self) {
                let size: i32 = sizeof($typ);
                if self->cap == 0 {
                    self->cap = 1;
                    self->data = (:*$typ)realloc((:*i8)self->data, self->cap * size);
                }
                if self->cap == self->len {
                    self->cap = self->cap * 2;
                    self->data = (:*$typ)realloc((:*i8)self->data, self->cap * size);
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

            fn insert(&mut self, index: u32, other: &Self) -> bool {
                let typ_size: i32 = sizeof($typ);
                self->may_grow();
                if self->cap < (self->len + other->len) {
                    self->cap = self->len + other->len;
                    self->data = (:*$typ)realloc((:*i8)self->data, self->cap * typ_size);
                }
                self->data = (:*$typ)memmove((:*i8)&self->data[index + other->len], (:*i8)&self->data[index], other->len * typ_size);
                self->data = (:*$typ)memcpy((:*i8)&self->data[index], (:*i8)other->data, other->len * typ_size);
            }
        }

        impl Drop for Vec##$name {
            fn drop(&mut self) {
                if self->data != (:*$typ)0 {
                    free((:*i8)self->data);
                }
            }
        }

        impl Clone for Vec##$name {
            fn clone(&self) -> Self {
                let typ_size: i32 = sizeof($typ);
                let this = Vec##$name::with_size(self->cap);
                this.data = (:*$typ)memcpy((:*i8)this.data, (:*i8)self->data, self->cap * typ_size);
                this.len = self->len;
                return this;
            }
        }
    }
}


macro StringMap {
    (name: $, typ: $) -> {
        struct String##$name##MapNode {
            key: String;
            value: $typ;
            next: *i8;
        };

        impl String##$name##MapNode {
            fn new(key: String, value: $typ) -> *Self {
                let this_size: i32 = sizeof(Self);
                let this = (:*Self)malloc(this_size);
                this->key = key;
                this->value = value;
                this->next = (:*i8)0;
                return this;
            }

            fn set_next(&self, node: *Self) {
                self->next = (:*i8)node;
            }

            fn get_next(&self) -> *Self {
                return (:*Self)self->next;
            }
        }

        struct String##$name##Map {
            seed: size_t;
            table: **String##$name##MapNode;
            size: size_t;
        };

        impl String##$name##Map {
            fn new(size: size_t) -> Self {
                let typ_ptr_size = sizeof(*String##$name##MapNode);
                let typ_size = sizeof(String##$name##MapNode);
                let this: Self = {
                    .seed = (:u64)16442353754,
                    .table = (:**String##$name##MapNode)malloc((:i32)(size * typ_ptr_size)),
                    .size = size,
                };
                memset((:*i8)this.table, 0, this.size * typ_ptr_size);
                return this;
            }

            fn insert_helper(&mut self, hash_value: u64, prev: *String##$name##MapNode, entry: *String##$name##MapNode) {
                if prev == (:*String##$name##MapNode)0 {
                    self->table[hash_value] = entry;
                }else {
                    prev->set_next(entry);
                }
            }

            fn insert(&mut self, key: String, value: $typ) {
                let hash_value = hash_string(key.data, self->seed) % self->size;
                let prev = (:*String##$name##MapNode)0;
                let entry: *String##$name##MapNode = self->table[hash_value];

                for let i = 0 in entry != (:*String##$name##MapNode)0 && entry->key.eq(key) != (:bool)1 {
                    prev = entry;
                    entry = entry->get_next();
                }

                if entry == (:*String##$name##MapNode)0 {
                    entry = String##$name##MapNode::new(key, value);
                    self->insert_helper(hash_value, prev, entry);
                }else {
                    entry->value = value;
                }
            }

            fn at(&self, key: String) -> &$typ {
                let hash_value = hash_string(key.data, self->seed) % self->size;
                let prev = (:*String##$name##MapNode)0;
                let entry: *String##$name##MapNode = self->table[hash_value];

                for let i = 0 in entry != (:*String##$name##MapNode)0 && entry->key.eq(key) != (:bool)1 {
                    prev = entry;
                    entry = entry->get_next();
                }

                if entry == (:*String##$name##MapNode)0 {
                    return (:*$typ)0;
                }
                return &entry->value;
            }

            fn contains(&self, key: String) -> bool {
                let hash_value = hash_string(key.data, self->seed) % self->size;
                let prev = (:*String##$name##MapNode)0;
                let entry: *String##$name##MapNode = self->table[hash_value];

                for let i = 0 in entry != (:*String##$name##MapNode)0 && entry->key.eq(key) != (:bool)1 {
                    prev = entry;
                    entry = entry->get_next();
                }

                if entry == (:*String##$name##MapNode)0 {
                    return (:bool)0;
                }
                return (:bool)1;
            }
        }
    }
}

struct String {
    data: *i8;
    len: u32;
    cap: u32;
};

impl Drop for String {
    fn drop(&mut self) {
        if self->data != (:*i8)0 {
            free(self->data);
        }
    }
}

impl String {
    fn new(size: i32) -> String {
        let typ_size: i32 = sizeof(i8);
        let str: String = {
            .data = malloc(size * typ_size),
            .len = 0,
            .cap = size,
        };
        return str;
    }

    fn from(ptr: *i8) -> String {
        let typ_size: i32 = sizeof(i8);
        let len = strlen(ptr);
        let str = String::new(len + 1);
        memcpy(str.data, ptr, (len + 1) * typ_size);
        str.len = len;
        return str;
    }

    fn grow(&mut self) {
        if self->cap == 0 {
            self->cap = 1;
        }
        self->cap = self->cap * 2;
        let size: i32 = sizeof(i8);
        self->data = realloc(self->data, self->cap * size);
    }

    fn push(&mut self, char: i8) {
        if self->len == self->cap {
            self->grow();
        }
        self->data[self->len] = char;
        self->len = self->len + 1;
        self->data[self->len] = (:i8)0;
    }

    fn push_str(&mut self, other: String) {
        for let i = 0 in i < other.len {
            self->push(other.data[i]);
            i = i + 1;
        }
        return;
    }

    fn eq(&self, other: String) -> bool {
        if self->len != other.len {
            return (:bool)0;
        }
        for let i = 0 in i < self->len {
            if self->data[i] != other.data[i] {
                return (:bool)0;
            }
            i = i + 1;
        }
        return (:bool)1;
    }

    fn eq_ptr(&self, ptr: *i8) -> bool {
        let other = String::from(ptr);
        let eq = self->eq(other);
        other.drop();
        return eq;
    }

    fn contains(&self, matchee: i8) -> bool {
        for let mut i = 0 in i < self->len {
            if self->data[i] == matchee {
                return (:bool)1;
            }
            i = i + 1;
        }
        return (:bool)0;
    }
}

impl Clone for String {
    fn clone(&self) -> String {
        let mut this = String::new(self->cap);
        let size: i32 = sizeof(i8);
        this.len = self->len;
        strcpy(this.data, self->data);
        return this;
    }
}

struct StringView {
    data: *i8;
    len: u32;
};

impl StringView {
    fn new(src: &String) -> Self {
        let this: StringView = {
            .data = src->data,
            .len = src->len,
        };
        return this;
    }
}

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
    KwSizeOf,

    Eof,
}

struct Loc {
    file: &String;
    line: u64;
    start: u64;
    end: u64;
};

impl Loc {
    fn new(file: &String, line: u64, start: u64, end: u64) -> Loc {
        let this: Loc = {
            .file = file,
            .line = line,
            .start = start,
            .end = end,
        };
        return this;
    }
}

struct Token {
    typ: TokenType;
    value: String;
    loc: Loc;
};

impl Token {
    fn new(value: String, typ: u32, loc: Loc) -> Token {
        let mut this: Token = {
            .value = value,
            .typ = typ,
            .loc = loc,
        };
        return this;
    }
}

Vec$(Token, Token);

struct Lexer {
    file: String;
    src: *i8;
    len: u32;
    curr: i8;
    index: u32;
    line: u64;
    line_index: u64;
};

impl Lexer {
    fn new(src: *i8, src_len: u32, file: String) -> Lexer {
        let mut this: Lexer = {
            .file = file,
            .src = src,
            .len = src_len,
            .curr = src[0],
            .index = 0,
            .line = (:u64)0,
            .line_index = (:u64)0,
        };
        return this;
    }

    fn advance(&mut self) {
        self->index = self->index + 1;
        self->curr = self->src[self->index];
        self->line_index = self->line_index + (:u64)1;
    }

    fn advance_token(&mut self, token: Token) -> Token {
        self->advance();
        return token;
    }

    fn lex_number(&self) -> Token {
        let mut str = String::new(0);
        let loc = Loc::new(&self->file, self->line, self->line_index, (:u64)0);
        for let curr = self->curr in isdigit((:i32)self->curr) != 0 || self->curr == '.' {
            str.push(self->curr);
            self->advance();
        }
        if str.contains('.') {
            return Token::new(str, TokenType::Float, loc);
        }
        return Token::new(str, TokenType::Integer, loc);
    }

    fn lex_string(&self) -> Token {
        let mut str = String::new(0);
        let loc = Loc::new(&self->file, self->line, self->line_index, (:u64)0);
        for let curr = self->curr in self->curr != (:i8)34 {
            str.push(self->curr);
            self->advance();
        }
        return Token::new(str, TokenType::String, loc);
    }

    fn lex_char(&self) -> Token {
        printf("unimplemented [`lex_char()`]");
        exit(1);
    }

    fn lex_id(&self) -> Token {
        let loc = Loc::new(&self->file, self->line, self->line_index, (:u64)0);
        let mut str = String::new(0);
        for let curr = self->curr in isalpha((:i32)self->curr) != 0 {
            str.push(self->curr);
            self->advance();
        }
        if str.eq_ptr("let") { return Token::new(str, TokenType::KwLet, loc); }
        if str.eq_ptr("mut") { return Token::new(str, TokenType::KwMut, loc); }
        if str.eq_ptr("const") { return Token::new(str, TokenType::KwConst, loc); }
        if str.eq_ptr("struct") { return Token::new(str, TokenType::KwStruct, loc); }
        if str.eq_ptr("if") { return Token::new(str, TokenType::KwIf, loc); }
        if str.eq_ptr("else") { return Token::new(str, TokenType::KwElse, loc); }
        if str.eq_ptr("for") { return Token::new(str, TokenType::KwFor, loc); }
        if str.eq_ptr("while") { return Token::new(str, TokenType::KwWhile, loc); }
        if str.eq_ptr("fn") { return Token::new(str, TokenType::KwFn, loc); }
        if str.eq_ptr("return") { return Token::new(str, TokenType::KwRet, loc); }
        if str.eq_ptr("in") { return Token::new(str, TokenType::KwIn, loc); }
        if str.eq_ptr("include") { return Token::new(str, TokenType::KwInclude, loc); }
        if str.eq_ptr("impl") { return Token::new(str, TokenType::KwImpl, loc); }
        if str.eq_ptr("type") { return Token::new(str, TokenType::KwType, loc); }
        if str.eq_ptr("static") { return Token::new(str, TokenType::KwStatic, loc); }
        if str.eq_ptr("match") { return Token::new(str, TokenType::KwMatch, loc); }
        if str.eq_ptr("trait") { return Token::new(str, TokenType::KwTrait, loc); }
        if str.eq_ptr("macro") { return Token::new(str, TokenType::KwMacro, loc); }
        if str.eq_ptr("enum") { return Token::new(str, TokenType::KwEnum, loc); }
        if str.eq_ptr("sizeof") { return Token::new(str, TokenType::KwSizeOf, loc); }
        return Token::new(str, TokenType::Id, loc);
    }

    fn next_token(&mut self) -> Token {
        for let w = 0 in self->index < self->len {
            for let l = 0 in isspace((:i32)self->curr) != 0 {
                if self->curr == (:i8)10 {
                    self->advance();
                    self->line = self->line + (:u64)1;
                    self->line_index = (:u64)0;
                }else {
                    self->advance();
                }
            }

            if self->curr == '.' { return self->advance_token(Token::new(String::from("."), TokenType::Dot, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == ',' { return self->advance_token(Token::new(String::from(","), TokenType::Comma, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == ';' { return self->advance_token(Token::new(String::from(";"), TokenType::Semi, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == ':' {
                if self->src[self->index + 1] == ':' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("::"), TokenType::OpScope, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from(":"), TokenType::Colon, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '+' { return self->advance_token(Token::new(String::from("+"), TokenType::OpPlus, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '-' {
                if self->src[self->index + 1] == '>' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("->"), TokenType::Arrow, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from("-"), TokenType::OpMinus, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '*' { return self->advance_token(Token::new(String::from("*"), TokenType::OpMul, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '/' {
                if self->src[self->index + 1] == '/' {
                    //TODO:
                    //for w in self->curr != '\n' {
                    //    self->advance();
                    //}
                }
                return self->advance_token(Token::new(String::from("/"), TokenType::OpDiv, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '%' { return self->advance_token(Token::new(String::from("%"), TokenType::OpMod, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '[' { return self->advance_token(Token::new(String::from("["), TokenType::BraceLeft, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == ']' { return self->advance_token(Token::new(String::from("]"), TokenType::BraceRight, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '{' { return self->advance_token(Token::new(String::from("{"), TokenType::CurlyLeft, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '}' { return self->advance_token(Token::new(String::from("}"), TokenType::CurlyRight, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '(' { return self->advance_token(Token::new(String::from("("), TokenType::ParanLeft, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == ')' { return self->advance_token(Token::new(String::from(")"), TokenType::ParanRight, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '#' { return self->advance_token(Token::new(String::from("#"), TokenType::Hash, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '$' { return self->advance_token(Token::new(String::from("$"), TokenType::Dollar, Loc::new(&self->file, self->line, self->line_index, (:u64)0))); }
            if self->curr == '<' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("<="), TokenType::OpLeEq, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from("<"), TokenType::AngleLeft, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '>' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from(">="), TokenType::OpGrEq, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from(">"), TokenType::AngleRight, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '&' {
                if self->src[self->index + 1] == '&' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("&&"), TokenType::OpAnd, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from("&"), TokenType::Ampercent, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '|' {
                if self->src[self->index + 1] == '|' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("||"), TokenType::OpOr, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from("|"), TokenType::Pipe, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '!' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("!="), TokenType::OpNeEq, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from("!"), TokenType::Bang, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == '=' {
                if self->src[self->index + 1] == '=' {
                    self->advance();
                    return self->advance_token(Token::new(String::from("=="), TokenType::OpEqEq, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
                }
                return self->advance_token(Token::new(String::from("="), TokenType::Equals, Loc::new(&self->file, self->line, self->line_index, (:u64)0)));
            }
            if self->curr == (:i8)39 {
                self->advance();
                return self->lex_char();
            }
            if self->curr == (:i8)0 {
                return Token::new(String::from(""), TokenType::Eof, Loc::new(&self->file, self->line, self->line_index, (:u64)0));
            }
            if isdigit((:i32)self->curr) != 0 {
                return self->lex_number();
            }
            if isalpha((:i32)self->curr) != 0 {
                return self->lex_id();
            }
        }
        return Token::new(String::from(""), TokenType::Eof, Loc::new(&self->file, self->line, self->line_index, (:u64)0));
    }

    fn collect_tokens(&mut self) -> VecToken {
        let tokens = VecToken::new();
        for let mut tok = self->next_token() in tok.typ != TokenType::Eof {
            tokens.push(tok);
            tok = self->next_token();
        }
        return tokens;
    }
}

struct Scope {};

enum ASTType {
    //statements
    Mod,
    Function,
    Closure,
    VarDecl,

    //expr
    AssignmentExpr,
    MemberExpr,
    IfStmt,
    ForStmt,
    MatchStmt,
    CallExpr,
    AccessExpr,
    UnaryExpr,
    ResolutionExpr,
    CastExpr,
    ReturnExpr,

    //literals
    StructDef,
    EnumDef,
    Impl,
    Trait,
    Macro,
    MacroCall,
    MacroInclude,
    MacroSizeOf,
    TypeAlias,
    NumberLiteral,
    StringLiteral,
    InitializerList,
    StaticLiterial,
    BinaryExpr,
    Id,
}

struct AST {
    typ: ASTType;
    loc: Loc;
};

Vec$(AST, *AST);

struct Block {
    content: VecAST;
    index: u64;
    returns: bool;
};

impl Block {
    fn new() -> Block {
        let this: Block = {
            .content = VecAST::new(),
            .index = (:u64)0,
            .returns = (:bool)0,
        };
        return this;
    }

    fn from(content: &VecAST) -> Block {
        let this: Block = {
            .content = content->clone(),
            .index = (:u64)0,
            .returns = (:bool)0,
        };
        return this;
    }

    fn increment(&mut self) {
        self->index = self->index + (:u64)1;
    }

    fn insert(&mut self, other: &Block) {
        self->content.insert((:i32)self->index, &other->content);
    }

    fn push(&mut self, item: *AST) {
        self->content.push(item);
    }
}

struct Mod {
    typ: ASTType;
    loc: Loc;
    body: Block;
    current_block: *Block;
};

impl Mod {
    fn new() -> *Mod {
        let mod_size: i32 = sizeof(Mod);
        let mod = (:*Mod)malloc(mod_size);
        mod->typ = ASTType::Mod;
        mod->loc = Loc::new((:&String)0, (:u64)0, (:u64)0, (:u64)0);
        mod->body = Block::new();
        mod->current_block = &mod->body;
        return mod;
    }
}

struct Parser {
    tokens: VecToken;
    index: u64;
};

impl Parser {
    fn from_lexer(lexer: &Lexer) -> Parser {
        let this: Parser = {
            .tokens = lexer->collect_tokens(),
            .index = (:u64)0,
        };
        return this;
    }

    fn from_tokens(tokens: &VecToken) -> Parser {
        let this: Parser = {
            .tokens = tokens->clone(),
            .index = (:u64)0,
        };
        return this;
    }

    fn at(&self) -> Token {
        return self->tokens.data[self->index];
    }

    fn eat(&mut self) -> Token {
        let tok = self->tokens.data[self->index];
        self->index = self->index + (:u64)1;
        return tok;
    }

    fn peek(&self, offset: u64) -> Token {
        return self->tokens.data[self->index + offset];
    }

    fn parse_globals(&self) -> *AST {
        return (:*AST)0;
    }

    fn build_ast(&self) -> *Mod {
        let mod = Mod::new();
        for let tok = self->at() in tok.typ != TokenType::Eof {
            mod->body.push(self->parse_globals());
            tok = self->at();
        }
        return mod;
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

    let lexer = Lexer::new("let x = 10;\nx = 10;", 19, String::from("test.ly"));
    println$("src -> %s", lexer.src);
    let tokens = lexer.collect_tokens();
    for let mut index = 0 in index < tokens.len {
        let t: Token = tokens.data[index];
        printf("%s:%.3d:%.2d -> %.2d | %s\n", t.loc.file->data, t.loc.line, t.loc.start, t.typ, t.value.data);
        index = index + 1;
    }
    return 0;
}
