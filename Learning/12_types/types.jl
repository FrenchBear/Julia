# types.jl
# Play with julia types
# 
# 2024-03-26    PV      First version

# --------------------------------------------------------------------
# Abstract types (interfaces)
#
# abstract type «name» end
# abstract type «name» <: «supertype» end

abstract type Animal end            # Default supertype is Any
abstract type Chien <: Animal end
# Union{} is an abstract subtype of any type

println(supertype(Chien))           # Animal
println(supertype(Animal))          # Any
println(Chien <: Animal)            # true
println(Animal <: Number)           # false
println()


# --------------------------------------------------------------------
# Primitive types (interfaces)
#
# primitive type «name» «bits» end
# primitive type «name» <: «supertype» «bits» end

# Predefined in Julia
# primitive type Float16 <: AbstractFloat 16 end
# primitive type Float32 <: AbstractFloat 32 end
# primitive type Float64 <: AbstractFloat 64 end
# 
# primitive type Bool <: Integer 8 end
# primitive type Char <: AbstractChar 32 end
# 
# primitive type Int8    <: Signed   8 end
# primitive type UInt8   <: Unsigned 8 end
# primitive type Int16   <: Signed   16 end
# primitive type UInt16  <: Unsigned 16 end
# primitive type Int32   <: Signed   32 end
# primitive type UInt32  <: Unsigned 32 end
# primitive type Int64   <: Signed   64 end
# primitive type UInt64  <: Unsigned 64 end
# primitive type Int128  <: Signed   128 end
# primitive type UInt128 <: Unsigned 128 end

primitive type ThreeBytes <: Unsigned 24 end

# Doesn't work yet...
# tb::ThreeBytes = UInt8(0)   # zero(Unsigned)
# println(tb)
# println()


# --------------------------------------------------------------------
# Composite types (struct)

struct X
    a::Int
    b::Float64
end

# If all the fields of an immutable structure are indistinguishable (===) then two immutable values containing those fields are also indistinguishable
println(X(1, 2) === X(1.0, 2.0))

# A struct can be mutable
mutable struct Bar
    baz
    qux::Float64
end

bar = Bar("Hello", 1.5);
bar.qux = 2.0
bar.baz = 1 // 2
println(bar)        # Bar(1//2, 2.0)

# Use const annotation for mutable struct fields that are fixed
mutable struct Baz
    a::Int
    const b::Float64
end
baz = Baz(1, 1.5);
baz.a = 2
# baz.b = 2.0
# ERROR: setfield!: const field .b of type Baz cannot be changed


# --------------------------------------------------------------------
# Types unions

IntOrString = Union{Int,AbstractString}
ec::IntOrString = 12
ec = "hello"
# ec = [1, 2]     # MethodError: Cannot `convert` an object of type Vector{Int64} to an object of type Union{Int64, AbstractString}

NullableInt = Union{Int,Nothing}
ni::NullableInt = 5
ni = nothing                        # Uppercase Nothing is the type, lowercase nothing is the value


# --------------------------------------------------------------------
# Parametric types

struct Point{T}
    x::T
    y::T
end

pi::Point{Int} = Point(2, 3)
pf::Point{Float64} = Point(3.5, -1.7)
ps::Point{String} = Point("Yes", "No")

println(ps isa Point{String})           # true
println(Point{String} <: Point{AbstractString})   # false
# oncrete points types with different values of T are never subtypes of each other
# even though Float64 <: Real we DO NOT have Point{Float64} <: Point{Real} -> Julia types are NOT covariant (and even less contravariant)
println()

# Point itself is also a valid type object, containing all instances Point{Float64}, Point{AbstractString}, etc. as subtypes
println(Point{Bool} <: Point)

function f(p::Point)
    println(p)
end
f(pi)
f(pf)
f(ps)
println()

# A correct way to define a method that accepts all arguments of type Point{T} where T is a subtype of Real is
function norm(p::Point{<:Real})
    sqrt(p.x^2 + p.y^2)
