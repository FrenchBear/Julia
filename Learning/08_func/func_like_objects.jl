# func_like_objects.jl
# Special case of functions
# 
# 2024-04-26    PV

# Methods are associated with types, so it is possible to make any arbitrary Julia object "callable" by adding methods
# to its type. (Such "callable" objects are sometimes called "functors.")

# For example, you can define a type that stores the coefficients of a polynomial, but behaves like a function
# evaluating the polynomial:

struct Polynomial{R}
	coeffs::Vector{R}
end

function (p::Polynomial)(x)         # Function has no name, but a type instead!
	v = p.coeffs[end]
	for i ∈ (length(p.coeffs)-1):-1:1
		v = v * x + p.coeffs[i]
	end
	return v
end

(p::Polynomial)() = p(5)

# Notice that the function is specified by type instead of by name. As with normal functions there is a terse syntax
# form. In the function body, p will refer to the object that was called. A Polynomial can be used as follows:

p = Polynomial([1, 10, 100])        # Polynomial{Int64}([1, 10, 100])
p(3)                                # 931
p()                                 # 2551

# This mechanism is also the key to how type constructors and closures (inner functions that refer to their surrounding
# environment) work in Julia.


eval_0_10(f::Function)::Tuple{Float64, Float64} = (f(0.0), f(10.0))

println(eval_0_10(√))               # (0.0, 3.1622776601683795)
# println(eval_0_10(p))             # MethodError: no method matching eval_0_10(::Polynomial{Int64})

eval_1_10(f::Union{Function, Polynomial})::Tuple{Float64, Float64} = (f(1.0), f(10.0))
println(eval_1_10(p))               # (111.0, 10101.0)