# collections.jl
# Julia collections documentation, from doc Base > Collections and Data Structures (beginnint up to Dictionaries)
# 
# 2024-04-24    PV      First version

# Collections and Data Structures

# Iteration

# Sequential iteration is implemented by the iterate function. The general for loop:
#
# for i in iter   # or  "for i = iter"
#     # body
# end
# 
# is translated into:
# 
# next = iterate(iter)
# while next !== nothing
#     (i, state) = next
#     # body
#     next = iterate(iter, state)
# end

# The state object may be anything, and should be chosen appropriately for each iterable type. See the manual section on
# the iteration interface for more details about defining a custom iterable type.

# Base.iterate
# Function iterate(iter [, state]) -> Union{Nothing, Tuple{Any, Any}}
# Advance the iterator to obtain the next element. If no elements remain, nothing should be returned. Otherwise, a
# 2-tuple of the next element and the new iteration state should be returned.

# Base.IteratorSize
# Type IteratorSize(itertype::Type) -> IteratorSize
# Given the type of an iterator, return one of the following values:
# - SizeUnknown() if the length (number of elements) cannot be determined in advance.
# - HasLength() if there is a fixed, finite length.
# - HasShape{N}() if there is a known length plus a notion of multidimensional shape (as for an array). In this case N
#   should give the number of dimensions, and the axes function is valid for the iterator.
# - IsInfinite() if the iterator yields values forever.
# The default value (for iterators that do not define this function) is HasLength(). This means that most iterators are
# assumed to implement length.

# This trait is generally used to select between algorithms that pre-allocate space for their result, and algorithms
# that resize their result incrementally.

Base.IteratorSize(1:5)          # Base.HasShape{1}()
Base.IteratorSize((2,3))        # Base.HasLength()

# Base.IteratorEltype
# Type IteratorEltype(itertype::Type) -> IteratorEltype
# Given the type of an iterator, return one of the following values:
# - EltypeUnknown() if the type of elements yielded by the iterator is not known in advance.
# - HasEltype() if the element type is known, and eltype would return a meaningful value.
# - HasEltype() is the default, since iterators are assumed to implement eltype.

# This trait is generally used to select between algorithms that pre-allocate a specific type of result, and algorithms
# that pick a result type based on the types of yielded values.

Base.IteratorEltype(1:5)        # Base.HasEltype()

# Fully implemented by:
# - AbstractRange
# - UnitRange
# - Tuple
# - Number
# - AbstractArray
# - BitSet
# - IdDict
# - Dict
# - WeakKeyDict
# - EachLine
# - AbstractString
# - Set
# - Pair
# - NamedTuple


# -------------------------------------------------------------------
# Constructors and Types

# Base.AbstractRange
# Type AbstractRange{T}
# Supertype for ranges with elements of type T. UnitRange and other types are subtypes of this.

# Base.OrdinalRange
# Type OrdinalRange{T, S} <: AbstractRange{T}
# Supertype for ordinal ranges with elements of type T with spacing(s) of type S. The steps should be always-exact
# multiples of oneunit, and T should be a "discrete" type, which cannot have values smaller than oneunit. For example,
# Integer or Date types would qualify, whereas Float64 would not (since this type can represent values smaller than
# oneunit(Float64). UnitRange, StepRange, and other types are subtypes of this.

# Base.AbstractUnitRange
# Type AbstractUnitRange{T} <: OrdinalRange{T, T}
# Supertype for ranges with a step size of oneunit(T) with elements of type T. UnitRange and other types are subtypes of this.

# Base.StepRange
# Type StepRange{T, S} <: OrdinalRange{T, S}
# Ranges with elements of type T with spacing of type S. The step between each element is constant, and the range is
# defined in terms of a start and stop of type T and a step of type S. Neither T nor S should be floating point types.
# The syntax a:b:c with b != 0 and a, b, and c all integers creates a StepRange.

collect(StepRange(1, Int8(2), 10))      # 5-element Vector{Int64}: 1, 3, 5, 7, 9
typeof(StepRange(1, Int8(2), 10))       # StepRange{Int64, Int8}
typeof(1:3:6)                           # StepRange{Int64, Int64}

# Base.UnitRange
# Type UnitRange{T<:Real}
# A range parameterized by a start and stop of type T, filled with elements spaced by 1 from start until stop is
# exceeded. The syntax a:b with a and b both Integers creates a UnitRange.

collect(UnitRange(2.3, 5.2))            # 3-element Vector{Float64}: 2.3, 3.3, 4.3
typeof(1:10)                            # UnitRange{Int64}

# Base.LinRange
# Type LinRange{T,L}
# A range with len linearly spaced elements between its start and stop. The size of the spacing is controlled by len,
# which must be an Integer.

LinRange(1.5, 5.5, 9)                   # 9-element LinRange{Float64, Int64}: 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5

# Compared to using range, directly constructing a LinRange should have less overhead but won't try to correct for
# floating point errors:
collect(range(-0.1, 0.3, length=5))     # 5-element Vector{Float64}: -0.1 0.0 0.1 0.2 0.3
collect(LinRange(-0.1, 0.3, 5))         # 5-element Vector{Float64}: -0.1 -1.3877787807814457e-17  0.09999999999999999 0.19999999999999998  0.3


# -------------------------------------------------------------------
# General Collections

# Base.isempty
# Function isempty(collection) -> Bool
# Determine whether a collection is empty (has no elements).

# Warning: isempty(itr) may consume the next element of a stateful iterator itr unless an appropriate Base.isdone(itr)
# or isempty method is defined. Use of isempty should therefore be avoided when writing generic code which should
# support any iterator type.

isempty([])                             # true
isempty([1 2 3])                        # false

# isempty(condition)
# Return true if no tasks are waiting on the condition, false otherwise.

# Base.empty!
# Function empty!(collection) -> collection
# Remove all elements from a collection.

A = Dict("a" => 1, "b" => 2)            # Dict{String, Int64} with 2 entries:  "b" => 2, "a" => 1
empty!(A);
A                                       # Dict{String, Int64}()

# Base.length
# Function length(collection) -> Integer
# Return the number of elements in the collection.
# Use lastindex to get the last valid index of an indexable collection.
# See also: size, ndims, eachindex.

length(1:5)                             # 5
length([1, 2, 3, 4])                    # 4
length([1 2; 3 4])                      # 4

# Base.checked_length
# Function Base.checked_length(r)
# Calculates length(r), but may check for overflow errors where applicable when the result doesn't fit into
# Union{Integer(eltype(r)),Int}.

# Fully implemented by:
# - AbstractRange
# - UnitRange
# - Tuple
# - Number
# - AbstractArray
# - BitSet
# - IdDict
# - Dict
# - WeakKeyDict
# - AbstractString
# - Set
# - NamedTuple


# -------------------------------------------------------------------
# Iterable Collections

# Base.in
# Function in(item, collection) -> Bool
# Function ∈(item, collection) -> Bool

# Determine whether an item is in the given collection, in the sense that it is == to one of the values generated by
# iterating over the collection. Return a Bool value, except if item is missing or collection contains missing but not
# item, in which case missing is returned (three-valued logic, matching the behavior of any and ==).

