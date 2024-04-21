# methods.jl
# Play with julia methods (Julia manual §12)
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

# Although it seems a simple concept, multiple dispatch on the types of values is perhaps the single most powerful and central feature of the Julia language.
# Core operations typically have dozens of methods
println("length(methods(+)): ", length(methods(+)))     # 189 (and there is no char/string concatenation here!)
println()


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

println("methods(mysum): $(methods(mysum))\n")      # List one defined method

# https://stackoverflow.com/questions/61837154/how-to-tell-what-specializations-are-compiled-for-a-method
using MethodAnalysis
println(methodinstances(mysum))                     # List two instances
# Core.MethodInstance[MethodInstance for mysum(::Int64, ::Int64), MethodInstance for mysum(::Float64, ::Float64)]
println()

# Check that Union{X,Y} actually builds two method instances, one for type X and ont for type Y
Zap(x::Union{String, Nothing})::Int = return isnothing(x) ? 0 : length(x)
Zap("Hello")
Zap(nothing)
println(methodinstances(Zap))                     # List two instances:[MethodInstance for Zap(::String), MethodInstance for Zap(::Nothing)]
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
myappend([1, 2, 3], 4)                         # 4-element Vector{Int64}: [1, 2, 3, 4]
# myappend([1, 2, 3], 2.5)                     # ERROR: MethodError: no method matching myappend(::Vector{Int64}, ::Float64)
myappend([1.0, 2.0, 3.0], 4.0)                 # 4-element Vector{Float64}: [1.0, 2.0, 3.0, 4.0]
# myappend([1.0, 2.0, 3.0], 4)                 # ERROR: MethodError: no method matching myappend(::Vector{Float64}, ::Int64)


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
println()

# Parametric methods allow the same syntax as where expressions used to write types (see UnionAll Types).
# If there is only a single parameter, the enclosing curly braces (in where {T}) can be omitted, but are often preferred for clarity.
# Multiple parameters can be separated with commas, e.g. where {T, S<:Real}, or written using nested where, e.g. where S<:Real where T


# ---------------------------------------------------------------------
# Function-like objects

# Methods are associated with types, so it is possible to make any arbitrary Julia object "callable" by adding methods to its type.
# Such "callable" objects are sometimes called "functors."

# For example, you can define a type that stores the coefficients of a polynomial, but behaves like a function evaluating the polynomial:
struct Polynomial{R}
    coeffs::Vector{R}
end

# Notice that the function is specified by type instead of by name. As with normal functions there is a terse syntax form.
function (p::Polynomial)(x)
    v = p.coeffs[end]
    for i = (length(p.coeffs)-1):-1:1
        v = v * x + p.coeffs[i]
    end
    return v
end

# In the function body, p will refer to the object that was called. A Polynomial can be used as follows:
p = Polynomial([1, 10, 100])    # Polynomial{Int64}([1, 10, 100])
println(p(3))   # 931
println()


# ---------------------------------------------------------------------
# Method design and the avoidance of ambiguities

# Julia's method polymorphism is one of its most powerful features, yet exploiting this power can pose design challenges.
# In particular, in more complex method hierarchies it is not uncommon for ambiguities to arise.

# One can resolve ambiguities like
f(x, y::Int) = 1
f(x::Int, y) = 2

# by defining a method
f(x::Int, y::Int) = 3

# This is often the right strategy; however, there are circumstances where following this advice mindlessly can be counterproductive.
# In particular, the more methods a generic function has, the more possibilities there are for ambiguities.
# When your method hierarchies get more complicated than this simple example, it can be worth your while
# to think carefully about alternative strategies.

# Below we discuss particular challenges and some alternative ways to resolve such issues.


# Tuple and NTuple arguments
#uple (and NTuple) arguments present special challenges. For example,
f(x::NTuple{N,Int}) where {N} = 1
f(x::NTuple{N,Float64}) where {N} = 2

# are ambiguous because of the possibility that N == 0: there are no elements to determine whether the Int or Float64
# variant should be called. To resolve the ambiguity, one approach is define a method for the empty tuple:
f(x::Tuple{}) = 3

# Alternatively, for all methods but one you can insist that there is at least one element in the tuple:
f(x::NTuple{N,Int}) where {N} = 1           # this is the fallback
f(x::Tuple{Float64,Vararg{Float64}}) = 2   # this requires at least one Float64


# Orthogonalize your design
# When you might be tempted to dispatch on two or more arguments, consider whether a "wrapper" function might make
# for a simpler design. For example, instead of writing multiple variants:
# f(x::A, y::A) = ...
# f(x::A, y::B) = ...
# f(x::B, y::A) = ...
# f(x::B, y::B) = ...