end
# Equivalently, one could define function norm(p::Point{T} where T<:Real) or function norm(p::Point{T}) where T<:Real
println(norm(pi))
println(norm(pf))
# println(norm(ps))     # MethodError: no method matching norm(::Point{String})
println()

p1 = Point(2.5, -3.2)   # Auto type inference
println(typeof(p1))     # Point{Float64}
p2 = Point{Bool}(false, false)
p3::Point{String} = Point("a", "z")
p4::Point{String} = Point{String}("e", "r")
println()

# --------------------------------------------------------------------
# Parametric Abstract types

abstract type Pointy{T} end
println(Pointy{Int16} <: Pointy)
println(Pointy{1} <: Pointy)
println(Pointy{1})              # Pointy{1}     ??
println(Pointy{1.5})            # Pointy{1.5}   ??
println(typeof(Pointy{1}))      # DataType
println()

# Parametric abstract types are invariant
println(Pointy{Float64} <: Pointy{Real})    # false

# The notation Pointy{<:Real} can be used to express the Julia analogue of a covariant type, 
# while Pointy{>:Int} the analogue of a contravariant type, but technically these represent sets of types
println(Pointy{Float64} <: Pointy{<:Real})  # true
println(Pointy{Real} <: Pointy{>:Int})      # true
println()

# Much as plain old abstract types serve to create a useful hierarchy of types over concrete types, parametric abstract types
# serve the same purpose with respect to parametric composite types. We could, for example, have declared Point{T} to be a subtype of Pointy{T} as follows:
struct NewPoint{T} <: Pointy{T}
    x::T
    y::T
end
println(Point{Float64} <: Pointy{Float64})                  # true
println(Point{Real} <: Pointy{Real})                        # true
println(Point{AbstractString} <: Pointy{AbstractString})    # true

# This relationship is also invariant:
println(Point{Float64} <: Pointy{Real})                     # false
println(Point{Float64} <: Pointy{<:Real})                   # true

# What purpose do parametric abstract types like Pointy serve?
# Consider if we create a point-like implementation that only requires a single coordinate because the point is on the diagonal line x = y:

struct DiagPoint{T} <: Pointy{T}
    x::T
end
# Now both Point{Float64} and DiagPoint{Float64} are implementations of the Pointy{Float64} abstraction, and similarly for every other possible choice of type T.
# This allows programming to a common interface shared by all Pointy objects, implemented for both Point and DiagPoint.

# Not very clear actually, need an example. What's the meaning of this Pointy struct?
struct PommeCaramel{T} <: Pointy{T}
    varietéDePomme::String
    quantitéDeCaramel::Float32
end

# It's possible to restrict parametric abstract types
abstract type PointyReal{T<:Real} end

println(PointyReal{Float64})
println(PointyReal{Real})
# println(PointyReal{AbstractString})          # ERROR: TypeError: in Pointy, in T, expected T<:Real, got Type{AbstractString}
# println(PointyReal{1})                       # ERROR: TypeError: in Pointy, in T, expected T<:Real, got a value of type Int64
println()

# Type parameters for parametric composite types can be restricted in the same manner:
struct PointReal{T<:Real} <: PointyReal{T}
    x::T
    y::T
end

# To give a real-world example of how all this parametric type machinery can be useful, here is the actual definition of Julia's
# Rational immutable type (except that we omit the constructor here for simplicity), representing an exact ratio of integers:
struct Rational{T<:Integer} <: Real
    num::T
    den::T
end


# --------------------------------------------------------------------
# Tuple types
#
# Tuples are an abstraction of the arguments of a function – without the function itself.
# The salient aspects of a function's arguments are their order and their types.

# A tuple type is similar to a parameterized immutable type where each parameter is the type of one field.
# For example, a 2-element tuple type resembles the following immutable type:
struct Tuple2{A,B}
    a::A
    b::B
end

println(typeof((1, "foo", 2.5)))      # Tuple{Int64, String, Float64}

