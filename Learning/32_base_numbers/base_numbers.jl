# base_numbers.jl
# Julia Base doc, Numbers
# 
# 2024-05-01    PV


# Numbers

# Standard Numeric Types
# A type tree for all subtypes of Number in Base is shown below. Abstract types have been marked, the rest are concrete
# types.

# Number  (Abstract Type)
# ├─ Complex{T<:Real}
# └─ Real  (Abstract Type)
#    ├─ AbstractFloat  (Abstract Type)
#    │  ├─ Float16
#    │  ├─ Float32
#    │  ├─ Float64
#    │  └─ BigFloat
#    ├─ Integer  (Abstract Type)
#    │  ├─ Bool
#    │  ├─ Signed  (Abstract Type)
#    │  │  ├─ Int8
#    │  │  ├─ Int16
#    │  │  ├─ Int32
#    │  │  ├─ Int64
#    │  │  ├─ Int128
#    │  │  └─ BigInt
#    │  └─ Unsigned  (Abstract Type)
#    │     ├─ UInt8
#    │     ├─ UInt16
#    │     ├─ UInt32
#    │     ├─ UInt64
#    │     └─ UInt128
#    ├─ Rational{T<:Integer}
#    └─ AbstractIrrational  (Abstract Type)
#       └─ Irrational{sym}

# ComplexF16, ComplexF32 and ComplexF64 are aliases for Complex{Float16}, Complex{Float32} and Complex{Float64}

# -----------------------------------------------------------
# Abstract number types

# -------------------------
# Core.Number
# Type Number
#
# Abstract supertype for all number types.

# -------------------------
# Core.Real
# Type Real <: Number
#
# Abstract supertype for all real numbers.

# -------------------------
# Core.AbstractFloat
# Type AbstractFloat <: Real
#
# Abstract supertype for all floating point numbers.

# -------------------------
# Core.Integer
# Type Integer <: Real
#
# Abstract supertype for all integers.

# -------------------------
# Core.Signed
# Type Signed <: Integer
#
# Abstract supertype for all signed integers.

# -------------------------
# Core.Unsigned
# Type Unsigned <: Integer
#
# Abstract supertype for all unsigned integers.

# -------------------------
# Base.AbstractIrrational
# Type AbstractIrrational <: Real
#
# Number type representing an exact irrational value, which is automatically rounded to the correct precision in
# arithmetic operations with other numeric quantities.
# 
# Subtypes MyIrrational <: AbstractIrrational should implement at least ==(::MyIrrational, ::MyIrrational),
# hash(x::MyIrrational, h::UInt), and convert(::Type{F}, x::MyIrrational) where {F <: Union{BigFloat,Float32,Float64}}.
# 
# If a subtype is used to represent values that may occasionally be rational (e.g. a square-root type that represents √n
# for integers n will give a rational result when n is a perfect square), then it should also implement isinteger,
# iszero, isone, and == with Real values (since all of these default to false for AbstractIrrational types), as well as
# defining hash to equal that of the corresponding Rational.


# -----------------------------------------------------------
# Concrete number types

# -------------------------
# Core.Float16
# Type Float16 <: AbstractFloat
#
# 16-bit floating point number type (IEEE 754 standard).
# Binary format: 1 sign, 5 exponent, 10 fraction bits.

# -------------------------
# Core.Float32
# Type Float32 <: AbstractFloat
#
# 32-bit floating point number type (IEEE 754 standard).
# Binary format: 1 sign, 8 exponent, 23 fraction bits.

# -------------------------
# Core.Float64
# Type Float64 <: AbstractFloat
#
# 64-bit floating point number type (IEEE 754 standard).
# Binary format: 1 sign, 11 exponent, 52 fraction bits.

# -------------------------
# Base.MPFR.BigFloat
# Type BigFloat <: AbstractFloat
#
# Arbitrary precision floating point number type.

