# arrays_doc.jl
# Arrays documentation in Julia
# Doc https://docs.julialang.org/en/v1/base/arrays/#lib-arrays
# 
# 2024-04-23    PV      First version

# Arrays

# Constructors and Types

# Core.AbstractArray
# Type AbstractArray{T,N}

# Supertype for N-dimensional arrays (or array-like types) with elements of type T. Array and other types are subtypes
# of this. See the manual section on the AbstractArray interface.
# See also: AbstractVector, AbstractMatrix, eltype, ndims.

# -------------------------------------------------
# Base.AbstractVector
# Type AbstractVector{T}

# Supertype for one-dimensional arrays (or array-like types) with elements of type T. Alias for AbstractArray{T,1}.

# -------------------------------------------------
# Base.AbstractMatrix
# Type AbstractMatrix{T}

# Supertype for two-dimensional arrays (or array-like types) with elements of type T. Alias for AbstractArray{T,2}.

# -------------------------------------------------
# Base.AbstractVecOrMat
# Type AbstractVecOrMat{T}

# Union type of AbstractVector{T} and AbstractMatrix{T}.

# -------------------------------------------------
# Core.Array
# Type Array{T,N} <: AbstractArray{T,N}

# N-dimensional dense array with elements of type T.

# -------------------------------------------------
# Core.Array
# Method Array{T}(undef, dims)
# Method Array{T,N}(undef, dims)

# Construct an uninitialized N-dimensional Array containing elements of type T. N can either be supplied explicitly, as
# in Array{T,N}(undef, dims), or be determined by the length or number of dims. dims may be a tuple or a series of
# integer arguments corresponding to the lengths in each dimension. If the rank N is supplied explicitly, then it must
# match the length or number of dims. Here undef is the UndefInitializer.

A = Array{Float64, 2}(undef, 2, 3) # N given explicitly
# 2×3 Matrix{Float64}:
#  6.90198e-310  6.90198e-310  6.90198e-310
#  6.90198e-310  6.90198e-310  0.0

B = Array{Float64}(undef, 4) # N determined by the input
# 4-element Vector{Float64}:
#    2.360075077e-314
#  NaN
#    2.2671131793e-314
#    2.299821756e-314

similar(B, 2, 4, 1) # use typeof(B), and the given size
# 2×4×1 Array{Float64, 3}:
# [:, :, 1] =
#  2.26703e-314  2.26708e-314  0.0           2.80997e-314
#  0.0           2.26703e-314  2.26708e-314  0.0

# -------------------------------------------------
# Core.Array
# Method Array{T}(nothing, dims)
# Method Array{T,N}(nothing, dims)

# Construct an N-dimensional Array containing elements of type T, initialized with nothing entries. Element type T must
# be able to hold these values, i.e. Nothing <: T.

Array{Union{Nothing, String}}(nothing, 2)
# 2-element Vector{Union{Nothing, String}}:
#  nothing
#  nothing

Array{Union{Nothing, Int}}(nothing, 2, 3)
# 2×3 Matrix{Union{Nothing, Int64}}:
#  nothing  nothing  nothing
#  nothing  nothing  nothing

# -------------------------------------------------
# Core.Array
# Method Array{T}(missing, dims)
# Method Array{T,N}(missing, dims)

# Construct an N-dimensional Array containing elements of type T, initialized with missing entries. Element type T must
# be able to hold these values, i.e. Missing <: T.

Array{Union{Missing, String}}(missing, 2)
# 2-element Vector{Union{Missing, String}}:
#  missing
#  missing

Array{Union{Missing, Int}}(missing, 2, 3)
# 2×3 Matrix{Union{Missing, Int64}}:
#  missing  missing  missing
#  missing  missing  missing

# -------------------------------------------------
# Core.UndefInitializer
# Type UndefInitializer

# Singleton type used in array initialization, indicating the array-constructor-caller would like an uninitialized
# array. See also undef, an alias for UndefInitializer().

Array{Float64, 1}(UndefInitializer(), 3)
# 3-element Array{Float64, 1}:
#  2.2752528595e-314
#  2.202942107e-314
#  2.275252907e-314

# -------------------------------------------------
# Core.undef
# Constant undef

# Alias for UndefInitializer(), which constructs an instance of the singleton type UndefInitializer, used in array initialization to indicate the array-constructor-caller would like an uninitialized array.
# See also: missing, similar.

Array{Float64, 1}(undef, 3)
# 3-element Vector{Float64}:
#  2.2752528595e-314
#  2.202942107e-314
#  2.275252907e-314

# -------------------------------------------------
# Base.Vector
# Type Vector{T} <: AbstractVector{T}

# One-dimensional dense array with elements of type T, often used to represent a mathematical vector. Alias for Array{T,1}.
# See also empty, similar and zero for creating vectors.

# -------------------------------------------------
# Base.Vector
# Method Vector{T}(undef, n)

# Construct an uninitialized Vector{T} of length n.

Vector{Float64}(undef, 3)
# 3-element Array{Float64, 1}:
#  6.90966e-310
#  6.90966e-310
#  6.90966e-310

# -------------------------------------------------
# Base.Vector Method Vector{T}(nothing, m)
# 
# Construct a Vector{T} of length m, initialized with nothing entries. Element type T must be able to hold these values,
# i.e. Nothing <: T.

Vector{Union{Nothing, String}}(nothing, 2)
# 2-element Vector{Union{Nothing, String}}:
#  nothing
#  nothing

# -------------------------------------------------
# Base.Vector
# Method Vector{T}(missing, m)

# Construct a Vector{T} of length m, initialized with missing entries. Element type T must be able to hold these values,
# i.e. Missing <: T.

Vector{Union{Missing, String}}(missing, 2)
# 2-element Vector{Union{Missing, String}}:
#  missing
#  missing

# -------------------------------------------------
# Base.Matrix
# Type Matrix{T} <: AbstractMatrix{T}

# Two-dimensional dense array with elements of type T, often used to represent a mathematical matrix. Alias for Array{T,2}.
# See also fill, zeros, undef and similar for creating matrices.

# -------------------------------------------------
# Base.Matrix
# Method Matrix{T}(undef, m, n)

# Construct an uninitialized Matrix{T} of size m×n.

ans=Matrix{Float64}(undef, 2, 3)
#2×3 Array{Float64, 2}:
# 2.36365e-314  2.28473e-314    5.0e-324
# 2.26704e-314  2.26711e-314  NaN

similar(ans, Int32, 2, 2)
# 2×2 Matrix{Int32}:
#  490537216  1277177453
#          1  1936748399

# -------------------------------------------------
# Base.Matrix
# Method Matrix{T}(nothing, m, n)

# Construct a Matrix{T} of size m×n, initialized with nothing entries. Element type T must be able to hold these values, i.e. Nothing <: T.

Matrix{Union{Nothing, String}}(nothing, 2, 3)
# 2×3 Matrix{Union{Nothing, String}}:
#  nothing  nothing  nothing
#  nothing  nothing  nothing

# -------------------------------------------------
# Base.Matrix
# Method Matrix{T}(missing, m, n)

# Construct a Matrix{T} of size m×n, initialized with missing entries. Element type T must be able to hold these values, i.e. Missing <: T.

Matrix{Union{Missing, String}}(missing, 2, 3)
# 2×3 Matrix{Union{Missing, String}}:
#  missing  missing  missing
#  missing  missing  missing

# -------------------------------------------------
# Base.VecOrMat
# Type VecOrMat{T}

# Union type of Vector{T} and Matrix{T} which allows functions to accept either a Matrix or a Vector.

Vector{Float64} <: VecOrMat{Float64}        # true
Matrix{Float64} <: VecOrMat{Float64}        # true
Array{Float64, 3} <: VecOrMat{Float64}      # false

# -------------------------------------------------
# Core.DenseArray
# Type DenseArray{T, N} <: AbstractArray{T,N}
# N-dimensional dense array with elements of type T. The elements of a dense array are stored contiguously in memory.

# Base.DenseVector
# Type DenseVector{T}
# One-dimensional DenseArray with elements of type T. Alias for DenseArray{T,1}.

# Base.DenseMatrix
# Type DenseMatrix{T}
# Two-dimensional DenseArray with elements of type T. Alias for DenseArray{T,2}.

# Base.DenseVecOrMat
# Type DenseVecOrMat{T}
# Union type of DenseVector{T} and DenseMatrix{T}.

# Base.StridedArray
# Type StridedArray{T, N}
# A hard-coded Union of common array types that follow the strided array interface, with elements of type T and N dimensions.
# If A is a StridedArray, then its elements are stored in memory with offsets, which may vary between dimensions but are
# constant within a dimension. For example, A could have stride 2 in dimension 1, and stride 3 in dimension 2.
# Incrementing A along dimension d jumps in memory by [stride(A, d)] slots. Strided arrays are particularly important
# and useful because they can sometimes be passed directly as pointers to foreign language libraries like BLAS.

# Base.StridedVector
# Type StridedVector{T}
# One dimensional StridedArray with elements of type T.

# Base.StridedMatrix
# Type StridedMatrix{T}
# Two dimensional StridedArray with elements of type T.

# Base.StridedVecOrMat
# Type StridedVecOrMat{T}
# Union type of StridedVector and StridedMatrix with elements of type T.

# -------------------------------------------------
# Base.Slices
# Type Slices{P,SM,AX,S,N} <: AbstractSlices{S,N}
# An AbstractArray of slices into a parent array over specified dimension(s), returning views that select all the data
# from the other dimension(s).
# These should typically be constructed by eachslice, eachcol or eachrow.
# parent(s::Slices) will return the parent array.

# Base.RowSlices
# Type RowSlices{M,AX,S}
# A special case of Slices that is a vector of row slices of a matrix, as constructed by eachrow.
# parent can be used to get the underlying matrix.

# Base.ColumnSlices
# Type ColumnSlices{M,AX,S}
# A special case of Slices that is a vector of column slices of a matrix, as constructed by eachcol.
# parent can be used to get the underlying matrix.

# -------------------------------------------------
# Base.getindex
# Method getindex(type[, elements...])

# Construct a 1-d array of the specified type. This is usually called with the syntax Type[]. Element values can be
# specified using Type[a,b,c,...].

Int8[1, 2, 3]
# 3-element Vector{Int8}:
#  1
#  2
#  3

getindex(Int8, 1, 2, 3)
# 3-element Vector{Int8}:
#  1
#  2
#  3

# Base.zeros
# Function zeros([T=Float64,] dims::Tuple)
# Function zeros([T=Float64,] dims...)

# Create an Array, with element type T, of all zeros with size specified by dims. See also fill, ones, zero.

zeros(1)
# 1-element Vector{Float64}:
#  0.0

zeros(Int8, 2, 3)
# 2×3 Matrix{Int8}:
#  0  0  0
#  0  0  0

# Base.ones
# Function ones([T=Float64,] dims::Tuple)
# Function ones([T=Float64,] dims...)

# Create an Array, with element type T, of all ones with size specified by dims. See also fill, zeros.

ones(1,2)
# 1×2 Matrix{Float64}:
#  1.0  1.0

ones(ComplexF64, 2, 3)
# 2×3 Matrix{ComplexF64}:
#  1.0+0.0im  1.0+0.0im  1.0+0.0im
#  1.0+0.0im  1.0+0.0im  1.0+0.0im

# -------------------------------------------------
# Base.BitArray
# Type BitArray{N} <: AbstractArray{Bool, N}
# 
# Space-efficient N-dimensional boolean array, using just one bit for each boolean value.

# BitArrays pack up to 64 values into every 8 bytes, resulting in an 8x space efficiency over Array{Bool, N} and
# allowing some operations to work on 64 values at once.
# By default, Julia returns BitArrays from broadcasting operations that generate boolean elements (including
# dotted-comparisons like .==) as well as from the functions trues and falses.
# Note: Due to its packed storage format, concurrent access to the elements of a BitArray where at least one of them is
# a write is not thread-safe.

# Base.BitArray
# Method BitArray(undef, dims::Integer...)
# Method BitArray{N}(undef, dims::NTuple{N,Int})
# Construct an undef BitArray with the given dimensions. Behaves identically to the Array constructor. See undef.

BitArray(undef, 2, 2)
# 2×2 BitMatrix:
#  0  0
#  0  0

BitArray(undef, (3, 1))
# 3×1 BitMatrix:
#  0
#  0
#  0

# Base.BitArray
# Method BitArray(itr)
# Construct a BitArray generated by the given iterable object. The shape is inferred from the itr object.

