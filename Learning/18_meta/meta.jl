# Test of Julia metaprogramming
#
# 2024-04-15    PV

# Warning!

# Metaprogramming is a powerful tool, but it introduces complexity that can make code more difficult to understand.
# For example, it can be surprisingly hard to get scope rules correct. Metaprogramming should typically be used only
# when other approaches such as higher order functions and closures cannot be applied.

# eval and defining new macros should be typically used as a last resort. It is almost never a good idea to use
# Meta.parse or convert an arbitrary string into Julia code. For manipulating Julia code, use the Expr data structure
# directly to avoid the complexity of how Julia syntax is parsed.

# The best uses of metaprogramming often implement most of their functionality in runtime helper functions, striving to
# minimize the amount of code they generate.


# Program representation
# Every Julia program starts life as a string:

prog = "1 + 1"

# The next step is to parse each string into an object called an expression, represented by the Julia type Expr:

ex1 = Meta.parse(prog)      # :(1 + 1)
typeof(ex1)                 # Expr

# Expr objects contain two parts:
# - a Symbol identifying the kind of expression. A symbol is an interned string identifier (more discussion below).
ex1.head                    # :call
# - the expression arguments, which may be symbols, other expressions, or literal values:
ex1.args                    # 3-element Vector{Any}: [:+, 1, 1]

# Expressions may also be constructed directly in prefix notation:
ex2 = Expr(:call, :+, 1, 1) # :(1 + 1)

# The two expressions constructed above – by parsing and by direct construction – are equivalent:
ex1 == ex2                  # true

# The key point here is that Julia code is internally represented as a data structure that is accessible from the
# language itself.
# The dump function provides indented and annotated display of Expr objects:
dump(ex2)
# Expr
#   head: Symbol call
#   args: Array{Any}((3,))
#     1: Symbol +
#     2: Int64 1
#     3: Int64 1

# Expr objects may also be nested:
ex3 = Meta.parse("(4 + 4) / 2")     # :((4 + 4) / 2)

# Another way to view expressions is with Meta.show_sexpr, which displays the S-expression form of a given Expr, which
# may look very familiar to users of Lisp. Here's an example illustrating the display on a nested Expr:
Meta.show_sexpr(ex3)                # (:call, :/, (:call, :+, 4, 4), 2)


# Symbols

# The : character has two syntactic purposes in Julia. The first form creates a Symbol, an interned string used as one
# building-block of expressions, from valid identifiers:
s = :foo                # :foo
typeof(s)               # Symbol

# The Symbol constructor takes any number of arguments and creates a new symbol by concatenating their string
# representations together:
:foo === Symbol("foo")  # true

Symbol("1foo")          # `:1foo` would not work, as `1foo` is not a valid identifier --> Symbol("1foo")
Symbol("func",10)       # :func10
Symbol(:var,'_',"sym")  # :var_sym

# In the context of an expression, symbols are used to indicate access to variables; when an expression is evaluated, a
# symbol is replaced with the value bound to that symbol in the appropriate scope.

# Sometimes extra parentheses around the argument to : are needed to avoid ambiguity in parsing:
:(:)                    # :(:)
:(::)                   # :(::)