# Some collections follow a slightly different definition. For example, Sets check whether the item isequal to one of
# the elements; Dicts look for key=>value pairs, and the key is compared using isequal.

# To test for the presence of a key in a dictionary, use haskey or k in keys(dict). For the collections mentioned above,
# the result is always a Bool.
 
# When broadcasting with in.(items, collection) or items .∈ collection, both item and collection are broadcasted over,
# which is often not what is intended. For example, if both arguments are vectors (and the dimensions match), the result
# is a vector indicating whether each value in collection items is in the value at the corresponding position in
# collection. To get a vector indicating whether each value in items is in collection, wrap collection in a tuple or a
# Ref like this: in.(items, Ref(collection)) or items .∈ Ref(collection).

# See also: ∉, insorted, contains, occursin, issubset.

a = 1:3:20                              # 1:3:19
4 in a                                  # true
5 in a                                  # false
missing in [1, 2]                       # missing
1 in [2, missing]                       # missing
1 in [1, missing]                       # true
missing in Set([1, 2])                  # false
(1=>missing) in Dict(1=>10, 2=>20)      # missing
[1, 2] .∈ [2, 3]                        # 2-element BitVector: 0  0
[1, 2] .∈ ([2, 3],)                     # 2-element BitVector: 0  1

# Base.:∉
# Function ∉(item, collection) -> Bool
# Function ∌(collection, item) -> Bool

# Negation of ∈ and ∋, i.e. checks that item is not in collection.

# When broadcasting with items .∉ collection, both item and collection are broadcasted over, which is often not what is
# intended. For example, if both arguments are vectors (and the dimensions match), the result is a vector indicating
# whether each value in collection items is not in the value at the corresponding position in collection. To get a
# vector indicating whether each value in items is not in collection, wrap collection in a tuple or a Ref like this:
# items .∉ Ref(collection).

1 ∉ 2:4                                 # true
1 ∉ 1:3                                 # false
[1, 2] .∉ [2, 3]                        # 2-element BitVector: 1  1
[1, 2] .∉ ([2, 3],)                     # 2-element BitVector: 1  0


# Base.eltype
# Function eltype(type)
# Determine the type of the elements generated by iterating a collection of the given type. For dictionary types, this will be a Pair{KeyType,ValType}. The definition eltype(x) = eltype(typeof(x)) is provided for convenience so that instances can be passed instead of types. However the form that accepts a type argument should be defined for new types.
# See also: keytype, typeof.

eltype(fill(1f0, (2,2)))                # Float32
eltype(fill(0x1, (2,2)))                # UInt8

# Base.indexin
# Function indexin(a, b)
# Return an array containing the first index in b for each value in a that is a member of b. The output array contains nothing wherever a is not a member of b.
# See also: sortperm, findfirst.

a = ['a', 'b', 'c', 'b', 'd', 'a'];
b = ['a', 'b', 'c'];
indexin(a, b)                           # 6-element Vector{Union{Nothing, Int64}}: 1 2 3 2 nothing 1
indexin(b, a)                           # 3-element Vector{Union{Nothing, Int64}}: 1 2 3

# Base.unique
# Function unique(itr)
# Return an array containing only the unique elements of collection itr, as determined by isequal, in the order that the
# first of each set of equivalent elements originally appears. The element type of the input is preserved.
# See also: unique!, allunique, allequal.

unique([1, 2, 6, 2])                    # 3-element Vector{Int64}: 1 2 6
unique(Real[1, 1.0, 2])                 # 2-element Vector{Real}: 1 2

# unique(f, itr)
# Return an array containing one value from itr for each unique value produced by f applied to elements of itr.

unique(x -> x^2, [1, -1, 3, -3, 4])     # 3-element Vector{Int64}: 1 3 4

# This functionality can also be used to extract the indices of the first occurrences of unique elements in an array:
a = [3.1, 4.2, 5.3, 3.1, 3.1, 3.1, 4.2, 1.7];
i = unique(i -> a[i], eachindex(a))     # 4-element Vector{Int64}: 1 2 3 8
a[i]                                    # 4-element Vector{Float64}: 3.1 4.2 5.3 1.7
a[i] == unique(a)                       # true

# unique(A::AbstractArray; dims::Int)
# Return unique regions of A along dimension dims.

A = map(isodd, reshape(Vector(1:8), (2,2,2)))   #
# 2×2×2 Array{Bool, 3}:
# [:, :, 1] =
#  1  1
#  0  0
# 
# [:, :, 2] =
#  1  1
#  0  0

unique(A)               # 2-element Vector{Bool}: 1 0
unique(A, dims=2)       
# 2×1×2 Array{Bool, 3}:
# [:, :, 1] =
#  1
#  0
# 
# [:, :, 2] =
#  1
#  0

unique(A, dims=3)
# 2×2×1 Array{Bool, 3}:
# [:, :, 1] =
#  1  1
#  0  0

# Base.unique!
# Function unique!(f, A::AbstractVector)
# Selects one value from A for each unique value produced by f applied to elements of A, then return the modified A.

unique!(x -> x^2, [1, -1, 3, -3, 4])                # 3-element Vector{Int64}: 1 3 4
unique!(n -> n%3, [5, 1, 8, 9, 3, 4, 10, 7, 2, 6])  # 3-element Vector{Int64}: 5 1 9
unique!(iseven, [2, 3, 5, 7, 9])                    # 2-element Vector{Int64}: 2 3

# unique!(A::AbstractVector)
# Remove duplicate items as determined by isequal, then return the modified A. unique! will return the elements of A in the order that they occur. If you do not care about the order of the returned data, then calling (sort!(A); unique!(A)) will be much more efficient as long as the elements of A can be sorted.

unique!([1, 1, 1])                  # 1-element Vector{Int64}: 1
A = [7, 3, 2, 3, 7, 5];
unique!(A)                          # 4-element Vector{Int64}: 7 3 2 5
B = [7, 6, 42, 6, 7, 42];
sort!(B);                           # unique! is able to process sorted data much more efficiently.
unique!(B)                          # 3-element Vector{Int64}:  6 7 42


# Base.allunique
# Function allunique(itr) -> Bool
# Return true if all values from itr are distinct when compared with isequal.
# See also: unique, issorted, allequal.

allunique([1, 2, 3])                # true
allunique([1, 2, 1, 2])             # false
allunique(Real[1, 1.0, 2])          # false
allunique([NaN, 2.0, NaN, 4.0])     # false


# Base.allequal
# Function allequal(itr) -> Bool
# Return true if all values from itr are equal when compared with isequal.
# See also: unique, allunique.

allequal([])                        # true
allequal([1])                       # true
allequal([1, 1])                    # true
allequal([1, 2])                    # false
allequal(Dict(:a => 1, :b => 1))    # false


# Base.reduce
# Method reduce(op, itr; [init])

# Reduce the given collection itr with the given binary operator op. If provided, the initial value init must be a
# neutral element for op that will be returned for empty collections. It is unspecified whether init is used for
# non-empty collections.

# For empty collections, providing init will be necessary, except for some special cases (e.g. when op is one of +, *,
# max, min, &, |) when Julia can determine the neutral element of op.

