# IMPORTANT
* sanatize AST lowering (void Expr::Sanatize() & integrety of Mod::Insert()/Replace())

# TODO/FIXME
* fix macros/include (ast replacement[re set block after expr is lowered])
* rethink macro args
* compare types at assignment, decl, ...
* add var-arg as special function type
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
