# complex_ratio.jl
# Play with julia complex and rational numbers (Julia manual §6)
# 
# 2024-04-04   	PV      First version

# Julia includes predefined types for both complex and rational numbers, and supports all the standard
# Mathematical Operations and Elementary Functions on them.
# Conversion and Promotion are defined so that operations on any combination of predefined numeric types,
# whether primitive or composite, behave as expected.

# Complex numbers

# The global constant im is bound to the complex number i, representing the principal square root of -1.
(1 + 2im)*(2 - 3im)     # 8 + 1im
(1 + 2im)/(1 - 2im)     # -0.6 + 0.8im
(1 + 2im) + (1 - 2im)   # 2 + 0im
(-3 + 2im) - (5 - 1im)  # -8 + 3im
(-1 + 2im)^2            # -3 - 4im
(-1 + 2im)^2.5          # 2.729624464784009 - 6.9606644595719im
(-1 + 2im)^(1 + 1im)    # -0.27910381075826657 + 0.08708053414102428im
3(2 - 5im)              # 6 - 15im
3(2 - 5im)^2            # -63 - 60im
3(2 - 5im)^-1.0         # 0.20689655172413793 + 0.5172413793103449im

# The promotion mechanism ensures that combinations of operands of different types just work:
2(1 - 1im)              # 2 - 2im
(2 + 3im) - 1           # 1 + 3im
(1 + 2im) + 0.5         # 1.5 + 2.0im
(2 + 3im) - 0.5im       # 2.0 + 2.5im
0.75(1 + 2im)           # 0.75 + 1.5im
(2 + 3im) / 2           # 1.0 + 1.5im
(1 - 3im) / (2 + 2im)   # -0.5 - 1.0im
2im^2                   # -2 + 0im
1 + 3/4im               # 1.0 - 0.75im
# Note that 3/4im == 3/(4*im) == -(3/4*im), since a literal coefficient binds more tightly than division.

# Standard functions to manipulate complex values are provided:
z = 1 + 2im             # 1 + 2im
real(1 + 2im)           # 1                     # real part of z
imag(1 + 2im)           # 2                     # imaginary part of z
conj(1 + 2im)           # 1 - 2im               # complex conjugate of z
abs(1 + 2im)            # 2.23606797749979      # absolute value of z
abs2(1 + 2im)           # 5                     # squared absolute value
angle(1 + 2im)          # 1.1071487177940904    # phase angle in radians

# As usual, the absolute value (abs) of a complex number is its distance from zero. abs2 gives the square of
# the absolute value, and is of particular use for complex numbers since it avoids taking a square root.
# angle returns the phase angle in radians (also known as the argument or arg function).
# The full gamut of other Elementary Functions is also defined for complex numbers:
sqrt(1im)               # 0.7071067811865476 + 0.7071067811865475im
sqrt(1 + 2im)           # 1.272019649514069 + 0.7861513777574233im
cos(1 + 2im)            # 2.0327230070196656 - 3.0518977991517997im
exp(1 + 2im)            # -1.1312043837568135 + 2.4717266720048188im
sinh(1 + 2im)           # -0.4890562590412937 + 1.4031192506220405im

# Note that mathematical functions typically return real values when applied to real numbers and complex values
# when applied to complex numbers. For example, sqrt behaves differently when applied to -1 versus -1 + 0im
# even though -1 == -1 + 0im:
# sqrt(-1)              # ERROR: DomainError with -1.0: sqrt was called with a negative real argument...
sqrt(-1 + 0im)          # 0.0 + 1.0im

# The literal numeric coefficient notation does not work when constructing a complex number from variables. Instead, the multiplication must be explicitly written out:
a = 1; b = 2; a + b*im
1 + 2im

# However, this is not recommended. Instead, use the more efficient complex function to construct a complex value directly from its real and imaginary parts:
# This construction avoids the multiplication and addition operations.
a = 1; b = 2; complex(a, b)
1 + 2im

# Inf and NaN propagate through complex numbers in the real and imaginary parts of a complex number as described in the Special floating-point values section:
1 + Inf*im              # 1.0 + Inf*im
1 + NaN*im              # 1.0 + NaN*im



# Rational Numbers

# Julia has a rational number type to represent exact ratios of integers. Rationals are constructed using the // operator
2//3                    # 2//3

# If the numerator and denominator of a rational have common factors, they are reduced to lowest terms such that
# the denominator is non-negative:
6//9                    # 2//3
-4//8                   # -1//2
5//-15                  # -1//3
-4//-12                 # 1//3

# This normalized form for a ratio of integers is unique, so equality of rational values can be tested by checking
# for equality of the numerator and denominator. The standardized numerator and denominator of a rational value
# can be extracted using the numerator and denominator functions:
numerator(2//3)         # 2
denominator(2//3)       # 3

# Direct comparison of the numerator and denominator is generally not necessary, since the standard arithmetic
# and comparison operations are defined for rational values:
2//3 == 6//9            # true
2//3 == 9//27           # false
3//7 < 1//2             # true
3//4 > 2//3             # true
2//4 + 1//6             # 2//3
5//12 - 1//4            # 1//6
5//8 * 3//12            # 5//32
6//5 / 10//7            # 21//25

# Rationals can easily be converted to floating-point numbers:
float(3//4)             # 0.75

# Conversion from rational to floating-point respects the following identity for any integral values of a and b,
# with the exception of the two cases b == 0 and a == 0 && b < 0:
a = 1; b = 2;
isequal(float(a//b), a/b)   # true

# Constructing infinite rational values is acceptable
5//0                    # 1//0
x = -3//0               # -1//0
typeof(x)               # Rational{Int64}

# Trying to construct a NaN rational value, however, is invalid:
# 0//0                  # ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)

#As usual, the promotion system makes interactions with other numeric types effortless:
3//5 + 1                # 8//5
3//5 - 0.5              # 0.09999999999999998
2//7 * (1 + 2im)        # 2//7 + 4//7*im
2//7 * (1.5 + 2im)      # 0.42857142857142855 + 0.5714285714285714im
3//2 / (1 + 2im)        # 3//10 - 3//5*im
1//2 + 2im              # 1//2 + 2//1*im
1 + 2//3im              # 1//1 - 2//3*im
0.5 == 1//2             # true
0.33 == 1//3            # false
0.33 < 1//3             # true
1//3 - 0.33             # 0.0033333333333332993
