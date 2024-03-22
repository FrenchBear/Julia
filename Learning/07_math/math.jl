# math.jl
# Play with julia math and operators
# 
# 2024-03-20    PV      First version

x = 5
y = 7
n = 3
f = 1.414

# Division
a = x / y           # Usual Float64 division = 4.3478260869565215
a = x ÷ y           # Integer division truncated = div(100, 23) = 4
a = x \ y           # Reverse division = 23/100 = 0.23

# More division, modulo, remainder, gcd...
a = div(x, y) + x ÷ y # truncated division; quotient rounded towards zero
a = fld(x, y)       # floored division; quotient rounded towards -Inf
a = cld(x, y)       # ceiling division; quotient rounded towards +Inf
a = rem(x, y) + x % y # remainder; satisfies x == div(x,y)*y + rem(x,y); sign matches x
a = mod(x, y)       # modulus; satisfies x == fld(x,y)*y + mod(x,y); sign matches y
a = mod1(x, y)      # mod with offset 1; returns r∈(0,y] for y>0 or r∈[y,0) for y<0, where mod(r, y) == mod(x, y).  Useful for sequences 1 2 3 1 2 3 1 2 3: x = mod1(x+1, 3)
a = mod2pi(x)       # modulus with respect to 2pi; 0 <= mod2pi(x) < 2pi
a = divrem(x, y)    # returns (div(x,y),rem(x,y))
a = fldmod(x, y)    # returns (fld(x,y),mod(x,y))
a = gcd(x, y)       # greatest positive common divisor of x, y,...
a = lcm(x, y)       # least positive common multiple of x, y,...

# Implicit miltiplication
a = 2x + 1          # = 2*a+1
a = 3x^2y           # = 3x(a^2b)

# Bitwise
i = ~7              # Bitwise not
i = 5 & 7           # Bitwise and
i = 5 | 7           # Bitwise or 
i = 5 ⊻ 7           # Exclusive or (\xor) = xor(5, 7)
i = 5 ⊼ 7           # Bitwise nand (\nand) = nand(5, 7)
i = 5 ⊽ 7           # Bitwise nor (\nor) = nor(5, 7)
i = 5 >>> 7         # Logical shirt right (no sign propagation)
i = 5 >> 7          # Arithmetic shift right
i = 5 << 1          # Arithmetic shift left

# Updating binari and bitwise operators (rebind variable, type may change)
# +=  -=  *=  /=  \=  ÷=  %=  ^=  &=  |=  ⊻=  >>>=  >>=  <<=

# Vectorized dot operators, ".operator", automatically defined, apply operator elementwise. Performs broadcast
# Also .operator= such as .+=
v = [1, 2, 3] .^ 3     # [1, 8, 27]
m = [1, 2, 3] .+ [4 5 6]
#=
3×3 Matrix{Int64}:
 5  6  7
 6  7  8
 7  8  9
=#

# @. macro:  2 .* A.^2 .+ sin.(A) is equivalent to @. 2A^2 + sin(A)

# Note that for operators, . is placed before, while it's placed after for functions
# .√[1,2,3] = sqrt.([1,2,3])

# Comparisons
b = x == y          # equality
b = x != y          # inequality, exclamation egals or \ne \neq ≠
b = x ≡ y           # identical to (NaN==Nan is false, but NaN≡NaN is true). = isequal(x, y)
# After t1=[1,2] and t2=[1,2], t1==t2 is true, but t1≡t2 is false

# Comparisons chaining (use && operator for scalar comparisons)
b = 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5

# Conversions
# T(x) or convert(T, x) converts x to a value of type T (truncated), or InexactError for inter types T if x is not representable
# x % T converts integer x to type T modulo 2ⁿ where n is the number of bits in T (binary representation is truncated to fit)
# rounding functions with a type T as first argument, such as round(Int, x), it's a shortcut for Int(Round(x))

# Rounding functions (also xxxx(T, x) converting the result to type T)
y = round(x)        # Round to the nearest integer, .5 is nounded to the nearest even integer
y = round(π; digits=4)  # Round to a specified number of decimals (also sigdigits argument)
y = floor(x)        # round x towards -∞
y = ceil(x)         # Round x towards +∞
y = trunc(x)        # Round x towards 0


# Sign and absolute value functions
y = abs(x)          # a positive value with the magnitude of x
y = abs2(x)         # the squared magnitude of x
y = sign(x)         # indicates the sign of x, returning -1, 0, or +1
y = signbit(x)      # indicates whether the sign bit is on (true) or off (false)
y = copysign(x, y)  # a value with the magnitude of x and the sign of y
y = flipsign(x, y)  # a value with the magnitude of x and the sign of x*y

# Powers, logs and roots
y = sqrt(x) + √x    # square root of x
y = cbrt(x) + ∛x    # cube root of x
y = fourthroot(256) + ∜x    # \fourthroot of x
y = hypot(x, y)     # hypotenuse of right-angled triangle with other sides of length x and y
y = exp(x)          # natural exponential function at x
y = expm1(x)        # accurate exp(x)-1 for x near zero
y = ldexp(f, n)     # x*2^n computed efficiently for integer values of n
y = log(x)          # natural logarithm of x
y = log(f, x)       # base b logarithm of x
y = log2(x)         # base 2 logarithm of x
y = log10(x)        # base 10 logarithm of x
y = log1p(x)        # accurate log(1+x) for x near zero
y = exponent(x)     # binary exponent of x
y = significand(f)  # binary significand (a.k.a. mantissa) of a floating-point number x

# Trigonometry (in radians), standard and hyperbolic
# sin    cos    tan    cot    sec    csc
# sinh   cosh   tanh   coth   sech   csch
# asin   acos   atan   acot   asec   acsc
# asinh  acosh  atanh  acoth  asech  acsch

# Trig in degrees
# sind   cosd   tand   cotd   secd   cscd
# asind  acosd  atand  acotd  asecd  acscd

# Extra trig
a = atan(y, x)      # atan(y/x)
a = sinpi(x)        # sin(π·x). Also cospi(x)
y = sinc(x)         # sin(π·x)/(π·x) if x≠0, or 1 if x==0.  Also cosc(x)
t = sincos(x)       # tuple(sine, cosine). Also sincospi(x)

println(9.0 |> sind |> cosd |> tand |> atand |> acosd |> asind)
println((asind ∘ acosd ∘ atand ∘ tand ∘ cosd ∘ sind)(9.0))

# Also special functions in SpecialFunctions.jl