BitArray([1 0; 0 1])
# 2×2 BitMatrix:
#  1  0
#  0  1

BitArray(x+y == 3 for x = 1:2, y = 1:3)
# 2×3 BitMatrix:
#  0  1  0
#  1  0  0

BitArray(x+y == 3 for x = 1:2 for y = 1:3)      # 6-element BitVector:  0, 1, 0, 1, 0, 0

# Base.trues
# Function trues(dims)
# Create a BitArray with all values set to true.

trues(2,3)
# 2×3 BitMatrix:
#  1  1  1
#  1  1  1

# Base.falses
# Function falses(dims)
# Create a BitArray with all values set to false.

falses(2,3)
# 2×3 BitMatrix:
#  0  0  0
#  0  0  0

# -------------------------------------------------
# Base.fill
# Function fill(value, dims::Tuple)
# Function fill(value, dims...)

# Create an array of size dims with every location set to value.
# For example, fill(1.0, (5,5)) returns a 5×5 array of floats, with 1.0 in every location of the array.
# The dimension lengths dims may be specified as either a tuple or a sequence of arguments. An N-length tuple or N
# arguments following the value specify an N-dimensional array. Thus, a common idiom for creating a zero-dimensional
# array with its only location set to x is fill(x).

# Every location of the returned array is set to (and is thus === to) the value that was passed; this means that if the
# value is itself modified, all elements of the filled array will reflect that modification because they're still that
# very value. This is of no concern with fill(1.0, (5,5)) as the value 1.0 is immutable and cannot itself be modified,
# but can be unexpected with mutable values like — most commonly — arrays. For example, fill([], 3) places the very same
# empty array in all three locations of the returned vector:

v = fill([], 3)
# 3-element Vector{Vector{Any}}:
#  []
#  []
#  []

v[1] === v[2] === v[3]      # true
value = v[1]                # Any[]
push!(value, 867_5309)      # 1-element Vector{Any}: 8675309
v                           # 3-element Vector{Vector{Any}}: [8675309], [8675309], [8675309]

# To create an array of many independent inner arrays, use a comprehension instead. This creates a new and distinct
# array on each iteration of the loop:

v2 = [[] for _ in 1:3]      # 3-element Vector{Vector{Any}}: [], [], []
v2[1] === v2[2] === v2[3]   # false
push!(v2[1], 8675309)       # 1-element Vector{Any}: 8675309
v2                          # 3-element Vector{Vector{Any}}: [8675309], [], []

fill(1.0, (2,3))            # 2×3 Matrix{Float64}: #  1.0  1.0  1.0\n #  1.0  1.0  1.0
fill(42)                    # 0-dimensional Array{Int64, 0}:
A = fill(zeros(2), 2)       # sets both elements to the same [0.0, 0.0] vector
# 2-element Vector{Vector{Float64}}:
#  [0.0, 0.0]
#  [0.0, 0.0]
A[1][1] = 42;               # modifies the filled value to be [42.0, 0.0]
# A                           # both A[1] and A[2] are the very same vector
# 2-element Vector{Vector{Float64}}:
#  [42.0, 0.0]
#  [42.0, 0.0]

# Base.fill!
# Function fill!(A, x)

# Fill array A with the value x. If x is an object reference, all elements will refer to the same object. fill!(A, Foo()) will return A filled with the result of evaluating Foo() once.

A = zeros(2,3)
# 2×3 Matrix{Float64}:
#  0.0  0.0  0.0
#  0.0  0.0  0.0

fill!(A, 2.)
# 2×3 Matrix{Float64}:
#  2.0  2.0  2.0
#  2.0  2.0  2.0

a = [1, 1, 1]; A = fill!(Vector{Vector{Int}}(undef, 3), a); a[1] = 2; A
# 3-element Vector{Vector{Int64}}:
#  [2, 1, 1]
#  [2, 1, 1]
#  [2, 1, 1]

x = 0; ff() = (global x += 1; x); fill!(Vector{Int}(undef, 3), ff())
# 3-element Vector{Int64}:
#  1
#  1
#  1

# -------------------------------------------------
# Base.empty
# Function empty(x::Tuple)
# Return an empty tuple, ().

# empty(v::AbstractVector, [eltype])
# Create an empty vector similar to v, optionally changing the eltype.
# See also: empty!, isempty, isassigned.

empty([1.0, 2.0, 3.0])              # Float64[]
empty([1.0, 2.0, 3.0], String)      # String[]

# empty(a::AbstractDict, [index_type=keytype(a)], [value_type=valtype(a)])
# Create an empty AbstractDict container which can accept indices of type index_type and values of type value_type. The
# second and third arguments are optional and default to the input's keytype and valtype, respectively. (If only one of
# the two types is specified, it is assumed to be the value_type, and the index_type we default to keytype(a)).
# Custom AbstractDict subtypes may choose which specific dictionary type is best suited to return for the given index
# and value types, by specializing on the three-argument signature. The default is to return an empty Dict.

# -------------------------------------------------
# Base.similar
# Function similar(A::AbstractSparseMatrixCSC{Tv,Ti}, [::Type{TvNew}, ::Type{TiNew}, m::Integer, n::Integer]) where {Tv,Ti}

# Create an uninitialized mutable array with the given element type, index type, and size, based upon the given source
# SparseMatrixCSC. The new sparse matrix maintains the structure of the original sparse matrix, except in the case where
# dimensions of the output matrix are different from the output.
# The output matrix has zeros in the same locations as the input, but uninitialized values for the nonzero locations.

# similar(array, [element_type=eltype(array)], [dims=size(array)])

# Create an uninitialized mutable array with the given element type and size, based upon the given source array. The
# second and third arguments are both optional, defaulting to the given array's eltype and size. The dimensions may be
# specified either as a single tuple argument or as a series of integer arguments.

# Custom AbstractArray subtypes may choose which specific array type is best-suited to return for the given element type
# and dimensionality. If they do not specialize this method, the default is an Array{element_type}(undef, dims...).

# For example, similar(1:10, 1, 4) returns an uninitialized Array{Int,2} since ranges are neither mutable nor support 2
# dimensions:
similar(1:10, 1, 4)             # 1×4 Matrix{Int64}: 4419743872  4374413872  4419743888  0

# Conversely, similar(trues(10,10), 2) returns an uninitialized BitVector with two elements since BitArrays are both
# mutable and can support 1-dimensional arrays:
similar(trues(10,10), 2)        # 2-element BitVector: 0,  0

# Since BitArrays can only store elements of type Bool, however, if you request a different element type it will create
# a regular Array instead:
similar(falses(10), Float64, 2, 4)  # 2×4 Matrix{Float64}: 2.18425e-314  2.18425e-314  2.18425e-314  2.18425e-314,  2.18425e-314  2.18425e-314  2.18425e-314  2.18425e-314

# See also: undef, isassigned.

# similar(storagetype, axes)
# Create an uninitialized mutable array analogous to that specified by storagetype, but with axes specified by the last argument.

similar(Array{Int}, axes(A))
# creates an array that "acts like" an Array{Int} (and might indeed be backed by one), but which is indexed identically
# to A. If A has conventional indexing, this will be identical to Array{Int}(undef, size(A)), but if A has
# unconventional indexing then the indices of the result will match A.

similar(BitArray, (axes(A, 2),))
# would create a 1-dimensional logical array whose indices match those of the columns of A.

# -------------------------------------------------
# Base.ndims
# Function ndims(A::AbstractArray) -> Integer

# Return the number of dimensions of A.
# See also: size, axes.

A = fill(1, (3,4,5));
ndims(A)                    # 3

# Base.size
# Function size(A::AbstractArray, [dim])
# Return a tuple containing the dimensions of A. Optionally you can specify a dimension to just get the length of that dimension.
# Note that size may not be defined for arrays with non-standard indices, in which case axes may be useful. See the manual chapter on arrays with custom indices.
# See also: length, ndims, eachindex, sizeof.

A = fill(1, (2,3,4));
size(A)                     # (2, 3, 4)
size(A, 2)                  # 3

# Base.axes
# Method axes(A)
# Return the tuple of valid indices for array A.
# See also: size, keys, eachindex.

A = fill(1, (5,6,7));
axes(A)                     # (Base.OneTo(5), Base.OneTo(6), Base.OneTo(7))

# Base.axes
# Method axes(A, d)
# Return the valid range of indices for array A along dimension d.
# See also size, and the manual chapter on arrays with custom indices.

A = fill(1, (5,6,7));
axes(A, 2)                  # Base.OneTo(6)
axes(A, 4) == 1:1           # true      # all dimensions d > ndims(A) have size 1

# Usage note
# Each of the indices has to be an AbstractUnitRange{<:Integer}, but at the same time can be a type that uses custom
# indices. So, for example, if you need a subset, use generalized indexing constructs like begin/end or
# firstindex/lastindex:

ix = axes(v, 1)
ix[2:end]                   # will work for eg Vector, but may fail in general
ix[(begin+1):end]           # works for generalized indexes

# Base.length
# Method length(A::AbstractArray)
# Return the number of elements in the array, defaults to prod(size(A)).

length([1, 2, 3, 4])        # 4
length([1 2; 3 4])          # 4

# Base.keys
# Method keys(a::AbstractArray)
# Return an efficient array describing all valid indices for a arranged in the shape of a itself.
# The keys of 1-dimensional arrays (vectors) are integers, whereas all other N-dimensional arrays use CartesianIndex to
# describe their locations. Often the special array types LinearIndices and CartesianIndices are used to efficiently
# represent these arrays of integers and CartesianIndexes, respectively.
# Note that the keys of an array might not be the most efficient index type; for maximum performance use eachindex
# instead.
keys([4, 5, 6])             # 3-element LinearIndices{1, Tuple{Base.OneTo{Int64}}}: 1, 2, 3
keys([4 5; 6 7])            # CartesianIndices((2, 2))

# Base.eachindex
# Function eachindex(A...)
# Function eachindex(::IndexStyle, A::AbstractArray...)

# Create an iterable object for visiting each index of an AbstractArray A in an efficient manner. For array types that
# have opted into fast linear indexing (like Array), this is simply the range 1:length(A) if they use 1-based indexing.
# For array types that have not opted into fast linear indexing, a specialized Cartesian range is typically returned to
# efficiently index into the array with indices specified for every dimension.

# In general eachindex accepts arbitrary iterables, including strings and dictionaries, and returns an iterator object
# supporting arbitrary index types (e.g. unevenly spaced or non-integer indices).

# If A is AbstractArray it is possible to explicitly specify the style of the indices that should be returned by
# eachindex by passing a value having IndexStyle type as its first argument (typically IndexLinear() if linear indices
# are required or IndexCartesian() if Cartesian range is wanted).

# If you supply more than one AbstractArray argument, eachindex will create an iterable object that is fast for all
# arguments (typically a UnitRange if all inputs have fast linear indexing, a CartesianIndices otherwise). If the arrays
# have different sizes and/or dimensionalities, a DimensionMismatch exception will be thrown.

# See also pairs(A) to iterate over indices and values together, and axes(A, 2) for valid indices along one dimension.

A = [10 20; 30 40];
for i in eachindex(A) # linear indexing
           println("A[", i, "] == ", A[i])
       end
# A[1] == 10
# A[2] == 30
# A[3] == 20
# A[4] == 40

for i in eachindex(view(A, 1:2, 1:1)) # Cartesian indexing
           println(i)
       end
# CartesianIndex(1, 1)
# CartesianIndex(2, 1)

# Base.IndexStyle
# Type IndexStyle(A)
# Type IndexStyle(typeof(A))
# IndexStyle specifies the "native indexing style" for array A. When you define a new AbstractArray type, you can choose to implement either linear indexing (with IndexLinear) or cartesian indexing. If you decide to only implement linear indexing, then you must set this trait for your array type:
# Base.IndexStyle(::Type{<:MyArray}) = IndexLinear()
# The default is IndexCartesian().

# Julia's internal indexing machinery will automatically (and invisibly) recompute all indexing operations into the
# preferred style. This allows users to access elements of your array using any indexing style, even when explicit
# methods have not been provided.

# If you define both styles of indexing for your AbstractArray, this trait can be used to select the most performant
# indexing style. Some methods check this trait on their inputs, and dispatch to different algorithms depending on the
# most efficient access pattern. In particular, eachindex creates an iterator whose type depends on the setting of this
# trait.

# Base.IndexLinear
# Type IndexLinear()
# Subtype of IndexStyle used to describe arrays which are optimally indexed by one linear index.