# Reductions for certain commonly-used operators may have special implementations, and should be used instead:
# maximum(itr), minimum(itr), sum(itr), prod(itr), any(itr), all(itr). There are efficient methods for concatenating
# certain arrays of arrays by calling reduce(vcat, arr) or reduce(hcat, arr).

# The associativity of the reduction is implementation dependent. This means that you can't use non-associative
# operations like - because it is undefined whether reduce(-,[1,2,3]) should be evaluated as (1-2)-3 or 1-(2-3). Use
# foldl or foldr instead for guaranteed left or right associativity.
 
# Some operations accumulate error. Parallelism will be easier if the reduction can be executed in groups. Future
# versions of Julia might change the algorithm. Note that the elements are not reordered if you use an ordered
# collection.

reduce(*, [2; 3; 4])                # 24
reduce(*, [2; 3; 4]; init=-1)       # -24


# Base.reduce
# Method reduce(f, A::AbstractArray; dims=:, [init])

# Reduce 2-argument function f along dimensions of A. dims is a vector specifying the dimensions to reduce, and the
# keyword argument init is the initial value to use in the reductions. For +, *, max and min the init argument is
# optional.
# The associativity of the reduction is implementation-dependent; if you need a particular associativity, e.g.
# left-to-right, you should write your own loop or consider using foldl or foldr. See documentation for reduce.

a = reshape(Vector(1:16), (4,4))
# 4×4 Matrix{Int64}:
#  1  5   9  13
#  2  6  10  14
#  3  7  11  15
#  4  8  12  16

reduce(max, a, dims=2)
# 4×1 Matrix{Int64}:
#  13
#  14
#  15
#  16

reduce(max, a, dims=1)
# 1×4 Matrix{Int64}:
#  4  8  12  16


# Method foldl(op, itr; [init])
# Like reduce, but with guaranteed left associativity. If provided, the keyword argument init will be used exactly once.
# In general, it will be necessary to provide init to work with empty collections.
# See also mapfoldl, foldr, accumulate.

foldl(=>, 1:4)              # ((1 => 2) => 3) => 4
foldl(=>, 1:4; init=0)      # (((0 => 1) => 2) => 3) => 4
accumulate(=>, (1,2,3,4))   # (1, 1 => 2, (1 => 2) => 3, ((1 => 2) => 3) => 4)


# Base.foldr
# Method foldr(op, itr; [init])
# Like reduce, but with guaranteed right associativity. If provided, the keyword argument init will be used exactly
# once. In general, it will be necessary to provide init to work with empty collections.

foldr(=>, 1:4)              # 1 => (2 => (3 => 4))
foldr(=>, 1:4; init=0)      # 1 => (2 => (3 => (4 => 0)))


# -------------------------------------------------------------------
# Base.maximum
# Function maximum(f, itr; [init])
# Return the largest result of calling function f on each element of itr.
# The value returned for empty itr can be specified by init. It must be a neutral element for max (i.e. which is less
# than or equal to any other element) as it is unspecified whether init is used for non-empty collections.

maximum(length, ["Julion", "Julia", "Jule"])        # 6
maximum(length, []; init=-1)                        # -1
maximum(sin, Real[]; init=-1.0)                     # -1.0      good, since output of sin is >= -1

# Function maximum(itr; [init])
# Return the largest element in a collection.
# The value returned for empty itr can be specified by init. It must be a neutral element for max (i.e. which is less
# than or equal to any other element) as it is unspecified whether init is used for non-empty collections.

maximum(-20.5:10)       # 9.5
maximum([1,2,3])        # 3
# maximum(())           # ERROR: MethodError: reducing over an empty collection is not allowed; consider supplying `init` to the reducer
maximum((); init=-Inf)  # -Inf


# Function maximum(A::AbstractArray; dims)
# Compute the maximum value of an array over the given dimensions. See also the max(a,b) function to take the maximum of
# two or more arguments, which can be applied elementwise to arrays via max.(a,b).
# See also: maximum!, extrema, findmax, argmax.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

maximum(A, dims=1)
# 1×2 Matrix{Int64}:
#  3  4

maximum(A, dims=2)
# 2×1 Matrix{Int64}:
#  2
#  4


# Function maximum(f, A::AbstractArray; dims)
# Compute the maximum value by calling the function f on each element of an array over the given dimensions.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

maximum(abs2, A, dims=1)
# 1×2 Matrix{Int64}:
#  9  16

maximum(abs2, A, dims=2)
# 2×1 Matrix{Int64}:
#   4
#  16


# Base.maximum!
# Function maximum!(r, A)
# Compute the maximum value of A over the singleton dimensions of r, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

maximum!([1; 1], A)
# 2-element Vector{Int64}:
#  2
#  4

maximum!([1 1], A)
# 1×2 Matrix{Int64}:
#  3  4


# Base.minimum
# Function minimum(f, itr; [init])
# Return the smallest result of calling function f on each element of itr.
# The value returned for empty itr can be specified by init. It must be a neutral element for min (i.e. which is greater
# than or equal to any other element) as it is unspecified whether init is used for non-empty collections.

minimum(length, ["Julion", "Julia", "Jule"])    # 4
minimum(length, []; init=typemax(Int64))        # 9223372036854775807
minimum(sin, Real[]; init=1.0)                  # 1.0           good, since output of sin is <= 1


# Function minimum(itr; [init])
# Return the smallest element in a collection.
# The value returned for empty itr can be specified by init. It must be a neutral element for min (i.e. which is greater
# than or equal to any other element) as it is unspecified whether init is used for non-empty collections.

minimum(-20.5:10)       # -20.5
minimum([1,2,3])        # 1
# minimum([])           # ERROR: MethodError: reducing over an empty collection is not allowed; consider supplying `init` to the reducer
minimum([]; init=Inf)   # Inf


# Function minimum(A::AbstractArray; dims)
# Compute the minimum value of an array over the given dimensions. See also the min(a,b) function to take the minimum of
# two or more arguments, which can be applied elementwise to arrays via min.(a,b).
# See also: minimum!, extrema, findmin, argmin.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

minimum(A, dims=1)
# 1×2 Matrix{Int64}:
#  1  2

minimum(A, dims=2)
# 2×1 Matrix{Int64}:
#  1
#  3


# Function minimum(f, A::AbstractArray; dims)
# Compute the minimum value by calling the function f on each element of an array over the given dimensions.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

minimum(abs2, A, dims=1)
# 1×2 Matrix{Int64}:
#  1  4

minimum(abs2, A, dims=2)
# 2×1 Matrix{Int64}:
#  1
#  9


# Base.minimum!
# Function minimum!(r, A)
# Compute the minimum value of A over the singleton dimensions of r, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

minimum!([1; 1], A)
# 2-element Vector{Int64}:
#  1
#  3

minimum!([1 1], A)
# 1×2 Matrix{Int64}:
#  1  2


# Base.extrema
# Function extrema(itr; [init]) -> (mn, mx)
# Compute both the minimum mn and maximum mx element in a single pass, and return them as a 2-tuple.
# The value returned for empty itr can be specified by init. It must be a 2-tuple whose first and second elements are
# neutral elements for min and max respectively (i.e. which are greater/less than or equal to any other element). As a
# consequence, when itr is empty the returned (mn, mx) tuple will satisfy mn ≥ mx. When init is specified it may be used
# even for non-empty itr.

