# arrays.jl
# Learn arrays in Julia
# 
# 2024-04-23    PV      First version

# Type Array{T,N} <: AbstractArray{T,N}     Core type for arrays, T is the type, N in the number of dimentions
# Type Vector{T} <: AbstractVector{T}       One-dimention arrays of type T, alias for Array{T,1}
# Type Matrix{T} <: AbstractMatrix{T}       Two-dimensions arrays of type T, alias for Array{T,2}.

# Construct, uninitialized (undef===UndefInitializer()). Dimensions is a Tuple or multiple numbers. Use isassigned(A, idx) to test for undef
Array{Char}(undef, 5)
Array{Char}(undef, 5, 5)                    # 5x5 Matrix {Char}
Array{Char}(undef, (5, 5, 5))               # 5×5×5 Array{Char, 3}

# Construct, nothing (Nothing <: T; nothing===Nothing())
Array{Union{Int, Nothing}}(nothing, 10)     # 10-element Vector{Union{Nothing, Int64}}

# construct, missing (Missing <: T; missing===Missing())
Array{Union{Missing, Int}}(missing, 2, 3)   # 2×3 Matrix{Union{Missing, Int64}}

# Specialized array
# Type BitArray{N} <: AbstractArray{Bool, N}    # Using just one bit for each boolean value, not thread-safe
# Pack up to 64 values into every 8 bytes, resulting in an 8x space efficiency over Array{Bool, N}
BitArray(undef, (3, 1))                     # 3×1 BitMatrix
BitArray([1 0; 0 1])                        # 2×2 BitMatrix
BitArray(x+y == 3 for x = 1:2, y = 1:3)     # 2×3 BitMatrix
BitArray(x+y == 3 for x = 1:2 for y = 1:3)  # 6-element BitVector


# Construct and initialize

# With specified values
[1, 2, 3]                       # 3-element Vector{Int64}: 1, 2, 3
Int8[1, 2, 3]                   # 3-element Vector{Int8}: 1, 2, 3
getindex(Int8, 1, 2, 3)         # 3-element Vector{Int8}: 1, 2, 3

# With zeros or ones (default type is FLoat64)
zeros(1)                        # 1-element Vector{Float64}: 0.0
ones(Int8, 2, 3)                # 2×3 Matrix{Int8}

# Create a BitArray with all values set to true or false
trues(2,3)                      # 2×3 BitMatrix
falses(5)                       # 5-element BitVector

# Create and initialize array (beware, if filler is a reference, all elements points to the same reference)
fill(1.0, (5,5))                # 5×5 Matrix{Float64}, with 1.0 in every location of the array
fill('r')                       # 0-dimensional Array{Char, 0}
fill([], 3)                     # Places the very same empty array in all three locations of the returned vector
[[] for _ in 1:3]               # Vector of three serarate empty vectors

# Fill existing array with spefified values (references all point to the same ref)
A = zeros(2,3)                  # 2×3 Matrix{Float64}: 0.0  0.0  0.0\n  0.0  0.0  0.0
fill!(A, 2.)                    # 2×3 Matrix{Float64}:  2.0  2.0  2.0\n  2.0  2.0  2.0


# Get infos in arrays

A = fill(1, (3,4,5));
ndims(A)                        # 3 = number of dimensions of a
size(A)                         # (2, 3, 4)     Tuple containing dimensions of a
size(A, 2)                      # 4             Specific 2nd dimension of A
axes(A)                         # (Base.OneTo(3), Base.OneTo(4), Base.OneTo(5))     tuple of valid indices for array A
axes(A, 3)                      # Base.OneTo(5)                                     Indices for a specified dimension
axes(A, 3) == 1:5               # true
length(A)                       # 60                Number of elements in the array, defaults to prod(size(A))
keys(A)                         # CartesianIndices((3, 4, 5))   array of valid indices for a arranged in the shape of A
eachindex(A)                    # Base.OntTo(60)    Iterable object for visiting each index of A (linear indexing)
eachindex(IndexCartesian(), A)  # CartesianIndices((3, 4, 5))
stride(A, 2)                    # 3                 Distance in memory (in number of elements) between adjacent elements in dimension k
stride(A, 3)                    # 12
strides(A)                      # (1, 3, 12)        Tuple of the memory strides in each dimension
Base.elsize(A)                  # 8                 Memory stride in bytes between consecutive elements of eltype
Base.summarysize(A)             # 528               Size in bytes (used by all objects reachable from the argument)
sizeof(A)                       # 480               Size in bytes of data (here, 3×4×5 × 8bytes = 480 bytes)

# Shorter form: foreach(println, CartesianIndices(A))
for ix in CartesianIndices(A)
    println(ix)
end
# CartesianIndex(1, 1, 1)
# CartesianIndex(2, 1, 1)
# CartesianIndex(3, 1, 1)
# CartesianIndex(1, 2, 1)
# CartesianIndex(2, 2, 1)
# CartesianIndex(3, 2, 1)
# CartesianIndex(1, 3, 1)
# ...
# CartesianIndex(3, 2, 5)
# CartesianIndex(1, 3, 5)
# CartesianIndex(2, 3, 5)
# CartesianIndex(3, 3, 5)
# CartesianIndex(1, 4, 5)
# CartesianIndex(2, 4, 5)
# CartesianIndex(3, 4, 5)


# Indexing and assignment
# getindex(A, inds...) returns a subset of array A as specified by inds, where each ind may be an Int, an AbstractRange, or a Vector.
A = [1 2; 3 4]                  # 2×2 Matrix{Int64}: 1  2, 3  4
getindex(A, 1)                  # 1
getindex(A, [2, 1])             # 2-element Vector{Int64}: 3, 1
getindex(A, 2:4)                # 3-element Vector{Int64}: 3, 2, 4


# Views
# A view is a lightweight array that lazily references (or is effectively a view into) the parent array.
# Slicing operations like x[1:10] create a copy by default. @view x[1:10] changes it to make a view.
A = [1 2; 3 4]              # 2×2 Matrix{Int64}:  1  2\n  3  4
b = view(A, :, 1)           # 2-element view(::Matrix{Int64}, :, 1) with eltype Int64:  1 3
fill!(b, 0)                 # 2-element view(::Matrix{Int64}, :, 1) with eltype Int64:  0 0
# Note A has changed even though we modified b
A                           # 2×2 Matrix{Int64}:  0  2\n 0  4
parent(b)                   # 2×2 Matrix{Int64}:  0  2\n 0  4
parent(b)===A               # true
parentindices(b)            # (Base.Slice(Base.OneTo(2)), 1)


# Reshaping
# Return an array with the same data as A, but with different dimension sizes or number of dimensions. The two arrays
# share the same underlying data, so that the result is mutable if and only if A is mutable, and setting elements of one
# alters the values of the other.
A = Vector(1:16)        # 16-element Vector{Int64}: 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
reshape(A, (4, 4))      # 4×4 Matrix{Int64}:  1  5   9  13\n  2  6  10  14\n  3  7  11  15\n  4  8  12  16
reshape(A, 2, :)        # 2×8 Matrix{Int64}:  1  3  5  7   9  11  13  15\n  2  4  6  8  10  12  14  16
reshape(1:6, 2, 3)      # 2×3 reshape(::UnitRange{Int64}, 2, 3) with eltype Int64:  1  3  5\n  2  4  6