# A linear indexing style uses one integer index to describe the position in the array (even if it's a multidimensional
# array) and column-major ordering is used to efficiently access the elements. This means that requesting eachindex from
# an array that is IndexLinear will return a simple one-dimensional range, even if it is multidimensional.

# A custom array that reports its IndexStyle as IndexLinear only needs to implement indexing (and indexed assignment)
# with a single Int index; all other indexing expressions — including multidimensional accesses — will be recomputed to
# the linear index. For example, if A were a 2×3 custom matrix with linear indexing, and we referenced A[1, 3], this
# would be recomputed to the equivalent linear index and call A[5] since 1 + 2*(3 - 1) = 5.

# Base.IndexCartesian
# Type IndexCartesian()
# Subtype of IndexStyle used to describe arrays which are optimally indexed by a Cartesian index. This is the default
# for new custom AbstractArray subtypes.
 
# A Cartesian indexing style uses multiple integer indices to describe the position in a multidimensional array, with
# exactly one index per dimension. This means that requesting eachindex from an array that is IndexCartesian will return
# a range of CartesianIndices.
 
# A N-dimensional custom array that reports its IndexStyle as IndexCartesian needs to implement indexing (and indexed
# assignment) with exactly N Int indices; all other indexing expressions — including linear indexing — will be
# recomputed to the equivalent Cartesian location. For example, if A were a 2×3 custom matrix with cartesian indexing,
# and we referenced A[5], this would be recomputed to the equivalent Cartesian index and call A[1, 3] since 5 = 1 + 2*(3
# - 1).
 
# It is significantly more expensive to compute Cartesian indices from a linear index than it is to go the other way.
# The former operation requires division — a very costly operation — whereas the latter only uses multiplication and
# addition and is essentially free. This asymmetry means it is far more costly to use linear indexing with an
# IndexCartesian array than it is to use Cartesian indexing with an IndexLinear array.

# -------------------------------------------------
# Base.conj!
# Function conj!(A)
# Transform an array to its complex conjugate in-place.

A = [1+im 2-im; 2+2im 3+im]
# 2×2 Matrix{Complex{Int64}}:
#  1+1im  2-1im
#  2+2im  3+1im

conj!(A);
# A
# 2×2 Matrix{Complex{Int64}}:
#  1-1im  2+1im
#  2-2im  3-1im

# -------------------------------------------------
# Base.stride
# Function stride(A, k::Integer)
# Return the distance in memory (in number of elements) between adjacent elements in dimension k.
# See also: strides.

A = fill(1, (3,4,5));
stride(A,2)             # 3
stride(A,3)             # 12

# Base.strides
# Function strides(A)
# Return a tuple of the memory strides in each dimension.

A = fill(1, (3,4,5));
strides(A)              # (1, 3, 12)

# -------------------------------------------------
# Broadcast and vectorization
# See also the dot syntax for vectorizing functions; for example, f.(args...) implicitly calls broadcast(f, args...). Rather than relying on "vectorized" methods of functions like sin to operate on arrays, you should use sin.(a) to vectorize via broadcast.
# 
# Base.Broadcast.broadcast
# Function broadcast(f, As...)
# Broadcast the function f over the arrays, tuples, collections, Refs and/or scalars As.
# Broadcasting applies the function f over the elements of the container arguments and the scalars themselves in As.
# Singleton and missing dimensions are expanded to match the extents of the other arguments by virtually repeating the
# value. By default, only a limited number of types are considered scalars, including Numbers, Strings, Symbols, Types,
# Functions and some common singletons like missing and nothing. All other arguments are iterated over or indexed into
# elementwise.

# The resulting container type is established by the following rules:
# - If all the arguments are scalars or zero-dimensional arrays, it returns an unwrapped scalar.
# - If at least one argument is a tuple and all others are scalars or zero-dimensional arrays, it returns a tuple.
# - All other combinations of arguments default to returning an Array, but custom container types can define their own
#   implementation and promotion-like rules to customize the result when they appear as arguments.
# - A special syntax exists for broadcasting: f.(args...) is equivalent to broadcast(f, args...), and nested
#   f.(g.(args...)) calls are fused into a single broadcast loop.

A = [1, 2, 3, 4, 5]                 # 5-element Vector{Int64}: 1, 2, 3, 4, 5
B = [1 2; 3 4; 5 6; 7 8; 9 10]      # 5×2 Matrix{Int64}:  1   2\n  3   4\n  5   6\n  7   8\n  9  10
broadcast(+, A, B)                  # 5×2 Matrix{Int64}:  2   3\n  5   6\n  8   9\n  11  12\n 14  15
parse.(Int, ["1", "2"])             # 2-element Vector{Int64}: 1, 2
abs.((1, -2))                       # (1, 2)
broadcast(+, 1.0, (0, -2.0))        # (1.0, -1.0)
(+).([[0,2], [1,3]], Ref{Vector{Int}}([1,-1]))  # 2-element Vector{Vector{Int64}}: [1, 1], [2, 2]
string.(("one","two","three","four"), ": ", 1:4)    # 4-element Vector{String}: "one: 1", "two: 2", "three: 3", "four: 4"

# Base.Broadcast.broadcast!
# Function broadcast!(f, dest, As...)
# Like broadcast, but store the result of broadcast(f, As...) in the dest array. Note that dest is only used to store
# the result, and does not supply arguments to f unless it is also listed in the As, as in broadcast!(f, A, A, B) to
# perform A[:] = broadcast(f, A, B).

A = [1.0; 0.0]; B = [0.0; 0.0];
broadcast!(+, B, A, (0, -2.0));
B                                   # 2-element Vector{Float64}: 1.0, -2.0
A                                   # 2-element Vector{Float64}: 1.0, 0.0
broadcast!(+, A, A, (0, -2.0));
A                                   # 2-element Vector{Float64}: 1.0, -2.0

# Base.Broadcast.@__dot__
# Macro @. expr
# Convert every function call or operator in expr into a "dot call" (e.g. convert f(x) to f.(x)), and convert every
# assignment in expr to a "dot assignment" (e.g. convert += to .+=).

# If you want to avoid adding dots for selected function calls in expr, splice those function calls in with $. For
# example, @. sqrt(abs($sort(x))) is equivalent to sqrt.(abs.(sort(x))) (no dot for sort).
# (@. is equivalent to a call to @__dot__.)

x = 1.0:3.0; y = similar(x);
@. y = x + 3 * sin(x)               # 3-element Vector{Float64}: 3.5244129544236893, 4.727892280477045, 3.4233600241796016

# Base.Broadcast.BroadcastStyle
# BroadcastStyle is an abstract type and trait-function used to determine behavior of objects under broadcasting.
# BroadcastStyle(typeof(x)) returns the style associated with x. To customize the broadcasting behavior of a type, one
# can declare a style by defining a type/method pair

struct MyContainer end
struct MyContainerStyle <: Base.BroadcastStyle end
Base.BroadcastStyle(::Type{<:MyContainer}) = MyContainerStyle()

# One then writes method(s) (at least similar) operating on Broadcasted{MyContainerStyle}. There are also several
# pre-defined subtypes of BroadcastStyle that you may be able to leverage; see the Interfaces chapter for more
# information.

# Base.Broadcast.AbstractArrayStyle
# Type Broadcast.AbstractArrayStyle{N} <: BroadcastStyle 
# is the abstract supertype for any style associated with an AbstractArray type. The N parameter is the dimensionality,
# which can be handy for AbstractArray types that only support specific dimensionalities:

struct SparseMatrixCSC end
struct SparseMatrixStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatrixStyle()

# For AbstractArray types that support arbitrary dimensionality, N can be set to Any:
# struct MyArrayStyle <: Broadcast.AbstractArrayStyle{Any} end
# Base.BroadcastStyle(::Type{<:MyArray}) = MyArrayStyle()

# In cases where you want to be able to mix multiple AbstractArrayStyles and keep track of dimensionality, your style
# needs to support a Val constructor:
struct MyArrayStyleDim{N} <: Broadcast.AbstractArrayStyle{N} end
(::Type{<:MyArrayStyleDim})(::Val{N}) where N = MyArrayStyleDim{N}()

# Note that if two or more AbstractArrayStyle subtypes conflict, broadcasting machinery will fall back to producing
# Arrays. If this is undesirable, you may need to define binary BroadcastStyle rules to control the output type.
# See also Broadcast.DefaultArrayStyle.

# Base.Broadcast.ArrayStyle
# Type Broadcast.ArrayStyle{MyArrayType}()
# is a BroadcastStyle indicating that an object behaves as an array for broadcasting. It presents a simple way to
# construct Broadcast.AbstractArrayStyles for specific AbstractArray container types. Broadcast styles created this way
# lose track of dimensionality; if keeping track is important for your type, you should create your own custom
# Broadcast.AbstractArrayStyle.

# Base.Broadcast.DefaultArrayStyle
# Type Broadcast.DefaultArrayStyle{N}()
# is a BroadcastStyle indicating that an object behaves as an N-dimensional array for broadcasting. Specifically,
# DefaultArrayStyle is used for any AbstractArray type that hasn't defined a specialized style, and in the absence of
# overrides from other broadcast arguments the resulting output type is Array. When there are multiple inputs to
# broadcast, DefaultArrayStyle "loses" to any other Broadcast.ArrayStyle.

# Base.Broadcast.broadcastable
# Function Broadcast.broadcastable(x)
# Return either x or an object like x such that it supports axes, indexing, and its type supports ndims.
# If x supports iteration, the returned value should have the same axes and indexing behaviors as collect(x).
# If x is not an AbstractArray but it supports axes, indexing, and its type supports ndims, then
# broadcastable(::typeof(x)) may be implemented to just return itself. Further, if x defines its own BroadcastStyle,
# then it must define its broadcastable method to return itself for the custom style to have any effect.

Broadcast.broadcastable([1,2,3]) # like `identity` since arrays already support axes and indexing
# 3-element Vector{Int64}:
#  1
#  2
#  3

Broadcast.broadcastable(Int) # Types don't support axes, indexing, or iteration but are commonly used as scalars
# Base.RefValue{Type{Int64}}(Int64)

Broadcast.broadcastable("hello") # Strings break convention of matching iteration and act like a scalar instead
# Base.RefValue{String}("hello")

# Base.Broadcast.combine_axes
# Function combine_axes(As...) -> Tuple
# Determine the result axes for broadcasting across all values in As.
Broadcast.combine_axes([1], [1 2; 3 4; 5 6])    # (Base.OneTo(3), Base.OneTo(2))
Broadcast.combine_axes(1, 1, 1)                 # ()

# Base.Broadcast.combine_styles
# Function combine_styles(cs...) -> BroadcastStyle
# Decides which BroadcastStyle to use for any number of value arguments. Uses BroadcastStyle to get the style for each argument, and uses result_style to combine styles.
Broadcast.combine_styles([1], [1 2; 3 4])       # Base.Broadcast.DefaultArrayStyle{2}()

# Base.Broadcast.result_style
# Function result_style(s1::BroadcastStyle[, s2::BroadcastStyle]) -> BroadcastStyle
# Takes one or two BroadcastStyles and combines them using BroadcastStyle to determine a common BroadcastStyle.

Broadcast.result_style(Broadcast.DefaultArrayStyle{0}(), Broadcast.DefaultArrayStyle{3}())  # Base.Broadcast.DefaultArrayStyle{3}()
Broadcast.result_style(Broadcast.Unknown(), Broadcast.DefaultArrayStyle{1}())               # Base.Broadcast.DefaultArrayStyle{1}()

# -------------------------------------------------
# Indexing and assignment

# Base.getindex
# Method getindex(A, inds...)
# Return a subset of array A as specified by inds, where each ind may be, for example, an Int, an AbstractRange, or a
# Vector. See the manual section on array indexing for details.

A = [1 2; 3 4]              # 2×2 Matrix{Int64}: 1  2, 3  4
getindex(A, 1)              # 1
getindex(A, [2, 1])         # 2-element Vector{Int64}: 3, 1
getindex(A, 2:4)            # 3-element Vector{Int64}: 3, 2, 4

# Base.setindex!
# Method setindex!(A, X, inds...)
# A[inds...] = X

# Store values from array X within some subset of A as specified by inds. The syntax A[inds...] = X is equivalent to
# (setindex!(A, X, inds...); X).
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = zeros(2,2);
setindex!(A, [10, 20], [1, 2]);
A[[3, 4]] = [30, 40];
A                           # 2×2 Matrix{Float64}: 10.0  30.0, 20.0  40.0