# you might consider defining
# f(x::A, y::A) = ...
# f(x, y) = f(g(x), g(y))

# where g converts the argument to type A. This is a very specific example of the more general principle of orthogonal design,
# in which separate concepts are assigned to separate methods. Here, g will most likely need a fallback definition
# g(x::A) = x

#A related strategy exploits promote to bring x and y to a common type:
# f(x::T, y::T) where {T} = ...
# f(x, y) = f(promote(x, y)...)

# One risk with this design is the possibility that if there is no suitable promotion method converting x and y to the same type,
# the second method will recurse on itself infinitely and trigger a stack overflow.


# Dispatch on one argument at a time
# If you need to dispatch on multiple arguments, and there are many fallbacks with too many combinations to make it practical
# to define all possible variants, then consider introducing a "name cascade" where (for example) you dispatch 
# on the first argument and then call an internal method:
# f(x::A, y) = _fA(x, y)
# f(x::B, y) = _fB(x, y)

# Then the internal methods _fA and _fB can dispatch on y without concern about ambiguities with each other with respect to x.
# Be aware that this strategy has at least one major disadvantage: in many cases, it is not possible for users to further
# customize the behavior of f by defining further specializations of your exported function f. Instead, they have to define
# specializations for your internal methods _fA and _fB, and this blurs the lines between exported and internal methods.


# Abstract containers and element types
# Where possible, try to avoid defining methods that dispatch on specific element types of abstract containers. For example,
# -(A::AbstractArray{T}, b::Date) where {T<:Date}

# generates ambiguities for anyone who defines a method
# -(A::MyArrayType{T}, b::T) where {T}

# The best approach is to avoid defining either of these methods: instead, rely on a generic method -(A::AbstractArray, b)
# and make sure this method is implemented with generic calls (like similar and -) that do the right thing for each
# container type and element type separately. This is just a more complex variant of the advice to orthogonalize your methods.

# When this approach is not possible, it may be worth starting a discussion with other developers about resolving the ambiguity; just because one method was defined first does not necessarily mean that it can't be modified or eliminated. As a last resort, one developer can define the "band-aid" method
# -(A::MyArrayType{T}, b::Date) where {T<:Date} = ...
# that resolves the ambiguity by brute force.


# Complex method "cascades" with default arguments
# If you are defining a method "cascade" that supplies defaults, be careful about dropping any arguments that correspond
# to potential defaults. For example, suppose you're writing a digital filtering algorithm and you have a method
# that handles the edges of the signal by applying padding:
# function myfilter(A, kernel, ::Replicate)
#     Apadded = replicate_edges(A, size(kernel))
#     myfilter(Apadded, kernel)  # now perform the "real" computation
# end

# This will run afoul of a method that supplies default padding:
# myfilter(A, kernel) = myfilter(A, kernel, Replicate()) # replicate the edge by default
# Together, these two methods generate an infinite recursion with A constantly growing bigger.

# The better design would be to define your call hierarchy like this:
# struct NoPad end  # indicate that no padding is desired, or that it's already applied
# myfilter(A, kernel) = myfilter(A, kernel, Replicate())  # default boundary conditions
# 
# function myfilter(A, kernel, ::Replicate)
#     Apadded = replicate_edges(A, size(kernel))
#     myfilter(Apadded, kernel, NoPad())  # indicate the new boundary conditions
# end

# other padding methods go here
# function myfilter(A, kernel, ::NoPad)
#     # Here's the "real" implementation of the core computation
# end

# NoPad is supplied in the same argument position as any other kind of padding, so it keeps the dispatch hierarchy
# well organized and with reduced likelihood of ambiguities. Moreover, it extends the "public" myfilter interface:
# a user who wants to control the padding explicitly can call the NoPad variant directly.


# ---------------------------------------------------------------------
# Defining methods in local scope

# You can define methods within a local scope, for example
function f(x)
    g(y::Int) = y + x
    g(y) = y - x
    g
end

h = f(3)
h(4)        # 7
h(4.0)      # 1.0

# However, you should not define local methods conditionally or subject to control flow, as in
#function f2(inc)
#    if inc
#        g(x) = x + 1
#    else
#        g(x) = x - 1
#    end
#end
#
#function f3()
#    function g end
#    return g
#    g() = 0
#end
# as it is not clear what function will end up getting defined. In the future, it might be an error to define local methods in this manner.

# For cases like this use anonymous functions instead:
function f2(inc)
    g = if inc
        x -> x + 1
    else
        x -> x - 1
    end
end
