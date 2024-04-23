# dequeue_doc.jl
# Julia dequeue documentation, from doc Base > Collections and Data Structures > Dequeues
# 
# 2024-04-21    PV      First version


# Dequeues (Vector, BitVector)


# Base.push!
# Function push!(collection, items...) -> collection

# Insert one or more items in collection. If collection is an ordered container, the items are inserted at the end (in the given order).

push!([1, 2, 3], 4, 5, 6)       # 6-element Vector{Int64}: 1, 2, 3, 4, 5, 6

#  If collection is ordered, use append! to add all the elements of another collection to it. The result of the
#  preceding example is equivalent to append!([1, 2, 3], [4, 5, 6]). For AbstractSet objects, union! can be used
#  instead.
# See sizehint! for notes about the performance model.
# See also pushfirst!.

# -------------------------------------------------
# Base.pop!
# Function pop!(collection) -> item

# Remove an item in collection and return it. If collection is an ordered container, the last item is returned; for
# unordered containers, an arbitrary element is returned.
# See also: popfirst!, popat!, delete!, deleteat!, splice!, and push!.

A=[1, 2, 3]                     # 3-element Vector{Int64}: 1, 2, 3
pop!(A)                         # 3
A                               # 2-element Vector{Int64}: 1, 2
S = Set([1, 2])                 # Set{Int64} with 2 elements: 2, 1
pop!(S)                         # 2
S                               # Set{Int64} with 1 element: 1
pop!(Dict(1=>2))                # 1 => 2


# pop!(collection, key[, default])
# Delete and return the mapping for key if it exists in collection, otherwise return default, or throw an error if default is not specified.

d = Dict("a"=>1, "b"=>2, "c"=>3);
pop!(d, "a")                    # 1
# pop!(d, "d")                  # ERROR: KeyError: key "d" not found
pop!(d, "e", 4)                 # 4

# -------------------------------------------------
# Base.popat!
# Function popat!(a::Vector, i::Integer, [default])

# Remove the item at the given i and return it. Subsequent items are shifted to fill the resulting gap. When i is not a
# valid index for a, return default, or throw an error if default is not specified.
# See also: pop!, popfirst!, deleteat!, splice!.

a = [4, 3, 2, 1]; popat!(a, 2)  # 3   
a                               # 3-element Vector{Int64}: 4, 2, 1
popat!(a, 4, missing)           # missing
# popat!(a, 4)                  # ERROR: BoundsError: attempt to access 3-element Vector{Int64} at index [4]

# -------------------------------------------------
# Base.pushfirst!
# Function pushfirst!(collection, items...) -> collection

# Insert one or more items at the beginning of collection.

pushfirst!([1, 2, 3, 4], 5, 6)  # 6-element Vector{Int64}: 5, 6, 1, 2, 3, 4

# -------------------------------------------------
# Base.popfirst!
# Function popfirst!(collection) -> item

# Remove the first item from collection.
# See also: pop!, popat!, delete!.

A = [1, 2, 3, 4, 5, 6]          # 6-element Vector{Int64}: 1, 2, 3, 4, 5, 6
popfirst!(A)                    # 1
A                               # 5-element Vector{Int64}: 2, 3, 4, 5, 6

# -------------------------------------------------
# Base.insert!
# Function insert!(a::Vector, index::Integer, item)

# Insert an item into a at the given index. index is the index of item in the resulting a.
# See also: push!, replace, popat!, splice!.

insert!(Any[1:6;], 3, "here")   # 7-element Vector{Any}: 1, 2, "here", 3, 4, 5, 6

# -------------------------------------------------
# Base.deleteat!
# Function deleteat!(a::Vector, i::Integer)

# Remove the item at the given i and return the modified a. Subsequent items are shifted to fill the resulting gap.
# See also: keepat!, delete!, popat!, splice!.

deleteat!([6, 5, 4, 3, 2, 1], 2)        # 5-element Vector{Int64}: 6, 4, 3, 2, 1

# deleteat!(a::Vector, inds) Remove the items at the indices given by inds, and return the modified a. Subsequent items
# are shifted to fill the resulting gap.
# inds can be either an iterator or a collection of sorted and unique integer indices, or a boolean vector of the same
# length as a with true indicating entries to delete.

deleteat!([6, 5, 4, 3, 2, 1], 1:2:5)    # 3-element Vector{Int64}: 5, 3, 1
deleteat!([6, 5, 4, 3, 2, 1], [true, false, true, false, true, false])  # 3-element Vector{Int64}: 5, 3, 1
# deleteat!([6, 5, 4, 3, 2, 1], (2, 2)) # ERROR: ArgumentError: indices must be unique and sorted