# Base.copyto!
# Method copyto!(dest, Rdest::CartesianIndices, src, Rsrc::CartesianIndices) -> dest
# Copy the block of src in the range of Rsrc to the block of dest in the range of Rdest. The sizes of the two regions must match.

A = zeros(5, 5);
B = [1 2; 3 4];
Ainds = CartesianIndices((2:3, 2:3));
Binds = CartesianIndices(B);
copyto!(A, Ainds, B, Binds) # 5×5 Matrix{Float64}:  0.0  0.0  0.0  0.0  0.0\n  0.0  1.0  2.0  0.0  0.0\n  0.0  3.0  4.0  0.0  0.0\n  0.0  0.0  0.0  0.0  0.0\n  0.0  0.0  0.0  0.0  0.0

# Base.copy!
# Function copy!(dst, src) -> dst
# In-place copy of src into dst, discarding any pre-existing elements in dst. If dst and src are of the same type, dst == src should hold after the call. If dst and src are multidimensional arrays, they must have equal axes.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

# Base.isassigned
# Function isassigned(array, i) -> Bool
# Test whether the given array has a value associated with index i. Return false if the index is out of bounds, or has
# an undefined reference.

isassigned(rand(3, 3), 5)           # true
isassigned(rand(3, 3), 3 * 3 + 1)   # false

mutable struct Foo end
v = similar(rand(3), Foo)           # 3-element Vector{Foo}:  #undef #undef #undef
isassigned(v, 1)                    # false

# Base.Colon
# Type Colon()
# Colons (:) are used to signify indexing entire objects or dimensions at once.
# Very few operations are defined on Colons directly; instead they are converted by to_indices to an internal vector
# type (Base.Slice) to represent the collection of indices they span before being used.
# The singleton instance of Colon is also a function used to construct ranges; see :.

# Base.IteratorsMD.CartesianIndex
# Type CartesianIndex(i, j, k...)   -> I
# Type CartesianIndex((i, j, k...)) -> I

# Create a multidimensional index I, which can be used for indexing a multidimensional array A. In particular, A[I] is
# equivalent to A[i,j,k...]. One can freely mix integer and CartesianIndex indices; for example, A[Ipre, i, Ipost]
# (where Ipre and Ipost are CartesianIndex indices and i is an Int) can be a useful expression when writing algorithms
# that work along a single dimension of an array of arbitrary dimensionality.

# A CartesianIndex is sometimes produced by eachindex, and always when iterating with an explicit CartesianIndices.

# An I::CartesianIndex is treated as a "scalar" (not a container) for broadcast. In order to iterate over the components
# of a CartesianIndex, convert it to a tuple with Tuple(I).

A = reshape(Vector(1:16), (2, 2, 2, 2)) 
# 2×2×2×2 Array{Int64, 4}:
# [:, :, 1, 1] =
#  1  3
#  2  4
# 
# [:, :, 2, 1] =
#  5  7
#  6  8
# 
# [:, :, 1, 2] =
#   9  11
#  10  12
# 
# [:, :, 2, 2] =
#  13  15
#  14  16

A[CartesianIndex((1, 1, 1, 1))]     # 1
A[CartesianIndex((1, 1, 1, 2))]     # 9
A[CartesianIndex((1, 1, 2, 1))]     # 5

# Base.IteratorsMD.CartesianIndices
# Type CartesianIndices(sz::Dims) -> R
# Type CartesianIndices((istart:[istep:]istop, jstart:[jstep:]jstop, ...)) -> R
# Define a region R spanning a multidimensional rectangular range of integer indices. These are most commonly
# encountered in the context of iteration, where for I in R ... end will return CartesianIndex indices I equivalent to
# the nested loops

# for j = jstart:jstep:jstop
#     for i = istart:istep:istop
#         ...
#     end
# end

# Consequently these can be useful for writing algorithms that work in arbitrary dimensions.

# CartesianIndices(A::AbstractArray) -> R
# As a convenience, constructing a CartesianIndices from an array makes a range of its indices.

foreach(println, CartesianIndices((2, 2, 2)))
# CartesianIndex(1, 1, 1)
# CartesianIndex(2, 1, 1)
# CartesianIndex(1, 2, 1)
# CartesianIndex(2, 2, 1)
# CartesianIndex(1, 1, 2)
# CartesianIndex(2, 1, 2)
# CartesianIndex(1, 2, 2)
# CartesianIndex(2, 2, 2)

CartesianIndices(fill(1, (2,3)))
# CartesianIndices((2, 3))

# -------------------------------------------------
# Conversion between linear and cartesian indices

# Linear index to cartesian index conversion exploits the fact that a CartesianIndices is an AbstractArray and can be
# indexed linearly:
cartesian = CartesianIndices((1:3, 1:2))    # CartesianIndices((1:3, 1:2))
cartesian[4]                                # CartesianIndex(1, 2)
cartesian = CartesianIndices((1:2:5, 1:2))  # CartesianIndices((1:2:5, 1:2))
cartesian[2, 2]                             # CartesianIndex(3, 2)

# Broadcasting
# CartesianIndices support broadcasting arithmetic (+ and -) with a CartesianIndex.
CIs = CartesianIndices((2:3, 5:6))          # CartesianIndices((2:3, 5:6))
CI = CartesianIndex(3, 4)                   # CartesianIndex(3, 4)
CIs .+ CI                                   # CartesianIndices((5:6, 9:10))

# For cartesian to linear index conversion, see LinearIndices.

# Base.Dims
# Type Dims{N}
# An NTuple of N Ints used to represent the dimensions of an AbstractArray.

# Base.LinearIndices
# Type LinearIndices(A::AbstractArray)
# Return a LinearIndices array with the same shape and axes as A, holding the linear index of each entry in A. Indexing
# this array with cartesian indices allows mapping them to linear indices.
# For arrays with conventional indexing (indices start at 1), or any multidimensional array, linear indices range from 1
# to length(A). However, for AbstractVectors linear indices are axes(A, 1), and therefore do not start at 1 for vectors
# with unconventional indexing.
# Calling this function is the "safe" way to write algorithms that exploit linear indexing.

A = fill(1, (5,6,7));
b = LinearIndices(A);
extrema(b)                                  # (1, 210)

# LinearIndices(inds::CartesianIndices) -> R
# LinearIndices(sz::Dims) -> R
# LinearIndices((istart:istop, jstart:jstop, ...)) -> R
# Return a LinearIndices array with the specified shape or axes.

# The main purpose of this constructor is intuitive conversion from cartesian to linear indexing:
linear = LinearIndices((1:3, 1:2))          # 3×2 LinearIndices{2, Tuple{UnitRange{Int64}, UnitRange{Int64}}}: 1  4\n 2  5\n 3  6
linear[1,2]                                 # 4

# Base.to_indices
# Function to_indices(A, I::Tuple)
# Convert the tuple I to a tuple of indices for use in indexing into array A.

# The returned tuple must only contain either Ints or AbstractArrays of scalar indices that are supported by array A. It
# will error upon encountering a novel index type that it does not know how to process.

# For simple index types, it defers to the unexported Base.to_index(A, i) to process each index i. While this internal
# function is not intended to be called directly, Base.to_index may be extended by custom array or index types to
# provide custom indexing behaviors.

# More complicated index types may require more context about the dimension into which they index. To support those
# cases, to_indices(A, I) calls to_indices(A, axes(A), I), which then recursively walks through both the given tuple of
# indices and the dimensional indices of A in tandem. As such, not all index types are guaranteed to propagate to
# Base.to_index.

A = zeros(1,2,3,4);
to_indices(A, (1,1,2,2))                    # (1, 1, 2, 2)
to_indices(A, (1,1,2,20))                   # (1, 1, 2, 20)         # no bounds checking
to_indices(A, (CartesianIndex((1,)), 2, CartesianIndex((3,4))))     # (1, 2, 3, 4)      exotic index
to_indices(A, ([1,1], 1:2, 3, 4))           # ([1, 1], 1:2, 3, 4)
to_indices(A, (1,2))                        # (1, 2)                # no shape checking

# Base.checkbounds
# Function checkbounds(Bool, A, I...)
# Return true if the specified indices I are in bounds for the given array A. Subtypes of AbstractArray should
# specialize this method if they need to provide custom bounds checking behaviors; however, in many cases one can rely
# on A's indices and checkindex.
# See also checkindex.

A = rand(3, 3);
checkbounds(Bool, A, 2)                     # true
checkbounds(Bool, A, 3, 4)                  # false
checkbounds(Bool, A, 1:3)                   # true
checkbounds(Bool, A, 1:3, 2:4)              # false

# checkbounds(A, I...)
# Throw an error if the specified indices I are not in bounds for the given array A.

# Base.checkindex
# Function checkindex(Bool, inds::AbstractUnitRange, index)
# Return true if the given index is within the bounds of inds. Custom types that would like to behave as indices for all
# arrays can extend this method in order to provide a specialized bounds checking implementation.

checkindex(Bool, 1:20, 8)                   # true
checkindex(Bool, 1:20, 21)                  # false

# Base.elsize
# Function elsize(type)
# Compute the memory stride in bytes between consecutive elements of eltype stored inside the given type, if the array
# elements are stored densely with a uniform linear stride.

Base.elsize(rand(Float32, 10))              # 4

# -------------------------------------------------
# Views (SubArrays and other view types)

# A “view” is a data structure that acts like an array (it is a subtype of AbstractArray), but the underlying data is
# actually part of another array.
# For example, if x is an array and v = @view x[1:10], then v acts like a 10-element array, but its data is actually
# accessing the first 10 elements of x. Writing to a view, e.g. v[3] = 2, writes directly to the underlying array x (in
# this case modifying x[3]).
# Slicing operations like x[1:10] create a copy by default in Julia. @view x[1:10] changes it to make a view. The @views
# macro can be used on a whole block of code (e.g. @views function foo() .... end or @views begin ... end) to change all
# the slicing operations in that block to use views. Sometimes making a copy of the data is faster and sometimes using a
# view is faster, as described in the performance tips.

# Base.view
# Function view(A, inds...)
# Like getindex, but returns a lightweight array that lazily references (or is effectively a view into) the parent array
# A at the given index or indices inds instead of eagerly extracting elements or constructing a copied subset. Calling
# getindex or setindex! on the returned value (often a SubArray) computes the indices to access or modify the parent
# array on the fly. The behavior is undefined if the shape of the parent array is changed after view is called because
# there is no bound check for the parent array; e.g., it may cause a segmentation fault.
# Some immutable parent arrays (like ranges) may choose to simply recompute a new array in some circumstances instead of
# returning a SubArray if doing so is efficient and provides compatible semantics.

A = [1 2; 3 4]              # 2×2 Matrix{Int64}:  1  2\n  3  4
b = view(A, :, 1)           # 2-element view(::Matrix{Int64}, :, 1) with eltype Int64:  1 3
fill!(b, 0)                 # 2-element view(::Matrix{Int64}, :, 1) with eltype Int64:  0 0
# Note A has changed even though we modified b
A                           # 2×2 Matrix{Int64}:  0  2\n 0  4

view(2:5, 2:3)              # 3:4       returns a range as type is immutable

# Base.@view
# Macro @view A[inds...]
# Transform the indexing expression A[inds...] into the equivalent view call.
# This can only be applied directly to a single indexing expression and is particularly helpful for expressions that
# include the special begin or end indexing syntaxes like A[begin, 2:end-1] (as those are not supported by the normal
# view function).
# Note that @view cannot be used as the target of a regular assignment (e.g., @view(A[1, 2:end]) = ...), nor would the
# un-decorated indexed assignment (A[1, 2:end] = ...) or broadcasted indexed assignment (A[1, 2:end] .= ...) make a
# copy. It can be useful, however, for updating broadcasted assignments like @view(A[1, 2:end]) .+= 1 because this is a
# simple syntax for @view(A[1, 2:end]) .= @view(A[1, 2:end]) + 1, and the indexing expression on the right-hand side
# would otherwise make a copy without the @view.
# See also @views to switch an entire block of code to use views for non-scalar indexing.

A = [1 2; 3 4]              # 2×2 Matrix{Int64}: 1  2\n 3  4
b = @view A[:, 1]           # 2-element view(::Matrix{Int64}, :, 1) with eltype Int64: 1 3
fill!(b, 0)                 # 2-element view(::Matrix{Int64}, :, 1) with eltype Int64: 0 0
A                           # 2×2 Matrix{Int64}: 0  2\n 0  4

