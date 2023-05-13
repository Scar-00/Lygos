# IMPORTANT
* sanatize AST lowering (void Expr::Sanatize() & integrety of Mod::Insert()/Replace())
* Traverse AST pre code gen(lower it) to get better type information/inferance

# TODO/FIXME
* compare types at assignment, decl, ...
* add var-arg as special function type
* determine if expr result of if/for/while are valid values
* rewrite return instructions (return block)
* redo initializers parsing

#AST building
- Expr <--------|
- Cond <------| | [respect precedence]
   \ ---------| |
- Additive <--| |
   \ ---------| |
- Mutlipl <---| |
   \ ---------| |
- Assignment ---|
   \            |
- Call ---------|
   \            |
- Member -------|
   \            |
- Resolution ---|
   \            |
- Index --------|
   \            |
- Unary --------|
   \            |
- Initializer --|
   \            |
- Paran --------|
   \            |
- Cast ---------|
   \ 
- Primary
