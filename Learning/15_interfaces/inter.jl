# inter.jl
# Play with julia interfaces (Julia manual §15)
#
# 2024-04-06    PV      First version

# Iteration

# Sequential iteration is implemented by the iterate function. Instead of mutating objects as they are iterated over,
# Julia iterators may keep track of the iteration state externally from the object. The return value from iterate is
# always either a tuple of a value and a state, or nothing if no elements remain. The state object will be passed back
# to the iterate function on the next iteration and is generally considered an implementation detail private to the
# iterable object.

# Any object that defines this function is iterable and can be used in the many functions that rely upon iteration. It
# can also be used directly in a for loop since the syntax
#
# for item in iter   # or  "for item = iter"
#     # body
# end
# 
# is translated into:
# 
# next = iterate(iter)
# while next !== nothing
#     (item, state) = next
#     # body
#     next = iterate(iter, state)
# end

# A simple example is an iterable sequence of square numbers with a defined length:

struct Squares
	count::Int
end

Base.iterate(S::Squares, state = 1) = state > S.count ? nothing : (state * state, state + 1)

# With only iterate definition, the Squares type is already pretty powerful. We can iterate over all the elements:

for item in Squares(7)
	println(item)
end

# We can use many of the builtin methods that work with iterables, like in or sum:

println(25 in Squares(10))          # true
println(sum(Squares(100)))          # 338350

# There are a few more methods we can extend to give Julia more information about this iterable collection. We know that
# the elements in a Squares sequence will always be Int. By extending the eltype method, we can give that information to
# Julia and help it make more specialized code in the more complicated methods. We also know the number of elements in
# our sequence, so we can extend length, too:

Base.eltype(::Type{Squares}) = Int  # Note that this is defined for the type
Base.length(S::Squares) = S.count   #

# Now, when we ask Julia to collect all the elements into an array it can preallocate a Vector{Int} of the right size
# instead of naively push!ing each element into a Vector{Any}:
println(collect(Squares(4)))        # 4-element Vector{Int64}: [1, 4, 9, 16]
println(length(Squares(7)))         # 7

# While we can rely upon generic implementations, we can also extend specific methods where we know there is a simpler
# algorithm. For example, there's a formula to compute the sum of squares, so we can override the generic iterative
# version with a more performant solution:

Base.sum(S::Squares) = (n = S.count; return n * (n + 1) * (2n + 1) ÷ 6)
println(sum(Squares(1803)))         # 1955361914

# It is also often useful to allow iteration over a collection in reverse order by iterating over
# Iterators.reverse(iterator). To actually support reverse-order iteration, however, an iterator type T needs to
# implement iterate for Iterators.Reverse{T}. (Given r::Iterators.Reverse{T}, the underling iterator of type T is
# r.itr.) In our Squares example, we would implement Iterators.Reverse{Squares} methods:

Base.iterate(rS::Iterators.Reverse{Squares}, state = rS.itr.count) = state < 1 ? nothing : (state * state, state - 1)
println(collect(Iterators.reverse(Squares(4))))  # 4-element Vector{Int64}: [16, 9, 4, 1]
println()


# My own tests

# classic permutator v2, more efficient, only the final Vector{Vector[T]} is allocated
restop::Int = 0
function classic_permutator2_sub(res::Vector{Vector{T}}, l::Vector{T}, from) where {T}
	global restop
	if from == length(l)
		res[restop] = l
		restop += 1
	else
		for i in from:length(l)
			l2::Vector{T} = copy(l)
			if i != from
				l2[from], l2[i] = l2[i], l2[from]
			end
			classic_permutator2_sub(res, l2, from + 1)
		end
	end
end

function classic_permutator2(lst::Vector{T})::Vector{Vector{T}} where {T}
	global restop
	restop = 1
	# Preallocate result vector
	res = Vector{Vector{T}}(undef, factorial(length(lst)))
	classic_permutator2_sub(res, lst, 1)
	res
end


# First implementation of Perm iterator, calculating all permutations at the beginning and storing them in state
struct Perm{T}
	Vec::Vector{T}
end

# Mutable to avoir reconstruction of a new PermState object at each iteration
mutable struct PermState{T}
	ix::Int
	len::Int
	Perms::Vector{Vector{T}}
end

function Base.iterate(P::Perm, state = PermState(0, factorial(length(P.Vec)), classic_permutator2(P.Vec)))
	if state.ix >= state.len
		return nothing
	else
		state.ix += 1
		return state.Perms[state.ix], state
	end
end

Base.eltype(::Type{Perm{T}}) where {T} = Vector{T}

Base.length(S::Perm{T}) where {T} = factorial(length(S.Vec))

for p in Perm(['a', 'b', 'c'])
	println(p)
end
println()

# Since we've define eltype and length
v = collect(Perm([1, 2, 3, 4]))
println(typeof(v))                          # Vector{Vector{Int64}} and not Vector{Any} since we've defined Base.eltype
println(length(Perm([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])))     # 20922789888000  immediate result without counting 21000 billions permutations!

println(Base.IteratorSize(Perm{UInt8}))     # Base.HasLength()
println(Base.IteratorEltype(Perm{UInt8}))   # Base.HasEltype()
println()


# ------------------------------------------------------------------------------------
# Indexing

