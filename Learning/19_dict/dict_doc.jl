# dict_doc.jl
# Julia dictionaries documentation, from doc Base > Collections and Data Structures > Dictionaries
# 
# 2024-04-21    PV      First version

# Dictionaries

# Dict is the standard dictionary. Its implementation uses hash as the hashing function for the key, and isequal to
# determine equality. Define these two functions for custom types to override how they are stored in a hash table.
#
# IdDict is a special hash table where the keys are always object identities.
#
# WeakKeyDict is a hash table implementation where the keys are weak references to objects, and thus may be garbage
# collected even when referenced in a hash table. Like Dict it uses hash for hashing and isequal for equality, unlike
# Dict it does not convert keys on insertion.

# Dicts can be created by passing pair objects constructed with => to a Dict constructor: Dict("A"=>1, "B"=>2). This
# call will attempt to infer type information from the keys and values (i.e. this example creates a Dict{String, Int64}).
# To explicitly specify types use the syntax Dict{KeyType,ValueType}(...). For example, Dict{String,Int32}("A"=>1, "B"=>2).

# Dictionaries may also be created with generators. For example, Dict(i => f(i) for i = 1:10).

# Given a dictionary D, the syntax D[x] returns the value of key x (if it exists) or throws an error, and D[x] = y
# stores the key-value pair x => y in D (replacing any existing value for the key x). Multiple arguments to D[...] are
# converted to tuples; for example, the syntax D[x,y] is equivalent to D[(x,y)], i.e. it refers to the value keyed by
# the tuple (x,y).

# -------------------------------------------------
# Base.AbstractDict
# Type AbstractDict{K, V}
# Supertype for dictionary-like types with keys of type K and values of type V. Dict, IdDict and other types are
# subtypes of this. An AbstractDict{K, V} should be an iterator of Pair{K, V}.

# Base.Dict
# Type Dict([itr])
# Dict{K,V}() constructs a hash table with keys of type K and values of type V. Keys are compared with isequal and
# hashed with hash.
# Given a single iterable argument, constructs a Dict whose key-value pairs are taken from 2-tuples (key,value)
# generated by the argument.

Dict([("A", 1), ("B", 2)])
#Dict{String, Int64} with 2 entries:
#  "B" => 2
#  "A" => 1

# Alternatively, a sequence of pair arguments may be passed.
Dict("A"=>1, "B"=>2)
#Dict{String, Int64} with 2 entries:
#  "B" => 2
#  "A" => 1

# -------------------------------------------------
# Base.IdDict
# Type IdDict([itr])
# IdDict{K,V}() constructs a hash table using objectid as hash and === as equality with keys of type K and values of type V.
# See Dict for further help. In the example below, The Dict keys are all isequal and therefore get hashed the same, so
# they get overwritten. The IdDict hashes by object-id, and thus preserves the 3 different keys.

Dict(true => "yes", 1 => "no", 1.0 => "maybe")
# Dict{Real, String} with 1 entry:
#   1.0 => "maybe"

IdDict(true => "yes", 1 => "no", 1.0 => "maybe")
# IdDict{Any, String} with 3 entries:
#   true => "yes"
#   1.0  => "maybe"
#   1    => "no"

# -------------------------------------------------
# Base.WeakKeyDict
# Type WeakKeyDict([itr])
# WeakKeyDict() constructs a hash table where the keys are weak references to objects which may be garbage collected
# even when referenced in a hash table.
# See Dict for further help. Note, unlike Dict, WeakKeyDict does not convert keys on insertion, as this would imply the
# key object was unreferenced anywhere before insertion. See also WeakRef.

# -------------------------------------------------
# Base.ImmutableDict
# Type ImmutableDict
# ImmutableDict is a dictionary implemented as an immutable linked list, which is optimal for small dictionaries that
# are constructed over many individual insertions. Note that it is not possible to remove a value, although it can be
# partially overridden and hidden by inserting a new value with the same key.

# ImmutableDict(KV::Pair)
# Create a new entry in the ImmutableDict for a key => value pair

# use (key => value) in dict to see if this particular combination is in the properties set
# use get(dict, key, default) to retrieve the most recent value for a particular key

# -------------------------------------------------
# Base.haskey
# Function haskey(collection, key) -> Bool
# Determine whether a collection has a mapping for a given key.

