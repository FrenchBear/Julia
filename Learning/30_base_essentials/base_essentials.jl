# base_essentials.jl
# Restart reading Julia manual, Part II, page 495, 'Base', decribing Base module
# Chaper 41, Essentials (but still 138 pages...)
# 
# 2024-04-01    PV      First version

# Quit a Julia program
# exit(code=0)


# atexit: Function called when program exits (LIFO), before objects finalizers
function when_program_exits()
    println("\nThat's all, folks!")
end
atexit(when_program_exits)


# Test if running in interactive session
println(isinteractive())


# Get size of all objects reachable by the argument
m = [1.0 2.0; 3.0 4.0]
println("m=$m")
println("summarysize(m)=$(Base.summarysize(m))")    # 72, matrix and 4 Float64
println("sizeof(m)=$(sizeof(m))")                   # 32, just the matrix itself (canonical size)

# ans and err for interactive session contain last result, last error stackoverflow

# Project is a file listing modules loaded or available?
println(Base.active_project())


# -------------------------------------------------------------
# Some introspection

# Define two methods of f, one for integers, onr for reals
f(a::Integer, b::Integer) = a + b
f(a::AbstractFloat, b::AbstractFloat) = a * b
# Calls two specific combinations
f(Int32(3), Int16(4))
f(Float32(1.0), Float64(2.0))
println("methods(f): $(methods(f))\n")                                          # List the two defined methods
println("which(f, (Int32, Int16)): $(methods(f, (Int32, Int16)))\n")            # Call the (::Integer, ::Integer) for these types
println("which(f, (Float32, Float64)): $(methods(f, (Float32, Float64)))\n")    # Call the (::AbstractFloat, ::AbstractFloat) for these types

# https://stackoverflow.com/questions/61837154/how-to-tell-what-specializations-are-compiled-for-a-method
using MethodAnalysis
for m in methodinstances(f)         # List method instaces actually compiled, here we have 2 methods actually compiled (the two combinations called)
    println(m)
end
println()


# -------------------------------------------------------------
# @Show, print expression and results

@show m, res, f(3, 4)
println()


# -------------------------------------------------------------
# Modules

# Base.include(m::Module, path::AbstractString)     Evaluate the contents of the input source file in the global scope of module m
# Base.MainInclude(path::AbstractString)            Evaluate the contents of the input source file in the global scope of the containing module
# Base.include_string(m::Module, code::AbstractString)  Like include, except reads code from the given string rather than from a file
res = Base.include_string(Main, "8*7")
println(res)
println()

module Module1
const CONSTANT = 1.414
function __init__()
    println("Module1 is loaded and initialized")    # Doesn't appear to be called, don't know why
end
end

println("Before using Module1")
using .Module1
println("CONSTANT=$(Module1.CONSTANT)")
println("After using Module1")
println()


module Foo
import Base.show
export MyType, foo      # Tell Julia which functions should be made available to the user
struct MyType
    x
end
bar(x) = 2x
foo(a::MyType) = bar(a.x) + 1
show(io::IO, a::MyType) = print(io, "MyType $(a.x)")
end

# .Foo because Foo is a local module
using .Foo                  # using Foo will load the module or package Foo and make its exported names available for direct use
# Foo.x access the name x whether they are exported or not
# import .Foo               # Loads the module, without exported names imported, so Foo. prefix is required
println(foo(MyType(2.2)))
Foo.show(stdout, MyType(2.2))
println()

import .Foo: MyType as MT   # With as, can import and rename specific names
println(MT(3 + 2im))
println()

# Macro (not clear yet what means $name, syntax seems illegal outside macros)
macro sayhello(name)
    return :(println("Hello, ", $name, "!"))
end
@sayhello "Pierre"
println()


# -------------------------------------------------------------
# Blocks: do begin let quote

# do block - Create an anonymous function and pass it as the first argument to a function call
r = map(1:10) do x        # Equivalent to map(x->2x, 1:10)
    2x
end
println(r)

items = ["Bonjour", "à tous!"]
foreach(items) do the_item #= the following with =#
    println(the_item)
end
println()


