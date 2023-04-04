# IMPORTANT
* fix prescedence (how to the ast is build up -> which instrcutions are executed first)
* **Traverse AST pre code gen to get better type information/inferance**

# TODO/FIXME
* compare types at assignment, decl, ...
* add var-arg as special function type
* [fix order of precedence in operations!!!]
* determine if expr result of if/for/while are valid values
* deref '->' operator and '(*x).x'
* rewrite return instructions (return block)
* fix escape sequences

#AST building
- Expr <--------|
   \            |
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
- Cond <------| | 
   \----------| |
- Additive <--| |
   \----------| |
- Mutlipl <---| |
   \----------| |
- Paran --------|
   \            |
- Cast ---------|
   \ 
- Primary