extrema(2:10)                           # (2, 10)
extrema([9,pi,4.5])                     # (3.141592653589793, 9.0)
extrema([]; init = (Inf, -Inf))         # (Inf, -Inf)


# Function extrema(f, itr; [init]) -> (mn, mx)
# Compute both the minimum mn and maximum mx of f applied to each element in itr and return them as a 2-tuple. Only one
# pass is made over itr.
# The value returned for empty itr can be specified by init. It must be a 2-tuple whose first and second elements are
# neutral elements for min and max respectively (i.e. which are greater/less than or equal to any other element). It is
# used for non-empty collections. Note: it implies that, for empty itr, the returned value (mn, mx) satisfies mn ≥ mx
# even though for non-empty itr it satisfies mn ≤ mx. This is a "paradoxical" but yet expected result.

extrema(sin, 0:π)                           # (0.0, 0.9092974268256817)
extrema(sin, Real[]; init = (1.0, -1.0))    # (1.0, -1.0)               good, since -1 ≤ sin(::Real) ≤ 1


# Function extrema(A::AbstractArray; dims) -> Array{Tuple}
# Compute the minimum and maximum elements of an array over the given dimensions.
# See also: minimum, maximum, extrema!.

A = reshape(Vector(1:2:16), (2,2,2))
# 2×2×2 Array{Int64, 3}:
# [:, :, 1] =
#  1  5
#  3  7
# 
# [:, :, 2] =
#   9  13
#  11  15

extrema(A, dims = (1,2))
# 1×1×2 Array{Tuple{Int64, Int64}, 3}:
# [:, :, 1] =
#  (1, 7)
# 
# [:, :, 2] =
#  (9, 15)


# Function extrema(f, A::AbstractArray; dims) -> Array{Tuple}
# Compute the minimum and maximum of f applied to each element in the given dimensions of A.


# Base.extrema!
# Function extrema!(r, A)
# Compute the minimum and maximum value of A over the singleton dimensions of r, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

extrema!([(1, 1); (1, 1)], A)
# 2-element Vector{Tuple{Int64, Int64}}:
#  (1, 2)
#  (3, 4)

extrema!([(1, 1);; (1, 1)], A)
# 1×2 Matrix{Tuple{Int64, Int64}}:
#  (1, 3)  (2, 4)


# Base.argmax
# Function argmax(r::AbstractRange)
# Ranges can have multiple maximal elements. In that case argmax will return a maximal index, but not necessarily the first one.

# Function argmax(f, domain)
# Return a value x from domain for which f(x) is maximised. If there are multiple maximal values for f(x) then the first one will be found.
# domain must be a non-empty iterable.
# Values are compared with isless.
# See also argmin, findmax.

argmax(abs, -10:5)          # -10
argmax(cos, 0:π/2:2π)       # 0.0


# Function argmax(itr)
# Return the index or key of the maximal element in a collection. If there are multiple maximal elements, then the first
# one will be returned.
# The collection must not be empty.
# Values are compared with isless.
# See also: argmin, findmax.

argmax([8, 0.1, -9, pi])    # 1
argmax([1, 7, 7, 6])        # 2
argmax([1, 7, 7, NaN])      # 4


# Function argmax(A; dims) -> indices
# For an array input, return the indices of the maximum elements over the given dimensions. NaN is treated as greater
# than all other values except missing.

A = [1.0 2; 3 4]
# 2×2 Matrix{Float64}:
#  1.0  2.0
#  3.0  4.0

argmax(A, dims=1)
# 1×2 Matrix{CartesianIndex{2}}:
#  CartesianIndex(2, 1)  CartesianIndex(2, 2)

argmax(A, dims=2)
# 2×1 Matrix{CartesianIndex{2}}:
#  CartesianIndex(1, 2)
#  CartesianIndex(2, 2)


# Base.argmin
# Function argmin(r::AbstractRange)
# Ranges can have multiple minimal elements. In that case argmin will return a minimal index, but not necessarily the first one.

# Function argmin(f, domain)
# Return a value x from domain for which f(x) is minimised. If there are multiple minimal values for f(x) then the first
# one will be found.
# domain must be a non-empty iterable.
# NaN is treated as less than all other values except missing.
# See also argmax, findmin.

argmin(sign, -10:5)                 # -10
argmin(x -> -x^3 + x^2 - 10, -5:5)  # 5
argmin(acos, 0:0.1:1)               # 1.0


# Function argmin(itr)
# Return the index or key of the minimal element in a collection. If there are multiple minimal elements, then the first
# one will be returned.
# The collection must not be empty.
# NaN is treated as less than all other values except missing.
# See also: argmax, findmin.

argmin([8, 0.1, -9, pi])            # 3
argmin([7, 1, 1, 6])                # 2
argmin([7, 1, 1, NaN])              # 4


# Function argmin(A; dims) -> indices
# For an array input, return the indices of the minimum elements over the given dimensions. NaN is treated as less than
# all other values except missing.

A = [1.0 2; 3 4]
# 2×2 Matrix{Float64}:
#  1.0  2.0
#  3.0  4.0

argmin(A, dims=1)
# 1×2 Matrix{CartesianIndex{2}}:
#  CartesianIndex(1, 1)  CartesianIndex(1, 2)

argmin(A, dims=2)
# 2×1 Matrix{CartesianIndex{2}}:
#  CartesianIndex(1, 1)
#  CartesianIndex(2, 1)


# Base.findmax
# Function findmax(f, domain) -> (f(x), index)
# Return a pair of a value in the codomain (outputs of f) and the index of the corresponding value in the domain (inputs
# to f) such that f(x) is maximised. If there are multiple maximal points, then the first one will be returned.
# domain must be a non-empty iterable.
# Values are compared with isless.

findmax(identity, 5:9)                          # (9, 5)
findmax(-, 1:10)                                # (-1, 1)
findmax(first, [(1, :a), (3, :b), (3, :c)])     # (3, 2)
findmax(cos, 0:π/2:2π)                          # (1.0, 1)


# Function findmax(itr) -> (x, index)
# Return the maximal element of the collection itr and its index or key. If there are multiple maximal elements, then
# the first one will be returned. Values are compared with isless.
# See also: findmin, argmax, maximum.

findmax([8, 0.1, -9, pi])       # (8.0, 1)
findmax([1, 7, 7, 6])           # (7, 2)
findmax([1, 7, 7, NaN])         # (NaN, 4)


# Function findmax(A; dims) -> (maxval, index)
# For an array input, returns the value and index of the maximum over the given dimensions. NaN is treated as greater
# than all other values except missing.

A = [1.0 2; 3 4]
# 2×2 Matrix{Float64}:
#  1.0  2.0
#  3.0  4.0

findmax(A, dims=1)              # ([3.0 4.0], CartesianIndex{2}[CartesianIndex(2, 1) CartesianIndex(2, 2)])
findmax(A, dims=2)              # ([2.0; 4.0;;], CartesianIndex{2}[CartesianIndex(1, 2); CartesianIndex(2, 2);;])


# Function findmax(f, A; dims) -> (f(x), index)
# For an array input, returns the value in the codomain and index of the corresponding value which maximize f over the
# given dimensions.