list = [1, 2, 3, 4]
map(x -> x^2, list)

# is the same as
f1 = function (x)
    x^2
end
map(f1, list)

# is the same as
map(list) do x
    x^2
end

# common cases
# open("path", "w") do io
#     # something with io
# end

# mktempdir() do dir
#     # something with the temp dir
# end

lv = ["CS", "AW", "W", "GS", "SAS"]
filter(lv) do x
    occursin("A", x)
end


# begin block
# Usually begin will not be necessary, since keywords such as function and let implicitly begin blocks of code
begin
    println("Hello, ")
    println("World!")
end


# let block
# let blocks create a new hard scope and optionally introduce new local bindings.
#let var1 = value1, var2, var3 = value3
#    code
#end


# quote
# quote creates multiple expression objects in a block without using the explicit Expr constructor
ex = quote
    x = 1
    y = 2
    x + y
end
println(ex)
# Unlike the other means of quoting, :( ... ), this form introduces QuoteNode elements to the expression
# tree, which must be considered when directly manipulating the tree. For other purposes, :( ...) 
# and quote .. end blocks are treated identically


# -------------------------------------------------------------
# Misc 

# Multiple variables can be declared within a single const
const y, z = 7, 11
# Note that const only applies to one = operation, therefore 
const k1 = v2 = 1
# declares k1 to be constant but not v2.
# On the other hand, 
const k3 = const k4 = 1
# declares both k3 and k4 constant


# @kwdef
# This is a helper macro that automatically defines a keyword-based constructor for the type declared in
# the expression typedef, which must be a struct or mutable struct expression.
@kwdef struct FooBar
    a::Int = 1      # specified default
    b::String       # required keyword
end
println(FooBar(b="hi"))


# ; has a similar role in Julia as in many C-like languages, and is used to delimit the end of the previous statement.
# Adding ; at the end of a line in the REPL will suppress printing the result of that expression.
# In function declarations, and optionally in calls, ; separates regular arguments from keywords

# In array literals, arguments separated by semicolons have their contents concatenated together. A
# separator made of a single ; concatenates vertically (i.e. along the first dimension), ;; concatenates
# horizontally (second dimension), ;;; concatenates along the third dimension, etc. Such a separator
# can also be used in last position in the square brackets to add trailing dimensions of length 1.

# A ; in first position inside of parentheses can be used to construct a named tuple. The same (; ...)
# syntax on the left side of an assignment allows for property destructuring.

nt = (; x=1) # without the ; or a trailing comma this would assign to x
# (x = 1,)

key = :a;
c = 3;
nt2 = (; key => 1, b=2, c, nt.x)
# (a = 1, b = 2, c = 3, x = 1)
(; b, x) = nt2; # set variables b and x using property destructuring
println(b, ' ', x)      # 2 1
println()


# = is the assignment operator.
# • For variable a and expression b, a = b makes a refer to the value of b.
# • For functions f(x), f(x) = x defines a new function constant f, or adds a new method to f if f is already defined;
#   this usage is equivalent to function f(x); x; end.
# • a[i] = v calls setindex!(a,v,i).
# • a.b = c calls setproperty!(a,:b,c).
# • Inside a function call, f(a=b) passes b as the value of keyword argument a.
# • Inside parentheses with commas, (a=1,) constructs a NamedTuple.

# Assigning a to b does not create a copy of b; instead use copy or deepcopy

# Assignment can operate on multiple variables in parallel, taking values from an iterable:
a, b = 4, 5
# (4, 5)
a, b = 1:3
# 1:3               # = result value is the right member!!!
# a, b
(1, 2)


# -------------------------------------------------------------
# Standard modules

# Main      Top level module
# Core      Module that contains all identifiers considered "built in" to the language, i.e. part of the core language and not libraries.
# Base      The base library of Julia.


# -------------------------------------------------------------
# Comparisons

# Core.:===  or  Code.≡ (\equiv)
# ===(x,y) -> Bool
# ≡(x,y) -> Bool
# Determine whether x and y are identical, in the sense that no program could distinguish them. First the types of x and y are compared.
# If those are identical, mutable objects are compared by address in memory and immutable objects (such as numbers) are compared
# by contents at the bit level. 
# either x===y or ===(x,y)
a = [1, 2];
b = [1, 2];
a == b      # true
a === b     # false
a === a     # true

