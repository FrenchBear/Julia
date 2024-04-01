# methods.jl
# Play with julia methods
# 
# 2024-03-29    PV      First version

# When defining a function, one can optionally constrain the types of parameters it is applicable to, using the :: type-assertion operator
f(x::Float64, y::Float64) = 2x + y

# This function definition applies only to calls where x and y are both values of type Float64
println(f(2.0, 3.0))    # 7.0

# Applying it to any other types of arguments will result in a MethodError:
# f(2.0, 3)               # ERROR: MethodError: no method matching f(::Float64, ::Int64)
# f(Float32(2.0), 3.0)    # ERROR: MethodError: no method matching f(::Float32, ::Float64)
# f(2.0, "3.0")           # ERROR: MethodError: no method matching f(::Float64, ::String)
# f("2.0", "3.0")         # ERROR: MethodError: no method matching f(::String, ::String)

# The arguments must be precisely of type Float64. Other numeric types, such as integers or 32-bit floating-point values,
# are not automatically converted to 64-bit floating-point, nor are strings parsed as numbers.
# Because Float64 is a concrete type and concrete types cannot be subclassed in Julia, such a definition can only be applied
# to arguments that are exactly of type Float64. It may often be useful, however, to write more general methods where
# the declared parameter types are abstract
f(x::Number, y::Number) = 2x - y
println(f(2.0, 3))      # 1.0

# This method definition applies to any pair of arguments that are instances of Number. They need not be of the same type,
# so long as they are each numeric values.
# The problem of handling disparate numeric types is delegated to the arithmetic operations in the expression 2x - y.

# To define a function with multiple methods, one simply defines the function multiple times, with different numbers and types of arguments.
# The first method definition for a function creates the function object, and subsequent method definitions add new methods to the existing function object.
# The most specific method definition matching the number and types of the arguments will be executed when the function is applied.

# In this example, if both arguments are Float64, then the pirst version 2x+y is used.
# If one of the arguments is a 64-bit float but the other one is not, then the f(Float64,Float64) method cannot be called
# and the more general f(Number,Number) method must be used
println(f(2.0, 3.0))    # 7.0
println(f(2.0, 3))      # 1.0

# For non-numeric values, and for fewer or more than two arguments, the function f remains undefined, and applying it will still result in a MethodError

# To see methods of a function
println(methods(f))
# 2 methods for generic function "f" from Main:
# [1] f(x::Float64, y::Float64)
# @ C:\Development\GitHub\Julia\Learning\13_methods\methods.jl:7
# [2] f(x::Number, y::Number)
# @ C:\Development\GitHub\Julia\Learning\13_methods\methods.jl:23

# In the absence of a type declaration with ::, the type of a method parameter is Any by default, thus we can define a catch-all method for f like so
f(x, y) = println("Whaaaaaat???")
# Note that in the signature of this method, there is no type specified for the arguments x and y. This is a shortened way of expressing f(x::Any, y::Any)

f("foo", 1)     # Whaaaaaat???  (calling function through println() would also print function result, that is, nothing)

# lthough it seems a simple concept, multiple dispatch on the types of values is perhaps the single most powerful and central feature of the Julia language.
# Core operations typically have dozens of methods
println(length(methods(+)))     # 189 (and there is no char/string concatenation here!)


# ---------------------------------------------------------------------
# Method specializations

# When you create multiple methods of the same function, this is sometimes called "specialization." In this case, you're specializing the function
# by adding additional methods to it: each new method is a new specialization of the function. As shown above, these specializations are returned by methods.

# There's another kind of specialization that occurs without programmer intervention: Julia's compiler can automatically specialize the method
# for the specific argument types used. Such specializations are not listed by methods, as this doesn't create new Methods,
# but tools like @code_typed allow you to inspect such specializations.

# For example, if you create a method
mysum(x::Real, y::Real) = x + y

# you've given the function mysum one new method (possibly its only method), and that method takes any pair of Real number inputs. But if you then execute
mysum(1, 2)
mysum(1.0, 2.0)