# Base.@views
# Macro @views expression
# Convert every array-slicing operation in the given expression (which may be a begin/end block, loop, function, etc.)
# to return a view. Scalar indices, non-array types, and explicit getindex calls (as opposed to array[...]) are
# unaffected.
# Similarly, @views converts string slices into SubString views.
# Note The @views macro only affects array[...] expressions that appear explicitly in the given expression, not array
# slicing that occurs in functions called by that code.

A = zeros(3, 3);
@views for row in 1:3
           bb = A[row, :]
           bb[:] .= row
       end
A
# 3×3 Matrix{Float64}:
#  1.0  1.0  1.0
#  2.0  2.0  2.0
#  3.0  3.0  3.0

# Base.parent
# Function parent(A)
# Return the underlying parent object of the view. This parent of objects of types SubArray, SubString, ReshapedArray or
# LinearAlgebra.Transpose is what was passed as an argument to view, reshape, transpose, etc. during object creation. If
# the input is not a wrapped object, return the input itself. If the input is wrapped multiple times, only the outermost
# wrapper will be removed.

A = [1 2; 3 4]              # 2×2 Matrix{Int64}: 1  2\n  3  4
V = view(A, 1:2, :)         # 2×2 view(::Matrix{Int64}, 1:2, :) with eltype Int64: 1  2\n 3  4
parent(V)                   # 2×2 Matrix{Int64}:  1  2\n  3  4

# Base.parentindices
# Function parentindices(A)
# Return the indices in the parent which correspond to the view A.

A = [1 2; 3 4];
V = view(A, 1, :)           # 2-element view(::Matrix{Int64}, 1, :) with eltype Int64:  1  2
parentindices(V)            # (1, Base.Slice(Base.OneTo(2)))

# Base.selectdim
# Function selectdim(A, d::Integer, i)
# Return a view of all the data of A where the index for dimension d equals i.
# Equivalent to view(A,:,:,...,i,:,:,...) where i is in position d.
# See also: eachslice.

A = [1 2 3 4; 5 6 7 8]      # 2×4 Matrix{Int64}:  1  2  3  4\n  5  6  7  8
selectdim(A, 2, 3)          # 2-element view(::Matrix{Int64}, :, 3) with eltype Int64:  3\n  7
selectdim(A, 2, 3:4)        # 2×2 view(::Matrix{Int64}, :, 3:4) with eltype Int64:  3  4\n  7  8

# Base.reinterpret
# Function reinterpret(::Type{Out}, x::In)
# Change the type-interpretation of the binary data in the isbits value x to that of the isbits type Out. The size
# (ignoring padding) of Out has to be the same as that of the type of x. For example, reinterpret(Float32, UInt32(7))
# interprets the 4 bytes corresponding to UInt32(7) as a Float32.

reinterpret(Float32, UInt32(7))                     # 1.0f-44
reinterpret(NTuple{2, UInt8}, 0x1234)               # (0x34, 0x12)
reinterpret(UInt16, (0x34, 0x12))                   # 0x1234
reinterpret(Tuple{UInt16, UInt8}, (0x01, 0x0203))   # (0x0301, 0x02)

# Warning: Use caution if some combinations of bits in Out are not considered valid and would otherwise be prevented by
# the type's constructors and methods. Unexpected behavior may result without additional validation.

# reinterpret(T::DataType, A::AbstractArray)
# Construct a view of the array with the same binary data as the given array, but with T as element type.
# This function also works on "lazy" array whose elements are not computed until they are explicitly retrieved. For
# instance, reinterpret on the range 1:6 works similarly as on the dense vector collect(1:6):

reinterpret(Float32, UInt32[1 2 3 4 5])             # 1×5 reinterpret(Float32, ::Matrix{UInt32}): 1.0f-45  3.0f-45  4.0f-45  6.0f-45  7.0f-45
reinterpret(Complex{Int}, 1:6)                      # 3-element reinterpret(Complex{Int64}, ::UnitRange{Int64}):  1 + 2im\n  3 + 4im\n  5 + 6im

# reinterpret(reshape, T, A::AbstractArray{S}) -> B
# Change the type-interpretation of A while consuming or adding a "channel dimension."
# If sizeof(T) = n*sizeof(S) for n>1, A's first dimension must be of size n and B lacks A's first dimension. Conversely,
# if sizeof(S) = n*sizeof(T) for n>1, B gets a new first dimension of size n. The dimensionality is unchanged if
# sizeof(T) == sizeof(S).

A = [1 2; 3 4]                              # 2×2 Matrix{Int64}: 1  2\n  3  4
reinterpret(reshape, Complex{Int}, A)       #  the result is a vector
# 2-element reinterpret(reshape, Complex{Int64}, ::Matrix{Int64}) with eltype Complex{Int64}:
#  1 + 3im
#  2 + 4im

a = [(1,2,3), (4,5,6)]                      # 2-element Vector{Tuple{Int64, Int64, Int64}}: (1, 2, 3)\n  (4, 5, 6)
reinterpret(reshape, Int, a)                # the result is a matrix
# 3×2 reinterpret(reshape, Int64, ::Vector{Tuple{Int64, Int64, Int64}}) with eltype Int64:
#  1  4
#  2  5
#  3  6

# Base.reshape
# Function reshape(A, dims...) -> AbstractArray
# Function reshape(A, dims) -> AbstractArray

# Return an array with the same data as A, but with different dimension sizes or number of dimensions. The two arrays
# share the same underlying data, so that the result is mutable if and only if A is mutable, and setting elements of one
# alters the values of the other.

# The new dimensions may be specified either as a list of arguments or as a shape tuple. At most one dimension may be
# specified with a :, in which case its length is computed such that its product with all the specified dimensions is
# equal to the length of the original array A. The total number of elements must not change.

A = Vector(1:16)        # 16-element Vector{Int64}: 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
reshape(A, (4, 4))      # 4×4 Matrix{Int64}:  1  5   9  13\n  2  6  10  14\n  3  7  11  15\n  4  8  12  16
reshape(A, 2, :)        # 2×8 Matrix{Int64}:  1  3  5  7   9  11  13  15\n  2  4  6  8  10  12  14  16
reshape(1:6, 2, 3)      # 2×3 reshape(::UnitRange{Int64}, 2, 3) with eltype Int64:  1  3  5\n  2  4  6

# Base.dropdims
# Function dropdims(A; dims)
# Return an array with the same data as A, but with the dimensions specified by dims removed. size(A,d) must equal 1 for
# every d in dims, and repeated dimensions or numbers outside 1:ndims(A) are forbidden.
# The result shares the same underlying data as A, such that the result is mutable if and only if A is mutable, and
# setting elements of one alters the values of the other.
# See also: reshape, vec.

a = reshape(Vector(1:4),(2,2,1,1))
# 2×2×1×1 Array{Int64, 4}:
# [:, :, 1, 1] =
#  1  3
#  2  4

b = dropdims(a; dims=3)
# 2×2×1 Array{Int64, 3}:
# [:, :, 1] =
#  1  3
#  2  4

b[1,1,1] = 5; a
# 2×2×1×1 Array{Int64, 4}:
# [:, :, 1, 1] =
#  5  3
#  2  4

# Base.vec
# Function vec(a::AbstractArray) -> AbstractVector
# Reshape the array a as a one-dimensional column vector. Return a if it is already an AbstractVector. The resulting
# array shares the same underlying data as a, so it will only be mutable if a is mutable, in which case modifying one
# will also modify the other.
a = [1 2 3; 4 5 6]      # 2×3 Matrix{Int64}:  1  2  3\n  4  5  6
vec(a)                  # 6-element Vector{Int64}: 1 4 2 5 3 6
vec(1:3)                # 1:3

# Base.SubArray
# Type SubArray{T,N,P,I,L} <: AbstractArray{T,N}
# N-dimensional view into a parent array (of type P) with an element type T, restricted by a tuple of indices (of type I).
# L is true for types that support fast linear indexing, and false otherwise.
# Construct SubArrays using the view function.


# -------------------------------------------------
# Concatenation and permutation

# Base.cat
# Function cat(A...; dims)
# Concatenate the input arrays along the dimensions specified in dims.

# Along a dimension d in dims, the size of the output array is sum(size(a,d) for a in A). Along other dimensions, all
# input arrays should have the same size, which will also be the size of the output array along those dimensions.

# If dims is a single number, the different arrays are tightly packed along that dimension. If dims is an iterable
# containing several dimensions, the positions along these dimensions are increased simultaneously for each input array,
# filling with zero elsewhere. This allows one to construct block-diagonal matrices as cat(matrices...; dims=(1,2)), and
# their higher-dimensional analogues.

# The special case dims=1 is vcat, and dims=2 is hcat. See also hvcat, hvncat, stack, repeat.
# The keyword also accepts Val(dims).

cat([1 2; 3 4], [pi, pi], fill(10, 2,3,1); dims=2)  # same as hcat
# 2×6×1 Array{Float64, 3}:
# [:, :, 1] =
#  1.0  2.0  3.14159  10.0  10.0  10.0
#  3.0  4.0  3.14159  10.0  10.0  10.0

