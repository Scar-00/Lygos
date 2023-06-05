# IMPORTANT
* [control-flow]: remove ret-block if control-flow structure is last item in function
* sanatize AST lowering (void Expr::Sanatize() & integrety of Mod::Insert()/Replace())

# TODO/FIXME
* compare types at assignment, decl, ...
* add var-arg as special function type
* rewrite return instructions (return block)

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