# Julia will compile mysum twice, once for x::Int, y::Int and again for x::Float64, y::Float64. The point of compiling twice is performance:
# the methods that get called for + (which mysum uses) vary depending on the specific types of x and y, and by compiling different specializations
# Julia can do all the method lookup ahead of time. This allows the program to run much more quickly, since it does not have to bother
# with method lookup while it is running. Julia's automatic specialization allows you to write generic algorithms and expect that the compiler
# will generate efficient, specialized code to handle each case you need.

# https://stackoverflow.com/questions/61837154/how-to-tell-what-specializations-are-compiled-for-a-method
using MethodAnalysis

println(methodinstances(mysum))
# Core.MethodInstance[MethodInstance for mysum(::Int64, ::Int64), MethodInstance for mysum(::Float64, ::Float64)]
println()


# ---------------------------------------------------------------------
# Method ambiguities

# It is possible to define a set of function methods such that there is no unique most specific method applicable to some combinations of arguments.
# In such cases, Julia raises a MethodError rather than arbitrarily picking a method. You can avoid method ambiguities by specifying an appropriate
# method for the intersection case

g(x::Float64, y) = 2x + y
g(x, y::Float64) = x + 2y

g(2.0, 3)       # 7.0
g(2, 3.0)       # 8.0
# g(2.0, 3.0)   # ERROR: MethodError: g(::Float64, ::Float64) is ambiguous.
# Candidates:
#   g(x, y::Float64)
#     @ Main none:1
#   g(x::Float64, y)
#     @ Main none:1
# Possible fix, define
#  g(::Float64, ::Float64)

# It is recommended that the disambiguating method be defined first, since otherwise the ambiguity exists, if transiently, until the more specific method is defined.


# ---------------------------------------------------------------------
# Parametric methods

# Method definitions can optionally have type parameters qualifying the signature

same_type(x::T, y::T) where {T} = true      # same_type (generic function with 1 method)
same_type(x, y) = false                     # same_type (generic function with 2 methods)     (catch all method)

println(same_type(1, 2))                    # true
println(same_type(1, 2.0))                  # false
println(same_type(1.0, 2.0))                # true
println(same_type("foo", 2.0))              # false
println(same_type("foo", "bar"))            # true
println(same_type(Int32(1), Int64(2)))      # false
println()

# Here's an example where the method type parameter T is used as the type parameter to the parametric type Vector{T} in the method signature
# The type of the appended element must match the element type of the vector it is appended to, or else a MethodError is raised
myappend(v::Vector{T}, x::T) where {T} = [v..., x]
myappend([1,2,3],4)                         # 4-element Vector{Int64}: [1, 2, 3, 4]
myappend([1,2,3],2.5)                       # ERROR: MethodError: no method matching myappend(::Vector{Int64}, ::Float64)
myappend([1.0,2.0,3.0],4.0)                 # 4-element Vector{Float64}: [1.0, 2.0, 3.0, 4.0]
myappend([1.0,2.0,3.0],4)                   # ERROR: MethodError: no method matching myappend(::Vector{Float64}, ::Int64)


# In the following example, the method type parameter T is used as the return value:
mytypeof(x::T) where {T} = T                # mytypeof (generic function with 1 method)
println(mytypeof(1))                        # Int64
println(mytypeof(1.0))                      # Float64


# You can also constrain type parameters of methods:
same_type_numeric(x::T, y::T) where {T<:Number} = true
same_type_numeric(x::Number, y::Number) = false
println(same_type_numeric(1, 2))            # true
println(same_type_numeric(1, 2.0))          # false
println(same_type_numeric(1.0, 2.0))        # true
# println(same_type_numeric("foo", 2.0)))   # ERROR: MethodError: no method matching same_type_numeric(::String, ::Float64)

# Parametric methods allow the same syntax as where expressions used to write types (see UnionAll Types).
# If there is only a single parameter, the enclosing curly braces (in where {T}) can be omitted, but are often preferred for clarity.
# Multiple parameters can be separated with commas, e.g. where {T, S<:Real}, or written using nested where, e.g. where S<:Real where T


# ---------------------------------------------------------------------
# Redefining methods