# -------------------------
# Core.Bool
# Type Bool <: Integer
#
# Boolean type, containing the values true and false.
# Bool is a kind of number: false is numerically equal to 0 and true is numerically equal to 1. Moreover, false acts as
# a multiplicative "strong zero":
# See also: digits, iszero, NaN.

false == 0              # true
true == 1               # true
0 * NaN                 # NaN
false * NaN             # 0.0

# -------------------------
# Core.Int8
# Type Int8 <: Signed
#
# 8-bit signed integer type.

# -------------------------
# Core.UInt8
# Type UInt8 <: Unsigned
#
# 8-bit unsigned integer type.

# -------------------------
# Core.Int16
# Type Int16 <: Signed
#
# 16-bit signed integer type.

# -------------------------
# Core.UInt16
# Type UInt16 <: Unsigned
#
# 16-bit unsigned integer type.

# -------------------------
# Core.Int32
# Type Int32 <: Signed
#
# 32-bit signed integer type.

# -------------------------
# Core.UInt32
# Type UInt32 <: Unsigned
#
# 32-bit unsigned integer type.

# -------------------------
# Core.Int64
# Type Int64 <: Signed
#
# 64-bit signed integer type.

# -------------------------
# Core.UInt64
# Type UInt64 <: Unsigned
#
# 64-bit unsigned integer type.

# -------------------------
# Core.Int128
# Type Int128 <: Signed
#
# 128-bit signed integer type.

# -------------------------
# Core.UInt128
# Type UInt128 <: Unsigned
#
# 128-bit unsigned integer type.

# -------------------------
# Base.GMP.BigInt
# Type BigInt <: Signed
#
# Arbitrary precision integer type.

# -------------------------
# Base.Complex
# Type Complex{T<:Real} <: Number
#
# Complex number type with real and imaginary part of type T.
# ComplexF16, ComplexF32 and ComplexF64 are aliases for Complex{Float16}, Complex{Float32} and Complex{Float64} respectively.
# See also: Real, complex, real.

# -------------------------
# Base.Rational
# Type Rational{T<:Integer} <: Real
#
# Rational number type, with numerator and denominator of type T. Rationals are checked for overflow.

# -------------------------
# Base.Irrational
# Type Irrational{sym} <: AbstractIrrational
#
# Number type representing an exact irrational value denoted by the symbol sym, such as π, ℯ and γ.
# See also AbstractIrrational.

Float64(::Irrational{:v}) = 56.96124843     # Float64
Irrational{:v}()                            # v = 56.96124843...


# -----------------------------------------------------------
# Data Formats

# -------------------------
# Base.digits
# Function digits([T<:Integer], n::Integer; base::T = 10, pad::Integer = 1)
#
# Return an array with element type T (default Int) of the digits of n in the given base, optionally padded with zeros
# to a specified size. More significant digits are at higher indices, such that n == sum(digits[k]*base^(k-1) for
# k=1:length(digits)).
# See also ndigits, digits!, and for base 2 also bitstring, count_ones.

digits(10)                                  # 2-element Vector{Int64}: 0 1
digits(10, base = 2)                        # 4-element Vector{Int64}: 0 1 0 1
digits(-256, base = 10, pad = 5)            # 5-element Vector{Int64}: -6 -5 -2  0  0
digits(51966, base=16)                      # 4-element Vector{Int64}: 14 15 10 12
n = rand(-999:999);
n == evalpoly(13, digits(n, base = 13))     # true

# -------------------------
# Base.digits!
# Function digits!(array, n::Integer; base::Integer = 10)
#
# Fills an array of the digits of n in the given base. More significant digits are at higher indices. If the array
# length is insufficient, the least significant digits are filled up to the array length. If the array length is
# excessive, the excess portion is filled with zeros.

digits!([2, 2, 2, 2], 10, base = 2)         # 4-element Vector{Int64}: 0 1 0 1
digits!([2, 2, 2, 2, 2, 2], 10, base = 2)   # 6-element Vector{Int64}: 0 1 0 1 0 0
digits!([0, 0], 51966, base=16)             # 2-element Vector{Int64}: 14 15