A = [-1.0 1; -0.5 2]
# 2×2 Matrix{Float64}:
#  -1.0  1.0
#  -0.5  2.0

findmax(abs2, A, dims=1)        # ([1.0 4.0], CartesianIndex{2}[CartesianIndex(1, 1) CartesianIndex(2, 2)])
findmax(abs2, A, dims=2)        # ([1.0; 4.0;;], CartesianIndex{2}[CartesianIndex(1, 1); CartesianIndex(2, 2);;])


# Base.findmin
# Function findmin(f, domain) -> (f(x), index)
# Return a pair of a value in the codomain (outputs of f) and the index of the corresponding value in the domain (inputs
# to f) such that f(x) is minimised. If there are multiple minimal points, then the first one will be returned.
# domain must be a non-empty iterable.
# NaN is treated as less than all other values except missing.

findmin(identity, 5:9)          # (5, 1)
findmin(-, 1:10)                # (-10, 10)
findmin(first, [(2, :a), (2, :b), (3, :c)])     # (2, 1)
findmin(cos, 0:π/2:2π)          # (-1.0, 3)


# Function findmin(itr) -> (x, index)
# Return the minimal element of the collection itr and its index or key. If there are multiple minimal elements, then
# the first one will be returned. NaN is treated as less than all other values except missing.
# See also: findmax, argmin, minimum.

findmin([8, 0.1, -9, pi])       # (-9.0, 3)
findmin([1, 7, 7, 6])           # (1, 1)
findmin([1, 7, 7, NaN])         # (NaN, 4)


# Function findmin(A; dims) -> (minval, index)
# For an array input, returns the value and index of the minimum over the given dimensions. NaN is treated as less than
# all other values except missing.

A = [1.0 2; 3 4]
# 2×2 Matrix{Float64}:
#  1.0  2.0
#  3.0  4.0

findmin(A, dims=1)              # ([1.0 2.0], CartesianIndex{2}[CartesianIndex(1, 1) CartesianIndex(1, 2)])
findmin(A, dims=2)              # ([1.0; 3.0;;], CartesianIndex{2}[CartesianIndex(1, 1); CartesianIndex(2, 1);;])


# Function findmin(f, A; dims) -> (f(x), index)
# For an array input, returns the value in the codomain and index of the corresponding value which minimize f over the
# given dimensions.

A = [-1.0 1; -0.5 2]
# 2×2 Matrix{Float64}:
#  -1.0  1.0
#  -0.5  2.0

findmin(abs2, A, dims=1)        # ([0.25 1.0], CartesianIndex{2}[CartesianIndex(2, 1) CartesianIndex(1, 2)])
findmin(abs2, A, dims=2)        # ([1.0; 0.25;;], CartesianIndex{2}[CartesianIndex(1, 1); CartesianIndex(2, 1);;])


# Base.findmax!
# Function findmax!(rval, rind, A) -> (maxval, index)
# Find the maximum of A and the corresponding linear index along singleton dimensions of rval and rind, and store the
# results in rval and rind. NaN is treated as greater than all other values except missing.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.


# Base.findmin!
# Function findmin!(rval, rind, A) -> (minval, index)
# Find the minimum of A and the corresponding linear index along singleton dimensions of rval and rind, and store the
# results in rval and rind. NaN is treated as less than all other values except missing.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.


# -------------------------------------------------------------------
# Base.sum
# Function sum(f, itr; [init])
# Sum the results of calling function f on each element of itr.
# The return type is Int for signed integers of less than system word size, and UInt for unsigned integers of less than
# system word size. For all other arguments, a common return type is found to which all arguments are promoted.
# The value returned for empty itr can be specified by init. It must be the additive identity (i.e. zero) as it is
# unspecified whether init is used for non-empty collections.

sum(abs2, [2; 3; 4])            # 29

# Note the important difference between sum(A) and reduce(+, A) for arrays with small integer eltype:
sum(Int8[100, 28])              # 128
reduce(+, Int8[100, 28])        # -128

# In the former case, the integers are widened to system word size and therefore the result is 128. In the latter case,
# no such widening happens and integer overflow results in -128.


# Function sum(itr; [init])
# Return the sum of all elements in a collection.
# The return type is Int for signed integers of less than system word size, and UInt for unsigned integers of less than
# system word size. For all other arguments, a common return type is found to which all arguments are promoted.
# The value returned for empty itr can be specified by init. It must be the additive identity (i.e. zero) as it is
# unspecified whether init is used for non-empty collections.
# See also: reduce, mapreduce, count, union.

sum(1:20)                       # 210
sum(1:20; init = 0.0)           # 210.0


# Function sum(A::AbstractArray; dims)
# Sum elements of an array over the given dimensions.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

sum(A, dims=1)
# 1×2 Matrix{Int64}:
#  4  6

sum(A, dims=2)
# 2×1 Matrix{Int64}:
#  3
#  7


# Function sum(f, A::AbstractArray; dims)
# Sum the results of calling function f on each element of an array over the given dimensions.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

sum(abs2, A, dims=1)
# 1×2 Matrix{Int64}:
#  10  20

sum(abs2, A, dims=2)
# 2×1 Matrix{Int64}:
#   5
#  25


# Base.sum!
# Function sum!(r, A)
# Sum elements of A over the singleton dimensions of r, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

sum!([1; 1], A)
# 2-element Vector{Int64}:
#  3
#  7

sum!([1 1], A)
# 1×2 Matrix{Int64}:
#  4  6


# Base.prod
# Function prod(f, itr; [init])
# Return the product of f applied to each element of itr.
# The return type is Int for signed integers of less than system word size, and UInt for unsigned integers of less than
# system word size. For all other arguments, a common return type is found to which all arguments are promoted.
# The value returned for empty itr can be specified by init. It must be the multiplicative identity (i.e. one) as it is
# unspecified whether init is used for non-empty collections.

prod(abs2, [2; 3; 4])           # 576


# Function prod(itr; [init])
# Return the product of all elements of a collection.
# The return type is Int for signed integers of less than system word size, and UInt for unsigned integers of less than
# system word size. For all other arguments, a common return type is found to which all arguments are promoted.
# The value returned for empty itr can be specified by init. It must be the multiplicative identity (i.e. one) as it is
# unspecified whether init is used for non-empty collections.
# See also: reduce, cumprod, any.

prod(1:5)                       # 120
prod(1:5; init = 1.0)           # 120.0


# Function prod(A::AbstractArray; dims)
# Multiply elements of an array over the given dimensions.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

prod(A, dims=1)
# 1×2 Matrix{Int64}:
#  3  8

prod(A, dims=2)
# 2×1 Matrix{Int64}:
#   2
#  12


# Function prod(f, A::AbstractArray; dims)
# Multiply the results of calling the function f on each element of an array over the given dimensions.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

prod(abs2, A, dims=1)
# 1×2 Matrix{Int64}:
#  9  64

prod(abs2, A, dims=2)
# 2×1 Matrix{Int64}:
#    4
#  144


# Base.prod!
# Function prod!(r, A)
# Multiply elements of A over the singleton dimensions of r, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [1 2; 3 4]
# 2×2 Matrix{Int64}:
#  1  2
#  3  4