# Note the implications of covariance
# Intuitively, this corresponds to the type of a function's arguments being a subtype of the function's signature (when the signature matches)
println(Tuple{Int,AbstractString} <: Tuple{Real,Any})       # true
println(Tuple{Int,AbstractString} <: Tuple{Real,Real})      # false
println(Tuple{Int,AbstractString} <: Tuple{Real,})          # false
println()

# Vararg Tuple Types
# The last parameter (only) of a tuple type can be the special value Vararg, which denotes any number of trailing elements
mytupletype = Tuple{AbstractString,Vararg{Int}}

println(isa(("1",), mytupletype))           # true
println(isa(("1", 1), mytupletype))          # true
println(isa(("1", 1, 2), mytupletype))        # true
println(isa(("1", 1, 2, 3.0), mytupletype))    # false
println()

# Vararg{T} corresponds to zero or more elements of type T. Vararg tuple types are used to represent the arguments accepted by varargs methods
# The special value Vararg{T,N} (when used as the last parameter of a tuple type) corresponds to exactly N elements of type T.
# NTuple{N,T} is a convenient alias for Tuple{Vararg{T,N}}, i.e. a tuple type containing exactly N elements of type T.
ThreeFloat = NTuple{3,Float64}
f3::ThreeFloat = (0.5, -1.4, 2.2)
println(f3)             # (0.5, -1.4, 2.2)
println(typeof(f3))     # Tuple{Float64, Float64, Float64}

# Named Tuple Types
# Named tuples are instances of the NamedTuple type, which has two parameters: a tuple of symbols giving the field names, and a tuple type giving the field types.
# For convenience, NamedTuple types are printed using the @NamedTuple macro which provides a convenient struct-like syntax
# for declaring these types via key::Type declarations, where an omitted ::Type corresponds to ::Any.

println(typeof((a=1, b="hello")))   # prints in macro form
#@NamedTuple{a::Int64, b::String}

println(NamedTuple{(:a, :b),Tuple{Int64,String}})   # long form of the type
#@NamedTuple{a::Int64, b::String}

# The begin ... end form of the @NamedTuple macro allows the declarations to be split across multiple lines
# (similar to a struct declaration), but is otherwise equivalent:
NT1 = @NamedTuple begin
    a::Int
    b::String
end
NT2 = @NamedTuple{a::Int64, b::String}

# A NamedTuple type can be used as a constructor, accepting a single tuple argument. The constructed NamedTuple type can be either a concrete type, with both parameters specified, or a type that specifies only field names:
println(@NamedTuple{a::Float32, b::String}((1, "")))    # (a = 1.0f0, b = "")
println(NamedTuple{(:a, :b)}((1, "")))                  # (a = 1, b = "")
println()
# If field types are specified, the arguments are converted. Otherwise the types of the arguments are used directly.


# --------------------------------------------------------------------
# Parametric Primitive Types

# Primitive types can also be declared parametrically. For example, pointers are represented as primitive types which would be declared in Julia like this:

# 32-bit system:
primitive type Ptr32{T} 32 end

# 64-bit system:
primitive type Ptr{T} 64 end

# The slightly odd feature of these declarations as compared to typical parametric composite types, is that the type parameter T
# is not used in the definition of the type itself – it is just an abstract tag, essentially defining an entire family of types
# with identical structure, differentiated only by their type parameter.
# Thus, Ptr{Float64} and Ptr{Int64} are distinct types, even though they have identical representations. And of course, 
# all specific pointer types are subtypes of the umbrella Ptr type:

println(Ptr{Float64} <: Ptr)    # true
println(Ptr{Int64} <: Ptr)      # true
println()


# --------------------------------------------------------------------
# UnionAll Types

# Parametric type like Ptr acts as a supertype of all its instances (Ptr{Int64} etc.).
# Ptr (or other parametric types like Array) is a different kind of type called a UnionAll type.
# Such a type expresses the iterated union of types for all values of some parameter.

# UnionAll types are usually written using the keyword where. For example Ptr could be more accurately written as Ptr{T} where T,
# meaning all values whose type is Ptr{T} for some value of T.
# Each where introduces a single type variable, so these expressions are nested for types with multiple parameters, for example Array{T,N} where N where T

