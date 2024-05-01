# base_math.jl
# Julia Base doc, mathematics
# 
# 2024-05-01    PV

# Mathematics

# Mathematical Operators
Base.:-
—
Method
-(x)

Unary minus operator.

See also: abs, flipsign.

Examples

-1
-1

-(2)
-2

-[1 2; 3 4]
2×2 Matrix{Int64}:
 -1  -2
 -3  -4

source
Base.:+
—
Function
dt::Date + t::Time -> DateTime

The addition of a Date with a Time produces a DateTime. The hour, minute, second, and millisecond parts of the Time are used along with the year, month, and day of the Date to create the new DateTime. Non-zero microseconds or nanoseconds in the Time type will result in an InexactError being thrown.

+(x, y...)

Addition operator. x+y+z+... calls this function with all arguments, i.e. +(x, y, z, ...).

Examples

1 + 20 + 4
25

+(1, 20, 4)
25

source
Base.:-
—
Method
-(x, y)

Subtraction operator.

Examples

2 - 3
-1

-(2, 4.5)
-2.5

source
Base.:*
—
Method
*(x, y...)

Multiplication operator. x*y*z*... calls this function with all arguments, i.e. *(x, y, z, ...).

Examples

2 * 7 * 8
112

*(2, 7, 8)
112

source
Base.:/
—
Function
/(x, y)

Right division operator: multiplication of x by the inverse of y on the right. Gives floating-point results for integer arguments.

Examples

1/2
0.5

4/2
2.0

4.5/2
2.25

source
A / B

Matrix right-division: A / B is equivalent to (B' \ A')' where \ is the left-division operator. For square matrices, the result X is such that A == X*B.

See also: rdiv!.

Examples

A = Float64[1 4 5; 3 9 2]; B = Float64[1 4 2; 3 4 2; 8 7 1];

X = A / B
2×3 Matrix{Float64}:
 -0.65   3.75  -1.2
  3.25  -2.75   1.0

isapprox(A, X*B)
true

isapprox(X, A*pinv(B))
true

Base.:\
—
Method
\(x, y)

Left division operator: multiplication of y by the inverse of x on the left. Gives floating-point results for integer arguments.

Examples

3 \ 6
2.0

inv(3) * 6
2.0

A = [4 3; 2 1]; x = [5, 6];

A \ x
2-element Vector{Float64}:
  6.5
 -7.0

inv(A) * x
2-element Vector{Float64}:
  6.5
 -7.0

source
Base.:^
—
Method
^(x, y)

Exponentiation operator. If x is a matrix, computes matrix exponentiation.

If y is an Int literal (e.g. 2 in x^2 or -3 in x^-3), the Julia code x^y is transformed by the compiler to Base.literal_pow(^, x, Val(y)), to enable compile-time specialization on the value of the exponent. (As a default fallback we have Base.literal_pow(^, x, Val(y)) = ^(x,y), where usually ^ == Base.^ unless ^ has been defined in the calling namespace.) If y is a negative integer literal, then Base.literal_pow transforms the operation to inv(x)^-y by default, where -y is positive.

Examples

3^5
243

A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

A^3
2×2 Matrix{Int64}:
 37   54
 81  118

source
Base.fma
—
Function
fma(x, y, z)

Computes x*y+z without rounding the intermediate result x*y. On some systems this is significantly more expensive than x*y+z. fma is used to improve accuracy in certain algorithms. See muladd.

source
Base.muladd
—
Function
muladd(x, y, z)

Combined multiply-add: computes x*y+z, but allowing the add and multiply to be merged with each other or with surrounding operations for performance. For example, this may be implemented as an fma if the hardware supports it efficiently. The result can be different on different machines and can also be different on the same machine due to constant propagation or other optimizations. See fma.

Examples

muladd(3, 2, 1)
7

3 * 2 + 1
7

source
muladd(A, y, z)

Combined multiply-add, A*y .+ z, for matrix-matrix or matrix-vector multiplication. The result is always the same size as A*y, but z may be smaller, or a scalar.

Julia 1.6
These methods require Julia 1.6 or later.

Examples

A=[1.0 2.0; 3.0 4.0]; B=[1.0 1.0; 1.0 1.0]; z=[0, 100];

muladd(A, B, z)
2×2 Matrix{Float64}:
   3.0    3.0
 107.0  107.0

Base.inv
—
Method
inv(x)

Return the multiplicative inverse of x, such that x*inv(x) or inv(x)*x yields one(x) (the multiplicative identity) up to roundoff errors.

If x is a number, this is essentially the same as one(x)/x, but for some types inv(x) may be slightly more efficient.

Examples

inv(2)
0.5

inv(1 + 2im)
0.2 - 0.4im

inv(1 + 2im) * (1 + 2im)
1.0 + 0.0im