# -------------------------
# Base.bitstring
# Function bitstring(n)
#
# A string giving the literal bit representation of a primitive type.
# See also count_ones, count_zeros, digits.

bitstring(Int32(4))                         # "00000000000000000000000000000100"
bitstring(2.2)                              # "0100000000000001100110011001100110011001100110011001100110011010"

# -------------------------
# Base.parse
# Function parse(::Type{Platform}, triplet::AbstractString)
#
# Parses a string platform triplet back into a Platform object.

# -----------
# Function parse(type, str; base)
#
# Parse a string as a number. For Integer types, a base can be specified (the default is 10). For floating-point types,
# the string is parsed as a decimal floating-point number. Complex types are parsed from decimal strings of the form
# "R±Iim" as a Complex(R,I) of the requested type; "i" or "j" can also be used instead of "im", and "R" or "Iim" are
# also permitted. If the string does not contain a valid number, an error is raised.

parse(Int, "1234")                          # 1234
parse(Int, "1234", base = 5)                # 194
parse(Int, "afc", base = 16)                # 2812
parse(Float64, "1.2e-3")                    # 0.0012
parse(Complex{Float64}, "3.2e-1 + 4.5im")   # 0.32 + 4.5im
parse(ComplexF64, "2+3i")                   # 2.0 + 3.0im
parse(Complex{Int}, "2+3i")                 # 2 + 3im

# -------------------------
# Base.tryparse
# Function tryparse(type, str; base)
#
# Like parse, but returns either a value of the requested type, or nothing if the string does not contain a valid number.

# -------------------------
# Base.big
# Function big(x)
#
# Convert a number to a maximum precision representation (typically BigInt or BigFloat). See BigFloat for information
# about some pitfalls with floating-point numbers.

# -------------------------
# Base.signed
# Function signed(T::Integer)
#
# Convert an integer bitstype to the signed type of the same size.

signed(UInt16)              # Int16
signed(UInt64)              # Int64

# -----------
# Function signed(x)
#
# Convert a number to a signed integer. If the argument is unsigned, it is reinterpreted as signed without checking for
# overflow.
# See also: unsigned, sign, signbit.

# -------------------------
# Base.unsigned
# Function unsigned(T::Integer)
#
# Convert an integer bitstype to the unsigned type of the same size.

unsigned(Int16)             # UInt16
unsigned(UInt64)            # UInt64

# -------------------------
# Base.float
# Method float(x)
#
# Convert a number or array to a floating point data type.
# See also: complex, oftype, convert.

float(1:1000)               # 1.0:1.0:1000.0
float(typemax(Int32))       # 2.147483647e9

# -------------------------
# Base.Math.significand
# Function significand(x)
#
# Extract the significand (a.k.a. mantissa) of a floating-point number. If x is a non-zero finite number, then the
# result will be a number of the same type and sign as x, and whose absolute value is on the interval [1,2[. Otherwise x
# is returned.

significand(15.2)           # 1.9
significand(-15.2)          # -1.9
significand(-15.2) * 2^3    # -15.2
significand(-Inf), significand(Inf), significand(NaN)   # (-Inf, Inf, NaN)

# -------------------------
# Base.Math.exponent
# Function exponent(x) -> Int
#
# Returns the largest integer y such that 2^y ≤ abs(x). For a normalized floating-point number x, this corresponds to
# the exponent of x.

