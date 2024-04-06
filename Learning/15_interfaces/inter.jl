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
	res = Vector{Vector{T}}(undef, fact(length(lst)))
	classic_permutator2_sub(res, lst, 1)
	res
end

# Helper, factorial
fact(n) = n <= 2 ? n : n * fact(n - 1)


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

function Base.iterate(P::Perm, state = PermState(0, fact(length(P.Vec)), classic_permutator2(P.Vec)))
	if state.ix >= state.len
		return nothing
	else
		state.ix += 1
		return state.Perms[state.ix], state
	end
end

for p in Perm(['a', 'b', 'c'])
	println(p)
end
println()