# -------------------------------------------------
# Base.keepat!
# Function keepat!(a::Vector, inds)
# Function keepat!(a::BitVector, inds)

# Remove the items at all the indices which are not given by inds, and return the modified a. Items which are kept are
# shifted to fill the resulting gaps.
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.
# inds must be an iterator of sorted and unique integer indices. See also deleteat!.

keepat!([6, 5, 4, 3, 2, 1], 1:2:5)      # 3-element Vector{Int64}: 6, 4, 2

# keepat!(a::Vector, m::AbstractVector{Bool})
# keepat!(a::BitVector, m::AbstractVector{Bool})
# The in-place version of logical indexing a = a[m]. That is, keepat!(a, m) on vectors of equal length a and m will
# remove all elements from a for which m at the corresponding index is false.

a = [:a, :b, :c];
keepat!(a, [true, false, true])         # 2-element Vector{Symbol}: :a, :c
a                                       # 2-element Vector{Symbol}: :a, :c

# -------------------------------------------------
# Base.splice!
# Function splice!(a::Vector, index::Integer, [replacement]) -> item

# Remove the item at the given index, and return the removed item. Subsequent items are shifted left to fill the
# resulting gap. If specified, replacement values from an ordered collection will be spliced in place of the removed
# item.
# See also: replace, delete!, deleteat!, pop!, popat!.

A = [6, 5, 4, 3, 2, 1]; splice!(A, 5)   # 2
A                                       # 5-element Vector{Int64}: 6, 5, 4, 3, 1
splice!(A, 5, -1)                       # 1
A                                       # 5-element Vector{Int64}: 6, 5, 4, 3, -1
splice!(A, 1, [-1, -2, -3])             # 6
A                                       # 7-element Vector{Int64}: -1, -2, -3, 5, 4, 3, -1

# To insert replacement before an index n without removing any items, use splice!(collection, n:n-1, replacement).

# splice!(a::Vector, indices, [replacement]) -> items
# Remove items at specified indices, and return a collection containing the removed items. Subsequent items are shifted
# left to fill the resulting gaps. If specified, replacement values from an ordered collection will be spliced in place
# of the removed items; in this case, indices must be a AbstractUnitRange.
# To insert replacement before an index n without removing any items, use splice!(collection, n:n-1, replacement).
# Warning: Behavior can be unexpected when any mutated argument shares memory with any other argument.

A = [-1, -2, -3, 5, 4, 3, -1]; splice!(A, 4:3, 2)   # Int64[]
A                                                   # 8-element Vector{Int64}: -1, -2, -3, 2, 5, 4, 3, -1

# -------------------------------------------------
# Base.resize!
# Function resize!(a::Vector, n::Integer) -> Vector

# Resize a to contain n elements. If n is smaller than the current collection length, the first n elements will be
# retained. If n is larger, the new elements are not guaranteed to be initialized.

resize!([6, 5, 4, 3, 2, 1], 3)          # 3-element Vector{Int64}: 6, 5, 4
a = resize!([6, 5, 4, 3, 2, 1], 8);
length(a)                               # 8
a[1:6]                                  # 6-element Vector{Int64}: 6, 5, 4, 3, 2, 1

# -------------------------------------------------
# Base.append!
# Function append!(collection, collections...) -> collection.

# For an ordered container collection, add the elements of each collections to the end of it.

append!([1], [2, 3])                    # 3-element Vector{Int64}: 1, 2, 3
append!([1, 2, 3], [4, 5], [6])         # 6-element Vector{Int64}: 1, 2, 3, 4, 5, 6

# Use push! to add individual items to collection which are not already themselves in another collection. The result of
# the preceding example is equivalent to push!([1, 2, 3], 4, 5, 6).
# See sizehint! for notes about the performance model.
# See also vcat for vectors, union! for sets, and prepend! and pushfirst! for the opposite order.

# -------------------------------------------------
# Base.prepend!
# Function prepend!(a::Vector, collections...) -> collection

# Insert the elements of each collections to the beginning of a.
# When collections specifies multiple collections, order is maintained: elements of collections[1] will appear leftmost
# in a, and so on.

prepend!([3], [1, 2])                   # 3-element Vector{Int64}: 1, 2, 3
prepend!([6], [1, 2], [3, 4, 5])        # 6-element Vector{Int64}: 1, 2, 3, 4, 5, 6


# Dequeue fully implemented by:
# Vector (a.k.a. 1-dimensional Array)
# BitVector (a.k.a. 1-dimensional BitArray)