prod!([1; 1], A)
# 2-element Vector{Int64}:
#   2
#  12

prod!([1 1], A)
# 1×2 Matrix{Int64}:
#  3  8


# -------------------------------------------------------------------
# Base.any

# Method any(itr) -> Bool
# Test whether any elements of a boolean collection are true, returning true as soon as the first true value in itr is
# encountered (short-circuiting). To short-circuit on false, use all.
# If the input contains missing values, return missing if all non-missing values are false (or equivalently, if the
# input contains no true value), following three-valued logic.
# See also: all, count, sum, |, , ||.

a = [true,false,false,true]
# 4-element Vector{Bool}:
#  1
#  0
#  0
#  1

any(a)                      #  true
any((println(i); v) for (i, v) in enumerate(a))
# 1
# true
any([missing, true])        # true
any([false, missing])       # missing


# Method any(p, itr) -> Bool
# Determine whether predicate p returns true for any elements of itr, returning true as soon as the first item in itr
# for which p returns true is encountered (short-circuiting). To short-circuit on false, use all.
# If the input contains missing values, return missing if all non-missing values are false (or equivalently, if the
# input contains no true value), following three-valued logic.

any(i->(4<=i<=6), [3,5,7])          # true
any(i -> (println(i); i > 3), 1:10)
# 1
# 2
# 3
# 4
# true

any(i -> i > 0, [1, missing])       # true
any(i -> i > 0, [-1, missing])      # missing
any(i -> i > 0, [-1, 0])            # false


# Base.any!
# Function any!(r, A)
# Test whether any values in A along the singleton dimensions of r are true, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [true false; true false]
# 2×2 Matrix{Bool}:
#  1  0
#  1  0

any!([1; 1], A)
# 2-element Vector{Int64}:
#  1
#  1

any!([1 1], A)
# 1×2 Matrix{Int64}:
#  1  0


# Base.all
# Method all(itr) -> Bool
# Test whether all elements of a boolean collection are true, returning false as soon as the first false value in itr is
# encountered (short-circuiting). To short-circuit on true, use any.
# If the input contains missing values, return missing if all non-missing values are true (or equivalently, if the input
# contains no false value), following three-valued logic.
# See also: all!, any, count, &, , &&, allunique.

a = [true,false,false,true]     # 4-element Vector{Bool}: 1 0 0 1
all(a)                          # false
all((println(i); v) for (i, v) in enumerate(a))
# 1
# 2
# false
all([missing, false])           # false
all([true, missing])            # missing


# Base.all
# Method all(p, itr) -> Bool
# Determine whether predicate p returns true for all elements of itr, returning false as soon as the first item in itr
# for which p returns false is encountered (short-circuiting). To short-circuit on true, use any.
# If the input contains missing values, return missing if all non-missing values are true (or equivalently, if the input
# contains no false value), following three-valued logic.

all(i->(4<=i<=6), [4,5,6])          # true
all(i -> (println(i); i < 3), 1:10) # 1 2 3 false
all(i -> i > 0, [1, missing])       # missing
all(i -> i > 0, [-1, missing])      # false
all(i -> i > 0, [1, 2])             # true


# Base.all!
# Function all!(r, A)
# Test whether all values in A along the singleton dimensions of r are true, and write results to r.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [true false; true false]
# 2×2 Matrix{Bool}:
#  1  0
#  1  0

all!([1; 1], A)
# 2-element Vector{Int64}:
#  0
#  0

all!([1 1], A)
# 1×2 Matrix{Int64}:
#  1  0

source
Base.count
—
Function
count([f=identity,] itr; init=0) -> Integer

Count the number of elements in itr for which the function f returns true. If f is omitted, count the number of true elements in itr (which should be a collection of boolean values). init optionally specifies the value to start counting from and therefore also determines the output type.

Julia 1.6
init keyword was added in Julia 1.6.

See also: any, sum.

Examples

count(i->(4<=i<=6), [2,3,4,5,6])
3

count([true, false, true, true])
3

count(>(3), 1:7, init=0x03)
0x07

source
count(
    pattern::Union{AbstractChar,AbstractString,AbstractPattern},
    string::AbstractString;
    overlap::Bool = false,
)

Return the number of matches for pattern in string. This is equivalent to calling length(findall(pattern, string)) but more efficient.

If overlap=true, the matching sequences are allowed to overlap indices in the original string, otherwise they must be from disjoint character ranges.

Julia 1.3
This method requires at least Julia 1.3.

Julia 1.7
Using a character as the pattern requires at least Julia 1.7.

Examples

count('a', "JuliaLang")
2

count(r"a(.)a", "cabacabac", overlap=true)
3

count(r"a(.)a", "cabacabac")
2

source
count([f=identity,] A::AbstractArray; dims=:)

Count the number of elements in A for which f returns true over the given dimensions.

Julia 1.5
dims keyword was added in Julia 1.5.

Julia 1.6
init keyword was added in Julia 1.6.

Examples

A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

count(<=(2), A, dims=1)
1×2 Matrix{Int64}:
 1  1

count(<=(2), A, dims=2)
2×1 Matrix{Int64}:
 2
 0

source
Base.foreach
—
Function
foreach(f, c...) -> Nothing

Call function f on each element of iterable c. For multiple iterable arguments, f is called elementwise, and iteration stops when any iterator is finished.

foreach should be used instead of map when the results of f are not needed, for example in foreach(println, array).

Examples

tri = 1:3:7; res = Int[];

foreach(x -> push!(res, x^2), tri)

res
3-element Vector{Int64}:
  1
 16
 49

foreach((x, y) -> println(x, " with ", y), tri, 'a':'z')
1 with a
4 with b
7 with c

source
Base.map
—
Function
map(f, c...) -> collection

Transform collection c by applying f to each element. For multiple collection arguments, apply f elementwise, and stop when any of them is exhausted.

See also map!, foreach, mapreduce, mapslices, zip, Iterators.map.

Examples

map(x -> x * 2, [1, 2, 3])
3-element Vector{Int64}:
 2
 4
 6

map(+, [1, 2, 3], [10, 20, 30, 400, 5000])
3-element Vector{Int64}:
 11
 22
 33

source
map(f, A::AbstractArray...) -> N-array

When acting on multi-dimensional arrays of the same ndims, they must all have the same axes, and the answer will too.

See also broadcast, which allows mismatched sizes.

Examples

