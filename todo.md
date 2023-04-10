# IMPORTANT
* **Traverse AST pre code gen(lower it) to get better type information/inferance**

# TODO/FIXME
* compare types at assignment, decl, ...
* add var-arg as special function type
* [fix order of precedence in operations!!!]
* determine if expr result of if/for/while are valid values
* deref '->' operator and '(*x).x'
* rewrite return instructions (return block)
* fix escape sequences
* rethink parser (this is not it)
* fix deref

#AST building
- Expr <--------|
- Cond <------| | [respect precedence]
   \ ---------| |
- Additive <--| |
   \ ---------| |
- Mutlipl <---| |
   \ ---------| |
- Assignment ---| [these are all of equal precedence]
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
