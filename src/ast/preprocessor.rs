use crate::lexer::{Token, Tagged, Lexer};
use crate::types::TokenType;
use crate::log::{ErrorLabel, error_msg_label};
use crate::ast::r#macro::{MacroArm, MacroArgType, MacroArg, Macro, MacroCall, IntrinsicMarcos};

use std::collections::{HashMap, BTreeSet};
use std::path::Path;
use std::rc::Rc;

use path_absolutize::*;


/*
 *  TODO(S):
 *  add preprocessor types -> [ident, literal, expr, stmt, ..]
 *
 *  create parser and parse arg into ast -> check its type, see if it maches
 *  the type specified by the macro definition, if not error on incompatible
 *  type
 *
 */


/*
 *  FIXME(S):
 *  rethink how to validate, that every source file is only included once in the current
 *  context, so that so overlapping symbols may occur. Because it can not garuenteed, that there
 *  is only ever one paring context operating on one source tree
 *
 */

#[derive(Debug)]
pub struct DependencyGraph {
    included_files: BTreeSet<Rc<str>>,
}

impl DependencyGraph {
    pub fn new() -> DependencyGraph {
        Self{ included_files: BTreeSet::new() }
    }

    pub fn add_included_file(&mut self, file: Rc<str>) {
        self.included_files.insert(file);
    }

    pub fn is_file_included<S: AsRef<str>>(&self, file: S) -> bool {
        return self.included_files.contains(file.as_ref());
    }
}

pub struct TokenStream(pub Vec<Token>);

pub struct Preprocessor {
    macros: HashMap<String, Macro>,
    dependencies: DependencyGraph,
}

macro_rules! for_loop {
    ($id: ident = $val: expr ; $cond: expr; $inc: expr; $b: block) => {
        {
            let mut $id = $val;
            while $cond {
                $b
                $inc;
            }
        }
    };
}

impl Preprocessor {
    pub fn new() -> Self {
        Self{ macros: HashMap::new(), dependencies: DependencyGraph::new() }
    }

    pub fn add_macro(&mut self, m: Macro) {
        self.macros.insert(m.id.inner().clone(), m);
    }

    pub fn expand_macro(&self, call: &mut MacroCall) -> Option<TokenStream> {
        if IntrinsicMarcos.contains_key(call.id.inner().as_str()) {
            return None;
        }

        if !self.macros.contains_key(call.id.inner()) {
            error_msg_label("could not resolve macro", ErrorLabel::from(call.id.loc(), "unknwon macro"));
        }

        let m = self.macros.get(call.id.inner()).unwrap();
        let arms = &m.arms;
        let mut arm = 0;
        for i in 0..arms.len() {
            let MacroArm { conds, .. } = &arms[i];
            if conds.len() == 0 && call.args.len() == 0 {
                arm = i;
                break;
            }
            let mut single_args = 0;
            if conds.len() == call.args.len() {
                for j in 0..conds.len() {
                    if conds[j].typ == MacroArgType::Single {
                        single_args += 1;
                    }
                }
                if single_args == conds.len() {
                    arm = i;
                    break;
                }
            }

            if single_args >= call.args.len() {
                error_msg_label(
                    format!("insufficient args supplied to macro `{}`", m.id.inner()).as_str(),
                    ErrorLabel::from(call.id.loc(), "insufficient number of args")
                );
            }
            arm = i;
        }

        let MacroArm { conds, mut tokens } = arms[arm].clone();
        for i in 0..conds.len() {
            let MacroArg { id, typ } = &conds[i];
            for_loop!(j = 0; j < tokens.len(); j+=1; {
                if tokens[j].typ == TokenType::Dollar {
                    if tokens.len() >= j + 1 && tokens[j + 1].typ == TokenType::Id {
                        if tokens[j + 1].value == *id.inner() {
                            let toks = &call.args[i];
                            tokens.remove(j + 1);
                            if *typ == MacroArgType::Variadic {
                                tokens.remove(j);
                                for k in i..call.args.len() {
                                    let tok = Token::new(", ", TokenType::Comma, tokens[j].loc.clone());
                                    tokens.insert(j, tok);
                                    for t in call.args[call.args.len() - k].iter().rev().clone() {
                                        tokens.insert(j, t.clone());
                                    }
                                }
                            }else {
                                for (h, t) in toks.iter().enumerate() {
                                    if h == 0 {
                                        tokens[j] = t.clone();
                                    }else {
                                        tokens.insert(j + h, t.clone());
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }

        //token concatination & stringifing
        for_loop!(i = 0; i < tokens.len(); i+=1; {
            if tokens[i].typ == TokenType::Hash {
                if tokens.len() > i + 1 && tokens[i + 1].typ == TokenType::Hash {
                    if i == 0 {
                        todo!("error no way to concat");
                    }
                    tokens.remove(i);
                    tokens.remove(i);
                    match (&tokens[i].typ, &tokens[i].typ) {
                        (TokenType::Id, TokenType::Id) => {
                            let rhs = tokens[i].clone();
                            let lhs = &mut tokens[i - 1];
                            lhs.value += &rhs.value;
                            lhs.loc = lhs.loc.clone() + rhs.loc;
                            tokens.remove(i);
                        },
                        (TokenType::Id, _) => {
                            let lhs = &mut tokens[i - 1];
                            todo!("invalid lhs[{:#?}] to concat macro", lhs);
                        },
                        (_, TokenType::Id) => {
                            let rhs = tokens[i].clone();
                            todo!("invalid rhs[{:#?}] to concat macro", rhs);
                        },
                        _ => {
                            let rhs = tokens[i].clone();
                            let lhs = &mut tokens[i - 1];
                            todo!("{:#?}{:#?}", lhs, rhs);
                        },
                    }
                }else if tokens.len() > i + 1 {
                    //stringify the token
                }else {
                    todo!("no token to stringify");
                }
            }
        });
        //dbg!(&tokens);
        //if tokens.last().unwrap().typ == TokenType::Semi {
        //    tokens.remove(tokens.len() - 1);
        //}
        return Some(TokenStream{ 0: tokens });
    }

    pub fn expand_include<P: AsRef<Path>>(&mut self, file: Tagged<P>) -> TokenStream {
        let base = &file.loc().file.parent().unwrap().absolutize().unwrap();
        let joined = base.join(file.inner());
        let file_path = joined.absolutize().unwrap();

        if self.dependencies.is_file_included(file_path.to_str().unwrap()) {
            return TokenStream{ 0: Vec::new() };
        }

        let content = match crate::io::read_file(&file_path) {
            Ok(c) => c,
            Err(_) => crate::log::error_msg_label(
                format!("could not read file `{}`", file.inner().as_ref().to_str().unwrap()).as_str(),
                ErrorLabel::from(file.loc(), "could not read file"),
            ),
        };

        let mut lex = Lexer::from(&content, &file_path.to_path_buf());
        self.dependencies.add_included_file(file_path.to_str().unwrap().into());
        return TokenStream{ 0: lex.get_tokens() };
    }
}

/*
mod comptime {
    use crate::lexer::Tagged;
    use crate::types::Type as RuntimeType;
    use crate::ast::AST;

    pub enum Type {
        None,
        Type(RuntimeType),
        Expr(AST),
    }

    pub struct FunctionArg {
        id: Tagged<String>,
        ty: Type,
    }

    pub struct Function {
        id: Tagged<String>,
        params: Vec<FunctionArg>,
        ret_type: Type,
    }

    impl Function {
        pub fn new(id: Tagged<String>, params: Vec<FunctionArg>, ret_type: Type) -> Function {
            return Self{ id, params, ret_type };
        }
    }
}
*/