# Methods to implement	Brief description
# getindex(X, i)	    X[i], indexed element access
# setindex!(X, v, i)	X[i] = v, indexed assignment
# firstindex(X)	        The first index, used in X[begin]
# lastindex(X)	        The last index, used in X[end]


# Let's build an example, with Fibonacci sequence iterator (not recursive!)

struct Fibo
end

mutable struct FiboState
	minus2::Int
	minus1::Int
end

Base.iterate(S::Fibo, state = FiboState(-2, 0)) = begin
	if state.minus2 == -2
		return 0, FiboState(-1, 0)
	elseif state.minus2 == -1
		return 1, FiboState(0, 1)
	else    # Really start calculations at the 3rd call, to avoid calculating 2 steps in advance
		state.minus2, state.minus1 = state.minus1, state.minus1 + state.minus2
		return state.minus1, state
	end
end

n = 0
for i in Fibo()
	global n
	println("F", n, " = ", i)
	n += 1
	if n > 8
		break
	end
end
println()


# Make the interator indexable using direct calculation expression
const φ = (1 + √5) / 2
function Base.getindex(F::Fibo, i::Int)
	# https://www.cuemath.com/algebra/fibonacci-numbers/
	FiboN(n::Int)::Int = round(Int, (φ^n - (1 - φ)^n) / √5)

	i < 0 && throw(BoundsError(F, i))
	return FiboN(i)
end
Base.firstindex(F::Fibo) = 0

println("F10 = ", Fibo()[10])       # 10th Fibonacci number (starts at 0)
println("F30 = ", Fibo()[30])       # 30th Fibonacci number = 832040 (verified)
println("F50 = ", Fibo()[50])       # 50th Fibonacci number = 12586269025 (verified)


# ------------------------------------------------------------------------------------
# Abstract Arrays

# Let's define a sequence
# it's important to specify the two parameters of the AbstractArray; the first defines the eltype, and the second
# defines the ndims. That supertype and those three methods are all it takes for SquaresVector to be an iterable,
# indexable, and completely functional array:
struct SquaresVector <: AbstractArray{Int, 1}
	count::Int
end
Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:SquaresVector}) = IndexLinear()
Base.getindex(S::SquaresVector, i::Int) = i * i


s = SquaresVector(4)    # 4-element SquaresVector: [1, 4, 9, 16]
s[s.>8]               # 2-element Vector{Int64}: [9, 16]
s + s                   # 4-element Vector{Int64}: [2, 8, 18, 32]
sin.(s)                 # 4-element Vector{Float64}: [0.8414709848078965, -0.7568024953079282, 0.4121184852417566, -0.2879033166650653]


# ------------------------------------------------------------------------------------
# Strided Arrays

# A strided array is a subtype of AbstractArray whose entries are stored in memory with fixed stride
# See manual


# ------------------------------------------------------------------------------------
# Customizing broadcasting
# See manual


# ------------------------------------------------------------------------------------
# Instances properties

# Sometimes, it is desirable to change how the end-user interacts with the fields of an object. Instead of granting
# direct access to type fields, an extra layer of abstraction between the user and the code can be provided by
# overloading object.field. Properties are what the user sees of the object, fields what the object actually is.

# By default, properties and fields are the same. However, this behavior can be changed. For example, take this
# representation of a point in a plane in polar coordinates:

mutable struct Point
	r::Float64
	ϕ::Float64
end

p = Point(7.0, pi / 4)                  # Point(7.0, 0.7853981633974483)

# As described in the table above dot access p.r is the same as getproperty(p, :r) which is by default the same as
# getfield(p, :r):
propertynames(p)                        # (:r, :ϕ)
getproperty(p, :r), getproperty(p, :ϕ)  # (7.0, 0.7853981633974483)
p.r, p.ϕ                                # (7.0, 0.7853981633974483)
getfield(p, :r), getproperty(p, :ϕ)     # (7.0, 0.7853981633974483)

# However, we may want users to be unaware that Point stores the coordinates as r and ϕ (fields), and instead interact
# with x and y (properties). The methods in the first column can be defined to add new functionality:

Base.propertynames(::Point, private::Bool = false) = private ? (:x, :y, :r, :ϕ) : (:x, :y)

function Base.getproperty(p::Point, s::Symbol)
	if s === :x
		return getfield(p, :r) * cos(getfield(p, :ϕ))
	elseif s === :y
		return getfield(p, :r) * sin(getfield(p, :ϕ))
	else
		# This allows accessing fields with p.r and p.ϕ
		return getfield(p, s)
	end
end

function Base.setproperty!(p::Point, s::Symbol, f)
	if s === :x
		y = p.y
		setfield!(p, :r, sqrt(f^2 + y^2))
		setfield!(p, :ϕ, atan(y, f))
		return f
	elseif s === :y
		x = p.x
		setfield!(p, :r, sqrt(x^2 + f^2))
		setfield!(p, :ϕ, atan(f, x))
		return f
	else
		# This allow modifying fields with p.r and p.ϕ
		return setfield!(p, s, f)
	end
end


# It is important that getfield and setfield are used inside getproperty and setproperty! instead of the dot syntax,
# since the dot syntax would make the functions recursive which can lead to type inference issues. We can now try out
# the new functionality:

propertynames(p)        # (:x, :y)
p.x                     # 4.949747468305833
p.y = 4.0               # 4.0
p.r                     # 6.363961030678928

