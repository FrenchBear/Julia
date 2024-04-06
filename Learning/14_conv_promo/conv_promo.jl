# conv_promo.jl
# Play with julia converstions and promotions (Julia manual §14)
# 
# 2024-04-04    PV      First version

# Julia has a system for promoting arguments of mathematical operators to a common type. "Automatic" promotion of
# mathematical operands simply emerges as a special application: Julia comes with pre-defined catch-all dispatch rules
# for mathematical operators, invoked when no specific implementation exists for some combination of operand types.
# These catch-all rules first promote all operands to a common type using user-definable promotion rules, and then
# invoke a specialized implementation of the operator in question for the resulting values, now of the same type.
# User-defined types can easily participate in this promotion system by defining methods for conversion to and from
# other types, and providing a handful of promotion rules defining what types they should promote to when mixed with
# other types.


# Conversion

# The standard way to obtain a value of a certain type T is to call the type's constructor, T(x). However, there are
# cases where it's convenient to convert a value from one type to another without the programmer asking for it
# explicitly. This is done via the convert function.

# The convert function generally takes two arguments: the first is a type object and the second is a value to convert to
# that type. The returned value is the value converted to an instance of given type.

x = 12                              # 12
typeof(x)                           # Int64
xu = convert(UInt8, x)              # 0x0c
typeof(xu)                          # UInt8
xf = convert(AbstractFloat, x)      # 12.0
typeof(xf)                          # Float64
a = Any[1 2 3; 4 5 6]               # 2×3 Matrix{Any}:  1  2  3\n 4  5  6
convert(Array{Float64}, a)          # 2×3 Matrix{Float64}:  1.0  2.0  3.0\n  4.0  5.0  6.0
# convert(AbstractFloat, "foo")     # ERROR: MethodError: Cannot `convert` an object of type String to an object of type AbstractFloat

# To convert a string-representation of a number, the dedicated parse function must be used.

# When is convert called?
# The following language constructs call convert:
# - Assigning to an array converts to the array's element type.
# - Assigning to a field of an object converts to the declared type of the field.
# - Constructing an object with new converts to the object's declared field types.
# - Assigning to a variable with a declared type (e.g. local x::T) converts to that type.
# - A function with a declared return type converts its return value to that type.
# - Passing a value to ccall converts it to the corresponding argument type.

# Conversion vs. Construction
# Note that the behavior of convert(T, x) appears to be nearly identical to T(x). Indeed, it usually is. However, there
# is a key semantic difference: since convert can be called implicitly, its methods are restricted to cases that are
# considered "safe" or "unsurprising". convert will only convert between types that represent the same basic kind of
# thing (e.g. different representations of numbers, or different string encodings). It is also usually lossless;
# converting a value to a different type and back again should result in the exact same value.

# There are four general kinds of cases where constructors differ from convert:
# - Constructors for types unrelated to their arguments
#   Some constructors don't implement the concept of "conversion". For example, Timer(2) creates a 2-second timer,
#   which is not really a "conversion" from an integer to a timer.
# - Mutable collections
#   convert(T, x) is expected to return the original x if x is already of type T. In contrast, if T is a mutable collection type
#   then T(x) should always make a new collection (copying elements from x).
# - Wrapper types
#   For some types which "wrap" other values, the constructor may wrap its argument inside a new object even if it is
#   already of the requested type. For example Some(x) wraps x to indicate that a value is present (in a context
#   where the result might be a Some or nothing). However, x itself might be the object Some(y), in which case
#   the result is Some(Some(y)), with two levels of wrapping. convert(Some, x), on the other hand, would just return x
#   since it is already a Some.
# - Constructors that don't return instances of their own type
#   In very rare cases it might make sense for the constructor T(x) to return an object not of type T.
#   This could happen if a wrapper type is its own inverse (e.g. Flip(Flip(x)) === x), or to support an old calling
#   syntax for backwards compatibility when a library is restructured. But convert(T, x) should always return a value of type T.


# Defining New Conversions

struct MyType end
 import Base.convert        # Without: ERROR: LoadError: invalid method definition in Main: function Base.convert must be explicitly imported to be extended

# When defining a new type, initially all ways of creating it should be defined as constructors. If it becomes clear
# that implicit conversion would be useful, and that some constructors meet the above "safety" criteria, then convert
# methods can be added. These methods are typically quite simple, as they only need to call the appropriate constructor.
# Such a definition might look like this:
convert(::Type{MyType}, x) = MyType(x)

# The type of the first argument of this method is Type{MyType}, the only instance of which is MyType. Thus, this method
# is only invoked when the first argument is the type value MyType. Notice the syntax used for the first argument: the
# argument name is omitted prior to the :: symbol, and only the type is given. This is the syntax in Julia for a
# function argument whose type is specified but whose value does not need to be referenced by name.

# All instances of some abstract types are by default considered "sufficiently similar" that a universal convert
# definition is provided in Julia Base. For example, this definition states that it's valid to convert any Number type
# to any other by calling a 1-argument constructor:
convert(::Type{T}, x::Number) where {T<:Number} = T(x)::T

# This means that new Number types only need to define constructors, since this definition will handle convert for them.
# An identity conversion is also provided to handle the case where the argument is already of the requested type:
convert(::Type{T}, x::T) where {T<:Number} = x

# Similar definitions exist for AbstractString, AbstractArray, and AbstractDict.


# Promotion

# Promotion refers to converting values of mixed types to a single common type
# Promotion has nothing to do with the type hierarchy, and everything to do with converting between alternate
# representations. For instance, although every Int32 value can also be represented as a Float64 value, Int32 is not a
# subtype of Float64.

