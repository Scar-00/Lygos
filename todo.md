# IMPORTANT
* call Parser::ParseIfExpr() at Parser::ParseStmt() instead of in PrimaryExpr 
* fix '*'/'&' "operator"  [unary expr]
* fix '=' after type in var decl
* fix gep for statically allocated arrays 

# TODO/FIXME
* compare types at assignment, decl, ...
* refactor for expr [determine functionality]
* add var-arg as special function type
* fix order of precedence in operations [maybe]
* determine if expr result of if/for/while are valid values
* add type casting [determine how they look (c-like | rust-like ?)]
* add struct impls

# Token:
- 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
