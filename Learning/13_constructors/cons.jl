# cons.jl
# Play with julia constructors (Julia manual §13)
# 
# 2024-04-02    PV      First version

# Constructors are functions that create new objects – specifically, instances of Composite Types.
# In Julia, type objects also serve as constructor functions: they create new instances of themselves when applied to an argument tuple as a function.
struct Foo
    bar
    baz
end

foo = Foo(1, 2)     # Foo(1, 2)
println(foo.bar)    # 1
println(foo.baz)    # 2
println()


# Outer Constructor Methods
# A constructor is just like any other function in Julia in that its overall behavior is defined by the combined behavior of its methods.
# Accordingly, you can add functionality to a constructor by simply defining new methods.
# For example, let's say you want to add a constructor method for Foo objects that takes only one argument:
Foo(x) = Foo(x, x)
Foo(1)      # Foo(1, 1)

# You could also add a zero-argument Foo constructor method that supplies default values for both of the bar and baz fields:
Foo() = Foo(0)
Foo()       # Foo(0, 0)


# Inner Constructor Methods
# While outer constructor methods succeed in addressing the problem of providing additional convenience methods for constructing objects,
# they fail to address the other two use cases: enforcing invariants, and allowing construction of self-referential objects.
# For these problems, one needs inner constructor methods.
# An inner constructor method is like an outer constructor method, except for two differences:
# - It is declared inside the block of a type declaration, rather than outside of it like normal methods.
# - It has access to a special locally existent function called new that creates objects of the block's type.

# For example, suppose one wants to declare a type that holds a pair of real numbers, subject to the constraint that the first number
# is not greater than the second one. One could declare it like this:
struct OrderedPair
    x::Real
    y::Real
    OrderedPair(x, y) = x > y ? error("out of order") : new(x, y)
end

OrderedPair(1, 2)   # OrderedPair(1, 2)
# OrderedPair(2,1)  # ERROR: out of order

# If the type were declared mutable, you could reach in and directly change the field values to violate this invariant.
# Of course, messing around with an object's internals uninvited is bad practice

# Once a type is declared, there is no way to add more inner constructor methods. Since outer constructor methods can only
# create objects by calling other constructor methods, ultimately, some inner constructor must be called to create an object.
# This guarantees that all objects of the declared type must come into existence by a call to one of the inner constructor
# methods provided with the type, thereby giving some degree of enforcement of a type's invariants.

# If any inner constructor method is defined, no default constructor method is provided: it is presumed that you have supplied
# yourself with all the inner constructors you need.
struct T2
    x::Int64
    T2(n::Int8) = new(Int64(n))
end
T2(Int8(12))    # T2(12)
# T2(-5)        # MethodError: no method matching T2(::Int64)

# The default constructor is equivalent to writing your own inner constructor
# method that takes all of the object's fields as parameters (constrained to be of the correct type, if the corresponding field has a type),
# and passes them to new, returning the resulting object:
let
    struct Foo
        bar
        baz
        Foo(bar, baz) = new(bar, baz)
    end
end


# Simple example of (non-balanced) b-tree
let
    mutable struct Node{T}
        value::T
        left::Union{Node,Nothing}
        right::Union{Node,Nothing}
    end

    # Root of b-tree
    root::Union{Node,Nothing} = nothing

    # Insert value in b-tree
    function treeins(value::T) where {T}
        nn = Node(value, nothing, nothing)
        if (isnothing(root))
            #        println("Insert $value as root")
            root = nn
        else
            r = root
            while true
                if value < r.value
                    if isnothing(r.left)
                        r.left = nn
                        #                    println("Insert $value as left node of $(r.value)")
                        return
                    else
                        r = r.left
                    end
                elseif value > r.value
                    if isnothing(r.right)
                        #                    println("Insert $value as right node of $(r.value)")
                        r.right = nn
                        return
                    else
                        r = r.right
                    end
                else
                    @error "Dumplicate value $value"
                end
            end
        end
    end

    # Print sorted tree
    function printtree(n::Union{Node,Nothing})
        !isnothing(n) || return
        printtree(n.left)
        print(n.value, ' ')
        printtree(n.right)
    end

    treeins(7)
    treeins(2)
    treeins(-2)
    treeins(8)
    treeins(-1)
    treeins(5)
    treeins(3)
    treeins(6)
    treeins(4)
    treeins(9)
    treeins(0)
    treeins(1)

    printtree(root)
    println()
    println()
end


# Incomplete initialization

# To allow for the creation of incompletely initialized objects, Julia allows the new function to be called
# with fewer than the number of fields that the type has, returning an object with the unspecified fields uninitialized.
# While you are allowed to create objects with uninitialized fields, any access to an uninitialized reference is an immediate error.

mutable struct SelfReferential
    obj::SelfReferential
    SelfReferential() = (x = new(); x.obj = x)
end

x = SelfReferential()
println(x === x)            # true
println(x === x.obj)        # true
println(x === x.obj.obj)    # true
println()


# Parametric constructors

struct Point{T<:Real}
    x::T
    y::T
end

# Point, Point{Float64} and Point{Int64} are all different constructor functions.
# In fact, Point{T} is a distinct constructor function for each type T.
# Without any explicitly provided inner constructors, the declaration of the composite type Point{T<:Real}
# automatically provides an inner constructor, Point{T}, for each possible type T<:Real, that behaves just
# like non-parametric default inner constructors do.
# It also provides a single general outer Point constructor that takes pairs of real arguments, which must be
# of the same type. This automatic provision of constructors is equivalent to the following explicit declaration:
let
    struct Point{T<:Real}
        x::T
        y::T
        Point{T}(x, y) where {T<:Real} = new(x, y)
    end

    Point(x::T, y::T) where {T<:Real} = Point{T}(x, y)