cat(true, trues(2,2), trues(4)', dims=(1,2))  # block-diagonal
# 4×7 Matrix{Bool}:
#  1  0  0  0  0  0  0
#  0  1  1  0  0  0  0
#  0  1  1  0  0  0  0
#  0  0  0  1  1  1  1

cat(1, [2], [3;;]; dims=Val(2))
# 1×3 Matrix{Int64}:
#  1  2  3

# Base.vcat
# Function vcat(A...)
# Concatenate arrays or numbers vertically. Equivalent to cat(A...; dims=1), and to the syntax [a; b; c].

# To concatenate a large vector of arrays, reduce(vcat, A) calls an efficient method when A isa
# AbstractVector{<:AbstractVecOrMat}, rather than working pairwise.
# See also hcat, Iterators.flatten, stack.

v = vcat([1,2], [3,4])                          # 4-element Vector{Int64}: 1 2 3 4
v == vcat(1, 2, [3,4])                          # true                                      # accepts numbers
v == [1; 2; [3,4]]                              # true                                      # syntax for the same operation
summary(ComplexF64[1; 2; [3,4]])                # "4-element Vector{ComplexF64}"            # syntax for supplying the element type
vcat(range(1, 2, length=3))                     # 3-element Vector{Float64}: 1.0 1.5 2.0    # collects lazy ranges
two = ([10, 20, 30]', Float64[4 5 6; 7 8 9])    # ([10 20 30], [4.0 5.0 6.0; 7.0 8.0 9.0])  # row vector and a matrix
vcat(two...)                                    # 3×3 Matrix{Float64}: 10.0  20.0  30.0\n  4.0   5.0   6.0\n  7.0   8.0   9.0
vs = [[1, 2], [3, 4], [5, 6]];
reduce(vcat, vs)                                # 6-element Vector{Int64}: 1 2 3 4 5 6      # more efficient than vcat(vs...)
ans == collect(Iterators.flatten(vs))           # true


# Base.hcat
# Function hcat(A...)
# Concatenate arrays or numbers horizontally. Equivalent to cat(A...; dims=2), and to the syntax [a b c] or [a;; b;; c].

# For a large vector of arrays, reduce(hcat, A) calls an efficient method when A isa AbstractVector{<:AbstractVecOrMat}.
# For a vector of vectors, this can also be written stack(A).
# See also vcat, hvcat.

hcat([1,2], [3,4], [5,6])
# 2×3 Matrix{Int64}:
#  1  3  5
#  2  4  6

hcat(1, 2, [30 40], [5, 6, 7]')  # accepts numbers
# 1×7 Matrix{Int64}:
#  1  2  30  40  5  6  7

ans == [1 2 [30 40] [5, 6, 7]']  # syntax for the same operation
# true

Float32[1 2 [30 40] [5, 6, 7]']  # syntax for supplying the eltype
# 1×7 Matrix{Float32}:
#  1.0  2.0  30.0  40.0  5.0  6.0  7.0

ms = [zeros(2,2), [1 2; 3 4], [50 60; 70 80]];

reduce(hcat, ms)  # more efficient than hcat(ms...)
# 2×6 Matrix{Float64}:
#  0.0  0.0  1.0  2.0  50.0  60.0
#  0.0  0.0  3.0  4.0  70.0  80.0

stack(ms) |> summary  # disagrees on a vector of matrices
# "2×2×3 Array{Float64, 3}"

hcat(Int[], Int[], Int[])  # empty vectors, each of size (0,)
# 0×3 Matrix{Int64}

hcat([1.1, 9.9], Matrix(undef, 2, 0))  # hcat with empty 2×0 Matrix
# 2×1 Matrix{Any}:
#  1.1
#  9.9


# Base.hvcat
# Function hvcat(blocks_per_row::Union{Tuple{Vararg{Int}}, Int}, values...)
# Horizontal and vertical concatenation in one call. This function is called for block matrix syntax. The first argument
# specifies the number of arguments to concatenate in each block row. If the first argument is a single integer n, then
# all block rows are assumed to have n block columns.

a, b, c, d, e, f = 1, 2, 3, 4, 5, 6
# (1, 2, 3, 4, 5, 6)

[a b c; d e f]
# 2×3 Matrix{Int64}:
#  1  2  3
#  4  5  6

hvcat((3,3), a,b,c,d,e,f)
# 2×3 Matrix{Int64}:
#  1  2  3
#  4  5  6

[a b; c d; e f]
# 3×2 Matrix{Int64}:
#  1  2
#  3  4
#  5  6

hvcat((2,2,2), a,b,c,d,e,f)
#3×2 Matrix{Int64}:
# 1  2
# 3  4
# 5  6

hvcat((2,2,2), a,b,c,d,e,f) == hvcat(2, a,b,c,d,e,f)
# true


# Base.hvncat
# Function hvncat(dim::Int, row_first, values...)
# Function hvncat(dims::Tuple{Vararg{Int}}, row_first, values...)
# Function hvncat(shape::Tuple{Vararg{Tuple}}, row_first, values...)
# Horizontal, vertical, and n-dimensional concatenation of many values in one call.

# This function is called for block matrix syntax. The first argument either specifies the shape of the concatenation,
# similar to hvcat, as a tuple of tuples, or the dimensions that specify the key number of elements along each axis, and
# is used to determine the output dimensions. The dims form is more performant, and is used by default when the
# concatenation operation has the same number of elements along each axis (e.g., [a b; c d;;; e f ; g h]). The shape
# form is used when the number of elements along each axis is unbalanced (e.g., [a b ; c]). Unbalanced syntax needs
# additional validation overhead. The dim form is an optimization for concatenation along just one dimension. row_first
# indicates how values are ordered. The meaning of the first and second elements of shape are also swapped based on
# row_first.

a, b, c, d, e, f = 1, 2, 3, 4, 5, 6
# (1, 2, 3, 4, 5, 6)

[a b c;;; d e f]
# 1×3×2 Array{Int64, 3}:
# [:, :, 1] =
#  1  2  3
# 
# [:, :, 2] =
#  4  5  6

hvncat((2,1,3), false, a,b,c,d,e,f)
# 2×1×3 Array{Int64, 3}:
# [:, :, 1] =
#  1
#  2
# 
# [:, :, 2] =
#  3
#  4
# 
# [:, :, 3] =
#  5
#  6

[a b;;; c d;;; e f]
# 1×2×3 Array{Int64, 3}:
# [:, :, 1] =
#  1  2
# 
# [:, :, 2] =
#  3  4
# 
# [:, :, 3] =
#  5  6

hvncat(((3, 3), (3, 3), (6,)), true, a, b, c, d, e, f)
# 1×3×2 Array{Int64, 3}:
# [:, :, 1] =
#  1  2  3
# 
# [:, :, 2] =
#  4  5  6

# Examples for construction of the arguments

# [a b c ; d e f ;;;
#  g h i ; j k l ;;;
#  m n o ; p q r ;;;
#  s t u ; v w x]
# ⇒ dims = (2, 3, 4)
# 
# [a b ; c ;;; d ;;;;]
#  ___   _     _
#  2     1     1 = elements in each row (2, 1, 1)
#  _______     _
#  3           1 = elements in each column (3, 1)
#  _____________
#  4             = elements in each 3d slice (4,)
#  _____________
#  4             = elements in each 4d slice (4,)
# ⇒ shape = ((2, 1, 1), (3, 1), (4,), (4,)) with `row_first` = true


# Base.stack
# Function stack(iter; [dims])
# Combine a collection of arrays (or other iterable objects) of equal size into one larger array, by arranging them
# along one or more new dimensions.
 
# By default the axes of the elements are placed first, giving size(result) = (size(first(iter))..., size(iter)...).
# This has the same order of elements as Iterators.flatten(iter).
 
# With keyword dims::Integer, instead the ith element of iter becomes the slice selectdim(result, dims, i), so that
# size(result, dims) == length(iter). In this case stack reverses the action of eachslice with the same dims.
 
# The various cat functions also combine arrays. However, these all extend the arrays' existing (possibly trivial)
# dimensions, rather than placing the arrays along new dimensions. They also accept arrays as separate arguments, rather
# than a single collection.

#=
vecs = (1:2, [30, 40], Float32[500, 600]);

mat = stack(vecs)
2×3 Matrix{Float32}:
 1.0  30.0  500.0
 2.0  40.0  600.0

mat == hcat(vecs...) == reduce(hcat, collect(vecs))
true

vec(mat) == vcat(vecs...) == reduce(vcat, collect(vecs))
true

stack(zip(1:4, 10:99))  # accepts any iterators of iterators
2×4 Matrix{Int64}:
  1   2   3   4
 10  11  12  13

vec(ans) == collect(Iterators.flatten(zip(1:4, 10:99)))
true

stack(vecs; dims=1)  # unlike any cat function, 1st axis of vecs[1] is 2nd axis of result
3×2 Matrix{Float32}:
   1.0    2.0
  30.0   40.0
 500.0  600.0

x = rand(3,4);

x == stack(eachcol(x)) == stack(eachrow(x), dims=1)  # inverse of eachslice
true

Higher-dimensional examples:

A = rand(5, 7, 11);

E = eachslice(A, dims=2);  # a vector of matrices

(element = size(first(E)), container = size(E))
(element = (5, 11), container = (7,))

stack(E) |> size
(5, 11, 7)

stack(E) == stack(E; dims=3) == cat(E...; dims=3)
true

A == stack(E; dims=2)
true

M = (fill(10i+j, 2, 3) for i in 1:5, j in 1:7);

(element = size(first(M)), container = size(M))
(element = (2, 3), container = (5, 7))

stack(M) |> size  # keeps all dimensions
(2, 3, 5, 7)

stack(M; dims=1) |> size  # vec(container) along dims=1
(35, 2, 3)

hvcat(5, M...) |> size  # hvcat puts matrices next to each other
(14, 15)
=#


# stack(f, args...; [dims])

# Apply a function to each element of a collection, and stack the result. Or to several collections, zipped together.

# The function should return arrays (or tuples, or other iterators) all of the same size. These become slices of the
# result, each separated along dims (if given) or by default along the last dimensions.
# See also mapslices, eachcol.

# stack(c -> (c, c-32), "julia")
# 2×5 Matrix{Char}:
#  'j'  'u'  'l'  'i'  'a'
#  'J'  'U'  'L'  'I'  'A'

stack(eachrow([1 2 3; 4 5 6]), (10, 100); dims=1) do row, n
         vcat(row, row .* n, row ./ n)
       end
# 2×9 Matrix{Float64}:
#  1.0  2.0  3.0   10.0   20.0   30.0  0.1   0.2   0.3
#  4.0  5.0  6.0  400.0  500.0  600.0  0.04  0.05  0.06


# Base.vect
# Function vect(X...)
# Create a Vector with element type computed from the promote_typeof of the argument, containing the argument list.

a = Base.vect(UInt8(1), 2.5, 1//2)
# 3-element Vector{Float64}:
#  1.0
#  2.5
#  0.5


# Base.circshift
# Function circshift(A, shifts)
# Circularly shift, i.e. rotate, the data in an array. The second argument is a tuple or vector giving the amount to
# shift in each dimension, or an integer to shift only in the first dimension.
# See also: circshift!, circcopy!, bitrotate, <<.

b = reshape(Vector(1:16), (4,4))
# 4×4 Matrix{Int64}:
#  1  5   9  13
#  2  6  10  14
#  3  7  11  15
#  4  8  12  16
 
circshift(b, (0,2))
# 4×4 Matrix{Int64}:
#   9  13  1  5
#  10  14  2  6
#  11  15  3  7
#  12  16  4  8
 
circshift(b, (-1,0))
# 4×4 Matrix{Int64}:
#  2  6  10  14
#  3  7  11  15
#  4  8  12  16
#  1  5   9  13
 
a = BitArray([true, true, false, false, true])
# 5-element BitVector:
#  1
#  1
#  0
#  0
#  1
 
circshift(a, 1)
# 5-element BitVector:
#  1
#  1
#  1
#  0
#  0
 
circshift(a, -1)
# 5-element BitVector:
#  1
#  0
#  0
#  1
#  1

# Base.circshift!
# Function circshift!(dest, src, shifts)
# Circularly shift, i.e. rotate, the data in src, storing the result in dest. shifts specifies the amount to shift in each dimension.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.


# Base.circcopy!
# Function circcopy!(dest, src)
# Copy src to dest, indexing each dimension modulo its length. src and dest must have the same size, but can be offset
# in their indices; any offset results in a (circular) wraparound. If the arrays have overlapping indices, then on the
# domain of the overlap dest agrees with src.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

src = reshape(Vector(1:16), (4,4))
# 4×4 Array{Int64,2}:
#  1  5   9  13
#  2  6  10  14
#  3  7  11  15
#  4  8  12  16


using OffsetArrays
# OffsetArrays provides Julia users with arrays that have arbitrary indices, similar to those found in some other languages.
# An OffsetArray is a lightweight wrapper around an AbstractArray that shifts its indices. Generally, indexing into an
# OffsetArray should be as performant as the parent array.

dest = OffsetArray{Int}(undef, (0:3,2:5))
 
circcopy!(dest, src)
# OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}} with indices 0:3×2:5:
#  8  12  16  4
#  5   9  13  1
#  6  10  14  2
#  7  11  15  3

dest[1:3,2:4] == src[1:3,2:4]
# true


# -------------------------------------------------
# Base.findall
# Method findall(A)

# Return a vector I of the true indices or keys of A. If there are no such elements of A, return an empty array. To
# search for other kinds of values, pass a predicate as the first argument.
# Indices or keys are of the same type as those returned by keys(A) and pairs(A).
# See also: findfirst, searchsorted.

A = [true, false, false, true]          # 4-element Vector{Bool}: 1 0 0 1
findall(A)                              # 2-element Vector{Int64}: 1 4
A = [true false; false true]            # 2×2 Matrix{Bool}: 1  0\n 0  1
findall(A)                              # 2-element Vector{CartesianIndex{2}}: CartesianIndex(1, 1),  CartesianIndex(2, 2)
findall(falses(3))                      # Int64[]

# Base.findall
# Method findall(f::Function, A)
# Return a vector I of the indices or keys of A where f(A[I]) returns true. If there are no such elements of A, return
# an empty array.
# Indices or keys are of the same type as those returned by keys(A) and pairs(A).

x = [1, 3, 4]                           # 3-element Vector{Int64}: 1 3 4
findall(isodd, x)                       # 2-element Vector{Int64}: 1 2

A = [1 2 0; 3 4 0]
# 2×3 Matrix{Int64}:
#  1  2  0
#  3  4  0

findall(isodd, A)
# 2-element Vector{CartesianIndex{2}}:
#  CartesianIndex(1, 1)
#  CartesianIndex(2, 1)

findall(!iszero, A)
# 4-element Vector{CartesianIndex{2}}:
#  CartesianIndex(1, 1)
#  CartesianIndex(2, 1)
#  CartesianIndex(1, 2)
#  CartesianIndex(2, 2)

d = Dict(:A => 10, :B => -1, :C => 0)
# Dict{Symbol, Int64} with 3 entries:
#   :A => 10
#   :B => -1
#   :C => 0

findall(x -> x >= 0, d)
# 2-element Vector{Symbol}:
#  :A
#  :C


# Base.findfirst
# Method findfirst(A)
# Return the index or key of the first true value in A. Return nothing if no such value is found. To search for other
# kinds of values, pass a predicate as the first argument.
# Indices or keys are of the same type as those returned by keys(A) and pairs(A).
# See also: findall, findnext, findlast, searchsortedfirst.

A = [false, false, true, false]             # 4-element Vector{Bool}: 0 0 1 0
findfirst(A)                                # 3
findfirst(falses(3))                        # returns nothing
A = [false false; true false]               # 2×2 Matrix{Bool}: 0  0\n 1  0
findfirst(A)                                # CartesianIndex(2, 1)


# Base.findfirst
# Method findfirst(predicate::Function, A)
# Return the index or key of the first element of A for which predicate returns true. Return nothing if there is no such
# element.
# Indices or keys are of the same type as those returned by keys(A) and pairs(A).

A = [1, 4, 2, 2]                            # 4-element Vector{Int64}: 1 4 2 2
findfirst(iseven, A)                        # 2
findfirst(x -> x>10, A)                     # returns nothing
findfirst(isequal(4), A)                    # 2
A = [1 4; 2 2]                              # 2×2 Matrix{Int64}: 1  4\n 2  2
findfirst(iseven, A)                        # CartesianIndex(2, 1)

# Base.findlast
# Method findlast(A)
# Return the index or key of the last true value in A. Return nothing if there is no true value in A.
# Indices or keys are of the same type as those returned by keys(A) and pairs(A).
# See also: findfirst, findprev, findall.

A = [true, false, true, false]              # 4-element Vector{Bool}: 1 0 1 0
findlast(A)                                 # 3
A = falses(2,2)
findlast(A)                                 # returns nothing
A = [true false; true false]                # 2×2 Matrix{Bool}: 1  0\n 1  0
findlast(A)                                 # CartesianIndex(2, 1)


# Base.findlast
# Method findlast(predicate::Function, A)
# Return the index or key of the last element of A for which predicate returns true. Return nothing if there is no such element.
# Indices or keys are of the same type as those returned by keys(A) and pairs(A).

A = [1, 2, 3, 4]                            # 4-element Vector{Int64}: 1 2 3 4
findlast(isodd, A)                          # 3
findlast(x -> x > 5, A)                     # returns nothing
A = [1 2; 3 4]                              # 2×2 Matrix{Int64}: 1  2\n 3  4
findlast(isodd, A)                          # CartesianIndex(2, 1)

# Base.findnext
# Method findnext(A, i)
# Find the next index after or including i of a true element of A, or nothing if not found.
# Indices are of the same type as those returned by keys(A) and pairs(A).

A = [false, false, true, false]             # 4-element Vector{Bool}: 0 0 1 0
findnext(A, 1)                              # 3
findnext(A, 4)                              # returns nothing
A = [false false; true false]               # 2×2 Matrix{Bool}: 0  0\n 1  0
findnext(A, CartesianIndex(1, 1))           # CartesianIndex(2, 1)


# Base.findnext
# Method findnext(predicate::Function, A, i)
# Find the next index after or including i of an element of A for which predicate returns true, or nothing if not found.
# Indices are of the same type as those returned by keys(A) and pairs(A).

A = [1, 4, 2, 2];
findnext(isodd, A, 1)                       # 1
findnext(isodd, A, 2)                       # returns nothing
A = [1 4; 2 2];
findnext(isodd, A, CartesianIndex(1, 1))    # CartesianIndex(1, 1)


# Base.findprev
# Method findprev(A, i)
# Find the previous index before or including i of a true element of A, or nothing if not found.
# Indices are of the same type as those returned by keys(A) and pairs(A).
# See also: findnext, findfirst, findall.

A = [false, false, true, true]              # 4-element Vector{Bool}: 0 0 1 1
findprev(A, 3)                              # 3
findprev(A, 1)                              # returns nothing
A = [false false; true true]                # 2×2 Matrix{Bool}: 0  0\n 1  1
findprev(A, CartesianIndex(2, 1))           # CartesianIndex(2, 1)

# Base.findprev
# Method findprev(predicate::Function, A, i)
# Find the previous index before or including i of an element of A for which predicate returns true, or nothing if not found.
# Indices are of the same type as those returned by keys(A) and pairs(A).

A = [4, 6, 1, 2]                            # 4-element Vector{Int64}: 4 6 1 2
findprev(isodd, A, 1)                       # returns nothing
findprev(isodd, A, 3)                       # 3
A = [4 6; 1 2]                              # 2×2 Matrix{Int64}: 4  6\n 1  2
findprev(isodd, A, CartesianIndex(1, 2))    # CartesianIndex(2, 1)


# -------------------------------------------------
# Base.permutedims
# Function permutedims(A::AbstractArray, perm)
# Permute the dimensions of array A. perm is a vector or a tuple of length ndims(A) specifying the permutation.
# See also permutedims!, PermutedDimsArray, transpose, invperm.

A = reshape(Vector(1:8), (2,2,2))
# 2×2×2 Array{Int64, 3}:
# [:, :, 1] =
#  1  3
#  2  4
# 
# [:, :, 2] =
#  5  7
#  6  8

perm = (3, 1, 2); # put the last dimension first

B = permutedims(A, perm)
# 2×2×2 Array{Int64, 3}:
# [:, :, 1] =
#  1  2
#  5  6
# 
# [:, :, 2] =
#  3  4
#  7  8

A == permutedims(B, invperm(perm)) # the inverse permutation
# true

# For each dimension i of B = permutedims(A, perm), its corresponding dimension of A will be perm[i]. This means the
# equality size(B, i) == size(A, perm[i]) holds.

A = randn(5, 7, 11, 13);
perm = [4, 1, 3, 2];
B = permutedims(A, perm);
size(B)                         # (13, 5, 11, 7)
size(A)[perm] == ans            # true


# permutedims(m::AbstractMatrix)
# Permute the dimensions of the matrix m, by flipping the elements across the diagonal of the matrix. Differs from
# LinearAlgebra's transpose in that the operation is not recursive.

a = [1 2; 3 4];
b = [5 6; 7 8];
c = [9 10; 11 12];
d = [13 14; 15 16];
X = [[a] [b]; [c] [d]]
# 2×2 Matrix{Matrix{Int64}}:
#  [1 2; 3 4]     [5 6; 7 8]
#  [9 10; 11 12]  [13 14; 15 16]

permutedims(X)
# 2×2 Matrix{Matrix{Int64}}:
#  [1 2; 3 4]  [9 10; 11 12]
#  [5 6; 7 8]  [13 14; 15 16]

transpose(X)
# 2×2 transpose(::Matrix{Matrix{Int64}}) with eltype Transpose{Int64, Matrix{Int64}}:
#  [1 3; 2 4]  [9 11; 10 12]
#  [5 7; 6 8]  [13 15; 14 16]

# permutedims(v::AbstractVector)
# Reshape vector v into a 1 × length(v) row matrix. Differs from LinearAlgebra's transpose in that the operation is not recursive.

permutedims([1, 2, 3, 4])
# 1×4 Matrix{Int64}:
#  1  2  3  4

V = [[[1 2; 3 4]]; [[5 6; 7 8]]]
# 2-element Vector{Matrix{Int64}}:
#  [1 2; 3 4]
#  [5 6; 7 8]

permutedims(V)
# 1×2 Matrix{Matrix{Int64}}:
#  [1 2; 3 4]  [5 6; 7 8]

transpose(V)
# 1×2 transpose(::Vector{Matrix{Int64}}) with eltype Transpose{Int64, Matrix{Int64}}:
#  [1 3; 2 4]  [5 7; 6 8]

# Base.permutedims!
# Function permutedims!(dest, src, perm)
# Permute the dimensions of array src and store the result in the array dest. perm is a vector specifying a permutation
# of length ndims(src). The preallocated array dest should have size(dest) == size(src)[perm] and is completely
# overwritten. No in-place permutation is supported and unexpected results will happen if src and dest have overlapping
# memory regions.

# Base.PermutedDimsArrays.PermutedDimsArray
# Type PermutedDimsArray(A, perm) -> B
# Given an AbstractArray A, create a view B such that the dimensions appear to be permuted. Similar to permutedims, except that no copying occurs (B shares storage with A).
# See also permutedims, invperm.

A = rand(3,5,4);
B = PermutedDimsArray(A, (3,1,2));
size(B)                                 # (4, 3, 5)
B[3,1,2] == A[1,2,3]                    # true


# Base.promote_shape
# Function promote_shape(s1, s2)
# Check two array shapes for compatibility, allowing trailing singleton dimensions, and return whichever shape has more dimensions.

a = fill(1, (3,4,1,1,1));
b = fill(1, (3,4));
promote_shape(a,b)                          # (Base.OneTo(3), Base.OneTo(4), Base.OneTo(1), Base.OneTo(1), Base.OneTo(1))
promote_shape((2,3,1,4), (2, 3, 1, 4, 1))   # (2, 3, 1, 4, 1)


# -------------------------------------------------
# Array functions

# Base.accumulate
# Function accumulate(op, A; dims::Integer, [init])

# Cumulative operation op along the dimension dims of A (providing dims is optional for vectors). An initial value init
# may optionally be provided by a keyword argument. See also accumulate! to use a preallocated output array, both for
# performance and to control the precision of the output (e.g. to avoid overflow).

# For common operations there are specialized variants of accumulate, see cumsum, cumprod. For a lazy version, see
# Iterators.accumulate.

accumulate(+, [1,2,3])                      # 3-element Vector{Int64}: 1 3 6
accumulate(min, (1, -2, 3, -4, 5), init=0)  # (0, -2, -2, -4, -4)
accumulate(/, (2, 4, Inf), init=100)        # (50.0, 12.5, 0.0)
accumulate(=>, i^2 for i in 1:3)
# 3-element Vector{Any}:
#           1
#         1 => 4
#  (1 => 4) => 9

accumulate(+, fill(1, 3, 4))
# 3×4 Matrix{Int64}:
#  1  4  7  10
#  2  5  8  11
#  3  6  9  12

accumulate(+, fill(1, 2, 5), dims=2, init=100.0)
# 2×5 Matrix{Float64}:
#  101.0  102.0  103.0  104.0  105.0
#  101.0  102.0  103.0  104.0  105.0

# Base.accumulate!
# Function accumulate!(op, B, A; [dims], [init])
# Cumulative operation op on A along the dimension dims, storing the result in B. Providing dims is optional for
# vectors. If the keyword argument init is given, its value is used to instantiate the accumulation.
# See also accumulate, cumsum!, cumprod!.

x = [1, 0, 2, 0, 3];
y = rand(5);
accumulate!(+, y, x);
y                           # 5-element Vector{Float64}: 1.0 1.0 3.0 3.0 6.0
A = [1 2 3; 4 5 6];
B = similar(A);

accumulate!(-, B, A, dims=1)
# 2×3 Matrix{Int64}:
#   1   2   3
#  -3  -3  -3

accumulate!(*, B, A, dims=2, init=10)
# 2×3 Matrix{Int64}:
#  10   20    60
#  40  200  1200


# Base.cumprod
# Function cumprod(A; dims::Integer)
# Cumulative product along the dimension dim. See also cumprod! to use a preallocated output array, both for performance
# and to control the precision of the output (e.g. to avoid overflow).

a = Int8[1 2 3; 4 5 6];

cumprod(a, dims=1)
# 2×3 Matrix{Int64}:
#  1   2   3
#  4  10  18

cumprod(a, dims=2)
# 2×3 Matrix{Int64}:
#  1   2    6
#  4  20  120


# cumprod(itr)
# Cumulative product of an iterator.
# See also cumprod!, accumulate, cumsum.

cumprod(fill(1//2, 3))
# 3-element Vector{Rational{Int64}}:
#  1//2
#  1//4
#  1//8

cumprod((1, 2, 1, 3, 1))            # (1, 2, 2, 6, 6)
cumprod("julia")                    # 5-element Vector{String}: "j" "ju" "jul" "juli" "julia"

# Base.cumprod!
# Function cumprod!(B, A; dims::Integer)
# Cumulative product of A along the dimension dims, storing the result in B. See also cumprod.

# cumprod!(y::AbstractVector, x::AbstractVector)
# Cumulative product of a vector x, storing the result in y. See also cumprod.


# Base.cumsum
# Function cumsum(A; dims::Integer)
# Cumulative sum along the dimension dims. See also cumsum! to use a preallocated output array, both for performance and
# to control the precision of the output (e.g. to avoid overflow).

a = [1 2 3; 4 5 6]
# 2×3 Matrix{Int64}:
#  1  2  3
#  4  5  6

cumsum(a, dims=1)
# 2×3 Matrix{Int64}:
#  1  2  3
#  5  7  9

cumsum(a, dims=2)
# 2×3 Matrix{Int64}:
#  1  3   6
#  4  9  15

# Note: The return array's eltype is Int for signed integers of less than system word size and UInt for unsigned
# integers of less than system word size. To preserve eltype of arrays with small signed or unsigned integer
# accumulate(+, A) should be used.

cumsum(Int8[100, 28])
# 2-element Vector{Int64}:
#  100
#  128

accumulate(+,Int8[100, 28])
# 2-element Vector{Int8}:
#   100
#  -128

# In the former case, the integers are widened to system word size and therefore the result is Int64[100, 128]. In the
# latter case, no such widening happens and integer overflow results in Int8[100, -128].


# cumsum(itr)
# Cumulative sum of an iterator.
# See also accumulate to apply functions other than +.

cumsum(1:3)                                 # 3-element Vector{Int64}: 1 3 6
cumsum((true, false, true, false, true))    # (1, 1, 2, 2, 3)
cumsum(fill(1, 2) for i in 1:3)             # 3-element Vector{Vector{Int64}}: [1, 1]\n [2, 2]\n [3, 3]


# Base.cumsum!
# Function cumsum!(B, A; dims::Integer)
# Cumulative sum of A along the dimension dims, storing the result in B. See also cumsum.


# -------------------------------------------------
# Base.diff
# Function diff(A::AbstractVector)
# Function diff(A::AbstractArray; dims::Integer)

# Finite difference operator on a vector or a multidimensional array A. In the latter case the dimension to operate on
# needs to be specified with the dims keyword argument.

a = [2 4; 6 16]
# 2×2 Matrix{Int64}:
#  2   4
#  6  16

diff(a, dims=2)
# 2×1 Matrix{Int64}:
#   2
#  10

diff(vec(a))
# 3-element Vector{Int64}:
#   4
#  -2
#  12


# -------------------------------------------------
Base.repeat
—
Function
repeat(A::AbstractArray, counts::Integer...)

Construct an array by repeating array A a given number of times in each dimension, specified by counts.

See also: fill, Iterators.repeated, Iterators.cycle.

Examples

repeat([1, 2, 3], 2)
6-element Vector{Int64}:
 1
 2
 3
 1
 2
 3

repeat([1, 2, 3], 2, 3)
6×3 Matrix{Int64}:
 1  1  1
 2  2  2
 3  3  3
 1  1  1
 2  2  2
 3  3  3

source
repeat(A::AbstractArray; inner=ntuple(Returns(1), ndims(A)), outer=ntuple(Returns(1), ndims(A)))

Construct an array by repeating the entries of A. The i-th element of inner specifies the number of times that the individual entries of the i-th dimension of A should be repeated. The i-th element of outer specifies the number of times that a slice along the i-th dimension of A should be repeated. If inner or outer are omitted, no repetition is performed.

Examples

repeat(1:2, inner=2)
4-element Vector{Int64}:
 1
 1
 2
 2

repeat(1:2, outer=2)
4-element Vector{Int64}:
 1
 2
 1
 2

repeat([1 2; 3 4], inner=(2, 1), outer=(1, 3))
4×6 Matrix{Int64}:
 1  2  1  2  1  2
 1  2  1  2  1  2
 3  4  3  4  3  4
 3  4  3  4  3  4

source
repeat(s::AbstractString, r::Integer)

Repeat a string r times. This can be written as s^r.

See also ^.

Examples

repeat("ha", 3)
"hahaha"

source
repeat(c::AbstractChar, r::Integer) -> String

Repeat a character r times. This can equivalently be accomplished by calling c^r.

Examples

repeat('A', 3)
"AAA"


# -------------------------------------------------
Base.rot180
—
Function
rot180(A)

Rotate matrix A 180 degrees.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

rot180(a)
2×2 Matrix{Int64}:
 4  3
 2  1

source
rot180(A, k)

Rotate matrix A 180 degrees an integer k number of times. If k is even, this is equivalent to a copy.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

rot180(a,1)
2×2 Matrix{Int64}:
 4  3
 2  1

rot180(a,2)
2×2 Matrix{Int64}:
 1  2
 3  4

source
Base.rotl90
—
Function
rotl90(A)

Rotate matrix A left 90 degrees.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

rotl90(a)
2×2 Matrix{Int64}:
 2  4
 1  3

source
rotl90(A, k)

Left-rotate matrix A 90 degrees counterclockwise an integer k number of times. If k is a multiple of four (including zero), this is equivalent to a copy.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

rotl90(a,1)
2×2 Matrix{Int64}:
 2  4
 1  3

rotl90(a,2)
2×2 Matrix{Int64}:
 4  3
 2  1

rotl90(a,3)
2×2 Matrix{Int64}:
 3  1
 4  2

rotl90(a,4)
2×2 Matrix{Int64}:
 1  2
 3  4

source
Base.rotr90
—
Function
rotr90(A)

Rotate matrix A right 90 degrees.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

rotr90(a)
2×2 Matrix{Int64}:
 3  1
 4  2

source
rotr90(A, k)

Right-rotate matrix A 90 degrees clockwise an integer k number of times. If k is a multiple of four (including zero), this is equivalent to a copy.

Examples

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

rotr90(a,1)
2×2 Matrix{Int64}:
 3  1
 4  2

rotr90(a,2)
2×2 Matrix{Int64}:
 4  3
 2  1

rotr90(a,3)
2×2 Matrix{Int64}:
 2  4
 1  3

rotr90(a,4)
2×2 Matrix{Int64}:
 1  2
 3  4


# -------------------------------------------------
Base.mapslices
—
Function
mapslices(f, A; dims)

Transform the given dimensions of array A by applying a function f on each slice of the form A[..., :, ..., :, ...], with a colon at each d in dims. The results are concatenated along the remaining dimensions.

For example, if dims = [1,2] and A is 4-dimensional, then f is called on x = A[:,:,i,j] for all i and j, and f(x) becomes R[:,:,i,j] in the result R.

See also eachcol or eachslice, used with map or stack.

Examples

A = reshape(1:30,(2,5,3))
2×5×3 reshape(::UnitRange{Int64}, 2, 5, 3) with eltype Int64:
[:, :, 1] =
 1  3  5  7   9
 2  4  6  8  10

[:, :, 2] =
 11  13  15  17  19
 12  14  16  18  20

[:, :, 3] =
 21  23  25  27  29
 22  24  26  28  30

f(x::Matrix) = fill(x[1,1], 1,4);  # returns a 1×4 matrix

B = mapslices(f, A, dims=(1,2))
1×4×3 Array{Int64, 3}:
[:, :, 1] =
 1  1  1  1

[:, :, 2] =
 11  11  11  11

[:, :, 3] =
 21  21  21  21

f2(x::AbstractMatrix) = fill(x[1,1], 1,4);

B == stack(f2, eachslice(A, dims=3))
true

g(x) = x[begin] // x[end-1];  # returns a number

mapslices(g, A, dims=[1,3])
1×5×1 Array{Rational{Int64}, 3}:
[:, :, 1] =
 1//21  3//23  1//5  7//27  9//29

map(g, eachslice(A, dims=2))
5-element Vector{Rational{Int64}}:
 1//21
 3//23
 1//5
 7//27
 9//29

mapslices(sum, A; dims=(1,3)) == sum(A; dims=(1,3))
true

Notice that in eachslice(A; dims=2), the specified dimension is the one without a colon in the slice. This is view(A,:,i,:), whereas mapslices(f, A; dims=(1,3)) uses A[:,i,:]. The function f may mutate values in the slice without affecting A.

source
Base.eachrow
—
Function
eachrow(A::AbstractVecOrMat) <: AbstractVector

Create a RowSlices object that is a vector of rows of matrix or vector A. Row slices are returned as AbstractVector views of A.

For the inverse, see stack(rows; dims=1).

See also eachcol, eachslice and mapslices.

Julia 1.1
This function requires at least Julia 1.1.

Julia 1.9
Prior to Julia 1.9, this returned an iterator.

Example

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

s = eachrow(a)
2-element RowSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}}:
 [1, 2]
 [3, 4]

s[1]
2-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2

source
Base.eachcol
—
Function
eachcol(A::AbstractVecOrMat) <: AbstractVector

Create a ColumnSlices object that is a vector of columns of matrix or vector A. Column slices are returned as AbstractVector views of A.

For the inverse, see stack(cols) or reduce(hcat, cols).

See also eachrow, eachslice and mapslices.

Julia 1.1
This function requires at least Julia 1.1.

Julia 1.9
Prior to Julia 1.9, this returned an iterator.

Example

a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

s = eachcol(a)
2-element ColumnSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Base.Slice{Base.OneTo{Int64}}, Int64}, true}}:
 [1, 3]
 [2, 4]

s[1]
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 1
 3

source
Base.eachslice
—
Function
eachslice(A::AbstractArray; dims, drop=true)

Create a Slices object that is an array of slices over dimensions dims of A, returning views that select all the data from the other dimensions in A. dims can either by an integer or a tuple of integers.

If drop = true (the default), the outer Slices will drop the inner dimensions, and the ordering of the dimensions will match those in dims. If drop = false, then the Slices will have the same dimensionality as the underlying array, with inner dimensions having size 1.

See stack(slices; dims) for the inverse of eachslice(A; dims::Integer).

See also eachrow, eachcol, mapslices and selectdim.

Julia 1.1
This function requires at least Julia 1.1.

Julia 1.9
Prior to Julia 1.9, this returned an iterator, and only a single dimension dims was supported.

Example

m = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

s = eachslice(m, dims=1)
3-element RowSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]

s[1]
3-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2
 3

eachslice(m, dims=1, drop=false)
3×1 Slices{Matrix{Int64}, Tuple{Int64, Colon}, Tuple{Base.OneTo{Int64}, Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}, 2}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]



# -------------------------------------------------
Combinatorics
Base.invperm
—
Function
invperm(v)

Return the inverse permutation of v. If B = A[v], then A == B[invperm(v)].

See also sortperm, invpermute!, isperm, permutedims.

Examples

p = (2, 3, 1);

invperm(p)
(3, 1, 2)

v = [2; 4; 3; 1];

invperm(v)
4-element Vector{Int64}:
 4
 1
 3
 2

A = ['a','b','c','d'];

B = A[v]
4-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

B[invperm(v)]
4-element Vector{Char}:
 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
 'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)

source
Base.isperm
—
Function
isperm(v) -> Bool

Return true if v is a valid permutation.

Examples

isperm([1; 2])
true

isperm([1; 3])
false

source
Base.permute!
—
Method
permute!(v, p)

Permute vector v in-place, according to permutation p. No checking is done to verify that p is a permutation.

To return a new permutation, use v[p]. This is generally faster than permute!(v, p); it is even faster to write into a pre-allocated output array with u .= @view v[p]. (Even though permute! overwrites v in-place, it internally requires some allocation to keep track of which elements have been moved.)

Warning
Behavior can be unexpected when any mutated argument shares memory with any other argument.

See also invpermute!.

Examples

A = [1, 1, 3, 4];

perm = [2, 4, 3, 1];

permute!(A, perm);

A
4-element Vector{Int64}:
 1
 4
 3
 1

source
Base.invpermute!
—
Function
invpermute!(v, p)

Like permute!, but the inverse of the given permutation is applied.

Note that if you have a pre-allocated output array (e.g. u = similar(v)), it is quicker to instead employ u[p] = v. (invpermute! internally allocates a copy of the data.)

Warning
Behavior can be unexpected when any mutated argument shares memory with any other argument.

Examples

A = [1, 1, 3, 4];

perm = [2, 4, 3, 1];

invpermute!(A, perm);

A
4-element Vector{Int64}:
 4
 1
 3
 1

source
Base.reverse
—
Method
reverse(A; dims=:)

Reverse A along dimension dims, which can be an integer (a single dimension), a tuple of integers (a tuple of dimensions) or : (reverse along all the dimensions, the default). See also reverse! for in-place reversal.

Examples

b = Int64[1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

reverse(b, dims=2)
2×2 Matrix{Int64}:
 2  1
 4  3

reverse(b)
2×2 Matrix{Int64}:
 4  3
 2  1

Julia 1.6
Prior to Julia 1.6, only single-integer dims are supported in reverse.

source
Base.reverseind
—
Function
reverseind(v, i)

Given an index i in reverse(v), return the corresponding index in v so that v[reverseind(v,i)] == reverse(v)[i]. (This can be nontrivial in cases where v contains non-ASCII characters.)

Examples

s = "Julia🚀"
"Julia🚀"

r = reverse(s)
"🚀ailuJ"

for i in eachindex(s)
           print(r[reverseind(r, i)])
       end
Julia🚀

source
Base.reverse!
—
Function
reverse!(v [, start=firstindex(v) [, stop=lastindex(v) ]]) -> v

In-place version of reverse.

Examples

A = Vector(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

reverse!(A);

A
5-element Vector{Int64}:
 5
 4
 3
 2
 1

source
reverse!(A; dims=:)

Like reverse, but operates in-place in A.