D = Dict('a'=>2, 'b'=>3)
#Dict{Char, Int64} with 2 entries:
#  'a' => 2
#  'b' => 3

haskey(D, 'a')      # true
haskey(D, 'c')      # false

# -------------------------------------------------
# Base.get

# Function get(collection, key, default)
# Return the value stored for the given key, or the given default value if no mapping for the key is present.

d = Dict("a"=>1, "b"=>2);
get(d, "a", 3)      # 1
get(d, "c", 3)      # 2

# get(f::Union{Function, Type}, collection, key)
# Return the value stored for the given key, or if no mapping for the key is present, return f(). Use get! to also store
# the default value in the dictionary.

# This is intended to be called using do block syntax:
# get(dict, key) do
#     # default value calculated here
#     time()
# end

# -------------------------------------------------
# Base.get!
# Function get!(collection, key, default)
# Return the value stored for the given key, or if no mapping for the key is present, store key => default, and return default.

d = Dict("a"=>1, "b"=>2, "c"=>3);
get!(d, "a", 5)     # 1
get!(d, "d", 4)     # 4
d                   # Dict{String, Int64} with 4 entries: "c" => 3, "b" => 2, "a" => 1, "d" => 4

# get!(f::Union{Function, Type}, collection, key)
# Return the value stored for the given key, or if no mapping for the key is present, store key => f(), and return f().
# This is intended to be called using do block syntax:
squares = Dict{Int, Int}();
function get_square!(d, i)
           get!(d, i) do
               i^2
           end
       end
# get_square! (generic function with 1 method)

get_square!(squares, 2)     # 4
squares                     # Dict{Int64, Int64} with 1 entry: 2 => 4

# -------------------------------------------------
# Base.getkey
# Function getkey(collection, key, default)
# Return the key matching argument key if one exists in collection, otherwise return default.

D = Dict('a'=>2, 'b'=>3)    # Dict{Char, Int64} with 2 entries: 'a' => 2, 'b' => 3
getkey(D, 'a', 1)           # 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
getkey(D, 'd', 'a')         # 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

# -------------------------------------------------
# Base.delete!
# Function delete!(collection, key)
# Delete the mapping for the given key in a collection, if any, and return the collection.

d = Dict("a"=>1, "b"=>2)    # Dict{String, Int64} with 2 entries: "b" => 2, "a" => 1
delete!(d, "b")             # Dict{String, Int64} with 1 entry: "a" => 1
delete!(d, "b")             # d is left unchanged: Dict{String, Int64} with 1 entry: "a" => 1

# -------------------------------------------------
# Base.pop!
# Method pop!(collection, key[, default])
# Delete and return the mapping for key if it exists in collection, otherwise return default, or throw an error if
# default is not specified.

d = Dict("a"=>1, "b"=>2, "c"=>3)
pop!(d, "a")                # 1
# pop!(d, "d")              # ERROR: KeyError: key "d" not found
pop!(d, "e", 4)             # 4

# -------------------------------------------------
# Base.keys
# Function keys(iterator)
# For an iterator or collection that has keys and values (e.g. arrays and dictionaries), return an iterator over the keys.

# -------------------------------------------------
# Base.values
# Function values(iterator)
# For an iterator or collection that has keys and values, return an iterator over the values. This function simply
# returns its argument by default, since the elements of a general iterator are normally considered its "values".

d = Dict("a"=>1, "b"=>2);
values(d)                   # ValueIterator for a Dict{String, Int64} with 2 entries. Values: 2, 1
values([2])                 # 1-element Vector{Int64}: 2

# values(a::AbstractDict)
# Return an iterator over all values in a collection. collect(values(a)) returns an array of values. When the values are
# stored internally in a hash table, as is the case for Dict, the order in which they are returned may vary. But keys(a)
# and values(a) both iterate a and return the elements in the same order.

D = Dict('a'=>2, 'b'=>3)    # Dict{Char, Int64} with 2 entries: 'a' => 2, 'b' => 3
collect(values(D))          # 2-element Vector{Int64}: 2, 3

# -------------------------------------------------
# Base.pairs
# Function pairs(IndexLinear(), A)
# Function pairs(IndexCartesian(), A)
# Function pairs(IndexStyle(A), A)