exponent(8)                 # 3
exponent(64//1)             # 6
exponent(1//64)             # -6
exponent(6.5)               # 2
exponent(16.0)              # 4
exponent(3.142e-4)          # -12

# -------------------------
# Base.complex
# Method complex(r, [i])
#
# Convert real numbers or arrays to complex. i defaults to zero.

complex(7)                  # 7 + 0im
complex([1, 2, 3])          # 3-element Vector{Complex{Int64}}: 1 + 0im  2 + 0im  3 + 0im

# -------------------------
# Base.bswap
# Function bswap(n)
#
# Reverse the byte order of n.
# (See also ntoh and hton to convert between the current native byte order and big-endian order.)

a = bswap(0x10203040)       # 0x40302010
bswap(a)                    # 0x10203040
bswap(0xCAFE)               # 0xfeca            0xCAFE is UInt16
bswap(UInt32(0xCAFE))       # 0xfeca0000
bswap(UInt64(0xCAFE))       # 0xfeca000000000000
string(1, base = 2)         # "1"
string(bswap(1), base = 2)  # "100000000000000000000000000000000000000000000000000000000"

# -------------------------
# Base.hex2bytes
# Function hex2bytes(itr)
#
# Given an iterable itr of ASCII codes for a sequence of hexadecimal digits, returns a Vector{UInt8} of bytes
# corresponding to the binary representation: each successive pair of hexadecimal digits in itr gives the value of one
# byte in the return vector.
# The length of itr must be even, and the returned array has half of the length of itr. See also hex2bytes! for an
# in-place version, and bytes2hex for the inverse.

s = string(12345, base = 16)    # "3039"
hex2bytes(s)                    # 2-element Vector{UInt8}:  0x30 0x39
a = b"01abEF"                   # 6-element Base.CodeUnits{UInt8, String}:  0x30 0x31 0x61 0x62 0x45 0x46
hex2bytes(a)                    # 3-element Vector{UInt8}: 0x01 0xab 0xef

# -------------------------
# Base.hex2bytes!
# Function hex2bytes!(dest::AbstractVector{UInt8}, itr)
#
# Convert an iterable itr of bytes representing a hexadecimal string to its binary representation, similar to hex2bytes
# except that the output is written in-place to dest. The length of dest must be half the length of itr.

# -------------------------
# Base.bytes2hex
# Function bytes2hex(itr) -> String
# Function bytes2hex(io::IO, itr)
#
# Convert an iterator itr of bytes to its hexadecimal string representation, either returning a String via
# bytes2hex(itr) or writing the string to an io stream via bytes2hex(io, itr). The hexadecimal characters are all
# lowercase.

a = string(12345, base = 16)    # "3039"
b = hex2bytes(a)                # 2-element Vector{UInt8}: 0x30 0x39
bytes2hex(b)                    # "3039"


# -----------------------------------------------------------
# General Number Functions and Constants

# Base.one
# Function one(x)
# Function one(T::type)
# 
# Return a multiplicative identity for x: a value such that one(x)*x == x*one(x) == x. Alternatively one(T) can take a
# type T, in which case one returns a multiplicative identity for any x of type T.
# 
# If possible, one(x) returns a value of the same type as x, and one(T) returns a value of type T. However, this may not
# be the case for types representing dimensionful quantities (e.g. time in days), since the multiplicative identity must
# be dimensionless. In that case, one(x) should return an identity value of the same precision (and shape, for matrices)
# as x.
# # If you want a quantity that is of the same type as x, or of type T, even if x is dimensionful, use oneunit instead.
# See also the identity function, and I in LinearAlgebra for the identity matrix.

one(3.7)                        # 1.0
one(Int)                        # 1
import Dates; one(Dates.Day(1)) # 1

# -------------------------
# Base.oneunit
# Function oneunit(x::T)
# Function oneunit(T::Type)
# 
# Return T(one(x)), where T is either the type of the argument or (if a type is passed) the argument. This differs from
# one for dimensionful quantities: one is dimensionless (a multiplicative identity) while oneunit is dimensionful (of
# the same type as x, or of type T).

oneunit(3.7)                     # 1.0
import Dates; oneunit(Dates.Day) # 1 day

# -------------------------
# Base.zero
# Function zero(x)
# Function zero(::Type)
#
# Get the additive identity element for the type of x (x can also specify the type itself).
# See also iszero, one, oneunit, oftype.

zero(1)                         # 0
zero(big"2.0")                  # 0.0
zero(rand(2,2))                 # 2×2 Matrix{Float64}:  0.0  0.0\n  0.0  0.0

# -------------------------
# Base.im
# Constant im
#
# The imaginary unit.
# See also: imag, angle, complex.

im * im                         # -1 + 0im
(2.0 + 3im)^2                   # -5.0 + 12.0im

# -------------------------
# Base.MathConstants.pi
# Constant π
# Constant pi
#
# The constant pi.
# Unicode π can be typed by writing \pi then pressing tab in the Julia REPL, and in many editors.
# See also: sinpi, sincospi, deg2rad.

pi                              # π = 3.1415926535897...
1/2pi                           # 0.15915494309189535

# -------------------------
# Base.MathConstants.ℯ
# Constant ℯ
#
# The constant ℯ.
# Unicode ℯ can be typed by writing \euler and pressing tab in the Julia REPL, and in many editors.
# See also: exp, cis, cispi.

ℯ                               # ℯ = 2.7182818284590...
log(ℯ)                          # 1
ℯ^(im)π ≈ -1                    # true

# -------------------------
# Base.MathConstants.catalan
# Constant catalan = Σ{n=0..∞}(-1)ⁿ/(2n+1)² = 1/1² - 1/3² + 1/5² - 1/7² ...
#
# Catalan's constant.

Base.MathConstants.catalan      # catalan = 0.9159655941772...
sum(log(x)/(1+x^2) for x in 1:0.01:10^6) * 0.01     # 0.9159466120554123

# -------------------------
# Base.MathConstants.eulergamma
# Constant γ
#
# Constant eulergamma = difference between the harmonic series and the natural logarithm = lim{n->∞} (Σ{k=1..n}1/k)-log(n)
# Euler's constant.

Base.MathConstants.eulergamma   # γ = 0.5772156649015...
dx = 10^-6;                     # 
sum(-exp(-x) * log(x) for x in dx:dx:100) * dx  # 0.5772078382499133
sum(1/k for k in 1:100_000)-log(100_000)        # 0.5772206648931064

# -------------------------
# Base.MathConstants.golden
# Constant φ
#
# Constant golden  = (1+√5)/2
# The golden ratio.

Base.MathConstants.golden       # φ = 1.6180339887498...
(2Base.MathConstants.φ - 1)^2 ≈ 5   # true

# -------------------------
# Base.Inf
# Constant Inf, Inf64
#
# Positive infinity of type Float64.
# See also: isfinite, typemax, NaN, Inf32.

π/0                             # Inf
+1.0 / -0.0                     # -Inf
ℯ^-Inf                          # 0.0

# -------------------------
# Base.Inf64
# Constant Inf, Inf64
#
# Positive infinity of type Float64.
# See also: isfinite, typemax, NaN, Inf32.

π/0                             # Inf
+1.0 / -0.0                     # -Inf
ℯ^-Inf                          # 0.0

# -------------------------
# Base.Inf32
# Constant Inf32
#
# Positive infinity of type Float32.

# -------------------------
# Base.Inf16
# Constant Inf16
#
# Positive infinity of type Float16.

# -------------------------
# Base.NaN
# Constant NaN, NaN64
#
# A not-a-number value of type Float64.
# See also: isnan, missing, NaN32, Inf.

0/0                             # NaN
Inf - Inf                       # NaN
NaN == NaN, isequal(NaN, NaN), NaN === NaN  # (false, true, true)

# -------------------------
# Base.NaN64
# Constant NaN, NaN64
#
# A not-a-number value of type Float64.
# See also: isnan, missing, NaN32, Inf.

0/0                             # NaN
Inf - Inf                       # NaN
NaN == NaN, isequal(NaN, NaN), NaN === NaN  # (false, true, true)

# -------------------------
# Base.NaN32
# Constant NaN32
#
# A not-a-number value of type Float32.

# -------------------------
# Base.NaN16
# Constant NaN16
#
# A not-a-number value of type Float16.

# -------------------------
# Base.issubnormal
# Function issubnormal(f) -> Bool
#
# Test whether a floating point number is subnormal.
# An IEEE floating point number is subnormal when its exponent bits are zero and its significand is not zero.

floatmin(Float32)               # 1.1754944f-38
issubnormal(1.0f-37)            # false
issubnormal(1.0f-38)            # true

# -------------------------
# Base.isfinite
# Function isfinite(f) -> Bool
#
# Test whether a number is finite.

isfinite(5)                     # true
isfinite(NaN32)                 # false

# -------------------------
# Base.isinf
# Function isinf(f) -> Bool
#
# Test whether a number is infinite.
# See also: Inf, iszero, isfinite, isnan.

# -------------------------
# Base.isnan
# Function isnan(f) -> Bool
#
# Test whether a number value is a NaN, an indeterminate value which is neither an infinity nor a finite number ("not a
# number").
# See also: iszero, isone, isinf, ismissing.

# -------------------------
# Base.iszero
# Function iszero(x)
#
# Return true if x == zero(x); if x is an array, this checks whether all of the elements of x are zero.
# See also: isone, isinteger, isfinite, isnan.

iszero(0.0)                     # true
iszero([1, 9, 0])               # false
iszero([false, 0, 0])           # true

# -------------------------
# Base.isone
# Function isone(x)
#
# Return true if x == one(x); if x is an array, this checks whether x is an identity matrix.

isone(1.0)                      # true
isone([1 0; 0 2])               # false
isone([1 0; 0 true])            # true

# -------------------------
# Base.nextfloat
# Function nextfloat(x::AbstractFloat, n::Integer)
#
# The result of n iterative applications of nextfloat to x if n >= 0, or -n applications of prevfloat if n < 0.

# ----------
# Function nextfloat(x::AbstractFloat)
#
# Return the smallest floating point number y of the same type as x such x < y. If no such y exists (e.g. if x is Inf or
# NaN), then return x.
# See also: prevfloat, eps, issubnormal.

# -------------------------
# Base.prevfloat
# Function prevfloat(x::AbstractFloat, n::Integer)
#
# The result of n iterative applications of prevfloat to x if n >= 0, or -n applications of nextfloat if n < 0.

# ----------
# Function prevfloat(x::AbstractFloat)
#
# Return the largest floating point number y of the same type as x such y < x. If no such y exists (e.g. if x is -Inf or
# NaN), then return x.

# -------------------------
# Base.isinteger
# Function isinteger(x) -> Bool
#
# Test whether x is numerically equal to some integer.

isinteger(4.0)                  # true

# -------------------------
# Base.isreal
# Function isreal(x) -> Bool
#
# Test whether x or all its elements are numerically equal to some real number including infinities and NaNs. isreal(x)
# is true if isequal(x, real(x)) is true.

isreal(5.)                      # true
isreal(1 - 3im)                 # false
isreal(Inf + 0im)               # true
isreal([4.; complex(0,1)])      # false
isreal([2,2.0,2+0im])           # true

# -------------------------
# Core.Float32
# Method Float32(x [, mode::RoundingMode])
#
# Create a Float32 from x. If x is not exactly representable then mode determines how x is rounded.
# See RoundingMode for available rounding modes.

Float32(1/3, RoundDown)         # 0.3333333f0
Float32(1/3, RoundUp)           # 0.33333334f0

# -------------------------
# Core.Float64
# Method Float64(x [, mode::RoundingMode])
#
# Create a Float64 from x. If x is not exactly representable then mode determines how x is rounded.
# See RoundingMode for available rounding modes.

Core.Float64(pi, RoundDown)          # 3.141592653589793
Core.Float64(pi, RoundUp)            # 3.1415926535897936

# -------------------------
# Base.Rounding.rounding
# Function rounding(T)
#
# Get the current floating point rounding mode for type T, controlling the rounding of basic arithmetic functions (+, -,
# *, / and sqrt) and type conversion.
# See RoundingMode for available modes.

# -------------------------
# Base.Rounding.setrounding
# Method setrounding(T, mode)
#
# Set the rounding mode of floating point type T, controlling the rounding of basic arithmetic functions (+, -, *, / and
# sqrt) and type conversion. Other numerical functions may give incorrect or invalid values when using rounding modes
# other than the default RoundNearest.
# Note that this is currently only supported for T == BigFloat.
#
# Warning: This function is not thread-safe. It will affect code running on all threads, but its behavior is undefined
# if called concurrently with computations that use the setting.

# -------------------------
# Base.Rounding.setrounding
# Method setrounding(f::Function, T, mode)
#
# Change the rounding mode of floating point type T for the duration of f. It is logically equivalent to:
#   old = rounding(T)
#   setrounding(T, mode)
#   f()
#   setrounding(T, old)
#
# See RoundingMode for available rounding modes.

# -------------------------
# Base.Rounding.get_zero_subnormals
# Function get_zero_subnormals() -> Bool
#
# Return false if operations on subnormal floating-point values ("denormals") obey rules for IEEE arithmetic, and true
# if they might be converted to zeros.
# Warning: This function only affects the current thread.

# -------------------------
# Base.Rounding.set_zero_subnormals
# Function set_zero_subnormals(yes::Bool) -> Bool
#
# If yes is false, subsequent floating-point operations follow rules for IEEE arithmetic on subnormal values
# ("denormals"). Otherwise, floating-point operations are permitted (but not required) to convert subnormal inputs or
# outputs to zero. Returns true unless yes==true but the hardware does not support zeroing of subnormal numbers.
# set_zero_subnormals(true) can speed up some computations on some hardware. However, it can break identities such as
# (x-y==0) == (x==y).
# Warning: This function only affects the current thread.


# -----------------------------------------------------------
# Integers

# Base.count_ones
# Function count_ones(x::Integer) -> Integer
#
# Number of ones in the binary representation of x.

count_ones(7)                   # 3
count_ones(Int32(-1))           # 32

# See Hamming distance example in Julia

# -------------------------
# Base.count_zeros
# Function count_zeros(x::Integer) -> Integer
#
# Number of zeros in the binary representation of x.

count_zeros(Int32(2 ^ 16 - 1))  # 16
count_zeros(-1)                 # 0

# -------------------------
# Base.leading_zeros
# Function leading_zeros(x::Integer) -> Integer
#
# Number of zeros leading the binary representation of x.

leading_zeros(Int32(1))         # 31

# -------------------------
# Base.leading_ones
# Function leading_ones(x::Integer) -> Integer
#
# Number of ones leading the binary representation of x.

leading_ones(UInt32(2 ^ 32 - 2))    # 31

# -------------------------
# Base.trailing_zeros
# Function trailing_zeros(x::Integer) -> Integer
#
# Number of zeros trailing the binary representation of x.

trailing_zeros(2)               # 1

# -------------------------
# Base.trailing_ones
# Function trailing_ones(x::Integer) -> Integer
#
# Number of ones trailing the binary representation of x.

trailing_ones(3)                # 2

# -------------------------
# Base.isodd
# Function isodd(x::Number) -> Bool
#
# Return true if x is an odd integer (that is, an integer not divisible by 2), and false otherwise.

isodd(9)                        # true
isodd(10)                       # false
isodd(3.0)                      # true
isodd(3.1)                      # false

# -------------------------
# Base.iseven
# Function iseven(x::Number) -> Bool
#
# Return true if x is an even integer (that is, an integer divisible by 2), and false otherwise.

iseven(9)                       # false
iseven(10)                      # true

# -------------------------
# Core.@int128_str
# Macro @int128_str str
#
# Parse str as an Int128. Throw an ArgumentError if the string is not a valid integer.

int128"123456789123"            # 123456789123
# int128"123456789123.4"        # ERROR: LoadError: ArgumentError: invalid base 10 digit '.' in "123456789123.4"

# -------------------------
# Core.@uint128_str
# Macro @uint128_str str
#
# Parse str as an UInt128. Throw an ArgumentError if the string is not a valid integer.

uint128"123456789123"           # 0x00000000000000000000001cbe991a83
# uint128"-123456789123"        # ERROR: LoadError: ArgumentError: invalid base 10 digit '-' in "-123456789123"


# -----------------------------------------------------------
# BigFloats and BigInts

# The BigFloat and BigInt types implements arbitrary-precision floating point and integer arithmetic, respectively. For
# BigFloat the GNU MPFR library is used, and for BigInt the GNU Multiple Precision Arithmetic Library (GMP) is used.

# -------------------------
# Base.MPFR.BigFloat
# Method BigFloat(x::Union{Real, AbstractString} [, rounding::RoundingMode=rounding(BigFloat)]; [precision::Integer=precision(BigFloat)])
#
# Create an arbitrary precision floating point number from x, with precision precision. The rounding argument specifies
# the direction in which the result should be rounded if the conversion cannot be done exactly. If not provided, these
# are set by the current global values.
# 
# BigFloat(x::Real) is the same as convert(BigFloat,x), except if x itself is already BigFloat, in which case it will
# return a value with the precision set to the current global precision; convert will always return x.
# 
# BigFloat(x::AbstractString) is identical to parse. This is provided for convenience since decimal literals are
# converted to Float64 when parsed, so BigFloat(2.1) may not yield what you expect.
# 
# See also: @big_str, rounding and setrounding, precision and setprecision

BigFloat(2.1) # 2.1 here is a Float64
# 2.100000000000000088817841970012523233890533447265625

BigFloat("2.1") # the closest BigFloat to 2.1
# 2.099999999999999999999999999999999999999999999999999999999999999999999999999986

BigFloat("2.1", RoundUp)
# 2.100000000000000000000000000000000000000000000000000000000000000000000000000021

BigFloat("2.1", RoundUp, precision=128)
# 2.100000000000000000000000000000000000007

# -------------------------
# Base.precision
# Function precision(num::AbstractFloat; base::Integer=2)
# Function precision(T::Type; base::Integer=2)
#
# Get the precision of a floating point number, as defined by the effective number of bits in the significand, or the
# precision of a floating-point type T (its current default, if T is a variable-precision type like BigFloat).
# If base is specified, then it returns the maximum corresponding number of significand digits in that base.

# -------------------------
# Base.MPFR.setprecision
# Function setprecision([T=BigFloat,] precision::Int; base=2)
#
# Set the precision (in bits, by default) to be used for T arithmetic. If base is specified, then the precision is the
# minimum required to give at least precision digits in the given base.
# Warning: This function is not thread-safe. It will affect code running on all threads, but its behavior is undefined
# if called concurrently with computations that use the setting.

# ---------
# Function setprecision(f::Function, [T=BigFloat,] precision::Integer; base=2)
#
# Change the T arithmetic precision (in the given base) for the duration of f. It is logically equivalent to:
#       old = precision(BigFloat)
#       setprecision(BigFloat, precision)
#       f()
#       setprecision(BigFloat, old)
# Often used as setprecision(T, precision) do ... end
# Note: nextfloat(), prevfloat() do not use the precision mentioned by setprecision.

# -------------------------
# Base.GMP.BigInt
# Method BigInt(x)
#
# Create an arbitrary precision integer. x may be an Int (or anything that can be converted to an Int). The usual
# mathematical operators are defined for this type, and results are promoted to a BigInt.
# Instances can be constructed from strings via parse, or using the big string literal.

parse(BigInt, "42")             # 42
big"313"                        # 313
BigInt(10)^19                   # 10000000000000000000

# -------------------------
# Core.@big_str
# Macro @big_str str
#
# Parse a string into a BigInt or BigFloat, and throw an ArgumentError if the string is not a valid number. For integers
# _ is allowed in the string as a separator.

big"123_456"                    # 123456
big"7891.5"                     # 7891.5
# big"_"                        # ERROR: ArgumentError: invalid number format _ for BigInt or BigFloat