map(//, [1 2; 3 4], [4 3; 2 1])
2×2 Matrix{Rational{Int64}}:
 1//4  2//3
 3//2  4//1

map(+, [1 2; 3 4], zeros(2,1))
ERROR: DimensionMismatch

map(+, [1 2; 3 4], [1,10,100,1000], zeros(3,1))  # iterates until 3rd is exhausted
3-element Vector{Float64}:
   2.0
  13.0
 102.0

source
Base.map!
—
Function
map!(function, destination, collection...)

Like map, but stores the result in destination rather than a new collection. destination must be at least as large as the smallest collection.

Warning
Behavior can be unexpected when any mutated argument shares memory with any other argument.

See also: map, foreach, zip, copyto!.

Examples

a = zeros(3);

map!(x -> x * 2, a, [1, 2, 3]);

a
3-element Vector{Float64}:
 2.0
 4.0
 6.0

map!(+, zeros(Int, 5), 100:999, 1:3)
5-element Vector{Int64}:
 101
 103
 105
   0
   0

source
map!(f, values(dict::AbstractDict))

Modifies dict by transforming each value from val to f(val). Note that the type of dict cannot be changed: if f(val) is not an instance of the value type of dict then it will be converted to the value type if possible and otherwise raise an error.

Julia 1.2
map!(f, values(dict::AbstractDict)) requires Julia 1.2 or later.

Examples

d = Dict(:a => 1, :b => 2)
Dict{Symbol, Int64} with 2 entries:
  :a => 1
  :b => 2

map!(v -> v-1, values(d))
ValueIterator for a Dict{Symbol, Int64} with 2 entries. Values:
  0
  1

source
Base.mapreduce
—
Method
mapreduce(f, op, itrs...; [init])

Apply function f to each element(s) in itrs, and then reduce the result using the binary function op. If provided, init must be a neutral element for op that will be returned for empty collections. It is unspecified whether init is used for non-empty collections. In general, it will be necessary to provide init to work with empty collections.

mapreduce is functionally equivalent to calling reduce(op, map(f, itr); init=init), but will in general execute faster since no intermediate collection needs to be created. See documentation for reduce and map.

Julia 1.2
mapreduce with multiple iterators requires Julia 1.2 or later.

Examples

mapreduce(x->x^2, +, [1:3;]) # == 1 + 4 + 9
14

The associativity of the reduction is implementation-dependent. Additionally, some implementations may reuse the return value of f for elements that appear multiple times in itr. Use mapfoldl or mapfoldr instead for guaranteed left or right associativity and invocation of f for every value.

source
Base.mapfoldl
—
Method
mapfoldl(f, op, itr; [init])

Like mapreduce, but with guaranteed left associativity, as in foldl. If provided, the keyword argument init will be used exactly once. In general, it will be necessary to provide init to work with empty collections.

source
Base.mapfoldr
—
Method
mapfoldr(f, op, itr; [init])

Like mapreduce, but with guaranteed right associativity, as in foldr. If provided, the keyword argument init will be used exactly once. In general, it will be necessary to provide init to work with empty collections.

source
Base.first
—
Function
first(coll)

Get the first element of an iterable collection. Return the start point of an AbstractRange even if it is empty.

See also: only, firstindex, last.

Examples

first(2:2:10)
2

first([1; 2; 3; 4])
1

source
first(itr, n::Integer)

Get the first n elements of the iterable collection itr, or fewer elements if itr is not long enough.

See also: startswith, Iterators.take.

Julia 1.6
This method requires at least Julia 1.6.

Examples

first(["foo", "bar", "qux"], 2)
2-element Vector{String}:
 "foo"
 "bar"

first(1:6, 10)
1:6

first(Bool[], 1)
Bool[]

source
first(s::AbstractString, n::Integer)

Get a string consisting of the first n characters of s.

Examples

first("∀ϵ≠0: ϵ²>0", 0)
""

first("∀ϵ≠0: ϵ²>0", 1)
"∀"

first("∀ϵ≠0: ϵ²>0", 3)
"∀ϵ≠"

source
Base.last
—
Function
last(coll)

Get the last element of an ordered collection, if it can be computed in O(1) time. This is accomplished by calling lastindex to get the last index. Return the end point of an AbstractRange even if it is empty.

See also first, endswith.

Examples

last(1:2:10)
9

last([1; 2; 3; 4])
4

source
last(itr, n::Integer)

Get the last n elements of the iterable collection itr, or fewer elements if itr is not long enough.

Julia 1.6
This method requires at least Julia 1.6.

Examples

last(["foo", "bar", "qux"], 2)
2-element Vector{String}:
 "bar"
 "qux"

last(1:6, 10)
1:6

last(Float64[], 1)
Float64[]

source
last(s::AbstractString, n::Integer)

Get a string consisting of the last n characters of s.

Examples

last("∀ϵ≠0: ϵ²>0", 0)
""

last("∀ϵ≠0: ϵ²>0", 1)
"0"

last("∀ϵ≠0: ϵ²>0", 3)
"²>0"

source
Base.front
—
Function
front(x::Tuple)::Tuple

Return a Tuple consisting of all but the last component of x.

See also: first, tail.

Examples

Base.front((1,2,3))
(1, 2)

Base.front(())
ERROR: ArgumentError: Cannot call front on an empty tuple.

source
Base.tail
—
Function
tail(x::Tuple)::Tuple

Return a Tuple consisting of all but the first component of x.

See also: front, rest, first, Iterators.peel.

Examples

Base.tail((1,2,3))
(2, 3)

Base.tail(())
ERROR: ArgumentError: Cannot call tail on an empty tuple.

source
Base.step
—
Function
step(r)

Get the step size of an AbstractRange object.

Examples

step(1:10)
1

step(1:2:10)
2

step(2.5:0.3:10.9)
0.3

step(range(2.5, stop=10.9, length=85))
0.1

source
Base.collect
—
Method
collect(collection)

Return an Array of all items in a collection or iterator. For dictionaries, returns Vector{Pair{KeyType, ValType}}. If the argument is array-like or is an iterator with the HasShape trait, the result will have the same shape and number of dimensions as the argument.

Used by comprehensions to turn a generator into an Array.

Examples

collect(1:2:13)
7-element Vector{Int64}:
  1
  3
  5
  7
  9
 11
 13

[x^2 for x in 1:8 if isodd(x)]
4-element Vector{Int64}:
  1
  9
 25
 49

source
Base.collect
—
Method
collect(element_type, collection)

Return an Array with the given element type of all items in a collection or iterable. The result has the same shape and number of dimensions as collection.

Examples

collect(Float64, 1:2:5)
3-element Vector{Float64}:
 1.0
 3.0
 5.0

source
Base.filter
—
Function
filter(f, a)

Return a copy of collection a, removing elements for which f is false. The function f is passed one argument.

Julia 1.4
Support for a as a tuple requires at least Julia 1.4.

See also: filter!, Iterators.filter.

Examples

a = 1:10
1:10

filter(isodd, a)
5-element Vector{Int64}:
 1
 3
 5
 7
 9

source
filter(f)

Create a function that filters its arguments with function f using filter, i.e. a function equivalent to x -> filter(f, x).

The returned function is of type Base.Fix1{typeof(filter)}, which can be used to implement specialized methods.

Examples

(1, 2, Inf, 4, NaN, 6) |> filter(isfinite)
(1, 2, 4, 6)

map(filter(iseven), [1:3, 2:4, 3:5])
3-element Vector{Vector{Int64}}:
 [2]
 [2, 4]
 [4]

Julia 1.9
This method requires at least Julia 1.9.

source
filter(f, d::AbstractDict)

Return a copy of d, removing elements for which f is false. The function f is passed key=>value pairs.

Examples

d = Dict(1=>"a", 2=>"b")
Dict{Int64, String} with 2 entries:
  2 => "b"
  1 => "a"

filter(p->isodd(p.first), d)
Dict{Int64, String} with 1 entry:
  1 => "a"

source
filter(f, itr::SkipMissing{<:AbstractArray})

Return a vector similar to the array wrapped by the given SkipMissing iterator but with all missing elements and those for which f returns false removed.

Julia 1.2
This method requires Julia 1.2 or later.

Examples

x = [1 2; missing 4]
2×2 Matrix{Union{Missing, Int64}}:
 1         2
  missing  4

filter(isodd, skipmissing(x))
1-element Vector{Int64}:
 1

source
Base.filter!
—
Function
filter!(f, a)

Update collection a, removing elements for which f is false. The function f is passed one argument.

Examples

filter!(isodd, Vector(1:10))
5-element Vector{Int64}:
 1
 3
 5
 7
 9

source
filter!(f, d::AbstractDict)

Update d, removing elements for which f is false. The function f is passed key=>value pairs.

Example

d = Dict(1=>"a", 2=>"b", 3=>"c")
Dict{Int64, String} with 3 entries:
  2 => "b"
  3 => "c"
  1 => "a"

filter!(p->isodd(p.first), d)
Dict{Int64, String} with 2 entries:
  3 => "c"
  1 => "a"

source
Base.replace
—
Method
replace(A, old_new::Pair...; [count::Integer])

Return a copy of collection A where, for each pair old=>new in old_new, all occurrences of old are replaced by new. Equality is determined using isequal. If count is specified, then replace at most count occurrences in total.

The element type of the result is chosen using promotion (see promote_type) based on the element type of A and on the types of the new values in pairs. If count is omitted and the element type of A is a Union, the element type of the result will not include singleton types which are replaced with values of a different type: for example, Union{T,Missing} will become T if missing is replaced.

See also replace!, splice!, delete!, insert!.

Julia 1.7
Version 1.7 is required to replace elements of a Tuple.

Examples

replace([1, 2, 1, 3], 1=>0, 2=>4, count=2)
4-element Vector{Int64}:
 0
 4
 1
 3

replace([1, missing], missing=>0)
2-element Vector{Int64}:
 1
 0

source
Base.replace
—
Method
replace(new::Union{Function, Type}, A; [count::Integer])

Return a copy of A where each value x in A is replaced by new(x). If count is specified, then replace at most count values in total (replacements being defined as new(x) !== x).

Julia 1.7
Version 1.7 is required to replace elements of a Tuple.

Examples

replace(x -> isodd(x) ? 2x : x, [1, 2, 3, 4])
4-element Vector{Int64}:
 2
 2
 6
 4

replace(Dict(1=>2, 3=>4)) do kv
           first(kv) < 3 ? first(kv)=>3 : kv
       end
Dict{Int64, Int64} with 2 entries:
  3 => 4
  1 => 3

source
Base.replace!
—
Function
replace!(A, old_new::Pair...; [count::Integer])

For each pair old=>new in old_new, replace all occurrences of old in collection A by new. Equality is determined using isequal. If count is specified, then replace at most count occurrences in total. See also replace.

Examples

replace!([1, 2, 1, 3], 1=>0, 2=>4, count=2)
4-element Vector{Int64}:
 0
 4
 1
 3

replace!(Set([1, 2, 3]), 1=>0)
Set{Int64} with 3 elements:
  0
  2
  3

source
replace!(new::Union{Function, Type}, A; [count::Integer])

Replace each element x in collection A by new(x). If count is specified, then replace at most count values in total (replacements being defined as new(x) !== x).

Examples

replace!(x -> isodd(x) ? 2x : x, [1, 2, 3, 4])
4-element Vector{Int64}:
 2
 2
 6
 4

replace!(Dict(1=>2, 3=>4)) do kv
           first(kv) < 3 ? first(kv)=>3 : kv
       end
Dict{Int64, Int64} with 2 entries:
  3 => 4
  1 => 3

replace!(x->2x, Set([3, 6]))
Set{Int64} with 2 elements:
  6
  12

source
Base.rest
—
Function
Base.rest(collection[, itr_state])

Generic function for taking the tail of collection, starting from a specific iteration state itr_state. Return a Tuple, if collection itself is a Tuple, a subtype of AbstractVector, if collection is an AbstractArray, a subtype of AbstractString if collection is an AbstractString, and an arbitrary iterator, falling back to Iterators.rest(collection[, itr_state]), otherwise.

Can be overloaded for user-defined collection types to customize the behavior of slurping in assignments in final position, like a, b... = collection.

Julia 1.6
Base.rest requires at least Julia 1.6.

See also: first, Iterators.rest, Base.split_rest.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

first, state = iterate(a)
(1, 2)

first, Base.rest(a, state)
(1, [3, 2, 4])

source
Base.split_rest
—
Function
Base.split_rest(collection, n::Int[, itr_state]) -> (rest_but_n, last_n)

Generic function for splitting the tail of collection, starting from a specific iteration state itr_state. Returns a tuple of two new collections. The first one contains all elements of the tail but the n last ones, which make up the second collection.

The type of the first collection generally follows that of Base.rest, except that the fallback case is not lazy, but is collected eagerly into a vector.

Can be overloaded for user-defined collection types to customize the behavior of slurping in assignments in non-final position, like a, b..., c = collection.

Julia 1.9
Base.split_rest requires at least Julia 1.9.

See also: Base.rest.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

first, state = iterate(a)
(1, 2)

first, Base.split_rest(a, 1, state)
(1, ([3, 2], [4]))

source
Indexable Collections
Base.getindex
—
Function
getindex(collection, key...)

Retrieve the value(s) stored at the given key or index within a collection. The syntax a[i,j,...] is converted by the compiler to getindex(a, i, j, ...).

See also get, keys, eachindex.

Examples

A = Dict("a" => 1, "b" => 2)
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

getindex(A, "a")
1

source
Base.setindex!
—
Function
setindex!(collection, value, key...)

Store the given value at the given key or index within a collection. The syntax a[i,j,...] = x is converted by the compiler to (setindex!(a, x, i, j, ...); x).

Examples

a = Dict("a"=>1)
Dict{String, Int64} with 1 entry:
  "a" => 1

setindex!(a, 2, "b")
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

source
Base.firstindex
—
Function
firstindex(collection) -> Integer
firstindex(collection, d) -> Integer

Return the first index of collection. If d is given, return the first index of collection along dimension d.

The syntaxes A[begin] and A[1, begin] lower to A[firstindex(A)] and A[1, firstindex(A, 2)], respectively.

See also: first, axes, lastindex, nextind.

Examples

firstindex([1,2,4])
1

firstindex(rand(3,4,5), 2)
1

source
Base.lastindex
—
Function
lastindex(collection) -> Integer
lastindex(collection, d) -> Integer

Return the last index of collection. If d is given, return the last index of collection along dimension d.

The syntaxes A[end] and A[end, end] lower to A[lastindex(A)] and A[lastindex(A, 1), lastindex(A, 2)], respectively.

See also: axes, firstindex, eachindex, prevind.

Examples

lastindex([1,2,4])
3

lastindex(rand(3,4,5), 2)
4

source
Fully implemented by:

Array
BitArray
AbstractArray
SubArray
Partially implemented by:

AbstractRange
UnitRange
Tuple
AbstractString
Dict
IdDict
WeakKeyDict
NamedTuple