# Base.isequal
# isequal(x, y) -> Bool
# Similar to ==, except for the treatment of floating point numbers and of missing values. isequal treats all floating-point NaN values
# as equal to each other, treats -0.0 as unequal to 0.0, and missing as equal to missing. Always returns a Bool value.
# isequal is an equivalence relation - it is reflexive (=== implies isequal), symmetric (isequal(a, b) implies isequal(b, a))
# and transitive (isequal(a, b) and isequal(b, c) implies isequal(a, c)).
# Implementation
# The default implementation of isequal calls ==, so a type that does not involve floating-point values generally only needs to define ==.

isequal([1.0, NaN], [1.0, NaN])    # true
[1.0, NaN] == [1.0, NaN]           # false
0.0 == -0.0                      # true
isequal(0.0, -0.0)               # false
missing == missing               # missing
isequal(missing, missing)        # true

# Base.isless
# isless(x, y)
# Test whether x is less than y, according to a fixed total order (defined together with isequal).
# isless is not defined for pairs (x, y) of all types. However, if it is defined, it is expected to satisfy the following:
# - If isless(x, y) is defined, then so is isless(y, x) and isequal(x, y), and exactly one of those three yields true.
# - The relation defined by isless is transitive, i.e., isless(x, y) && isless(y, z) implies isless(x, z).
# Values that are normally unordered, such as NaN, are ordered after regular values. missing values are ordered last.
# This is the default comparison used by sort!.
# Implementation
# Non-numeric types with a total order should implement this function. Numeric types only need to implement it if they have
# special values such as NaN. Types with a partial order should implement <. 

isless(1, 3)            # true
isless("Red", "Blue")   # false

# ifelse(condition, if_true, if_false)
# ifelse must always execute both arguments and ?: must only execute the correct side, but this distinction only matters
# when either has side-effects. For example, ifelse(true, 1, error()) must error while true ? 1 : error() must not.
# --> use ternary operator

# isunordered(x)
# Return true if x is a value that is not orderable according to <, such as NaN or missing.
isunordered('z')        # false


# -------------------------------------------------------------
# Type checks

# Core.isa
# isa(x, type) -> Bool
# Determine whether x is of the given type. Can also be used as an infix operator, e.g. x isa type.
isa(1, Int)         # true
isa(1, Matrix)      # false
isa(1, Char)        # false
isa(1, Number)      # true
1 isa Number        # true

# Core.typeassert
# typeassert(x, type)
# Throw a TypeError unless x isa type. The syntax x::type calls this function.

# typeassert(2.5, Int)    # ERROR: TypeError: in typeassert, expected Int64, got a value of type Float64

# Core.typeof
# typeof(x)
# Get the concrete type of x.

a = 1 // 2
typeof(a)           # Rational{Int64}
M = [1 2; 3.5 4];
typeof(M)           # Matrix{Float64} (alias for Array{Float64, 2})


# -------------------------------------------------------------
# Tuples

tuple(1, 'b', π)    # typle consuctor, identical to (1, 'b', π)

#ntuple(f::Function, n::Integer)
# Create a tuple of length n, computing each element as f(i), where i is the index of the element.

ntuple(i -> 2 * i, 4) # (2, 4, 6, 8)


# -------------------------------------------------------------
# Id

# Base.objectid
# objectid(x) -> UInt
# Get a hash value for x based on object identity.
# If x === y then objectid(x) == objectid(y), and usually when x !== y, objectid(x) != objectid(y).

# Base.hash
# hash(x[, h::UInt]) -> UInt
# Compute an integer hash code such that isequal(x,y) implies hash(x)==hash(y). The optional second argument h
# is another hash code to be mixed with the result.
# New types should implement the 2-argument form, typically by calling the 2-argument hash method recursively
# in order to mix hashes of the contents with each other (and with h). Typically, any type that implements hash
# should also implement its own == (hence isequal) to guarantee the property mentioned above.
# Types supporting subtraction (operator -) should also implement widen, which is required to hash values inside heterogeneous arrays.
# The hash value may change when a new Julia process is started.

