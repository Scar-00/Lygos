# IMPORTANT
* [control-flow]: remove ret-block if control-flow structure is last item in function
* sanatize AST lowering (void Expr::Sanatize() & integrety of Mod::Insert()/Replace())

# TODO/FIXME
* move parsing of index expr up in the call chain
* compare types at assignment, decl, ...
* add var-arg as special function type
* add RAII support

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
