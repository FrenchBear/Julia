# types.jl
# Play with julia types
# 
# 2024-03-26    PV      First version

# --------------------------------------------------------------------
# abstract types (interfaces)
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
# primitive types (interfaces)
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