a = hash(10)     # 0x95ea2955abd45275
# only use the output of another hash function as the second argument
hash(10, a)     # 0xd42bad54a8575b16


# -------------------------------------------------------------
# Finalizer

# Base.finalizer
# finalizer(f, x)
# Register a function f(x) to be called when there are no program-accessible references to x, and return x.
# The type of x must be a mutable struct, otherwise the function will throw.
# f must not cause a task switch, which excludes most I/O operations such as println. Using the @async macro
# (to defer context switching to outside of the finalizer) or ccall to directly invoke IO functions in C may be helpful for debugging purposes.
# Note that there is no guaranteed world age for the execution of f. It may be called in the world age in which the finalizer was registered
# or any later world age.

# finalizer(my_mutable_struct) do x
#     @async println("Finalizing $x.")
# end
# 
# finalizer(my_mutable_struct) do x
#     ccall(:jl_safe_printf, Cvoid, (Cstring, Cstring), "Finalizing %s.", repr(x))
# end

# A finalizer may be registered at object construction. In the following example note that we implicitly rely on the finalizer
# returning the newly created mutable struct x.

mutable struct MyMutableStruct
    bar
    function MyMutableStruct(bar)
        x = new(bar)
        f(t) = @async println("Finalizing $t.")
        finalizer(f, x)
    end
end
st = MyMutableStruct(123)
nt = nothing                    # Doesn't see finalizer
GC.gc()                         # Not after that either...

# Base.finalize
# finalize(x)
# Immediately run finalizers registered for object x.


# -------------------------------------------------------------
# Copy

# Base.copy
# copy(x)
# Create a shallow copy of x: the outer structure is copied, but not all internal values. For example, copying an array
# produces a new array with identically-same elements as the original.
# See also copy!, copyto!, deepcopy

# Base.deepcopy
# deepcopy(x)
# Create a deep copy of x: everything is copied recursively, resulting in a fully independent object.
# For example, deep-copying an array produces a new array whose elements are deep copies of the original elements.
# Calling deepcopy on an object should generally have the same effect as serializing and then deserializing it.

# While it isn't normally necessary, user-defined types can override the default deepcopy behavior by defining
# a specialized version of the function deepcopy_internal(x::T, dict::IdDict) (which shouldn't otherwise be used),
# where T is the type to be specialized for, and dict keeps track of objects copied so far within the recursion.
# Within the definition, deepcopy_internal should be used in place of deepcopy, and the dict variable should be updated
# as appropriate before returning.


# -------------------------------------------------------------
# Properties 

# Base.getproperty
# getproperty(value, name::Symbol)
# getproperty(value, name::Symbol, order::Symbol)
# The syntax a.b calls getproperty(a, :b). The syntax @atomic order a.b calls getproperty(a, :b, :order) and the syntax
# @atomic a.b calls getproperty(a, :b, :sequentially_consistent).

struct MyType3{T<:Number}
    x::T
end

function Base.getproperty(obj::MyType3, sym::Symbol)
    if sym === :special
        return obj.x + 1
    else # fallback to getfield
        return getfield(obj, sym)
    end
end

obj = MyType3(1)
obj.special         # 2
obj.x               # 1

# One should overload getproperty only when necessary, as it can be confusing if the behavior of the syntax obj.f is unusual.
# Also note that using methods is often preferable. See also this style guide documentation for more information:
# Prefer exported methods over direct field access.
# See also getfield, propertynames and setproperty!.


# Base.setproperty!
# setproperty!(value, name::Symbol, x)
# setproperty!(value, name::Symbol, x, order::Symbol)
# The syntax a.b = c calls setproperty!(a, :b, c). The syntax @atomic order a.b = c calls setproperty!(a, :b, c, :order)
# and the syntax @atomic a.b = c calls setproperty!(a, :b, c, :sequentially_consistent).
# See also setfield!, propertynames and getproperty.


