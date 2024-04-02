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
a1 = x -> x^2 + 1
a2 = function (x)
	x^3 - 1
end
a3 = (x, y, z) -> x / y + z

println(a1(5))
println(a2(5))

println(map(round, [1.2, 3.5, 1.7]))
println(map(x -> x + 0.5, [1.2, 3.5, 1.7]))


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
println(foo((x = 1, y = 2)))
struct A
	x::Any
	y::Any
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

function date(y::Int64, m::Int64 = 1, d::Int64 = 1)     # Constructs a date with optional month and day, defaults 1. Builds actually 3 methods
	err = Dates.validargs(Date, y, m, d)
	err === nothing || throw(err)
	return Date(Dates.UTD(Dates.totaldays(y, m, d)))
end
println(date(2024, 2, 26))
println(date(2024, 2))
println(date(2024))
println()
println(methods(date))
println()

# Note for optional arguments: optional arguments are tied to a function, not a method 
fdef(a = 1, b = 2) = a + 2b
# translates to the following three methods:
# f(a,b) = a+2b
# f(a) = f(a,2)
# f() = f(1,2)

println("methods(fdef): $(methods(fdef))\n")    # List three defined methods

#println("fdef()=", fdef())         # Was initially 5
fdef(a::Int, b::Int) = a - 2b
println("fdef()=", fdef())          # Now -3, new method definition is used with default function arguments

# # https://stackoverflow.com/questions/61837154/how-to-tell-what-specializations-are-compiled-for-a-method
# using MethodAnalysis
# println(methodinstances(fdef))
println()


# Keywords arguments
function plot1(x, y; style = "solid", width = 1, color = "black")     # If a keyword argument is not assigned a default value in the method definition, then it is required
	println("plot1 x=$x y=$y  style=$style  width=$width  color=$color")
end
plot1(3, 2)
plot1(1, -2, color = "red", width = 2)
plot1(-1, 4; style = "dash-dot")          # Can use ; at call site, but not needed and uncommon

function plot2(x...; style = "solid")     # Keyword arguments can be used in varargs functions
	println("plot2 x=$x  style=$style")
end
plot2(1, 3, -2, style = "dot")

function plot3(x; y = 0, kwargs...)       # Extra keyword arguments can be collected using ..., kwargs will be an immutable key-value iterator over a named tuple
	println("plot3 x=$x y=$y  kwargs=$kwargs")
end
plot3(6; color = "blue", thickness = 2.5, style = "solid", closed = false)
dic = Dict{Symbol, Integer}(:a => 1, :b => 2, :c => 3)
plot3(1; y = 2, dic...)
println()

# Do-block syntax for function arguments
# do creates an anonymous function passed as 1st parameter of preceding function call
v = map(1:10) do x
	√x
end
println(v)

v = map([5, -2, 0]) do x
	if x < 0 && iseven(x)
		return 0
	elseif x == 0
		return 1
	else
		return x
	end
end
println(v)

# Similarly, do a,b would create a two-argument anonymous function.
# Note that do (a,b) would create a one-argument anonymous function, whose argument is a tuple to be deconstructed.
# A plain do would declare that what follows is an anonymous function of the form () ->

# Here is a version of open that runs code ensuring that the opened file is eventually closed:
msg = "Hello, world\r\n"
open("outfile.txt", "w") do io
	write(io, msg)
end

# A do block, like any other inner function, can "capture" variables from its enclosing scope.
# For example, the variable data in the above example of open...do is captured from the outer scope.

# where
# function open(f::Function, args...)
#     io = open(args...)
#     try
#         f(io)
#     finally
#         close(io)
#     end
# end


# Function composition
# Use the function composition operator (∘ \circ) to compose the functions, so (f ∘ g)(args...) is the same as f(g(args...))
r = (sqrt ∘ +)(3, 6)    # 3.0
println(map(first ∘ reverse ∘ uppercase, split("you can compose functions like this")))


# Function piping
# Function chaining (sometimes called "piping" or "using a pipe" to send data to a subsequent function) is when you apply a function
# to the previous function's output
r = 1:10 |> sum |> sqrt
r = (sqrt ∘ sum)(1:10)          # Same as previous line
# pipe broadcasting
println(["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length])
# When combining pipes with anonymous functions, parentheses must be used if subsequent pipes are not to be parsed as part of the anonymous function's body
println(1:3 .|> (x -> x^2) |> sum |> sqrt)
println()

# Dot syntax for vectorizing functions
B = [1.0, 2.0, 3.0]
println(sin.(B))            # [0.8414709848078965, 0.9092974268256817, 0.1411200080598672]

# More generally, f.(args...) is actually equivalent to broadcast(f, args...), which allows you to operate on multiple arrays (even of different shapes),
# or a mix of arrays and scalars
# For example, if you have f(x,y) = 3x + 4y, then f.(pi,A) will return a new array consisting of f(pi,a) for each a in A, and f.(vector1,vector2)
# will return a new vector consisting of f(vector1[i],vector2[i]) for each index i (throwing an exception if the vectors have different length).
f1(x, y) = 3x + 4y
C = [1.0, 2.0, 3.0]
D = [4.0, 5.0, 6.0]
println(f1.(pi, C))         # [13.42477796076938, 17.42477796076938, 21.42477796076938]
println(f1.(C, D))          # [19.0, 26.0, 33.0]

# Keyword arguments are not broadcasted over, but are simply passed through to each call of the function. For example, round.(x, digits=3)
# is equivalent to broadcast(x -> round(x, digits=3), x).

# Nested f.(args...) calls are fused into a single broadcast loop
# For example, sin.(cos.(X)) is equivalent to broadcast(x -> sin(cos(x)), X), similar to [sin(cos(x)) for x in X]:
# there is only a single loop over X, and a single array is allocated for the result
# Technically, the fusion stops as soon as a "non-dot" function call is encountered; for example, in sin.(sort(cos.(X)))
# the sin and cos loops cannot be merged because of the intervening sort function.

# The maximum efficiency is typically achieved when the output array of a vectorized operation is pre-allocated, so that repeated calls
# do not allocate new arrays over and over again for the results (see Pre-allocating outputs).
# A convenient syntax for this is X .= ..., which is equivalent to broadcast!(identity, X, ...) except that, as above,
# the broadcast! loop is fused with any nested "dot" calls.
# For example, X .= sin.(Y) is equivalent to broadcast!(sin, X, Y), overwriting X with sin.(Y) in-place.
# If the left-hand side is an array-indexing expression, e.g. X[begin+1:end] .= sin.(Y), then it translates to broadcast! on a view,
# e.g. broadcast!(sin, view(X, firstindex(X)+1:lastindex(X)), Y), so that the left-hand side is updated in-place.
Y = [1.0, 2.0, 3.0, 4.0];
X = similar(Y); # pre-allocate output array
@. X = sin(cos(Y)) # equivalent to X .= sin.(cos.(Y))

# Binary (or unary) operators like .+ are handled with the same mechanism: they are equivalent to broadcast calls and are fused
# with other nested "dot" calls. X .+= Y etcetera is equivalent to X .= X .+ Y and results in a fused in-place assignment; see also dot operators.

#You can also combine dot operations with function chaining using |>, as in this example:
println(1:5 .|> [x -> x^2, inv, x -> 2 * x, -, isodd])      # [1, 0.5, 6, -4, true]
