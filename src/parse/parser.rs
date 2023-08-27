pub mod Parser {
    use std::path::PathBuf;

    use crate::ast::ast::AST::{Mod, AST};
    use crate::lexer::lexer::Lexer::{Lexer, Loc, Token};
    use crate::types::TokenType;

    pub struct Parser {
        tokens: Vec<Token>,
        index: usize,
    }

    impl Parser {
        pub fn new(lexer: &mut Lexer) -> Self {
            let mut parser = Parser {
                tokens: lexer.get_tokens(),
                index: 0,
            };
            parser.tokens.push(Token::new(
                "",
                TokenType::Eof,
                Loc::new(PathBuf::new(), 0, 0, 0),
            ));
            return parser;
        }

        pub fn from(tokens: Vec<Token>) -> Self {
            let mut parser = Parser { tokens, index: 0 };
            parser.tokens.push(Token::new(
                "",
                TokenType::Eof,
                Loc::new(PathBuf::new(), 0, 0, 0),
            ));
            return parser;
        }
    }
}