# Base.replaceproperty!
# replaceproperty!(x, f::Symbol, expected, desired, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
# Perform a compare-and-swap operation on x.f from expected to desired, per egal. The syntax @atomic_replace! x.f expected => desired
# can be used instead of the function call form.
# See also replacefield! and setproperty!.


# Base.swapproperty!
# swapproperty!(x, f::Symbol, v, order::Symbol=:not_atomic)
# The syntax @atomic a.b, _ = c, a.b returns (c, swapproperty!(a, :b, c, :sequentially_consistent)),
# where there must be one getproperty expression common to both sides.
# See also swapfield! and setproperty!.


# Base.modifyproperty!
# modifyproperty!(x, f::Symbol, op, v, order::Symbol=:not_atomic)
# The syntax @atomic op(x.f, v) (and its equivalent @atomic x.f op v) returns modifyproperty!(x, :f, op, v, :sequentially_consistent),
# where the first argument must be a getproperty expression and is modified atomically.
# Invocation of op(getproperty(x, f), v) must return a value that can be stored in the field f of the object x by default.
# In particular, unlike the default behavior of setproperty!, the convert function is not called automatically.
# See also modifyfield! and setproperty!.


# Base.propertynames
# propertynames(x, private=false)
# Get a tuple or a vector of the properties (x.property) of an object x. This is typically the same as fieldnames(typeof(x)),
# but types that overload getproperty should generally overload propertynames as well to get the properties of an instance of the type.
# propertynames(x) may return only "public" property names that are part of the documented interface of x.
# If you want it to also return "private" property names intended for internal use, pass true for the optional second argument.
# REPL tab completion on x. shows only the private=false properties.
# See also: hasproperty, hasfield.


# Base.hasproperty
# hasproperty(x, s::Symbol)
# Return a boolean indicating whether the object x has s as one of its own properties.
# See also: propertynames, hasfield.


# Core.getfield
# getfield(value, name::Symbol, [order::Symbol])
# getfield(value, i::Int, [order::Symbol])
# Extract a field from a composite value by name or position. Optionally, an ordering can be defined for the operation.
# If the field was declared @atomic, the specification is strongly recommended to be compatible with the stores to that location.
# Otherwise, if not declared as @atomic, this parameter must be :not_atomic if specified. See also getproperty and fieldnames.

a = 1 // 2
1 // 2
getfield(a, :num)   # 1
a.num               # 1
getfield(a, 1)      # 1


Core.setfield!
# setfield!(value, name::Symbol, x, [order::Symbol])
# # etfield!(value, i::Int, x, [order::Symbol])
# Assign x to a named field in value of composite type. The value must be mutable and x must be a subtype of fieldtype(typeof(value), name). Additionally, an ordering can be specified for this operation. If the field was declared @atomic, this specification is mandatory. Otherwise, if not declared as @atomic, it must be :not_atomic if specified. See also setproperty!.

mutable struct MyMutableStruct2
    field::Int
end

a = MyMutableStruct2(1)
setfield!(a, :field, 2)
getfield(a, :field)         # 2
a = 1 // 2                  # 1//2
# setfield!(a, :num, 3)     # ERROR: setfield!: immutable struct of type Rational cannot be changed


# Core.modifyfield!
# modifyfield!(value, name::Symbol, op, x, [order::Symbol]) -> Pair
# modifyfield!(value, i::Int, op, x, [order::Symbol]) -> Pair
# These atomically perform the operations to get and set a field after applying the function op.

# y = getfield(value, name)
# z = op(y, x)
# setfield!(value, name, z)
# return y => z

# If supported by the hardware (for example, atomic increment), this may be optimized to the appropriate hardware instruction,
# otherwise it'll use a loop.


# Core.replacefield!
# replacefield!(value, name::Symbol, expected, desired, [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
# replacefield!(value, i::Int, expected, desired, [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
# These atomically perform the operations to get and conditionally set a field to a given value.

# y = getfield(value, name, fail_order)
# ok = y === expected
# if ok
#     setfield!(value, name, desired, success_order)
# end
# return (; old = y, success = ok)

# If supported by the hardware, this may be optimized to the appropriate hardware instruction, otherwise it'll use a loop.


