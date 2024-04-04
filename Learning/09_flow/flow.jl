# flow.jl
# Play with julia flow control (Julia manual §9)
# 
# 2024-03-22    PV      First version

# Compount expressions: begin blocks and ; chains
a = begin
    x = 1
    y = 2
    x + y
end
b = (x = 1; y = 2; x + y)

# if blocks are "leaky", i.e. they do not introduce a local scope
if a < b
    relation = "less than"
elseif a == b
    relation = "equal to"
else
    relation = "greater than"
end
println(relation)

# If blocks have a return value, last evaluated
s = if x > 0
    "Positive"
elseif x == 0
    "Nul"
else
    "Negative"
end
println(s)

# It is an error if the conditionnal expression is anything but true or false (same for || and && operators)
#if 1
#    println("true")
#end

# Instead of if <cond> <statement> end, one can write <cond> && <statement> (which could be read as: <cond> and then <statement>).
# Similarly, instead of if ! <cond> <statement> end, one can write <cond> || <statement> (which could be read as: <cond> or else <statement>).

function fact(n::Int)::BigInt
    n >= 0 || error("n must be non-negative")
    n <= 1 && return 1
    n * fact(n - 1)
end
println(fact(30))


# && and || use short-circuit evaluation.
# Boolean operations without short-circuit evaluation can be done with the bitwise boolean operators & and |.
# These are normal functions, which happen to support infix operator syntax, but always evaluate their arguments

# A for loop always introduces a new iteration variable in its body, regardless of whether a variable of the same name exists in the enclosing scope.
j = 8
for j = 1:3
    # something
end
println(j)      # 8

# Use for outer to reuse an existing local variable (can't be a global variable)
function f()
    k = 0
    for outer k ∈ 1:3           # \in
        k == 2 && break
    end
    println(k)  # 2
end
f()
println()

# Multiple nested for loops can be combined into a single outer loop, forming the cartesian product of its iterables
for i = 1:2, j = 3:4
    print((i, j), "  ")
end
println()
println()

# Multiple containers can be iterated over at the same time in a single for loop using zip. 
# Using zip will create an iterator that is a tuple containing the subiterators for the containers passed to it.
# Once any of the subiterators run out, the for loop will stop.
for (j, k) in zip([1 2 3], [4 5 6 7])
    println((j, k))
end
println()


# Exceptions
# built-in:
# ArgumentError   BoundsError     CompositeException  DimensionMismatch
# DivideError     DomainError     EOFError            ErrorException
# InexactError    InitError       InterruptException  InvalidStateException
# KeyError        LoadError       OutOfMemoryError    ReadOnlyMemoryError
# RemoteException MethodError     OverflowError       Meta.ParseError
# SystemError     TypeError       UndefRefError       UndefVarError
# StringIndexError

# Define own Exceptions
struct MyCustomException <: Exception end

# throw function
f(x) = x >= 0 ? exp(-x) : throw(DomainError(x, "argument must be nonnegative"))
# Note that DomainError without parentheses is not an exception, but a type of exception. 
# It needs to be called to obtain an Exception object, such as DomainError(nothing)

# Some exception types take one or more arguments that are used for error reporting
# throw(UndefVarError(:x))
# ERROR: UndefVarError: `x` not defined

# This mechanism can be implemented easily by custom exception types following the way UndefVarError is written:
struct MyUndefVarError <: Exception
    var::Symbol
end
Base.showerror(io::IO, e::MyUndefVarError) = print(io, e.var, " not defined")

# When writing an error message, it is preferred to make the first word lowercase. For example,
A = B = [1 2 3]
size(A) == size(B) || throw(DimensionMismatch("size of A not equal to size of B"))

# The error function is used to produce an ErrorException that interrupts the normal flow of control.
fussy_sqrt(x) = x >= 0 ? sqrt(x) : error("negative x not allowed")      # Shortcut for throw(ErrorException("negative x not allowed"))


# try/catch
try
    sqrt("ten")
catch e
    println("You should have entered a numeric value")
end

sqrt_second(x) =
    try
        sqrt(x[2])
    catch y
        if isa(y, DomainError)
            sqrt(complex(x[2], 0))
        elseif isa(y, BoundsError)
            sqrt(x)
        end
    end

# if error variable is not needed, use a semicolon or insert a line break after catch
try
    bad()
catch
    x
end

# Julia provides the rethrow, backtrace, catch_backtrace and current_exceptions functions for more advanced error handling.

# An else clause can be specified after the catch block that is run whenever no error was thrown previously.
# The advantage over including this code in the try block instead is that any further errors don't get silently caught by the catch clause.

local x
try
    x = read("file", String)
catch
    # handle read errors
else
    # do something with x
end

# The finally keyword provides a way to run some code when a given block of code exits, regardless of how it exits.
fi::Union{IOStream, Nothing} = nothing
try
    fi = open("myfile.txt")
catch e
    println("Error opening myfile.txt: ", e)
finally
    isnothing(fi) || close(fi)
end

# Note that locals to try block are not available to else and finally blocks, without global az, following code fails in else/finally statements
az = 0
try
    global az
    az = 1
catch
else
    println("else ", az)
finally
    println("finally ", az)
end