end

# Notice that each definition looks like the form of constructor call that it handles.
# The call Point{Int64}(1,2) will invoke the definition Point{T}(x,y) inside the struct block.
# The outer constructor declaration, on the other hand, defines a method for the general Point constructor
# which only applies to pairs of values of the same real type. This declaration makes constructor calls
# without explicit type parameters, like Point(1,2) and Point(1.0,2.5), work.
# Since the method declaration restricts the arguments to being of the same type, calls like Point(1,2.5),
# with arguments of different types, result in "no method" errors.

# To allow specific integer values as 1st argument work, we can vrite another outer constructor
Point(x::Int64, y::Float64) = Point(convert(Float64, x), y)

# But this doesn't work for other similar calls such as Point(1.5,2)
# The following outer method definition to make all calls to the general Point constructor work as one would expect:
Point(x::Real, y::Real) = Point(promote(x, y)...)

# Now it works:
Point(1.5, 2)           # Point{Float64}(1.5, 2.0)
Point(1, 1 // 2)        # Point{Rational{Int64}}(1//1, 1//2)
Point(1.0, 1 // 2)      # Point{Float64}(1.0, 0.5)


# Case study: Rational

# Here is a real world example of a parametric composite type and its constructor methods. To that end,
# we implement our own rational number type OurRational, similar to Julia's built-in Rational type, defined in rational.jl

# OurRational takes one type parameter of an integer type, and is itself a real type.
struct OurRational{T<:Integer} <: Real
    num::T
    den::T
    function OurRational{T}(num::T, den::T) where {T<:Integer}
        if num == 0 && den == 0
            error("invalid rational: 0//0")
        end
        num = flipsign(num, den)    # Only num bear sign
        den = flipsign(den, den)    # Den is >0
        g = gcd(num, den)           # Reduce fraction
        num = div(num, g)
        den = div(den, g)
        new(num, den)
    end
end

# OurRational also provides several outer constructor methods for convenience.
# The first is the "standard" general constructor that infers the type parameter T from the type of the numerator
# and denominator when they have the same type.
# The second applies when the given numerator and denominator values have different types:
# it promotes them to a common type and then delegates construction to the outer constructor for arguments of matching type.
# The third outer constructor turns integer values into rationals by supplying a value of 1 as the denominator.
OurRational(n::T, d::T) where {T<:Integer} = OurRational{T}(n, d)
OurRational(n::Integer, d::Integer) = OurRational(promote(n, d)...)
OurRational(n::Integer) = OurRational(n, one(n))

#  We define a number of methods for the ⊘ operator, which provides a syntax for writing rationals (e.g. 1 ⊘ 2).
# Julia's Rational type uses the // operator for this purpose. Before these definitions, ⊘ is a completely undefined
# operator with only syntax and no meaning. Afterwards, it behaves just as described in Rational Numbers –
# its entire behavior is defined in these few lines.
# The first and most basic definition just makes a ⊘ b construct a OurRational by applying the OurRational constructor
# to a and b when they are integers. When one of the operands of ⊘ is already a rational number, we construct a new
# rational for the resulting ratio slightly differently; this behavior is actually identical to division of
# a rational with an integer.
# Finally, applying ⊘ to complex integral values creates an instance of Complex{<:OurRational} – a complex number
# whose real and imaginary parts are rationals:
⊘(n::Integer, d::Integer) = OurRational(n, d)
⊘(x::OurRational, y::Integer) = x.num ⊘ (x.den * y)
⊘(x::Integer, y::OurRational) = (x * y.den) ⊘ y.num
⊘(x::Complex, y::Real) = complex(real(x) ⊘ y, imag(x) ⊘ y)
⊘(x::Real, y::Complex) = (x * y') ⊘ real(y * y')
function ⊘(x::Complex, y::Complex)
    xy = x * y'
    yy = real(y * y')
    complex(real(xy) ⊘ yy, imag(xy) ⊘ yy)
end

# Thus, although the ⊘ operator usually returns an instance of OurRational, if either of its arguments are complex integers,
# it will return an instance of Complex{<:OurRational} instead. The interested reader should consider perusing
# the rest of rational.jl: it is short, self-contained, and implements an entire basic Julia type.



# Test of constructors

struct S1
    x::Float64
    y::Float64

    function S1()
        println("S1 inner .ctor No args")
        new(0.0, 0.0)
    end

    function S1(f::Float64)
        println("S1 inner .ctor 1 Float64")
        new(f, 0.0)
    end

    function S1(f::Float64, g::Float64)
        println("S1 inner .ctor 2 Float64")
        new(f, g)
    end

    function S1(z::ComplexF64)
        println("S1 inner .ctor 1 ComplexF64")
        new(z.re, z.im)
    end
end

function  S1(i::Int, j::Int)
    println("S1 outer .ctor 2 Int")
    S1(Float64(i), Float64(j))
end

S1(2.1, 3.2)    # S1 inner .ctor 2 Float64
S1(√2)          # S1 inner .ctor 1 Float64
S1()            # S1 inner .ctor No args
S1(2.0-1.5im)   # S1 inner .ctor 1 ComplexF64
S1(3, 4)        # S1 outer .ctor 2 Int -> S1 inner .ctor 2 Float64

