# func.jl
# Play with julia functions
# 
# 2024-03-20    PV      First version

function fib(n::Integer)::BigInt
    φ = (BigFloat(1) + √BigFloat(5)) / BigFloat(2)
    r = (φ^BigFloat(n) - (-φ)^-BigFloat(n)) / (BigFloat(2) * φ - BigFloat(1))
    round(BigInt, r)
end

function fib(n::Float64)::BigFloat
    φ = (BigFloat(1) + √BigFloat(5)) / BigFloat(2)
    r = (φ^BigFloat(n) - (-φ)^-BigFloat(n)) / (BigFloat(2) * φ - BigFloat(1))
    r
end

# for i in 1:250
#     println(i, ' ', fib(i))
#     println(i, ' ', fib(Float64(i)))
# end

# most operators are also functions (exceptions such as && or || because short-circuit requires that their operands are not evaluated before evaluation of the operator)
s = 1 + 2 + 3       # Infix notation
s = +(1, 2, 3)      # Function notation
f = +
s = f(1, 2, 3)      # Under the name f, fuction does not support infix notation


# Operators with special names
# [A B C ...]	        hvcat       Also [A, B, C...]
# [A; B; C; ...]	    vcat
# [A B; C D; ...]	    hvcat
# [A; B;; C; D;; ...]   hvncat
# A'	                adjoint
# A[i]	                getindex
# A[i] = x	            setindex!
# A.n	                getproperty
# A.n = x	            setproperty!

#=
Fill matrix per columns
[1 2 3;4 5 6;7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9 

Fill matrix per rows
[1; 2; 3;; 4; 5; 6;; 7; 8; 9;;]
3×3 Matrix{Int64}:
 1  4  7
 2  5  8
 3  6  9
=#


# Anomymous functions
a1 = x -> x^2+1
a2 = function(x)
    x^3-1
end
a3 = (x,y,z) -> x/y+z

println(a1(5))
println(a2(5))

println(map(round, [1.2, 3.5, 1.7]))
println(map(x -> x+0.5, [1.2, 3.5, 1.7]))

# do crates an anonymous function passed as 1st parameter of preceding function call
v = map(1:10) do x
    √x
end
println(v)


# Function returning a tuple
function trig(a)
    sin(a), cos(a), tan(a)
end
println(trig(π / 3))
println()

# Argument destructuring
minmax(x, y) = (y < x) ? (y, x) : (x, y)
gap((min, max)) = max - min     # Argument destructuring, without parentheses, this would be a 2-argument function
println(gap(minmax(10, 2)))
println()

# Property destructuring for functions arguments
foo((; x, y)) = x + y
println(foo((x=1, y=2)))
struct A
    x
    y
end
println(foo(A(3, 4)))
println()


# Varargs functions
bar(a, b, x...) = (a, b, x)     # Last argument is bound to an iterable collection to zero or more values
println(bar(1, 2))
println(bar(1, 2, 3))
println(bar(1, 2, 3, 4))
println(bar(1, 2, 3, 4, 5, 6))

# Symmetrically, can expand as at call site (function call does not actually need to be a varargs function)
x = (2, 3, 4)
println(bar(1, x...))
x = [1, 2, 3, 4]
println(bar(x...))

somme(a, b) = a + b
println(somme(x[2:3]...))
println()


# Optional arguments
using Dates

function date(y::Int64, m::Int64=1, d::Int64=1)     # Constructs a date with optional month and day, defaults 1. Builds actually 3 methods
    err = Dates.validargs(Date, y, m, d)
    err === nothing || throw(err)
    return Date(Dates.UTD(Dates.totaldays(y, m, d)))
end
println(date(2024,2,26))
println(date(2024,2))
println(date(2024))
println()
println(methods(date))
println()


# Keywords arguments
