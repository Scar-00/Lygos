pub mod lexer {
    use super::super::super::types::{KeyWords, TokenType};
    use std::path::PathBuf;

    #[derive(Debug, Clone)]
    pub struct Loc {
        pub file: PathBuf,
        pub start: usize,
        pub end: usize,
    }

    impl Loc {
        pub fn new(file: PathBuf, start: usize, end: usize) -> Self {
            return Self {
                file,
                start,
                end,
            };
        }
    }

    impl std::ops::Add for Loc {
        type Output = Loc;
        fn add(self, rhs: Self) -> Self::Output {
            Self::new(self.file, self.start, rhs.end)
        }
    }

    #[derive(Debug, Clone)]
    pub struct Tagged<T> {
        inner: T,
        loc: Loc,
    }

    impl<T> Tagged<T> {
        pub fn new(loc: Loc, value: T) -> Tagged<T> {
            return Self{ loc, inner: value };
        }

        pub fn inner(&self) -> &T {
            return &self.inner;
        }

        pub fn inner_mut(&mut self) -> &mut T {
            return &mut self.inner;
        }

        pub fn loc(&self) -> &Loc {
            return &self.loc;
        }
    }

    impl From<Token> for Tagged<String> {
        fn from(value: Token) -> Self {
            Self{ inner: value.value, loc: value.loc }
        }
    }

    #[derive(Debug, Clone)]
    pub struct Token {
        pub value: String,
        pub typ: TokenType,
        pub loc: Loc,
    }

    impl Token {
        pub fn new(value: &str, typ: TokenType, loc: Loc) -> Self {
            return Self {
                value: String::from(value),
                typ,
                loc,
            };
        }
    }

    pub struct Lexer {
        pub file: PathBuf,
        src: Vec<char>,
        curr: char,
        index: usize,
        line_index: usize,
    }

    impl Lexer {
        pub fn from(logic: &str, file: &PathBuf) -> Self {
            let mut parser = Self {
                file: file.clone(),
                src: logic.chars().collect(),
                curr: ' ',
                index: 0,
                line_index: 0,
            };
            parser.src.push('\0');
            parser.curr = parser.src[0];
            return parser;
        }

        pub fn get_tokens(&mut self) -> Vec<Token> {
            let mut token = self.next_token();
            let mut tokens = vec![];
            loop {
                tokens.push(token);
                token = self.next_token();
                if token.typ == TokenType::Eof {
                    break;
                }
            }
            return tokens;
        }

        fn advance(&mut self) {
            self.index += 1;
            self.curr = self.src[self.index];
            self.line_index += 1;
        }

        fn number(&mut self) -> Token {
            let mut value: String = String::new();
            let start = self.line_index;
            while self.curr.is_digit(10) || self.curr == '.' {
                value.push(self.curr);
                self.advance();
            }
            let loc = Loc::new(self.file.clone(), start, self.line_index);
            if value.contains(".") {
                return Token::new(value.as_str(), TokenType::Float, loc);
            }
            return Token::new(value.as_str(), TokenType::Integer, loc);
        }

        fn string(&mut self) -> Token {
            let mut value: String = String::new();
            let start = self.line_index;
            while self.curr != '\"' {
                value.push(self.curr);
                self.advance();
            }
            let loc = Loc::new(self.file.clone(), start, self.line_index);
            self.advance();
            return Token::new(value.as_str(), TokenType::String, loc);
        }

        fn char(&mut self) -> Token {
            let mut value: String = String::new();
            let start = self.line_index;
            while self.curr != '\'' {
                value.push(self.curr);
                self.advance();
            }
            let loc = Loc::new(self.file.clone(), start, self.line_index);
            self.advance();
            return Token::new(value.as_str(), TokenType::Char, loc);
        }

        fn id(&mut self) -> Token {
            let mut value: String = String::new();
            let start = self.line_index;
            while self.curr.is_alphanumeric() || self.curr == '_' {
                value.push(self.curr);
                self.advance();
            }
            let loc = Loc::new(self.file.clone(), start, self.line_index);
            if let Some(typ) = KeyWords.get(&value.as_str()) {
                return Token::new(value.as_str(), typ.clone(), loc);
            }

            return Token::new(value.as_str(), TokenType::Id, loc);
        }

        fn advance_token(&mut self, token: Token) -> Token {
            self.advance();
            return token;
        }

        /*
        *   FIXME(S): multi character values
        */

        fn next_token(&mut self) -> Token {
            while self.curr != '\0' {
                while self.curr.is_whitespace() {
                    self.advance();
                }

                let loc = Loc::new(self.file.clone(), self.line_index, self.line_index + 1);
                match self.curr {
                    '.' => return self.advance_token(Token::new(".", TokenType::Dot, loc)),
                    ',' => return self.advance_token(Token::new(",", TokenType::Comma, loc)),
                    ';' => return self.advance_token(Token::new(";", TokenType::Semi, loc)),
                    ':' => match self.src[self.index + 1] {
                        ':' => {
                            self.advance();
                            return self.advance_token(Token::new("::", TokenType::OpScope, loc));
                        }
                        _ => return self.advance_token(Token::new(":", TokenType::Colon, loc)),
                    },
                    '+' => return self.advance_token(Token::new("+", TokenType::OpPlus, loc)),
                    '-' => match self.src[self.index + 1] {
                        '>' => {
                            self.advance();
                            return self.advance_token(Token::new("->", TokenType::Arrow, loc));
                        }
                        _ => return self.advance_token(Token::new("-", TokenType::OpMinus, loc)),
                    },
                    '*' => return self.advance_token(Token::new("*", TokenType::OpMul, loc)),
                    '/' => match self.src[self.index + 1] {
                        '/' => {
                            while self.curr != '\n' {
                                self.advance();
                            }
                            continue;
                        },
                        '*' => {
                            let mut braces = 0;
                            loop {
                                if self.curr == '/' && self.src[self.index + 1] == '*' {
                                    self.advance();
                                    self.advance();
                                    braces += 1;
                                }
                                if self.curr == '*' && self.src[self.index + 1] == '/' {
                                    self.advance();
                                    self.advance();
                                    braces -= 1;
                                    if braces == 0 {
                                        break;
                                    }
                                }
                                self.advance();
                                if self.curr == '\0' {
                                    break;
                                }
                            }
                            continue;
                        },
                        _ => return self.advance_token(Token::new("/", TokenType::OpDiv, loc)),
                    },
                    '%' => return self.advance_token(Token::new("%", TokenType::OpMod, loc)),
                    '[' => return self.advance_token(Token::new("[", TokenType::BraceLeft, loc)),
                    ']' => return self.advance_token(Token::new("]", TokenType::BraceRight, loc)),
                    '{' => return self.advance_token(Token::new("{", TokenType::CurlyLeft, loc)),
                    '}' => return self.advance_token(Token::new("}", TokenType::CurlyRight, loc)),
                    '(' => return self.advance_token(Token::new("(", TokenType::ParanLeft, loc)),
                    ')' => return self.advance_token(Token::new(")", TokenType::ParanRight, loc)),
                    '#' => return self.advance_token(Token::new("#", TokenType::Hash, loc)),
                    '$' => return self.advance_token(Token::new("$", TokenType::Dollar, loc)),
                    '<' => match self.src[self.index + 1] {
                        '=' => {
                            self.advance();
                            return self.advance_token(Token::new("<=", TokenType::OpLeEq, loc));
                        }
                        _ => return self.advance_token(Token::new("<", TokenType::AngleLeft, loc)),
                    },
                    '>' => match self.src[self.index + 1] {
                        '=' => {
                            self.advance();
                            return self.advance_token(Token::new(">=", TokenType::OpGrEq, loc));
                        }
                        _ => {
                            return self.advance_token(Token::new(">", TokenType::AngleRight, loc))
                        }
                    },
                    '&' => match self.src[self.index + 1] {
                        '&' => {
                            self.advance();
                            return self.advance_token(Token::new("&&", TokenType::OpAnd, loc));
                        }
                        _ => return self.advance_token(Token::new("&", TokenType::Ampercent, loc)),
                    },
                    '|' => match self.src[self.index + 1] {
                        '|' => {
                            self.advance();
                            return self.advance_token(Token::new("||", TokenType::OpOr, loc));
                        }
                        _ => return self.advance_token(Token::new("|", TokenType::Pipe, loc)),
                    },
                    '!' => match self.src[self.index + 1] {
                        '=' => {
                            self.advance();
                            return self.advance_token(Token::new("!=", TokenType::OpNeEq, loc));
                        }
                        _ => return self.advance_token(Token::new("!", TokenType::Bang, loc)),
                    },
                    '=' => match self.src[self.index + 1] {
                        '=' => {
                            self.advance();
                            return self.advance_token(Token::new("==", TokenType::OpEqEq, loc));
                        }
                        _ => return self.advance_token(Token::new("=", TokenType::Equals, loc)),
                    },

                    '\"' => {
                        self.advance();
                        return self.string();
                    }
                    '\'' => {
                        self.advance();
                        return self.char();
                    }
                    '\0' => return Token::new("", TokenType::Eof, loc),
                    _ => {
                        if self.curr.is_digit(10) {
                            return self.number();
                        }

                        if self.curr.is_alphabetic() {
                            return self.id();
                        }

                        panic!("unknown token found `{}`", self.curr);
                    }
                }
            }
            return Token::new("", TokenType::Eof, Loc::new(PathBuf::new(), self.line_index, self.line_index + 1));
        }
    }
}