# The type application syntax A{B,C} requires A to be a UnionAll type, and first substitutes B for the outermost type variable in A.
# The result is expected to be another UnionAll type, into which C is then substituted. So A{B,C} is equivalent to A{B}{C}.
# This explains why it is possible to partially instantiate a type, as in Array{Float64}: the first parameter value has been fixed,
# but the second still ranges over all possible values. Using explicit where syntax, any subset of parameters can be fixed.
# For example, the type of all 1-dimensional arrays can be written as Array{T,1} where T.
VecR = Array{T,1} where {T<:Real}       # or Array{<:Real,1}
t1::VecR = [1.1, 2.6]
#t2::TR = [1.1  2.6; 2.0 -1.2]          # Error MethodError: no method matching (Vector{T} where T<:Real)(::Matrix{Float64})

TN = Array{T} where {Int <: T <: Real}
t2::TN = [3, -2]
t3::TN = Array{Real}(undef, 5)          # Not happy with Vector{Float64} initialisation such as [3.2, -7.8]

TT = Tuple{T,Array{S}} where {S<:AbstractArray{T}} where {T<:Real}
# refers to 2-tuples whose first element is some Real, and whose second element is an Array of any kind of array
# whose element type contains the type of the first tuple element

const T1 = Array{Array{T,1} where T,1}        # Vector{Vector} (alias for Array{Array{T, 1} where T, 1})
const T2 = Array{Array{T,1},1} where {T}        # Array{Vector{T}, 1} where T
# Type T1 defines a 1-dimensional array of 1-dimensional arrays; each of the inner arrays consists of objects of the same type,
# but this type may vary from one inner array to the next.
# On the other hand, type T2 defines a 1-dimensional array of 1-dimensional arrays all of whose inner arrays must have the same type.
# Note that T2 is an abstract type, e.g., Array{Array{Int,1},1} <: T2, whereas T1 is a concrete type.
# As a consequence, T1 can be constructed with a zero-argument constructor a=T1() but T2 cannot.

# There is a convenient syntax for naming such types, similar to the short form of function definition syntax:
Vector{T} = Array{T,1}
Matrix{T} = Array{T,2}


# --------------------------------------------------------------------
# Singleton types (interfaces)

# Immutable composite types with no fields are called singletons. Formally, if
# - T is an immutable composite type (i.e. defined with struct),
# - a isa T && b isa T implies a === b,
# then T is a singleton type.

# Base.issingletontype can be used to check if a type is a singleton type. Abstract types cannot be singleton types by construction

struct NoFields
end

println(NoFields() === NoFields())          # true, the === function confirms that the constructed instances of NoFields are actually one and the same
println(Base.issingletontype(NoFields))     # true

# Parametric types can be singleton types when the above condition holds. For example,
struct NoFieldsParam{T}
end
# But NoFieldsParam is not a singleton type because it has multiples instances (NoFieldsParam{Int}(), NoFieldsParam{Bool}(), ...)

println(NoFieldsParam{Int}() === NoFieldsParam{Int}())      # true
println()


# --------------------------------------------------------------------
# Types of functions

# Each function has its own type, which is a subtype of Function.
foo41(x) = x + 1.0f0        # foo41 (generic function with 1 method)
println(typeof(foo41))      # typeof(foo41) (singleton type of function foo41, subtype of Function)

# Note how typeof(foo41) prints as itself. This is merely a convention for printing, as it is a first-class object that can be used like any other value:
T = typeof(foo41)
println(T)                  # typeof(foo41) (singleton type of function foo41, subtype of Function)
println(T <: Function)      # true

# Types of functions defined at top-level are singletons. When necessary, you can compare them with ===.

# Closures also have their own type, which is usually printed with names that end in #<number>. Names and types for functions defined at different locations are distinct, but not guaranteed to be printed the same way across sessions.
println(typeof(x -> x + 1)) # var"#9#10"
println()