# An iterator that accesses each element of the array A, returning i => x, where i is the index for the element and x = A[i].
# Identical to pairs(A), except that the style of index can be selected. Also similar to enumerate(A), except i
# will be a valid index for A, while enumerate always counts from 1 regardless of the indices of A.

# Specifying IndexLinear() ensures that i will be an integer; specifying IndexCartesian() ensures that i will be a
# Base.CartesianIndex; specifying IndexStyle(A) chooses whichever has been defined as the native indexing style for
# array A.

# Mutation of the bounds of the underlying array will invalidate this iterator.

A = ["a" "d"; "b" "e"; "c" "f"];
for (index, value) in pairs(IndexStyle(A), A)
           println("$index $value")
       end
# 1 a
# 2 b
# 3 c
# 4 d
# 5 e
# 6 f

S = view(A, 1:2, :);
for (index, value) in pairs(IndexStyle(S), S)
           println("$index $value")
       end
# CartesianIndex(1, 1) a
# CartesianIndex(2, 1) b
# CartesianIndex(1, 2) d
# CartesianIndex(2, 2) e

# pairs(collection)
# Return an iterator over key => value pairs for any collection that maps a set of keys to a set of values. This includes arrays, where the keys are the array indices.

a = Dict(zip(["a", "b", "c"], [1, 2, 3]))   # Dict{String, Int64} with 3 entries: "c" => 3, "b" => 2, "a" => 1
pairs(a)                                    # Dict{String, Int64} with 3 entries: "c" => 3, "b" => 2, "a" => 1
foreach(println, pairs(["a", "b", "c"]))    
# 1 => "a"
# 2 => "b"
# 3 => "c"

(;a=1, b=2, c=3) |> pairs |> collect        # 3-element Vector{Pair{Symbol, Int64}}: :a => 1, :b => 2, :c => 3
(;a=1, b=2, c=3) |> collect                 # 3-element Vector{Int64}: 1, 2, 3

# -------------------------------------------------
# Base.merge
# Function merge(d::AbstractDict, others::AbstractDict...)
# Construct a merged collection from the given collections. If necessary, the types of the resulting collection will be
# promoted to accommodate the types of the merged collections. If the same key is present in another collection, the
# value for that key will be the value it has in the last collection listed. See also mergewith for custom handling of
# values with the same key.

a = Dict("foo" => 0.0, "bar" => 42.0)       # Dict{String, Float64} with 2 entries: "bar" => 42.0, "foo" => 0.0
b = Dict("baz" => 17, "bar" => 4711)        # Dict{String, Int64} with 2 entries: "bar" => 4711, "baz" => 17
merge(a, b)                                 # Dict{String, Float64} with 3 entries: "bar" => 4711.0, "baz" => 17.0, "foo" => 0.0
merge(b, a)                                 # Dict{String, Float64} with 3 entries: "bar" => 42.0, "baz" => 17.0, "foo" => 0.0

# merge(a::NamedTuple, bs::NamedTuple...)
# Construct a new named tuple by merging two or more existing ones, in a left-associative manner. Merging proceeds
# left-to-right, between pairs of named tuples, and so the order of fields present in both the leftmost and rightmost
# named tuples take the same position as they are found in the leftmost named tuple. However, values are taken from
# matching fields in the rightmost named tuple that contains that field. Fields present in only the rightmost named
# tuple of a pair are appended at the end. A fallback is implemented for when only a single named tuple is supplied,
# with signature merge(a::NamedTuple).

merge((a=1, b=2, c=3), (b=4, d=5))          # (a = 1, b = 4, c = 3, d = 5)
merge((a=1, b=2), (b=3, c=(d=1,)), (c=(d=2,),))     # (a = 1, b = 3, c = (d = 2,))

# merge(a::NamedTuple, iterable)
# Interpret an iterable of key-value pairs as a named tuple, and perform a merge.
merge((a=1, b=2, c=3), [:b=>4, :d=>5])      # (a = 1, b = 4, c = 3, d = 5)

# -------------------------------------------------
# Base.mergewith
# Function mergewith(combine, d::AbstractDict, others::AbstractDict...)
# Function mergewith(combine)
# Function merge(combine, d::AbstractDict, others::AbstractDict...)

# Construct a merged collection from the given collections. If necessary, the types of the resulting collection will be
# promoted to accommodate the types of the merged collections. Values with the same key will be combined using the
# combiner function. The curried form mergewith(combine) returns the function (args...) -> mergewith(combine, args...).