inv(2//3)
3//2

Julia 1.2
inv(::Missing) requires at least Julia 1.2.

source
Base.div
—
Function
div(x, y)
÷(x, y)

The quotient from Euclidean (integer) division. Generally equivalent to a mathematical operation x/y without a fractional part.

See also: cld, fld, rem, divrem.

Examples

9 ÷ 4
2

-5 ÷ 3
-1

5.0 ÷ 2
2.0

div.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -1  -1  -1  0  0  0  0  0  1  1  1

source
Base.fld
—
Function
fld(x, y)

Largest integer less than or equal to x / y. Equivalent to div(x, y, RoundDown).

See also div, cld, fld1.

Examples

fld(7.3, 5.5)
1.0

fld.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -2  -2  -1  -1  -1  0  0  0  1  1  1

Because fld(x, y) implements strictly correct floored rounding based on the true value of floating-point numbers, unintuitive situations can arise. For example:

fld(6.0, 0.1)
59.0
6.0 / 0.1
60.0
6.0 / big(0.1)
59.99999999999999666933092612453056361837965690217069245739573412231113406246995

What is happening here is that the true value of the floating-point number written as 0.1 is slightly larger than the numerical value 1/10 while 6.0 represents the number 6 precisely. Therefore the true value of 6.0 / 0.1 is slightly less than 60. When doing division, this is rounded to precisely 60.0, but fld(6.0, 0.1) always takes the floor of the true value, so the result is 59.0.

source
Base.cld
—
Function
cld(x, y)

Smallest integer larger than or equal to x / y. Equivalent to div(x, y, RoundUp).

See also div, fld.

Examples

cld(5.5, 2.2)
3.0

cld.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -1  -1  -1  0  0  0  1  1  1  2  2

source
Base.mod
—
Function
mod(x::Integer, r::AbstractUnitRange)

Find y in the range r such that 
𝑥
≡
𝑦
(
𝑚
𝑜
𝑑
𝑛
)
x≡y(modn), where n = length(r), i.e. y = mod(x - first(r), n) + first(r).

See also mod1.

Examples

mod(0, Base.OneTo(3))  # mod1(0, 3)
3

mod(3, 0:2)  # mod(3, 3)
0

Julia 1.3
This method requires at least Julia 1.3.

source
mod(x, y)
rem(x, y, RoundDown)

The reduction of x modulo y, or equivalently, the remainder of x after floored division by y, i.e. x - y*fld(x,y) if computed without intermediate rounding.

The result will have the same sign as y, and magnitude less than abs(y) (with some exceptions, see note below).

Note
When used with floating point values, the exact result may not be representable by the type, and so rounding error may occur. In particular, if the exact result is very close to y, then it may be rounded to y.

See also: rem, div, fld, mod1, invmod.

mod(8, 3)
2

mod(9, 3)
0

mod(8.9, 3)
2.9000000000000004

mod(eps(), 3)
2.220446049250313e-16

mod(-eps(), 3)
3.0

mod.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 1  2  0  1  2  0  1  2  0  1  2

source
rem(x::Integer, T::Type{<:Integer}) -> T
mod(x::Integer, T::Type{<:Integer}) -> T
%(x::Integer, T::Type{<:Integer}) -> T

Find y::T such that x ≡ y (mod n), where n is the number of integers representable in T, and y is an integer in [typemin(T),typemax(T)]. If T can represent any integer (e.g. T == BigInt), then this operation corresponds to a conversion to T.

Examples

x = 129 % Int8
-127

typeof(x)
Int8

x = 129 % BigInt
129

typeof(x)
BigInt

source
Base.rem
—
Function
rem(x, y)
%(x, y)

Remainder from Euclidean division, returning a value of the same sign as x, and smaller in magnitude than y. This value is always exact.

See also: div, mod, mod1, divrem.

Examples

x = 15; y = 4;

x % y
3

x == div(x, y) * y + rem(x, y)
true

rem.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -2  -1  0  -2  -1  0  1  2  0  1  2

source
Base.Math.rem2pi
—
Function
rem2pi(x, r::RoundingMode)

Compute the remainder of x after integer division by 2π, with the quotient rounded according to the rounding mode r. In other words, the quantity

x - 2π*round(x/(2π),r)

without any intermediate rounding. This internally uses a high precision approximation of 2π, and so will give a more accurate result than rem(x,2π,r)

if r == RoundNearest, then the result is in the interval 
[
−
𝜋
,
𝜋
]
[−π,π]. This will generally be the most accurate result. See also RoundNearest.

if r == RoundToZero, then the result is in the interval 
[
0
,
2
𝜋
]
[0,2π] if x is positive,. or 
[
−
2
𝜋
,
0
]
[−2π,0] otherwise. See also RoundToZero.

if r == RoundDown, then the result is in the interval 
[
0
,
2
𝜋
]
[0,2π]. See also RoundDown.

if r == RoundUp, then the result is in the interval 
[
−
2
𝜋
,
0
]
[−2π,0]. See also RoundUp.

Examples

rem2pi(7pi/4, RoundNearest)
-0.7853981633974485

rem2pi(7pi/4, RoundDown)
5.497787143782138

source
Base.Math.mod2pi
—
Function
mod2pi(x)

Modulus after division by 2π, returning in the range 
[
0
,
2
𝜋
)
[0,2π).

This function computes a floating point representation of the modulus after division by numerically exact 2π, and is therefore not exactly the same as mod(x,2π), which would compute the modulus of x relative to division by the floating-point number 2π.

Note
Depending on the format of the input value, the closest representable value to 2π may be less than 2π. For example, the expression mod2pi(2π) will not return 0, because the intermediate value of 2*π is a Float64 and 2*Float64(π) < 2*big(π). See rem2pi for more refined control of this behavior.

Examples

mod2pi(9*pi/4)
0.7853981633974481

source
Base.divrem
—
Function
divrem(x, y, r::RoundingMode=RoundToZero)

The quotient and remainder from Euclidean division. Equivalent to (div(x, y, r), rem(x, y, r)). Equivalently, with the default value of r, this call is equivalent to (x ÷ y, x % y).

See also: fldmod, cld.

Examples

divrem(3, 7)
(0, 3)

divrem(7, 3)
(2, 1)

source
Base.fldmod
—
Function
fldmod(x, y)

The floored quotient and modulus after division. A convenience wrapper for divrem(x, y, RoundDown). Equivalent to (fld(x, y), mod(x, y)).

See also: fld, cld, fldmod1.

source
Base.fld1
—
Function
fld1(x, y)

Flooring division, returning a value consistent with mod1(x,y)

See also mod1, fldmod1.

Examples

x = 15; y = 4;

fld1(x, y)
4

x == fld(x, y) * y + mod(x, y)
true

x == (fld1(x, y) - 1) * y + mod1(x, y)
true

source
Base.mod1
—
Function
mod1(x, y)

Modulus after flooring division, returning a value r such that mod(r, y) == mod(x, y) in the range 
(
0
,
𝑦
]
(0,y] for positive y and in the range 
[
𝑦
,
0
)
[y,0) for negative y.

With integer arguments and positive y, this is equal to mod(x, 1:y), and hence natural for 1-based indexing. By comparison, mod(x, y) == mod(x, 0:y-1) is natural for computations with offsets or strides.

See also mod, fld1, fldmod1.

Examples

mod1(4, 2)
2

mod1.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 1  2  3  1  2  3  1  2  3  1  2

mod1.([-0.1, 0, 0.1, 1, 2, 2.9, 3, 3.1]', 3)
1×8 Matrix{Float64}:
 2.9  3.0  0.1  1.0  2.0  2.9  3.0  0.1

source
Base.fldmod1
—
Function
fldmod1(x, y)

Return (fld1(x,y), mod1(x,y)).

See also fld1, mod1.

source
Base.://
—
Function
//(num, den)

Divide two integers or rational numbers, giving a Rational result.

Examples

3 // 5
3//5

(3 // 5) // (2 // 1)
3//10

source
Base.rationalize
—
Function
rationalize([T<:Integer=Int,] x; tol::Real=eps(x))

Approximate floating point number x as a Rational number with components of the given integer type. The result will differ from x by no more than tol.

Examples

rationalize(5.6)
28//5

a = rationalize(BigInt, 10.3)
103//10

typeof(numerator(a))
BigInt

source
Base.numerator
—
Function
numerator(x)

Numerator of the rational representation of x.

Examples

numerator(2//3)
2

numerator(4)
4

source
Base.denominator
—
Function
denominator(x)

Denominator of the rational representation of x.

Examples

denominator(2//3)
3

denominator(4)
1

source
Base.:<<
—
Function
<<(x, n)

Left bit shift operator, x << n. For n >= 0, the result is x shifted left by n bits, filling with 0s. This is equivalent to x * 2^n. For n < 0, this is equivalent to x >> -n.

Examples

Int8(3) << 2
12

bitstring(Int8(3))
"00000011"

bitstring(Int8(12))
"00001100"

See also >>, >>>, exp2, ldexp.

source
<<(B::BitVector, n) -> BitVector

Left bit shift operator, B << n. For n >= 0, the result is B with elements shifted n positions backwards, filling with false values. If n < 0, elements are shifted forwards. Equivalent to B >> -n.

Examples

B = BitVector([true, false, true, false, false])
5-element BitVector:
 1
 0
 1
 0
 0

B << 1
5-element BitVector:
 0
 1
 0
 0
 0

B << -1
5-element BitVector:
 0
 1
 0
 1
 0

source
Base.:>>
—
Function
>>(x, n)

Right bit shift operator, x >> n. For n >= 0, the result is x shifted right by n bits, filling with 0s if x >= 0, 1s if x < 0, preserving the sign of x. This is equivalent to fld(x, 2^n). For n < 0, this is equivalent to x << -n.

Examples

Int8(13) >> 2
3

bitstring(Int8(13))
"00001101"

bitstring(Int8(3))
"00000011"

Int8(-14) >> 2
-4

bitstring(Int8(-14))
"11110010"

bitstring(Int8(-4))
"11111100"

See also >>>, <<.

source
>>(B::BitVector, n) -> BitVector

Right bit shift operator, B >> n. For n >= 0, the result is B with elements shifted n positions forward, filling with false values. If n < 0, elements are shifted backwards. Equivalent to B << -n.

Examples

B = BitVector([true, false, true, false, false])
5-element BitVector:
 1
 0
 1
 0
 0

B >> 1
5-element BitVector:
 0
 1
 0
 1
 0

B >> -1
5-element BitVector:
 0
 1
 0
 0
 0

source
Base.:>>>
—
Function
>>>(x, n)

Unsigned right bit shift operator, x >>> n. For n >= 0, the result is x shifted right by n bits, filling with 0s. For n < 0, this is equivalent to x << -n.

For Unsigned integer types, this is equivalent to >>. For Signed integer types, this is equivalent to signed(unsigned(x) >> n).

Examples

Int8(-14) >>> 2
60

bitstring(Int8(-14))
"11110010"

bitstring(Int8(60))
"00111100"

BigInts are treated as if having infinite size, so no filling is required and this is equivalent to >>.

See also >>, <<.

source
>>>(B::BitVector, n) -> BitVector

Unsigned right bitshift operator, B >>> n. Equivalent to B >> n. See >> for details and examples.

source
Base.bitrotate
—
Function
bitrotate(x::Base.BitInteger, k::Integer)

bitrotate(x, k) implements bitwise rotation. It returns the value of x with its bits rotated left k times. A negative value of k will rotate to the right instead.

Julia 1.5
This function requires Julia 1.5 or later.

See also: <<, circshift, BitArray.

bitrotate(UInt8(114), 2)
0xc9

bitstring(bitrotate(0b01110010, 2))
"11001001"

bitstring(bitrotate(0b01110010, -2))
"10011100"

bitstring(bitrotate(0b01110010, 8))
"01110010"

source
Base.::
—
Function
:expr

Quote an expression expr, returning the abstract syntax tree (AST) of expr. The AST may be of type Expr, Symbol, or a literal value. The syntax :identifier evaluates to a Symbol.

See also: Expr, Symbol, Meta.parse

Examples

expr = :(a = b + 2*x)
:(a = b + 2x)

sym = :some_identifier
:some_identifier

value = :0xff
0xff

typeof((expr, sym, value))
Tuple{Expr, Symbol, UInt8}

source
Base.range
—
Function
range(start, stop, length)
range(start, stop; length, step)
range(start; length, stop, step)
range(;start, length, stop, step)

Construct a specialized array with evenly spaced elements and optimized storage (an AbstractRange) from the arguments. Mathematically a range is uniquely determined by any three of start, step, stop and length. Valid invocations of range are:

Call range with any three of start, step, stop, length.
Call range with two of start, stop, length. In this case step will be assumed to be one. If both arguments are Integers, a UnitRange will be returned.
Call range with one of stop or length. start and step will be assumed to be one.
See Extended Help for additional details on the returned type.

Examples

range(1, length=100)
1:100

range(1, stop=100)
1:100

range(1, step=5, length=100)
1:5:496

range(1, step=5, stop=100)
1:5:96

range(1, 10, length=101)
1.0:0.09:10.0

range(1, 100, step=5)
1:5:96

range(stop=10, length=5)
6:10

range(stop=10, step=1, length=5)
6:1:10

range(start=1, step=1, stop=10)
1:1:10

range(; length = 10)
Base.OneTo(10)

range(; stop = 6)
Base.OneTo(6)

range(; stop = 6.5)
1.0:1.0:6.0

If length is not specified and stop - start is not an integer multiple of step, a range that ends before stop will be produced.

range(1, 3.5, step=2)
1.0:2.0:3.0

Special care is taken to ensure intermediate values are computed rationally. To avoid this induced overhead, see the LinRange constructor.

Julia 1.1
stop as a positional argument requires at least Julia 1.1.

Julia 1.7
The versions without keyword arguments and start as a keyword argument require at least Julia 1.7.

Julia 1.8
The versions with stop as a sole keyword argument, or length as a sole keyword argument require at least Julia 1.8.

Extended Help

range will produce a Base.OneTo when the arguments are Integers and

Only length is provided
Only stop is provided
range will produce a UnitRange when the arguments are Integers and

Only start and stop are provided
Only length and stop are provided
A UnitRange is not produced if step is provided even if specified as one.

source
Base.OneTo
—
Type
Base.OneTo(n)

Define an AbstractUnitRange that behaves like 1:n, with the added distinction that the lower limit is guaranteed (by the type system) to be 1.

source
Base.StepRangeLen
—
Type
StepRangeLen(         ref::R, step::S, len, [offset=1]) where {  R,S}
StepRangeLen{T,R,S}(  ref::R, step::S, len, [offset=1]) where {T,R,S}
StepRangeLen{T,R,S,L}(ref::R, step::S, len, [offset=1]) where {T,R,S,L}

A range r where r[i] produces values of type T (in the first form, T is deduced automatically), parameterized by a reference value, a step, and the length. By default ref is the starting value r[1], but alternatively you can supply it as the value of r[offset] for some other index 1 <= offset <= len. The syntax a:b or a:b:c, where any of a, b, or c are floating-point numbers, creates a StepRangeLen.

Julia 1.7
The 4th type parameter L requires at least Julia 1.7.

source
Base.:==
—
Function
==(x, y)

Generic equality operator. Falls back to ===. Should be implemented for all types with a notion of equality, based on the abstract value that an instance represents. For example, all numeric types are compared by numeric value, ignoring type. Strings are compared as sequences of characters, ignoring encoding. For collections, == is generally called recursively on all contents, though other properties (like the shape for arrays) may also be taken into account.

This operator follows IEEE semantics for floating-point numbers: 0.0 == -0.0 and NaN != NaN.

The result is of type Bool, except when one of the operands is missing, in which case missing is returned (three-valued logic). For collections, missing is returned if at least one of the operands contains a missing value and all non-missing values are equal. Use isequal or === to always get a Bool result.

Implementation

New numeric types should implement this function for two arguments of the new type, and handle comparison to other types via promotion rules where possible.

isequal falls back to ==, so new methods of == will be used by the Dict type to compare keys. If your type will be used as a dictionary key, it should therefore also implement hash.

If some type defines ==, isequal, and isless then it should also implement < to ensure consistency of comparisons.

source
Base.:!=
—
Function
!=(x, y)
≠(x,y)

Not-equals comparison operator. Always gives the opposite answer as ==.

Implementation

New types should generally not implement this, and rely on the fallback definition !=(x,y) = !(x==y) instead.

Examples

3 != 2
true

"foo" ≠ "foo"
false

source
!=(x)

Create a function that compares its argument to x using !=, i.e. a function equivalent to y -> y != x. The returned function is of type Base.Fix2{typeof(!=)}, which can be used to implement specialized methods.

Julia 1.2
This functionality requires at least Julia 1.2.

source
Base.:!==
—
Function
!==(x, y)
≢(x,y)

Always gives the opposite answer as ===.

Examples

a = [1, 2]; b = [1, 2];

a ≢ b
true

a ≢ a
false

source
Base.:<
—
Function
<(x, y)

Less-than comparison operator. Falls back to isless. Because of the behavior of floating-point NaN values, this operator implements a partial order.

Implementation

New types with a canonical partial order should implement this function for two arguments of the new type. Types with a canonical total order should implement isless instead.

See also isunordered.

Examples

'a' < 'b'
true

"abc" < "abd"
true

5 < 3
false

source
<(x)

Create a function that compares its argument to x using <, i.e. a function equivalent to y -> y < x. The returned function is of type Base.Fix2{typeof(<)}, which can be used to implement specialized methods.

Julia 1.2
This functionality requires at least Julia 1.2.

source
Base.:<=
—
Function
<=(x, y)
≤(x,y)

Less-than-or-equals comparison operator. Falls back to (x < y) | (x == y).

Examples

'a' <= 'b'
true

7 ≤ 7 ≤ 9
true

"abc" ≤ "abc"
true

5 <= 3
false

source
<=(x)

Create a function that compares its argument to x using <=, i.e. a function equivalent to y -> y <= x. The returned function is of type Base.Fix2{typeof(<=)}, which can be used to implement specialized methods.

Julia 1.2
This functionality requires at least Julia 1.2.

source
Base.:>
—
Function
>(x, y)

Greater-than comparison operator. Falls back to y < x.

Implementation

Generally, new types should implement < instead of this function, and rely on the fallback definition >(x, y) = y < x.

Examples

'a' > 'b'
false

7 > 3 > 1
true

"abc" > "abd"
false

5 > 3
true

source
>(x)

Create a function that compares its argument to x using >, i.e. a function equivalent to y -> y > x. The returned function is of type Base.Fix2{typeof(>)}, which can be used to implement specialized methods.

Julia 1.2
This functionality requires at least Julia 1.2.

source
Base.:>=
—
Function
>=(x, y)
≥(x,y)

Greater-than-or-equals comparison operator. Falls back to y <= x.

Examples

'a' >= 'b'
false

7 ≥ 7 ≥ 3
true

"abc" ≥ "abc"
true

5 >= 3
true

source
>=(x)

Create a function that compares its argument to x using >=, i.e. a function equivalent to y -> y >= x. The returned function is of type Base.Fix2{typeof(>=)}, which can be used to implement specialized methods.

Julia 1.2
This functionality requires at least Julia 1.2.

source
Base.cmp
—
Function
cmp(x,y)

Return -1, 0, or 1 depending on whether x is less than, equal to, or greater than y, respectively. Uses the total order implemented by isless.

Examples

cmp(1, 2)
-1

cmp(2, 1)
1

cmp(2+im, 3-im)
ERROR: MethodError: no method matching isless(::Complex{Int64}, ::Complex{Int64})
[...]

source
cmp(<, x, y)

Return -1, 0, or 1 depending on whether x is less than, equal to, or greater than y, respectively. The first argument specifies a less-than comparison function to use.

source
cmp(a::AbstractString, b::AbstractString) -> Int

Compare two strings. Return 0 if both strings have the same length and the character at each index is the same in both strings. Return -1 if a is a prefix of b, or if a comes before b in alphabetical order. Return 1 if b is a prefix of a, or if b comes before a in alphabetical order (technically, lexicographical order by Unicode code points).

Examples

cmp("abc", "abc")
0

cmp("ab", "abc")
-1

cmp("abc", "ab")
1

cmp("ab", "ac")
-1

cmp("ac", "ab")
1

cmp("α", "a")
1

cmp("b", "β")
-1

source
Base.:~
—
Function
~(x)

Bitwise not.

See also: !, &, |.

Examples

~4
-5

~10
-11

~true
false

source
Base.:&
—
Function
x & y

Bitwise and. Implements three-valued logic, returning missing if one operand is missing and the other is true. Add parentheses for function application form: (&)(x, y).

See also: |, xor, &&.

Examples

4 & 10
0

4 & 12
4

true & missing
missing

false & missing
false

source
Base.:|
—
Function
x | y

Bitwise or. Implements three-valued logic, returning missing if one operand is missing and the other is false.

See also: &, xor, ||.

Examples

4 | 10
14

4 | 1
5

true | missing
true

false | missing
missing

source
Base.xor
—
Function
xor(x, y)
⊻(x, y)

Bitwise exclusive or of x and y. Implements three-valued logic, returning missing if one of the arguments is missing.

The infix operation a ⊻ b is a synonym for xor(a,b), and ⊻ can be typed by tab-completing \xor or \veebar in the Julia REPL.

Examples

xor(true, false)
true

xor(true, true)
false

xor(true, missing)
missing

false ⊻ false
false

[true; true; false] .⊻ [true; false; false]
3-element BitVector:
 0
 1
 0

source
Base.nand
—
Function
nand(x, y)
⊼(x, y)

Bitwise nand (not and) of x and y. Implements three-valued logic, returning missing if one of the arguments is missing.

The infix operation a ⊼ b is a synonym for nand(a,b), and ⊼ can be typed by tab-completing \nand or \barwedge in the Julia REPL.

Examples

nand(true, false)
true

nand(true, true)
false

nand(true, missing)
missing

false ⊼ false
true

[true; true; false] .⊼ [true; false; false]
3-element BitVector:
 0
 1
 1

source
Base.nor
—
Function
nor(x, y)
⊽(x, y)

Bitwise nor (not or) of x and y. Implements three-valued logic, returning missing if one of the arguments is missing and the other is not true.

The infix operation a ⊽ b is a synonym for nor(a,b), and ⊽ can be typed by tab-completing \nor or \barvee in the Julia REPL.

Examples

nor(true, false)
false

nor(true, true)
false

nor(true, missing)
false

false ⊽ false
true

false ⊽ missing
missing

[true; true; false] .⊽ [true; false; false]
3-element BitVector:
 0
 0
 1

source
Base.:!
—
Function
!(x)

Boolean not. Implements three-valued logic, returning missing if x is missing.

See also ~ for bitwise not.

Examples

!true
false

!false
true

!missing
missing

.![true false true]
1×3 BitMatrix:
 0  1  0

source
!f::Function

Predicate function negation: when the argument of ! is a function, it returns a composed function which computes the boolean negation of f.

See also ∘.

Examples

str = "∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"
"∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"

filter(isletter, str)
"εδxyδfxfyε"

filter(!isletter, str)
"∀  > 0, ∃  > 0: |-| <  ⇒ |()-()| < "

Julia 1.9
Starting with Julia 1.9, !f returns a ComposedFunction instead of an anonymous function.

source
&&
—
Keyword
x && y

Short-circuiting boolean AND.

See also &, the ternary operator ? :, and the manual section on control flow.

Examples

x = 3;

x > 1 && x < 10 && x isa Int
true

x < 0 && error("expected positive x")
false

source
||
—
Keyword
x || y

Short-circuiting boolean OR.

See also: |, xor, &&.

Examples

pi < 3 || ℯ < 3
true

false || true || println("neither is true!")
true

source
Mathematical Functions
Base.isapprox
—
Function
isapprox(x, y; atol::Real=0, rtol::Real=atol>0 ? 0 : √eps, nans::Bool=false[, norm::Function])

Inexact equality comparison. Two numbers compare equal if their relative distance or their absolute distance is within tolerance bounds: isapprox returns true if norm(x-y) <= max(atol, rtol*max(norm(x), norm(y))). The default atol (absolute tolerance) is zero and the default rtol (relative tolerance) depends on the types of x and y. The keyword argument nans determines whether or not NaN values are considered equal (defaults to false).

For real or complex floating-point values, if an atol > 0 is not specified, rtol defaults to the square root of eps of the type of x or y, whichever is bigger (least precise). This corresponds to requiring equality of about half of the significant digits. Otherwise, e.g. for integer arguments or if an atol > 0 is supplied, rtol defaults to zero.

The norm keyword defaults to abs for numeric (x,y) and to LinearAlgebra.norm for arrays (where an alternative norm choice is sometimes useful). When x and y are arrays, if norm(x-y) is not finite (i.e. ±Inf or NaN), the comparison falls back to checking whether all elements of x and y are approximately equal component-wise.

The binary operator ≈ is equivalent to isapprox with the default arguments, and x ≉ y is equivalent to !isapprox(x,y).

Note that x ≈ 0 (i.e., comparing to zero with the default tolerances) is equivalent to x == 0 since the default atol is 0. In such cases, you should either supply an appropriate atol (or use norm(x) ≤ atol) or rearrange your code (e.g. use x ≈ y rather than x - y ≈ 0). It is not possible to pick a nonzero atol automatically because it depends on the overall scaling (the "units") of your problem: for example, in x - y ≈ 0, atol=1e-9 is an absurdly small tolerance if x is the radius of the Earth in meters, but an absurdly large tolerance if x is the radius of a Hydrogen atom in meters.

Julia 1.6
Passing the norm keyword argument when comparing numeric (non-array) arguments requires Julia 1.6 or later.

Examples

isapprox(0.1, 0.15; atol=0.05)
true

isapprox(0.1, 0.15; rtol=0.34)
true

isapprox(0.1, 0.15; rtol=0.33)
false

0.1 + 1e-10 ≈ 0.1
true

1e-10 ≈ 0
false

isapprox(1e-10, 0, atol=1e-8)
true

isapprox([10.0^9, 1.0], [10.0^9, 2.0]) # using `norm`
true

source
isapprox(x; kwargs...) / ≈(x; kwargs...)

Create a function that compares its argument to x using ≈, i.e. a function equivalent to y -> y ≈ x.

The keyword arguments supported here are the same as those in the 2-argument isapprox.

Julia 1.5
This method requires Julia 1.5 or later.

source
Base.sin
—
Method
sin(x)

Compute sine of x, where x is in radians.

See also sind, sinpi, sincos, cis, asin.

Examples

round.(sin.(range(0, 2pi, length=9)'), digits=3)
1×9 Matrix{Float64}:
 0.0  0.707  1.0  0.707  0.0  -0.707  -1.0  -0.707  -0.0

sind(45)
0.7071067811865476

sinpi(1/4)
0.7071067811865475

round.(sincos(pi/6), digits=3)
(0.5, 0.866)

round(cis(pi/6), digits=3)
0.866 + 0.5im

round(exp(im*pi/6), digits=3)
0.866 + 0.5im

source
Base.cos
—
Method
cos(x)

Compute cosine of x, where x is in radians.

See also cosd, cospi, sincos, cis.

source
Base.Math.sincos
—
Method
sincos(x)

Simultaneously compute the sine and cosine of x, where x is in radians, returning a tuple (sine, cosine).

See also cis, sincospi, sincosd.

source
Base.tan
—
Method
tan(x)

Compute tangent of x, where x is in radians.

source
Base.Math.sind
—
Function
sind(x)

Compute sine of x, where x is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.cosd
—
Function
cosd(x)

Compute cosine of x, where x is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.tand
—
Function
tand(x)

Compute tangent of x, where x is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.sincosd
—
Function
sincosd(x)

Simultaneously compute the sine and cosine of x, where x is in degrees.

Julia 1.3
This function requires at least Julia 1.3.

source
Base.Math.sinpi
—
Function
sinpi(x)

Compute 
sin
⁡
(
𝜋
𝑥
)
sin(πx) more accurately than sin(pi*x), especially for large x.

See also sind, cospi, sincospi.

source
Base.Math.cospi
—
Function
cospi(x)

Compute 
cos
⁡
(
𝜋
𝑥
)
cos(πx) more accurately than cos(pi*x), especially for large x.

source
Base.Math.sincospi
—
Function
sincospi(x)

Simultaneously compute sinpi(x) and cospi(x) (the sine and cosine of π*x, where x is in radians), returning a tuple (sine, cosine).

Julia 1.6
This function requires Julia 1.6 or later.

See also: cispi, sincosd, sinpi.

source
Base.sinh
—
Method
sinh(x)

Compute hyperbolic sine of x.

source
Base.cosh
—
Method
cosh(x)

Compute hyperbolic cosine of x.

source
Base.tanh
—
Method
tanh(x)

Compute hyperbolic tangent of x.

See also tan, atanh.

Examples

tanh.(-3:3f0)  # Here 3f0 isa Float32
7-element Vector{Float32}:
 -0.9950548
 -0.9640276
 -0.7615942
  0.0
  0.7615942
  0.9640276
  0.9950548

tan.(im .* (1:3))
3-element Vector{ComplexF64}:
 0.0 + 0.7615941559557649im
 0.0 + 0.9640275800758169im
 0.0 + 0.9950547536867306im

source
Base.asin
—
Method
asin(x)

Compute the inverse sine of x, where the output is in radians.

See also asind for output in degrees.

Examples

asin.((0, 1/2, 1))
(0.0, 0.5235987755982989, 1.5707963267948966)

asind.((0, 1/2, 1))
(0.0, 30.000000000000004, 90.0)

source
Base.acos
—
Method
acos(x)

Compute the inverse cosine of x, where the output is in radians

source
Base.atan
—
Method
atan(y)
atan(y, x)

Compute the inverse tangent of y or y/x, respectively.

For one argument, this is the angle in radians between the positive x-axis and the point (1, y), returning a value in the interval 
[
−
𝜋
/
2
,
𝜋
/
2
]
[−π/2,π/2].

For two arguments, this is the angle in radians between the positive x-axis and the point (x, y), returning a value in the interval 
[
−
𝜋
,
𝜋
]
[−π,π]. This corresponds to a standard atan2 function. Note that by convention atan(0.0,x) is defined as 
𝜋
π and atan(-0.0,x) is defined as 
−
𝜋
−π when x < 0.

See also atand for degrees.

Examples

rad2deg(atan(-1/√3))
-30.000000000000004

rad2deg(atan(-1, √3))
-30.000000000000004

rad2deg(atan(1, -√3))
150.0

source
Base.Math.asind
—
Function
asind(x)

Compute the inverse sine of x, where the output is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.acosd
—
Function
acosd(x)

Compute the inverse cosine of x, where the output is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.atand
—
Function
atand(y)
atand(y,x)

Compute the inverse tangent of y or y/x, respectively, where the output is in degrees.

Julia 1.7
The one-argument method supports square matrix arguments as of Julia 1.7.

source
Base.Math.sec
—
Method
sec(x)

Compute the secant of x, where x is in radians.

source
Base.Math.csc
—
Method
csc(x)

Compute the cosecant of x, where x is in radians.

source
Base.Math.cot
—
Method
cot(x)

Compute the cotangent of x, where x is in radians.

source
Base.Math.secd
—
Function
secd(x)

Compute the secant of x, where x is in degrees.

source
Base.Math.cscd
—
Function
cscd(x)

Compute the cosecant of x, where x is in degrees.

source
Base.Math.cotd
—
Function
cotd(x)

Compute the cotangent of x, where x is in degrees.

source
Base.Math.asec
—
Method
asec(x)

Compute the inverse secant of x, where the output is in radians.

source
Base.Math.acsc
—
Method
acsc(x)

Compute the inverse cosecant of x, where the output is in radians.

source
Base.Math.acot
—
Method
acot(x)

Compute the inverse cotangent of x, where the output is in radians.

source
Base.Math.asecd
—
Function
asecd(x)

Compute the inverse secant of x, where the output is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.acscd
—
Function
acscd(x)

Compute the inverse cosecant of x, where the output is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.acotd
—
Function
acotd(x)

Compute the inverse cotangent of x, where the output is in degrees. If x is a matrix, x needs to be a square matrix.

Julia 1.7
Matrix arguments require Julia 1.7 or later.

source
Base.Math.sech
—
Method
sech(x)

Compute the hyperbolic secant of x.

source
Base.Math.csch
—
Method
csch(x)

Compute the hyperbolic cosecant of x.

source
Base.Math.coth
—
Method
coth(x)

Compute the hyperbolic cotangent of x.

source
Base.asinh
—
Method
asinh(x)

Compute the inverse hyperbolic sine of x.

source
Base.acosh
—
Method
acosh(x)

Compute the inverse hyperbolic cosine of x.

source
Base.atanh
—
Method
atanh(x)

Compute the inverse hyperbolic tangent of x.

source
Base.Math.asech
—
Method
asech(x)

Compute the inverse hyperbolic secant of x.

source
Base.Math.acsch
—
Method
acsch(x)

Compute the inverse hyperbolic cosecant of x.

source
Base.Math.acoth
—
Method
acoth(x)

Compute the inverse hyperbolic cotangent of x.

source
Base.Math.sinc
—
Function
sinc(x)

Compute 
sin
⁡
(
𝜋
𝑥
)
/
(
𝜋
𝑥
)
sin(πx)/(πx) if 
𝑥
≠
0
x

=0, and 
1
1 if 
𝑥
=
0
x=0.

See also cosc, its derivative.

source
Base.Math.cosc
—
Function
cosc(x)

Compute 
cos
⁡
(
𝜋
𝑥
)
/
𝑥
−
sin
⁡
(
𝜋
𝑥
)
/
(
𝜋
𝑥
2
)
cos(πx)/x−sin(πx)/(πx 
2
 ) if 
𝑥
≠
0
x

=0, and 
0
0 if 
𝑥
=
0
x=0. This is the derivative of sinc(x).

source
Base.Math.deg2rad
—
Function
deg2rad(x)

Convert x from degrees to radians.

See also rad2deg, sind, pi.

Examples

deg2rad(90)
1.5707963267948966

source
Base.Math.rad2deg
—
Function
rad2deg(x)

Convert x from radians to degrees.

See also deg2rad.

Examples

rad2deg(pi)
180.0

source
Base.Math.hypot
—
Function
hypot(x, y)

Compute the hypotenuse 
∣
𝑥
∣
2
+
∣
𝑦
∣
2
∣x∣ 
2
 +∣y∣ 
2
 
​
  avoiding overflow and underflow.

This code is an implementation of the algorithm described in: An Improved Algorithm for hypot(a,b) by Carlos F. Borges The article is available online at arXiv at the link https://arxiv.org/abs/1904.09481

hypot(x...)

Compute the hypotenuse 
∑
∣
𝑥
𝑖
∣
2
∑∣x 
i
​
 ∣ 
2
 
​
  avoiding overflow and underflow.

See also norm in the LinearAlgebra standard library.

Examples

a = Int64(10)^10;

hypot(a, a)
1.4142135623730951e10

√(a^2 + a^2) # a^2 overflows
ERROR: DomainError with -2.914184810805068e18:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]

hypot(3, 4im)
5.0

hypot(-5.7)
5.7

hypot(3, 4im, 12.0)
13.0

using LinearAlgebra

norm([a, a, a, a]) == hypot(a, a, a, a)
true

source
Base.log
—
Method
log(x)

Compute the natural logarithm of x. Throws DomainError for negative Real arguments. Use complex negative arguments to obtain complex results.

See also ℯ, log1p, log2, log10.

Examples

log(2)
0.6931471805599453

log(-3)
ERROR: DomainError with -3.0:
log was called with a negative real argument but will only return a complex result if called with a complex argument. Try log(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

log.(exp.(-1:1))
3-element Vector{Float64}:
 -1.0
  0.0
  1.0

source
Base.log
—
Method
log(b,x)

Compute the base b logarithm of x. Throws DomainError for negative Real arguments.

Examples

log(4,8)
1.5

log(4,2)
0.5

log(-2, 3)
ERROR: DomainError with -2.0:
log was called with a negative real argument but will only return a complex result if called with a complex argument. Try log(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

log(2, -3)
ERROR: DomainError with -3.0:
log was called with a negative real argument but will only return a complex result if called with a complex argument. Try log(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

Note
If b is a power of 2 or 10, log2 or log10 should be used, as these will typically be faster and more accurate. For example,

log(100,1000000)
2.9999999999999996

log10(1000000)/2
3.0

source
Base.log2
—
Function
log2(x)

Compute the logarithm of x to base 2. Throws DomainError for negative Real arguments.

See also: exp2, ldexp, ispow2.

Examples

log2(4)
2.0

log2(10)
3.321928094887362

log2(-2)
ERROR: DomainError with -2.0:
log2 was called with a negative real argument but will only return a complex result if called with a complex argument. Try log2(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(f::Symbol, x::Float64) at ./math.jl:31
[...]

log2.(2.0 .^ (-1:1))
3-element Vector{Float64}:
 -1.0
  0.0
  1.0

source
Base.log10
—
Function
log10(x)

Compute the logarithm of x to base 10. Throws DomainError for negative Real arguments.

Examples

log10(100)
2.0

log10(2)
0.3010299956639812

log10(-2)
ERROR: DomainError with -2.0:
log10 was called with a negative real argument but will only return a complex result if called with a complex argument. Try log10(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(f::Symbol, x::Float64) at ./math.jl:31
[...]

source
Base.log1p
—
Function
log1p(x)

Accurate natural logarithm of 1+x. Throws DomainError for Real arguments less than -1.

Examples

log1p(-0.5)
-0.6931471805599453

log1p(0)
0.0

log1p(-2)
ERROR: DomainError with -2.0:
log1p was called with a real argument < -1 but will only return a complex result if called with a complex argument. Try log1p(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

source
Base.Math.frexp
—
Function
frexp(val)

Return (x,exp) such that x has a magnitude in the interval 
[
1
/
2
,
1
)
[1/2,1) or 0, and val is equal to 
𝑥
×
2
𝑒
𝑥
𝑝
x×2 
exp
 .

Examples

frexp(12.8)
(0.8, 4)

source
Base.exp
—
Method
exp(x)

Compute the natural base exponential of x, in other words 
ℯ
𝑥
ℯ 
x
 .

See also exp2, exp10 and cis.

Examples

exp(1.0)
2.718281828459045

exp(im * pi) ≈ cis(pi)
true

source
Base.exp2
—
Function
exp2(x)

Compute the base 2 exponential of x, in other words 
2
𝑥
2 
x
 .

See also ldexp, <<.

Examples

exp2(5)
32.0

2^5
32

exp2(63) > typemax(Int)
true

source
Base.exp10
—
Function
exp10(x)

Compute the base 10 exponential of x, in other words 
1
0
𝑥
10 
x
 .

Examples

exp10(2)
100.0

10^2
100

source
Base.Math.ldexp
—
Function
ldexp(x, n)

Compute 
𝑥
×
2
𝑛
x×2 
n
 .

Examples

ldexp(5., 2)
20.0

source
Base.Math.modf
—
Function
modf(x)

Return a tuple (fpart, ipart) of the fractional and integral parts of a number. Both parts have the same sign as the argument.

Examples

modf(3.5)
(0.5, 3.0)

modf(-3.5)
(-0.5, -3.0)

source
Base.expm1
—
Function
expm1(x)

Accurately compute 
𝑒
𝑥
−
1
e 
x
 −1. It avoids the loss of precision involved in the direct evaluation of exp(x)-1 for small values of x.

Examples

expm1(1e-16)
1.0e-16

exp(1e-16) - 1
0.0

source
Base.round
—
Method
round([T,] x, [r::RoundingMode])
round(x, [r::RoundingMode]; digits::Integer=0, base = 10)
round(x, [r::RoundingMode]; sigdigits::Integer, base = 10)

Rounds the number x.

Without keyword arguments, x is rounded to an integer value, returning a value of type T, or of the same type of x if no T is provided. An InexactError will be thrown if the value is not representable by T, similar to convert.

If the digits keyword argument is provided, it rounds to the specified number of digits after the decimal place (or before if negative), in base base.

If the sigdigits keyword argument is provided, it rounds to the specified number of significant digits, in base base.

The RoundingMode r controls the direction of the rounding; the default is RoundNearest, which rounds to the nearest integer, with ties (fractional values of 0.5) being rounded to the nearest even integer. Note that round may give incorrect results if the global rounding mode is changed (see rounding).

Examples

round(1.7)
2.0

round(Int, 1.7)
2

round(1.5)
2.0

round(2.5)
2.0

round(pi; digits=2)
3.14

round(pi; digits=3, base=2)
3.125

round(123.456; sigdigits=2)
120.0

round(357.913; sigdigits=4, base=2)
352.0

Note
Rounding to specified digits in bases other than 2 can be inexact when operating on binary floating point numbers. For example, the Float64 value represented by 1.15 is actually less than 1.15, yet will be rounded to 1.2. For example:

x = 1.15
1.15

big(1.15)
1.149999999999999911182158029987476766109466552734375

x < 115//100
true

round(x, digits=1)
1.2

Extensions

To extend round to new numeric types, it is typically sufficient to define Base.round(x::NewType, r::RoundingMode).

source
Base.Rounding.RoundingMode
—
Type
RoundingMode

A type used for controlling the rounding mode of floating point operations (via rounding/setrounding functions), or as optional arguments for rounding to the nearest integer (via the round function).

Currently supported rounding modes are:

RoundNearest (default)
RoundNearestTiesAway
RoundNearestTiesUp
RoundToZero
RoundFromZero
RoundUp
RoundDown
Julia 1.9
RoundFromZero requires at least Julia 1.9. Prior versions support RoundFromZero for BigFloats only.

source
Base.Rounding.RoundNearest
—
Constant
RoundNearest

The default rounding mode. Rounds to the nearest integer, with ties (fractional values of 0.5) being rounded to the nearest even integer.

source
Base.Rounding.RoundNearestTiesAway
—
Constant
RoundNearestTiesAway

Rounds to nearest integer, with ties rounded away from zero (C/C++ round behaviour).

source
Base.Rounding.RoundNearestTiesUp
—
Constant
RoundNearestTiesUp

Rounds to nearest integer, with ties rounded toward positive infinity (Java/JavaScript round behaviour).

source
Base.Rounding.RoundToZero
—
Constant
RoundToZero

round using this rounding mode is an alias for trunc.

source
Base.Rounding.RoundFromZero
—
Constant
RoundFromZero

Rounds away from zero.

Julia 1.9
RoundFromZero requires at least Julia 1.9. Prior versions support RoundFromZero for BigFloats only.

Examples

BigFloat("1.0000000000000001", 5, RoundFromZero)
1.06

source
Base.Rounding.RoundUp
—
Constant
RoundUp

round using this rounding mode is an alias for ceil.

source
Base.Rounding.RoundDown
—
Constant
RoundDown

round using this rounding mode is an alias for floor.

source
Base.round
—
Method
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]])
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; digits=0, base=10)
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; sigdigits, base=10)

Return the nearest integral value of the same type as the complex-valued z to z, breaking ties using the specified RoundingModes. The first RoundingMode is used for rounding the real components while the second is used for rounding the imaginary components.

RoundingModeReal and RoundingModeImaginary default to RoundNearest, which rounds to the nearest integer, with ties (fractional values of 0.5) being rounded to the nearest even integer.

Example

round(3.14 + 4.5im)
3.0 + 4.0im

round(3.14 + 4.5im, RoundUp, RoundNearestTiesUp)
4.0 + 5.0im

round(3.14159 + 4.512im; digits = 1)
3.1 + 4.5im

round(3.14159 + 4.512im; sigdigits = 3)
3.14 + 4.51im

source
Base.ceil
—
Function
ceil([T,] x)
ceil(x; digits::Integer= [, base = 10])
ceil(x; sigdigits::Integer= [, base = 10])

ceil(x) returns the nearest integral value of the same type as x that is greater than or equal to x.

ceil(T, x) converts the result to type T, throwing an InexactError if the value is not representable.

Keywords digits, sigdigits and base work as for round.

source
Base.floor
—
Function
floor([T,] x)
floor(x; digits::Integer= [, base = 10])
floor(x; sigdigits::Integer= [, base = 10])

floor(x) returns the nearest integral value of the same type as x that is less than or equal to x.

floor(T, x) converts the result to type T, throwing an InexactError if the value is not representable.

Keywords digits, sigdigits and base work as for round.

source
Base.trunc
—
Function
trunc([T,] x)
trunc(x; digits::Integer= [, base = 10])
trunc(x; sigdigits::Integer= [, base = 10])

trunc(x) returns the nearest integral value of the same type as x whose absolute value is less than or equal to the absolute value of x.

trunc(T, x) converts the result to type T, throwing an InexactError if the value is not representable.

Keywords digits, sigdigits and base work as for round.

See also: %, floor, unsigned, unsafe_trunc.

Examples

trunc(2.22)
2.0

trunc(-2.22, digits=1)
-2.2

trunc(Int, -2.22)
-2

source
Base.unsafe_trunc
—
Function
unsafe_trunc(T, x)

Return the nearest integral value of type T whose absolute value is less than or equal to the absolute value of x. If the value is not representable by T, an arbitrary value will be returned. See also trunc.

Examples

unsafe_trunc(Int, -2.2)
-2

unsafe_trunc(Int, NaN)
-9223372036854775808

source
Base.min
—
Function
min(x, y, ...)

Return the minimum of the arguments (with respect to isless). See also the minimum function to take the minimum element from a collection.

Examples

min(2, 5, 1)
1

source
Base.max
—
Function
max(x, y, ...)

Return the maximum of the arguments (with respect to isless). See also the maximum function to take the maximum element from a collection.

Examples

max(2, 5, 1)
5

source
Base.minmax
—
Function
minmax(x, y)

Return (min(x,y), max(x,y)).

See also extrema that returns (minimum(x), maximum(x)).

Examples

minmax('c','b')
('b', 'c')

source
Base.Math.clamp
—
Function
clamp(x, lo, hi)

Return x if lo <= x <= hi. If x > hi, return hi. If x < lo, return lo. Arguments are promoted to a common type.

See also clamp!, min, max.

Julia 1.3
missing as the first argument requires at least Julia 1.3.

Examples

clamp.([pi, 1.0, big(10)], 2.0, 9.0)
3-element Vector{BigFloat}:
 3.141592653589793238462643383279502884197169399375105820974944592307816406286198
 2.0
 9.0

clamp.([11, 8, 5], 10, 6)  # an example where lo > hi
3-element Vector{Int64}:
  6
  6
 10

source
clamp(x, T)::T

Clamp x between typemin(T) and typemax(T) and convert the result to type T.

See also trunc.

Examples

clamp(200, Int8)
127

clamp(-200, Int8)
-128

trunc(Int, 4pi^2)
39

source
clamp(x::Integer, r::AbstractUnitRange)

Clamp x to lie within range r.

Julia 1.6
This method requires at least Julia 1.6.

source
Base.Math.clamp!
—
Function
clamp!(array::AbstractArray, lo, hi)

Restrict values in array to the specified range, in-place. See also clamp.

Julia 1.3
missing entries in array require at least Julia 1.3.

Examples

row = collect(-4:4)';

clamp!(row, 0, Inf)
1×9 adjoint(::Vector{Int64}) with eltype Int64:
 0  0  0  0  0  1  2  3  4

clamp.((-4:4)', 0, Inf)
1×9 Matrix{Float64}:
 0.0  0.0  0.0  0.0  0.0  1.0  2.0  3.0  4.0

source
Base.abs
—
Function
abs(x)

The absolute value of x.

When abs is applied to signed integers, overflow may occur, resulting in the return of a negative value. This overflow occurs only when abs is applied to the minimum representable value of a signed integer. That is, when x == typemin(typeof(x)), abs(x) == x < 0, not -x as might be expected.

See also: abs2, unsigned, sign.

Examples

abs(-3)
3

abs(1 + im)
1.4142135623730951

abs.(Int8[-128 -127 -126 0 126 127])  # overflow at typemin(Int8)
1×6 Matrix{Int8}:
 -128  127  126  0  126  127

maximum(abs, [1, -2, 3, -4])
4

source
Base.Checked.checked_abs
—
Function
Base.checked_abs(x)

Calculates abs(x), checking for overflow errors where applicable. For example, standard two's complement signed integers (e.g. Int) cannot represent abs(typemin(Int)), thus leading to an overflow.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_neg
—
Function
Base.checked_neg(x)

Calculates -x, checking for overflow errors where applicable. For example, standard two's complement signed integers (e.g. Int) cannot represent -typemin(Int), thus leading to an overflow.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_add
—
Function
Base.checked_add(x, y)

Calculates x+y, checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_sub
—
Function
Base.checked_sub(x, y)

Calculates x-y, checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_mul
—
Function
Base.checked_mul(x, y)

Calculates x*y, checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_div
—
Function
Base.checked_div(x, y)

Calculates div(x,y), checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_rem
—
Function
Base.checked_rem(x, y)

Calculates x%y, checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_fld
—
Function
Base.checked_fld(x, y)

Calculates fld(x,y), checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_mod
—
Function
Base.checked_mod(x, y)

Calculates mod(x,y), checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.checked_cld
—
Function
Base.checked_cld(x, y)

Calculates cld(x,y), checking for overflow errors where applicable.

The overflow protection may impose a perceptible performance penalty.

source
Base.Checked.add_with_overflow
—
Function
Base.add_with_overflow(x, y) -> (r, f)

Calculates r = x+y, with the flag f indicating whether overflow has occurred.

source
Base.Checked.sub_with_overflow
—
Function
Base.sub_with_overflow(x, y) -> (r, f)

Calculates r = x-y, with the flag f indicating whether overflow has occurred.

source
Base.Checked.mul_with_overflow
—
Function
Base.mul_with_overflow(x, y) -> (r, f)

Calculates r = x*y, with the flag f indicating whether overflow has occurred.

source
Base.abs2
—
Function
abs2(x)

Squared absolute value of x.

This can be faster than abs(x)^2, especially for complex numbers where abs(x) requires a square root via hypot.

See also abs, conj, real.

Examples

abs2(-3)
9

abs2(3.0 + 4.0im)
25.0

sum(abs2, [1+2im, 3+4im])  # LinearAlgebra.norm(x)^2
30

source
Base.copysign
—
Function
copysign(x, y) -> z

Return z which has the magnitude of x and the same sign as y.

Examples

copysign(1, -2)
-1

copysign(-1, 2)
1

source
Base.sign
—
Function
sign(x)

Return zero if x==0 and 
𝑥
/
∣
𝑥
∣
x/∣x∣ otherwise (i.e., ±1 for real x).

See also signbit, zero, copysign, flipsign.

Examples

sign(-4.0)
-1.0

sign(99)
1

sign(-0.0)
-0.0

sign(0 + im)
0.0 + 1.0im

source
Base.signbit
—
Function
signbit(x)

Return true if the value of the sign of x is negative, otherwise false.

See also sign and copysign.

Examples

signbit(-4)
true

signbit(5)
false

signbit(5.5)
false

signbit(-4.1)
true

source
Base.flipsign
—
Function
flipsign(x, y)

Return x with its sign flipped if y is negative. For example abs(x) = flipsign(x,x).

Examples

flipsign(5, 3)
5

flipsign(5, -3)
-5

source
Base.sqrt
—
Method
sqrt(x)

Return 
𝑥
x
​
 . Throws DomainError for negative Real arguments. Use complex negative arguments instead. The prefix operator √ is equivalent to sqrt.

See also: hypot.

Examples

sqrt(big(81))
9.0

sqrt(big(-81))
ERROR: DomainError with -81.0:
NaN result for non-NaN input.
Stacktrace:
 [1] sqrt(::BigFloat) at ./mpfr.jl:501
[...]

sqrt(big(complex(-81)))
0.0 + 9.0im

.√(1:4)
4-element Vector{Float64}:
 1.0
 1.4142135623730951
 1.7320508075688772
 2.0

source
Base.isqrt
—
Function
isqrt(n::Integer)

Integer square root: the largest integer m such that m*m <= n.

isqrt(5)
2

source
Base.Math.cbrt
—
Function
cbrt(x::Real)

Return the cube root of x, i.e. 
𝑥
1
/
3
x 
1/3
 . Negative values are accepted (returning the negative real root when 
𝑥
<
0
x<0).

The prefix operator ∛ is equivalent to cbrt.

Examples

cbrt(big(27))
3.0

cbrt(big(-27))
-3.0

source
Base.real
—
Function
real(z)

Return the real part of the complex number z.

See also: imag, reim, complex, isreal, Real.

Examples

real(1 + 3im)
1

source
real(T::Type)

Return the type that represents the real part of a value of type T. e.g: for T == Complex{R}, returns R. Equivalent to typeof(real(zero(T))).

Examples

real(Complex{Int})
Int64

real(Float64)
Float64

source
real(A::AbstractArray)

Return an array containing the real part of each entry in array A.

Equivalent to real.(A), except that when eltype(A) <: Real A is returned without copying, and that when A has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

Examples

real([1, 2im, 3 + 4im])
3-element Vector{Int64}:
 1
 0
 3

real(fill(2 - im))
0-dimensional Array{Int64, 0}:
2

source
Base.imag
—
Function
imag(z)

Return the imaginary part of the complex number z.

See also: conj, reim, adjoint, angle.

Examples

imag(1 + 3im)
3

source
imag(A::AbstractArray)

Return an array containing the imaginary part of each entry in array A.

Equivalent to imag.(A), except that when A has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

Examples

imag([1, 2im, 3 + 4im])
3-element Vector{Int64}:
 0
 2
 4

imag(fill(2 - im))
0-dimensional Array{Int64, 0}:
-1

source
Base.reim
—
Function
reim(z)

Return a tuple of the real and imaginary parts of the complex number z.

Examples

reim(1 + 3im)
(1, 3)

source
reim(A::AbstractArray)

Return a tuple of two arrays containing respectively the real and the imaginary part of each entry in A.

Equivalent to (real.(A), imag.(A)), except that when eltype(A) <: Real A is returned without copying to represent the real part, and that when A has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

Examples

reim([1, 2im, 3 + 4im])
([1, 0, 3], [0, 2, 4])

reim(fill(2 - im))
(fill(2), fill(-1))

source
Base.conj
—
Function
conj(z)

Compute the complex conjugate of a complex number z.

See also: angle, adjoint.

Examples

conj(1 + 3im)
1 - 3im

source
conj(A::AbstractArray)

Return an array containing the complex conjugate of each entry in array A.

Equivalent to conj.(A), except that when eltype(A) <: Real A is returned without copying, and that when A has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

Examples

conj([1, 2im, 3 + 4im])
3-element Vector{Complex{Int64}}:
 1 + 0im
 0 - 2im
 3 - 4im

conj(fill(2 - im))
0-dimensional Array{Complex{Int64}, 0}:
2 + 1im

source
Base.angle
—
Function
angle(z)

Compute the phase angle in radians of a complex number z.

See also: atan, cis.

Examples

rad2deg(angle(1 + im))
45.0

rad2deg(angle(1 - im))
-45.0

rad2deg(angle(-1 - im))
-135.0

source
Base.cis
—
Function
cis(x)

More efficient method for exp(im*x) by using Euler's formula: 
𝑐
𝑜
𝑠
(
𝑥
)
+
𝑖
𝑠
𝑖
𝑛
(
𝑥
)
=
exp
⁡
(
𝑖
𝑥
)
cos(x)+isin(x)=exp(ix).

See also cispi, sincos, exp, angle.

Examples

cis(π) ≈ -1
true

source
Base.cispi
—
Function
cispi(x)

More accurate method for cis(pi*x) (especially for large x).

See also cis, sincospi, exp, angle.

Examples

cispi(10000)
1.0 + 0.0im

cispi(0.25 + 1im)
0.030556854645954562 + 0.03055685464595456im

Julia 1.6
This function requires Julia 1.6 or later.

source
Base.binomial
—
Function
binomial(n::Integer, k::Integer)

The binomial coefficient 
(
𝑛
𝑘
)
( 
k
n
​
 ), being the coefficient of the 
𝑘
kth term in the polynomial expansion of 
(
1
+
𝑥
)
𝑛
(1+x) 
n
 .

If 
𝑛
n is non-negative, then it is the number of ways to choose k out of n items:

(
𝑛
𝑘
)
=
𝑛
!
𝑘
!
(
𝑛
−
𝑘
)
!
( 
k
n
​
 )= 
k!(n−k)!
n!
​
 

where 
𝑛
!
n! is the factorial function.

If 
𝑛
n is negative, then it is defined in terms of the identity

(
𝑛
𝑘
)
=
(
−
1
)
𝑘
(
𝑘
−
𝑛
−
1
𝑘
)
( 
k
n
​
 )=(−1) 
k
 ( 
k
k−n−1
​
 )

See also factorial.

Examples

binomial(5, 3)
10

factorial(5) ÷ (factorial(5-3) * factorial(3))
10

binomial(-5, 3)
-35

External links

Binomial coefficient on Wikipedia.
source
binomial(x::Number, k::Integer)

The generalized binomial coefficient, defined for k ≥ 0 by the polynomial

1
𝑘
!
∏
𝑗
=
0
𝑘
−
1
(
𝑥
−
𝑗
)
k!
1
​
  
j=0
∏
k−1
​
 (x−j)

When k < 0 it returns zero.

For the case of integer x, this is equivalent to the ordinary integer binomial coefficient

(
𝑛
𝑘
)
=
𝑛
!
𝑘
!
(
𝑛
−
𝑘
)
!
( 
k
n
​
 )= 
k!(n−k)!
n!
​
 

Further generalizations to non-integer k are mathematically possible, but involve the Gamma function and/or the beta function, which are not provided by the Julia standard library but are available in external packages such as SpecialFunctions.jl.

External links

Binomial coefficient on Wikipedia.
source
Base.factorial
—
Function
factorial(n::Integer)

Factorial of n. If n is an Integer, the factorial is computed as an integer (promoted to at least 64 bits). Note that this may overflow if n is not small, but you can use factorial(big(n)) to compute the result exactly in arbitrary precision.

See also binomial.

Examples

factorial(6)
720

factorial(21)
ERROR: OverflowError: 21 is too large to look up in the table; consider using `factorial(big(21))` instead
Stacktrace:
[...]

factorial(big(21))
51090942171709440000

External links

Factorial on Wikipedia.
source
Base.gcd
—
Function
gcd(x, y...)

Greatest common (positive) divisor (or zero if all arguments are zero). The arguments may be integer and rational numbers.

Julia 1.4
Rational arguments require Julia 1.4 or later.

Examples

gcd(6, 9)
3

gcd(6, -9)
3

gcd(6, 0)
6

gcd(0, 0)
0

gcd(1//3, 2//3)
1//3

gcd(1//3, -2//3)
1//3

gcd(1//3, 2)
1//3

gcd(0, 0, 10, 15)
5

source
Base.lcm
—
Function
lcm(x, y...)

Least common (positive) multiple (or zero if any argument is zero). The arguments may be integer and rational numbers.

Julia 1.4
Rational arguments require Julia 1.4 or later.

Examples

lcm(2, 3)
6

lcm(-2, 3)
6

lcm(0, 3)
0

lcm(0, 0)
0

lcm(1//3, 2//3)
2//3

lcm(1//3, -2//3)
2//3

lcm(1//3, 2)
2//1

lcm(1, 3, 5, 7)
105

source
Base.gcdx
—
Function
gcdx(a, b)

Computes the greatest common (positive) divisor of a and b and their Bézout coefficients, i.e. the integer coefficients u and v that satisfy 
𝑢
𝑎
+
𝑣
𝑏
=
𝑑
=
𝑔
𝑐
𝑑
(
𝑎
,
𝑏
)
ua+vb=d=gcd(a,b). 
𝑔
𝑐
𝑑
𝑥
(
𝑎
,
𝑏
)
gcdx(a,b) returns 
(
𝑑
,
𝑢
,
𝑣
)
(d,u,v).

The arguments may be integer and rational numbers.

Julia 1.4
Rational arguments require Julia 1.4 or later.

Examples

gcdx(12, 42)
(6, -3, 1)

gcdx(240, 46)
(2, -9, 47)

Note
Bézout coefficients are not uniquely defined. gcdx returns the minimal Bézout coefficients that are computed by the extended Euclidean algorithm. (Ref: D. Knuth, TAoCP, 2/e, p. 325, Algorithm X.) For signed integers, these coefficients u and v are minimal in the sense that 
∣
𝑢
∣
<
∣
𝑏
/
𝑑
∣
∣u∣<∣b/d∣ and 
∣
𝑣
∣
<
∣
𝑎
/
𝑑
∣
∣v∣<∣a/d∣. Furthermore, the signs of u and v are chosen so that d is positive. For unsigned integers, the coefficients u and v might be near their typemax, and the identity then holds only via the unsigned integers' modulo arithmetic.

source
Base.ispow2
—
Function
ispow2(n::Number) -> Bool

Test whether n is an integer power of two.

See also count_ones, prevpow, nextpow.

Examples

ispow2(4)
true

ispow2(5)
false

ispow2(4.5)
false

ispow2(0.25)
true

ispow2(1//8)
true

Julia 1.6
Support for non-Integer arguments was added in Julia 1.6.

source
Base.nextpow
—
Function
nextpow(a, x)

The smallest a^n not less than x, where n is a non-negative integer. a must be greater than 1, and x must be greater than 0.

See also prevpow.

Examples

nextpow(2, 7)
8

nextpow(2, 9)
16

nextpow(5, 20)
25

nextpow(4, 16)
16

source
Base.prevpow
—
Function
prevpow(a, x)

The largest a^n not greater than x, where n is a non-negative integer. a must be greater than 1, and x must not be less than 1.

See also nextpow, isqrt.

Examples

prevpow(2, 7)
4

prevpow(2, 9)
8

prevpow(5, 20)
5

prevpow(4, 16)
16

source
Base.nextprod
—
Function
nextprod(factors::Union{Tuple,AbstractVector}, n)

Next integer greater than or equal to n that can be written as 
∏
𝑘
𝑖
𝑝
𝑖
∏k 
i
p 
i
​
 
​
  for integers 
𝑝
1
p 
1
​
 , 
𝑝
2
p 
2
​
 , etcetera, for factors 
𝑘
𝑖
k 
i
​
  in factors.

Examples

nextprod((2, 3), 105)
108

2^2 * 3^3
108

Julia 1.6
The method that accepts a tuple requires Julia 1.6 or later.

source
Base.invmod
—
Function
invmod(n, m)

Take the inverse of n modulo m: y such that 
𝑛
𝑦
=
1
(
m
o
d
𝑚
)
ny=1(modm), and 
𝑑
𝑖
𝑣
(
𝑦
,
𝑚
)
=
0
div(y,m)=0. This will throw an error if 
𝑚
=
0
m=0, or if 
𝑔
𝑐
𝑑
(
𝑛
,
𝑚
)
≠
1
gcd(n,m)

=1.

Examples

invmod(2, 5)
3

invmod(2, 3)
2

invmod(5, 6)
5

source
Base.powermod
—
Function
powermod(x::Integer, p::Integer, m)

Compute 
𝑥
𝑝
(
m
o
d
𝑚
)
x 
p
 (modm).

Examples

powermod(2, 6, 5)
4

mod(2^6, 5)
4

powermod(5, 2, 20)
5

powermod(5, 2, 19)
6

powermod(5, 3, 19)
11

source
Base.ndigits
—
Function
ndigits(n::Integer; base::Integer=10, pad::Integer=1)

Compute the number of digits in integer n written in base base (base must not be in [-1, 0, 1]), optionally padded with zeros to a specified size (the result will never be less than pad).

See also digits, count_ones.

Examples

ndigits(0)
1

ndigits(12345)
5

ndigits(1022, base=16)
3

string(1022, base=16)
"3fe"

ndigits(123, pad=5)
5

ndigits(-123)
3

source
Base.add_sum
—
Function
Base.add_sum(x, y)

The reduction operator used in sum. The main difference from + is that small integers are promoted to Int/UInt.

source
Base.widemul
—
Function
widemul(x, y)

Multiply x and y, giving the result as a larger type.

See also promote, Base.add_sum.

Examples

widemul(Float32(3.0), 4.0) isa BigFloat
true

typemax(Int8) * typemax(Int8)
1

widemul(typemax(Int8), typemax(Int8))  # == 127^2
16129

source
Base.Math.evalpoly
—
Function
evalpoly(x, p)

Evaluate the polynomial 
∑
𝑘
𝑥
𝑘
−
1
𝑝
[
𝑘
]
∑ 
k
​
 x 
k−1
 p[k] for the coefficients p[1], p[2], ...; that is, the coefficients are given in ascending order by power of x. Loops are unrolled at compile time if the number of coefficients is statically known, i.e. when p is a Tuple. This function generates efficient code using Horner's method if x is real, or using a Goertzel-like [DK62] algorithm if x is complex.

Julia 1.4
This function requires Julia 1.4 or later.

Example

evalpoly(2, (1, 2, 3))
17

source
Base.Math.@evalpoly
—
Macro
@evalpoly(z, c...)

Evaluate the polynomial 
∑
𝑘
𝑧
𝑘
−
1
𝑐
[
𝑘
]
∑ 
k
​
 z 
k−1
 c[k] for the coefficients c[1], c[2], ...; that is, the coefficients are given in ascending order by power of z. This macro expands to efficient inline code that uses either Horner's method or, for complex z, a more efficient Goertzel-like algorithm.

See also evalpoly.

Examples

@evalpoly(3, 1, 0, 1)
10

@evalpoly(2, 1, 0, 1)
5

@evalpoly(2, 1, 1, 1)
7

source
Base.FastMath.@fastmath
—
Macro
@fastmath expr

Execute a transformed version of the expression, which calls functions that may violate strict IEEE semantics. This allows the fastest possible operation, but results are undefined – be careful when doing this, as it may change numerical results.

This sets the LLVM Fast-Math flags, and corresponds to the -ffast-math option in clang. See the notes on performance annotations for more details.

Examples

@fastmath 1+2
3

@fastmath(sin(3))
0.1411200080598672

source
Customizable binary operators
Some unicode characters can be used to define new binary operators that support infix notation. For example ⊗(x,y) = kron(x,y) defines the ⊗ (otimes) function to be the Kronecker product, and one can call it as binary operator using infix syntax: C = A ⊗ B as well as with the usual prefix syntax C = ⊗(A,B).

Other characters that support such extensions include \odot ⊙ and \oplus ⊕

The complete list is in the parser code: https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm

Those that are parsed like * (in terms of precedence) include * / ÷ % & ⋅ ∘ × |\\| ∩ ∧ ⊗ ⊘ ⊙ ⊚ ⊛ ⊠ ⊡ ⊓ ∗ ∙ ∤ ⅋ ≀ ⊼ ⋄ ⋆ ⋇ ⋉ ⋊ ⋋ ⋌ ⋏ ⋒ ⟑ ⦸ ⦼ ⦾ ⦿ ⧶ ⧷ ⨇ ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨻ ⨼ ⨽ ⩀ ⩃ ⩄ ⩋ ⩍ ⩎ ⩑ ⩓ ⩕ ⩘ ⩚ ⩜ ⩞ ⩟ ⩠ ⫛ ⊍ ▷ ⨝ ⟕ ⟖ ⟗ and those that are parsed like + include + - |\|| ⊕ ⊖ ⊞ ⊟ |++| ∪ ∨ ⊔ ± ∓ ∔ ∸ ≏ ⊎ ⊻ ⊽ ⋎ ⋓ ⟇ ⧺ ⧻ ⨈ ⨢ ⨣ ⨤ ⨥ ⨦ ⨧ ⨨ ⨩ ⨪ ⨫ ⨬ ⨭ ⨮ ⨹ ⨺ ⩁ ⩂ ⩅ ⩊ ⩌ ⩏ ⩐ ⩒ ⩔ ⩖ ⩗ ⩛ ⩝ ⩡ ⩢ ⩣ There are many others that are related to arrows, comparisons, and powers.