# --------------------------------------------------------------------
# Type{T} typ selectors

# For each type T, Type{T} is an abstract parametric type whose only instance is the object T
println(isa(Float64, Type{Float64}))      # true
println(isa(Real, Type{Float64}))         # false
println(isa(Real, Type{Real}))            # true
println(isa(Float64, Type{Real}))         # false

# In other words, isa(A, Type{B}) is true if and only if A and B are the same object and that object is a type.

# In particular, since parametric types are invariant, we have
struct TypeParamExample{T}
    x::T
end

println(TypeParamExample isa Type{TypeParamExample})            # true
println(TypeParamExample{Int} isa Type{TypeParamExample})       # false
println(TypeParamExample{Int} isa Type{TypeParamExample{Int}})  # true

# Without the parameter, Type is simply an abstract type which has all type objects as its instances:
println((Type{Float64}, Type))  # true
println((Float64, Type))        # true
println((Real, Type))           # true

#Any object that is not a type is not an instance of Type:
println(isa(1, Type))           # false
println(isa("foo", Type))       # false
println()


# --------------------------------------------------------------------
# Type aliases

# This can be done with a simple assignment statement.
# For example, UInt is aliased to either UInt32 or UInt64 as is appropriate for the size of pointers on the system

# This is accomplished via the following code in base/boot.jl:
if Int === Int64
    const UInt = UInt64
else
    const UInt = UInt32
end

# Unlike Int, Float does not exist as a type alias for a specific sized AbstractFloat. Unlike with integer registers where the size of Int
# reflects the size of a native pointer on that machine, the floating point register sizes are specified by the IEEE-754 standard.


# --------------------------------------------------------------------
# Operations on types

# The isa function tests if an object is of a given type and returns true or false:
println(isa(1, Int))                # true
println(isa(1, AbstractFloat))      # false

# The typeof function, already used throughout the manual in examples, returns the type of its argument. Since, as noted above,
# types are objects, they also have types, and we can ask what their types are:
println(typeof(Rational{Int}))      # DataType
println(typeof(Union{Real,String})) # Union

# What if we repeat the process? What is the type of a type of a type? As it happens, types are all composite values and thus all have a type of DataType:
println(typeof(DataType))           # DataType
println(typeof(Union))              # DataType
# DataType is its own type.

# Another operation that applies to some types is supertype, which reveals a type's supertype. Only declared types (DataType) have unambiguous supertypes:

println(supertype(Float64))         # AbstractFloat
println(supertype(Number))          # Any
println(supertype(AbstractString))  # Any
println(supertype(Any))             # Any
println()

# If you apply supertype to other type objects (or non-type objects), a MethodError is raised:
# println(supertype(Union{Float64,Int64}))
# ERROR: MethodError: no method matching supertype(::Type{Union{Float64, Int64}})


# --------------------------------------------------------------------
# Custom pretty-printing

# Often, one wants to customize how instances of a type are displayed. This is accomplished by overloading the show function.
# For example, suppose we define a type to represent complex numbers in polar form:
struct Polar{T<:Real} <: Number
    r::T
    Θ::T
end

Polar(r::Real,Θ::Real) = Polar(promote(r,Θ)...)

# Here, we've added a custom constructor function so that it can take arguments of different Real types and promote them
# to a common type (see Constructors and Conversion and Promotion).
# By default, instances of this type display rather simply, with information about the type name and the field values, as e.g. Polar{Float64}(3.0,4.0).

# If we want it to display instead as 3.0 * exp(4.0im), we would define the following method to print the object to a given output object io
# (representing a file, terminal, buffer, etcetera; see Networking and Streams):

p = Polar(5.0, π/6)
println(p)              # Polar{Float64}(5.0, 0.5235987755982988)

Base.show(io::IO, z::Polar) = print(io, z.r, " * exp(", z.Θ, "im)")
println(p)              # 5.0 * exp(0.5235987755982988im)

# ... more options, see later


# --------------------------------------------------------------------
# Value types

# ... see later