# Method merge(combine::Union{Function,Type}, args...) as an alias of mergewith(combine, args...) is still available for
# backward compatibility.

a = Dict("foo" => 0.0, "bar" => 42.0)       # Dict{String, Float64} with 2 entries:"bar" => 42.0, "foo" => 0.0
b = Dict("baz" => 17, "bar" => 4711)        # Dict{String, Int64} with 2 entries: "bar" => 4711, "baz" => 17
mergewith(+, a, b)                          # Dict{String, Float64} with 3 entries: "bar" => 4753.0, "baz" => 17.0, "foo" => 0.0
ans == mergewith(+)(a, b)                   # true

# -------------------------------------------------
# Base.merge!
# Function merge!(d::AbstractDict, others::AbstractDict...)
# Update collection with pairs from the other collections. See also merge.

d1 = Dict(1 => 2, 3 => 4)
d2 = Dict(1 => 4, 4 => 5)
merge!(d1, d2)
d1                                          # Dict{Int64, Int64} with 3 entries: 4 => 5, 3 => 4, 1 => 4

# -------------------------------------------------
# Base.mergewith!
# Function mergewith!(combine, d::AbstractDict, others::AbstractDict...) -> d
# Function mergewith!(combine)
# Function merge!(combine, d::AbstractDict, others::AbstractDict...) -> d

# Update collection with pairs from the other collections. Values with the same key will be combined using the combiner
# function. The curried form mergewith!(combine) returns the function (args...) -> mergewith!(combine, args...).

# Method merge!(combine::Union{Function,Type}, args...) as an alias of mergewith!(combine, args...) is still available
# for backward compatibility.

d1 = Dict(1 => 2, 3 => 4)
d2 = Dict(1 => 4, 4 => 5)
mergewith!(+, d1, d2)
d1                                          # Dict{Int64, Int64} with 3 entries: 4 => 5, 3 => 4, 1 => 6
mergewith!(-, d1, d1)
d1                                          # Dict{Int64, Int64} with 3 entries: 4 => 0, 3 => 0, 1 => 0

# foldl: Like reduce, but with guaranteed left associativity
foldl(mergewith!(+), [d1, d2]; init=Dict{Int64, Int64}())   # Dict{Int64, Int64} with 3 entries: 4 => 5, 3 => 0, 1 => 4

# -------------------------------------------------
# Base.sizehint!
# Function sizehint!(s, n) -> s

# Suggest that collection s reserve capacity for at least n elements. That is, if you expect that you're going to have
# to push a lot of values onto s, you can avoid the cost of incremental reallocation by doing it once up front; this can
# improve performance.
# See also resize!.

# Notes on the performance model
# For types that support sizehint!, push! and append! methods generally may (but are not required to) preallocate extra
# storage. For types implemented in Base, they typically do, using a heuristic optimized for a general use case.
# sizehint! may control this preallocation. Again, it typically does this for types in Base.
# empty! is nearly costless (and O(1)) for types that support this kind of preallocation.

# -------------------------------------------------
# Base.keytype
# Function keytype(T::Type{<:AbstractArray})
# Function keytype(A::AbstractArray)

# Return the key type of an array. This is equal to the eltype of the result of keys(...), and is provided mainly for
# compatibility with the dictionary interface.
keytype([1, 2, 3]) == Int                   # true
keytype([1 2; 3 4])                         # CartesianIndex{2}

# keytype(type)
# Get the key type of a dictionary type. Behaves similarly to eltype.
keytype(Dict(Int32(1) => "foo"))            # Int32

# -------------------------------------------------
# Base.valtype
# Function valtype(T::Type{<:AbstractArray})
# Function valtype(A::AbstractArray)

# Return the value type of an array. This is identical to eltype and is provided mainly for compatibility with the
# dictionary interface.
valtype(["one", "two", "three"])            # String

# valtype(type)
# Get the value type of a dictionary type. Behaves similarly to eltype.
valtype(Dict(Int32(1) => "foo"))            # String



# Dictionary Fully implemented by:
# IdDict
# Dict
# WeakKeyDict

# Partially implemented by:
# BitSet
# Set
# EnvDict
# Array
# BitArray
# ImmutableDict
# Iterators.Pairs