# Core.swapfield!
# swapfield!(value, name::Symbol, x, [order::Symbol])
# swapfield!(value, i::Int, x, [order::Symbol])
# These atomically perform the operations to simultaneously get and set a field:

#y = getfield(value, name)
#setfield!(value, name, x)
#return y


# -------------------------------------------------------------
# IsDefined

# Core.isdefined
# isdefined(m::Module, s::Symbol, [order::Symbol])
# isdefined(object, s::Symbol, [order::Symbol])
# isdefined(object, index::Int, [order::Symbol])
# Tests whether a global variable or object field is defined. The arguments can be a module and a symbol or a composite object
# and field name (as a symbol) or index. Optionally, an ordering can be defined for the operation. If the field was declared @atomic,
# the specification is strongly recommended to be compatible with the stores to that location.
# Otherwise, if not declared as @atomic, this parameter must be :not_atomic if specified.
# To test whether an array element is defined, use isassigned instead.
# See also @isdefined.

isdefined(Base, :sum)                   # true
isdefined(Base, :NonExistentMethod)     # false
a = 1 // 2
isdefined(a, 2)                         # true, index 2 is defined
isdefined(a, 3)                         # false, index 3 is not defined
isdefined(a, :num)                      # true
isdefined(a, :numerator)                # false


# Base.@isdefined
# @isdefined s -> Bool
# Tests whether variable s is defined in the current scope.
# See also isdefined for field properties and isassigned for array indexes or haskey for other mappings.

@isdefined newvar   # false
newvar = 1          # 1
@isdefined newvar   # true

function f()
    println(@isdefined x)
    x = 3
    println(@isdefined x)
end
# f (generic function with 1 method)
f()                 # false true


# -------------------------------------------------------------
# Conversions

# Base.convert
# convert(T, x)
# Convert x to a value of type T.
# If T is an Integer type, an InexactError will be raised if x is not representable by T, for example if x
# is not integer-valued, or is outside the range supported by T.

convert(Int, 3.0)       # 3
# convert(Int, 3.5)     # ERROR: InexactError: Int64(3.5)

# If T is a AbstractFloat type, then it will return the closest value to x representable by T.
x = 1 / 3
convert(Float32, x)     # 0.33333334f0
convert(BigFloat, x)    # 0.333333333333333314829616256247390992939472198486328125

# If T is a collection type and x a collection, the result of convert(T, x) may alias all or part of x.
let
    x = Int[1, 2, 3]
    y = convert(Vector{Int}, x)
    y === x                         # true
end
# See also: round, trunc, oftype, reinterpret.


# Base.promote
# promote(xs...)
# Convert all arguments to a common type, and return them all (as a tuple). If no arguments can be converted, an error is raised.
# See also: promote_type, promote_rule.

promote(Int8(1), Float16(4.5), Float32(4.1))                # (1.0f0, 4.5f0, 4.1f0)
promote_type(Int8, Float16, Float32)                        # Float32
reduce(Base.promote_typejoin, (Int8, Float16, Float32))     # Real
# promote(1, "x")                                           # ERROR: promotion of types Int64 and String failed to change any arguments
promote_type(Int, String)                                   # Any


# Base.oftype
# oftype(x, y)
# Convert y to the type of x i.e. convert(typeof(x), y).
let
    x = 4
    y = 3.0
    oftype(x, y)        # 3
    oftype(y, x)        # 4.0
end


# Base.widen
# widen(x)
# If x is a type, return a "larger" type, defined so that arithmetic operations + and - are guaranteed not to overflow
# nor lose precision for any combination of values that type x can hold.
# For fixed-size integer types less than 128 bits, widen will return a type with twice the number of bits.
# If x is a value, it is converted to widen(typeof(x)).

widen(Int32)        # Int64
widen(1.5f0)        # 1.5


# -------------------------------------------------------------
# Misc 

# Base.identity
# identity(x)
# The identity function. Returns its argument.

identity("Well, what did you expect?")      # "Well, what did you expect?"


# -------------------------------------------------------------
# Properties of types

# .. todo
