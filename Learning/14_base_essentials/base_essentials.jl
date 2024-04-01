# base_essentials.jl
# Restart reading Julia manual, Part II, page 495, 'Base'. Why this isn't Part I at the beginning of the book eludes me...
# Chaper 41, Essentials (but still 138 pages...)
# 
# 2024-04-01    PV      First version

# Qui julia program
# exit(code=0)

function when_program_exits()
    println("That's all, folks!")
end

# Function called when program exits (LIFO), before objects finalizers
atexit(when_program_exits)

# Test if running in interactive session
println(isinteractive())

# Get size of all objects reachable by the argument
m = [1.0 2.0; 3.0 4.0]
println("m=$m")
println("summarysize(m)=$(Base.summarysize(m))")    # 72, matrix and 4 Float64
println("sizeof(m)=$(sizeof(m))")                   # 32, just the matrix itself (canonical size)

# Base.include(m::Module, path::AbstractString)     Evaluate the contents of the input source file in the global scope of module m
# Base.MainInclude(path::AbstractString)            Evaluate the contents of the input source file in the global scope of the containing module
# Base.include_string(m::Module, code::AbstractString)  Like include, except reads code from the given string rather than from a file
res = Base.include_string(Main, "8*7")
println(res)
println()

module Module1
const CONSTANT = 1.414
function __init__()
    println("Module1 is loaded and initialized")    # Doesn't appear to be called, don't know why
end
end

println("Before using Module1")
using .Module1
println("CONSTANT=$(Module1.CONSTANT)")
println("After using Module1")
println()

# Some introspection
# Define two methods of f, one for integers, onr for reals
f(a::Integer, b::Integer) = a + b
f(a::AbstractFloat, b::AbstractFloat) = a * b
# Calls two specific combinations
f(Int32(3), Int16(4))
f(Float32(1.0), Float64(2.0))
println("methods(f): $(methods(f))\n")                                          # List the two defined methods
println("which(f, (Int32, Int16)): $(methods(f, (Int32, Int16)))\n")            # Call the (::Integer, ::Integer) for these types
println("which(f, (Float32, Float64)): $(methods(f, (Float32, Float64)))\n")    # Call the (::AbstractFloat, ::AbstractFloat) for these types

# https://stackoverflow.com/questions/61837154/how-to-tell-what-specializations-are-compiled-for-a-method
using MethodAnalysis
for m in methodinstances(f)         # List method instaces actually compiled, here we have 2 methods actually compiled (the two combinations called)
    println(m)
end
println()

# @Show, print expression and results
@show m, res, f(3, 4)
println()

# and and err for interactive session contain last result, last error stackoverflow

# Project is a file listing modules loaded or available?
println(Base.active_project())


# Module
module Foo
import Base.show
export MyType, foo      # Tell Julia which functions should be made available to the user
struct MyType
    x
end
bar(x) = 2x
foo(a::MyType) = bar(a.x) + 1
show(io::IO, a::MyType) = print(io, "MyType $(a.x)")
end

# .Foo because Foo is a local module
using .Foo                  # using Foo will load the module or package Foo and make its exported names available for direct use
# Foo.x access the name x whether they are exported or not
# import .Foo               # Loads the module, without exported names imported, so Foo. prefix is required
println(foo(MyType(2.2)))
Foo.show(stdout, MyType(2.2))
println()

import .Foo: MyType as MT   # With as, can import and rename specific names
println(MT(3 + 2im))
println()

# Macro (not clear yet what means $name, syntax seems illegal outside macros)
macro sayhello(name)
    return :(println("Hello, ", $name, "!"))
end
@sayhello "Pierre"

