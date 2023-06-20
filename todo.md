# IMPORTANT
* !!!! move scopes into their apropriate block[outlive function scope and persist as long as the AST lives];
  at the lowering stage, collect all types eg. strcuts(&impls), enums, functions, type-aliases, traits
  -> remove dependence on order of declaration
* fix nested control-flow structures
* [control-flow]: remove ret-block if control-flow structure is last item in function
* sanatize AST lowering (void Expr::Sanatize() & integrety of Mod::Insert()/Replace())

# TODO/FIXME
* move parsing of index expr up in the call chain
* move parsing of unary exprs, so that they take priority over assignment
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