# Promotion to a common "greater" type is performed in Julia by the promote function, which takes any number of
# arguments, and returns a tuple of the same number of values, converted to a common type, or throws an exception if
# promotion is not possible.

promote(1, 2.5)             # (1.0, 2.5)
promote(1, 2.5, 3)          # (1.0, 2.5, 3.0)
promote(2, 3//4)            # (2//1, 3//4)
promote(1, 2.5, 3, 3//4)    # (1.0, 2.5, 3.0, 0.75)
promote(1.5, im)            # (1.5 + 0.0im, 0.0 + 1.0im)
promote(1 + 2im, 3//4)      # (1//1 + 2//1*im, 3//4 + 0//1*im)

# Floating-point values are promoted to the largest of the floating-point argument types.
# Integer values are promoted to the largest of the integer argument types.
# If the types are the same size but differ in signedness, the unsigned type is chosen.
# Mixtures of integers and floating-point values are promoted to a floating-point type big enough to hold all the values.
# Integers mixed with rationals are promoted to rationals.
# Rationals mixed with floats are promoted to floats.
# Complex values mixed with real values are promoted to the appropriate kind of complex value.

# That is really all there is to using promotions. The rest is just a matter of clever application, the most typical
# "clever" application being the definition of catch-all methods for numeric operations like the arithmetic operators +,
# -, * and /. Here are some of the catch-all method definitions given in promotion.jl:
import Base.:+, Base.:-, Base.:*, Base.:/       # Without: ERROR: LoadError: invalid method definition in Main: function Base.* must be explicitly imported to be extended
+(x::Number, y::Number) = +(promote(x,y)...)
-(x::Number, y::Number) = -(promote(x,y)...)
*(x::Number, y::Number) = *(promote(x,y)...)
/(x::Number, y::Number) = /(promote(x,y)...)

# The most common usages of promote occur in outer constructors methods, provided for convenience, to allow constructor
# calls with mixed types to delegate to an inner type with fields promoted to an appropriate common type. For example,
# recall that rational.jl provides the following outer constructor method:
Rational(n::Integer, d::Integer) = Rational(promote(n,d)...)

# This allows calls like the following to work:
x = Rational(Int8(15),Int32(-5))    # -3//1
typeof(x)                           # Rational{Int32}

# For most user-defined types, it is better practice to require programmers to supply the expected types to constructor
# functions explicitly, but sometimes, especially for numeric problems, it can be convenient to do promotion
# automatically.


# Defining Promotion Rules

# Although one could, in principle, define methods for the promote function directly, this would require many redundant
# definitions for all possible permutations of argument types. Instead, the behavior of promote is defined in terms of
# an auxiliary function called promote_rule, which one can provide methods for. The promote_rule function takes a pair
# of type objects and returns another type object, such that instances of the argument types will be promoted to the
# returned type. Thus, by defining the rule:
promote_rule(::Type{Float64}, ::Type{Float32}) = Float64

# one declares that when 64-bit and 32-bit floating-point values are promoted together, they should be promoted to
# 64-bit floating-point. The promotion type does not need to be one of the argument types. For example, the following
# promotion rules both occur in Julia Base:
promote_rule(::Type{BigInt}, ::Type{Float64}) = BigFloat
promote_rule(::Type{BigInt}, ::Type{Int8}) = BigInt

# In the latter case, the result type is BigInt since BigInt is the only type large enough to hold integers for
# arbitrary-precision integer arithmetic. Also note that one does not need to define both promote_rule(::Type{A},
# ::Type{B}) and promote_rule(::Type{B}, ::Type{A}) – the symmetry is implied by the way promote_rule is used in the
# promotion process.

# The promote_rule function is used as a building block to define a second function called promote_type, which, given
# any number of type objects, returns the common type to which those values, as arguments to promote should be promoted.
# Thus, if one wants to know, in absence of actual values, what type a collection of values of certain types would
# promote to, one can use promote_type:
promote_type(Int8, Int64)   # Int64

# Note that we do not overload promote_type directly: we overload promote_rule instead. promote_type uses promote_rule,
# and adds the symmetry. Overloading it directly can cause ambiguity errors. We overload promote_rule to define how
# things should be promoted, and we use promote_type to query that.


# Case Study: Rational Promotions

# Finally, we finish off our ongoing case study of Julia's rational number type, which makes relatively sophisticated
# use of the promotion mechanism with the following promotion rules:
promote_rule(::Type{Rational{T}}, ::Type{S}) where {T<:Integer,S<:Integer} = Rational{promote_type(T,S)}
promote_rule(::Type{Rational{T}}, ::Type{Rational{S}}) where {T<:Integer,S<:Integer} = Rational{promote_type(T,S)}
promote_rule(::Type{Rational{T}}, ::Type{S}) where {T<:Integer,S<:AbstractFloat} = promote_type(T,S)

# The first rule says that promoting a rational number with any other integer type promotes to a rational type whose
# numerator/denominator type is the result of promotion of its numerator/denominator type with the other integer type.
# The second rule applies the same logic to two different types of rational numbers, resulting in a rational of the
# promotion of their respective numerator/denominator types.
# The third and final rule dictates that promoting a rational with a float results in the same type as promoting the
# numerator/denominator type with the float.

# This small handful of promotion rules, together with the type's constructors and the default convert method for
# numbers, are sufficient to make rational numbers interoperate completely naturally with all of Julia's other numeric
# types – integers, floating-point numbers, and complex numbers. By providing appropriate conversion methods and
# promotion rules in the same manner, any user-defined numeric type can interoperate just as naturally with Julia's
# predefined numerics.
