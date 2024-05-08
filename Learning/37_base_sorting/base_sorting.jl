# base_sorting.jl
# Julia Base doc, Sorting
# 
# 2024-05-01    PV


# Sorting and Related Functions

# Julia has an extensive, flexible API for sorting and interacting with already-sorted arrays of values. By default,
# Julia picks reasonable algorithms and sorts in ascending order:

sort([2,3,1])
3-element Vector{Int64}:
 1
 2
 3

You can sort in reverse order as well:

sort([2,3,1], rev=true)
3-element Vector{Int64}:
 3
 2
 1

sort constructs a sorted copy leaving its input unchanged. Use the "bang" version of the sort function to mutate an existing array:

a = [2,3,1];

sort!(a);

a
3-element Vector{Int64}:
 1
 2
 3

Instead of directly sorting an array, you can compute a permutation of the array's indices that puts the array into sorted order:

v = randn(5)
5-element Array{Float64,1}:
  0.297288
  0.382396
 -0.597634
 -0.0104452
 -0.839027

p = sortperm(v)
5-element Array{Int64,1}:
 5
 3
 4
 1
 2

v[p]
5-element Array{Float64,1}:
 -0.839027
 -0.597634
 -0.0104452
  0.297288
  0.382396

Arrays can be sorted according to an arbitrary transformation of their values:

sort(v, by=abs)
5-element Array{Float64,1}:
 -0.0104452
  0.297288
  0.382396
 -0.597634
 -0.839027

Or in reverse order by a transformation:

sort(v, by=abs, rev=true)
5-element Array{Float64,1}:
 -0.839027
 -0.597634
  0.382396
  0.297288
 -0.0104452

If needed, the sorting algorithm can be chosen:

sort(v, alg=InsertionSort)
5-element Array{Float64,1}:
 -0.839027
 -0.597634
 -0.0104452
  0.297288
  0.382396

All the sorting and order related functions rely on a "less than" relation defining a strict weak order on the values to be manipulated. The isless function is invoked by default, but the relation can be specified via the lt keyword, a function that takes two array elements and returns true if and only if the first argument is "less than" the second. See sort! and Alternate Orderings for more information.

Sorting Functions
Base.sort!
Function sort!(v; alg::Algorithm=defalg(v), lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

Sort the vector v in place. A stable algorithm is used by default: the ordering of elements that compare equal is preserved. A specific algorithm can be selected via the alg keyword (see Sorting Algorithms for available algorithms).

Elements are first transformed with the function by and then compared according to either the function lt or the ordering order. Finally, the resulting order is reversed if rev=true (this preserves forward stability: elements that compare equal are not reversed). The current implemention applies the by transformation before each comparison rather than once per element.

Passing an lt other than isless along with an order other than Base.Order.Forward or Base.Order.Reverse is not permitted, otherwise all options are independent and can be used together in all possible combinations. Note that order can also include a "by" transformation, in which case it is applied after that defined with the by keyword. For more information on order values see the documentation on Alternate Orderings.

Relations between two elements are defined as follows (with "less" and "greater" exchanged when rev=true):

x is less than y if lt(by(x), by(y)) (or Base.Order.lt(order, by(x), by(y))) yields true.
x is greater than y if y is less than x.
x and y are equivalent if neither is less than the other ("incomparable" is sometimes used as a synonym for "equivalent").
The result of sort! is sorted in the sense that every element is greater than or equivalent to the previous one.

The lt function must define a strict weak order, that is, it must be

irreflexive: lt(x, x) always yields false,
asymmetric: if lt(x, y) yields true then lt(y, x) yields false,
transitive: lt(x, y) && lt(y, z) implies lt(x, z),
transitive in equivalence: !lt(x, y) && !lt(y, x) and !lt(y, z) && !lt(z, y) together imply !lt(x, z) && !lt(z, x). In words: if x and y are equivalent and y and z are equivalent then x and z must be equivalent.
For example < is a valid lt function for Int values but ≤ is not: it violates irreflexivity. For Float64 values even < is invalid as it violates the fourth condition: 1.0 and NaN are equivalent and so are NaN and 2.0 but 1.0 and 2.0 are not equivalent.

See also sort, sortperm, sortslices, partialsort!, partialsortperm, issorted, searchsorted, insorted, Base.Order.ord.


v = [3, 1, 2]; sort!(v); v
3-element Vector{Int64}:
 1
 2
 3

v = [3, 1, 2]; sort!(v, rev = true); v
3-element Vector{Int64}:
 3
 2
 1

v = [(1, "c"), (3, "a"), (2, "b")]; sort!(v, by = x -> x[1]); v
3-element Vector{Tuple{Int64, String}}:
 (1, "c")
 (2, "b")
 (3, "a")

v = [(1, "c"), (3, "a"), (2, "b")]; sort!(v, by = x -> x[2]); v
3-element Vector{Tuple{Int64, String}}:
 (3, "a")
 (2, "b")
 (1, "c")

sort(0:3, by=x->x-2, order=Base.Order.By(abs)) # same as sort(0:3, by=abs(x->x-2))
4-element Vector{Int64}:
 2
 1
 3
 0

sort([2, NaN, 1, NaN, 3]) # correct sort with default lt=isless
5-element Vector{Float64}:
   1.0
   2.0
   3.0
 NaN
 NaN

sort([2, NaN, 1, NaN, 3], lt=<) # wrong sort due to invalid lt. This behavior is undefined.
5-element Vector{Float64}:
   2.0
 NaN
   1.0
 NaN
   3.0

# -------------------------
sort!(A; dims::Integer, alg::Algorithm=defalg(A), lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

Sort the multidimensional array A along dimension dims. See the one-dimensional version of sort! for a description of possible keyword arguments.

To sort slices of an array, refer to sortslices.

Julia 1.1
This function requires at least Julia 1.1.


A = [4 3; 1 2]
2×2 Matrix{Int64}:
 4  3
 1  2

sort!(A, dims = 1); A
2×2 Matrix{Int64}:
 1  2
 4  3

sort!(A, dims = 2); A
2×2 Matrix{Int64}:
 1  2
 3  4

# -------------------------
Base.sort
Function sort(v; alg::Algorithm=defalg(v), lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

Variant of sort! that returns a sorted copy of v leaving v itself unmodified.


v = [3, 1, 2];

sort(v)
3-element Vector{Int64}:
 1
 2
 3

v
3-element Vector{Int64}:
 3
 1
 2

# -------------------------
sort(A; dims::Integer, alg::Algorithm=defalg(A), lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

Sort a multidimensional array A along the given dimension. See sort! for a description of possible keyword arguments.

To sort slices of an array, refer to sortslices.


A = [4 3; 1 2]
2×2 Matrix{Int64}:
 4  3
 1  2

sort(A, dims = 1)
2×2 Matrix{Int64}:
 1  2
 4  3

sort(A, dims = 2)
2×2 Matrix{Int64}:
 3  4
 1  2

# -------------------------
Base.sortperm
Function sortperm(A; alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward, [dims::Integer])

Return a permutation vector or array I that puts A[I] in sorted order along the given dimension. If A has more than one dimension, then the dims keyword argument must be specified. The order is specified using the same keywords as sort!. The permutation is guaranteed to be stable even if the sorting algorithm is unstable: the indices of equal elements will appear in ascending order.

See also sortperm!, partialsortperm, invperm, indexin. To sort slices of an array, refer to sortslices.

Julia 1.9
The method accepting dims requires at least Julia 1.9.


v = [3, 1, 2];

p = sortperm(v)
3-element Vector{Int64}:
 2
 3
 1

v[p]
3-element Vector{Int64}:
 1
 2
 3

A = [8 7; 5 6]
2×2 Matrix{Int64}:
 8  7
 5  6

sortperm(A, dims = 1)
2×2 Matrix{Int64}:
 2  4
 1  3

sortperm(A, dims = 2)
2×2 Matrix{Int64}:
 3  1
 2  4

# -------------------------
Base.Sort.InsertionSort
Constant
InsertionSort

Use the insertion sort algorithm.

Insertion sort traverses the collection one element at a time, inserting each element into its correct, sorted position in the output vector.

Characteristics:

stable: preserves the ordering of elements that compare equal
(e.g. "a" and "A" in a sort of letters that ignores case).

in-place in memory.
quadratic performance in the number of elements to be sorted:
it is well-suited to small collections but should not be used for large ones.

# -------------------------
Base.Sort.MergeSort
Constant
MergeSort

Indicate that a sorting function should use the merge sort algorithm. Merge sort divides the collection into subcollections and repeatedly merges them, sorting each subcollection at each step, until the entire collection has been recombined in sorted form.

Characteristics:

stable: preserves the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
not in-place in memory.
divide-and-conquer sort strategy.
good performance for large collections but typically not quite as fast as QuickSort.
# -------------------------
Base.Sort.QuickSort
Constant
QuickSort

Indicate that a sorting function should use the quick sort algorithm, which is not stable.

Characteristics:

not stable: does not preserve the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
in-place in memory.
divide-and-conquer: sort strategy similar to MergeSort.
good performance for large collections.
# -------------------------
Base.Sort.PartialQuickSort
Type PartialQuickSort{T <: Union{Integer,OrdinalRange}}

Indicate that a sorting function should use the partial quick sort algorithm. PartialQuickSort(k) is like QuickSort, but is only required to find and sort the elements that would end up in v[k] were v fully sorted.

Characteristics:

not stable: does not preserve the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
in-place in memory.
divide-and-conquer: sort strategy similar to MergeSort.
Note that PartialQuickSort(k) does not necessarily sort the whole array. For example,

x = rand(100);

k = 50:100;

s1 = sort(x; alg=QuickSort);

s2 = sort(x; alg=PartialQuickSort(k));

map(issorted, (s1, s2))
(true, false)

map(x->issorted(x[k]), (s1, s2))
(true, true)

s1[k] == s2[k]
true

# -------------------------
Base.Sort.sortperm!
Function sortperm!(ix, A; alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward, [dims::Integer])

Like sortperm, but accepts a preallocated index vector or array ix with the same axes as A. ix is initialized to contain the values LinearIndices(A).

Warning
Behavior can be unexpected when any mutated argument shares memory with any other argument.

Julia 1.9
The method accepting dims requires at least Julia 1.9.


v = [3, 1, 2]; p = zeros(Int, 3);

sortperm!(p, v); p
3-element Vector{Int64}:
 2
 3
 1

v[p]
3-element Vector{Int64}:
 1
 2
 3

A = [8 7; 5 6]; p = zeros(Int,2, 2);

sortperm!(p, A; dims=1); p
2×2 Matrix{Int64}:
 2  4
 1  3

sortperm!(p, A; dims=2); p
2×2 Matrix{Int64}:
 3  1
 2  4

# -------------------------
Base.sortslices
Function sortslices(A; dims, alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

Sort slices of an array A. The required keyword argument dims must be either an integer or a tuple of integers. It specifies the dimension(s) over which the slices are sorted.

E.g., if A is a matrix, dims=1 will sort rows, dims=2 will sort columns. Note that the default comparison function on one dimensional slices sorts lexicographically.

For the remaining keyword arguments, see the documentation of sort!.


sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1) # Sort rows
3×3 Matrix{Int64}:
 -1   6  4
  7   3  5
  9  -2  8

sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1, lt=(x,y)->isless(x[2],y[2]))
3×3 Matrix{Int64}:
  9  -2  8
  7   3  5
 -1   6  4

sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1, rev=true)
3×3 Matrix{Int64}:
  9  -2  8
  7   3  5
 -1   6  4

sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2) # Sort columns
3×3 Matrix{Int64}:
  3   5  7
 -1  -4  6
 -2   8  9

sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2, alg=InsertionSort, lt=(x,y)->isless(x[2],y[2]))
3×3 Matrix{Int64}:
  5   3  7
 -4  -1  6
  8  -2  9

sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2, rev=true)
3×3 Matrix{Int64}:
 7   5   3
 6  -4  -1
 9   8  -2

Higher dimensions

sortslices extends naturally to higher dimensions. E.g., if A is a a 2x2x2 array, sortslices(A, dims=3) will sort slices within the 3rd dimension, passing the 2x2 slices A[:, :, 1] and A[:, :, 2] to the comparison function. Note that while there is no default order on higher-dimensional slices, you may use the by or lt keyword argument to specify such an order.

If dims is a tuple, the order of the dimensions in dims is relevant and specifies the linear order of the slices. E.g., if A is three dimensional and dims is (1, 2), the orderings of the first two dimensions are re-arranged such that the slices (of the remaining third dimension) are sorted. If dims is (2, 1) instead, the same slices will be taken, but the result order will be row-major instead.

Higher dimensional examples

A = permutedims(reshape([4 3; 2 1; 'A' 'B'; 'C' 'D'], (2, 2, 2)), (1, 3, 2))
2×2×2 Array{Any, 3}:
[:, :, 1] =
 4  3
 2  1

[:, :, 2] =
 'A'  'B'
 'C'  'D'

sortslices(A, dims=(1,2))
2×2×2 Array{Any, 3}:
[:, :, 1] =
 1  3
 2  4

[:, :, 2] =
 'D'  'B'
 'C'  'A'

sortslices(A, dims=(2,1))
2×2×2 Array{Any, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 'D'  'C'
 'B'  'A'

sortslices(reshape([5; 4; 3; 2; 1], (1,1,5)), dims=3, by=x->x[1,1])
1×1×5 Array{Int64, 3}:
[:, :, 1] =
 1

[:, :, 2] =
 2

[:, :, 3] =
 3

[:, :, 4] =
 4

[:, :, 5] =
 5

# -------------------------
Order-Related Functions
Base.issorted
Function issorted(v, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

Test whether a collection is in sorted order. The keywords modify what order is considered sorted, as described in the sort! documentation.


issorted([1, 2, 3])
true

issorted([(1, "b"), (2, "a")], by = x -> x[1])
true

issorted([(1, "b"), (2, "a")], by = x -> x[2])
false

issorted([(1, "b"), (2, "a")], by = x -> x[2], rev=true)
true

issorted([1, 2, -2, 3], by=abs)
true

# -------------------------
Base.Sort.searchsorted
Function searchsorted(v, x; by=identity, lt=isless, rev=false)

Return the range of indices in v where values are equivalent to x, or an empty range located at the insertion point if v does not contain values equivalent to x. The vector v must be sorted according to the order defined by the keywords. Refer to sort! for the meaning of the keywords and the definition of equivalence. Note that the by function is applied to the searched value x as well as the values in v.

The range is generally found using binary search, but there are optimized implementations for some inputs.

See also: searchsortedfirst, sort!, insorted, findall.


searchsorted([1, 2, 4, 5, 5, 7], 4) # single match
3:3

searchsorted([1, 2, 4, 5, 5, 7], 5) # multiple matches
4:5

searchsorted([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
3:2

searchsorted([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
7:6

searchsorted([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
1:0

searchsorted([1=>"one", 2=>"two", 2=>"two", 4=>"four"], 2=>"two", by=first) # compare the keys of the pairs
2:3

# -------------------------
Base.Sort.searchsortedfirst
Function searchsortedfirst(v, x; by=identity, lt=isless, rev=false)

Return the index of the first value in v greater than or equivalent to x. If x is greater than all values in v, return lastindex(v) + 1.

The vector v must be sorted according to the order defined by the keywords. insert!ing x at the returned index will maintain the sorted order. Refer to sort! for the meaning of the keywords and the definition of "greater than" and equivalence. Note that the by function is applied to the searched value x as well as the values in v.

The index is generally found using binary search, but there are optimized implementations for some inputs.

See also: searchsortedlast, searchsorted, findfirst.


searchsortedfirst([1, 2, 4, 5, 5, 7], 4) # single match
3

searchsortedfirst([1, 2, 4, 5, 5, 7], 5) # multiple matches
4

searchsortedfirst([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
3

searchsortedfirst([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
7

searchsortedfirst([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
1

searchsortedfirst([1=>"one", 2=>"two", 4=>"four"], 3=>"three", by=first) # compare the keys of the pairs
3

# -------------------------
Base.Sort.searchsortedlast
Function searchsortedlast(v, x; by=identity, lt=isless, rev=false)

Return the index of the last value in v less than or equivalent to x. If x is less than all values in v the function returns firstindex(v) - 1.

The vector v must be sorted according to the order defined by the keywords. Refer to sort! for the meaning of the keywords and the definition of "less than" and equivalence. Note that the by function is applied to the searched value x as well as the values in v.

The index is generally found using binary search, but there are optimized implementations for some inputs


searchsortedlast([1, 2, 4, 5, 5, 7], 4) # single match
3

searchsortedlast([1, 2, 4, 5, 5, 7], 5) # multiple matches
5

searchsortedlast([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
2

searchsortedlast([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
6

searchsortedlast([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
0

searchsortedlast([1=>"one", 2=>"two", 4=>"four"], 3=>"three", by=first) # compare the keys of the pairs
2

# -------------------------
Base.Sort.insorted
Function insorted(x, v; by=identity, lt=isless, rev=false) -> Bool

Determine whether a vector v contains any value equivalent to x. The vector v must be sorted according to the order defined by the keywords. Refer to sort! for the meaning of the keywords and the definition of equivalence. Note that the by function is applied to the searched value x as well as the values in v.

The check is generally done using binary search, but there are optimized implementations for some inputs.

See also in.


insorted(4, [1, 2, 4, 5, 5, 7]) # single match
true

insorted(5, [1, 2, 4, 5, 5, 7]) # multiple matches
true

insorted(3, [1, 2, 4, 5, 5, 7]) # no match
false

insorted(9, [1, 2, 4, 5, 5, 7]) # no match
false

insorted(0, [1, 2, 4, 5, 5, 7]) # no match
false

insorted(2=>"TWO", [1=>"one", 2=>"two", 4=>"four"], by=first) # compare the keys of the pairs
true

Julia 1.6
insorted was added in Julia 1.6.

# -------------------------
Base.Sort.partialsort!
Function partialsort!(v, k; by=identity, lt=isless, rev=false)

Partially sort the vector v in place so that the value at index k (or range of adjacent values if k is a range) occurs at the position where it would appear if the array were fully sorted. If k is a single index, that value is returned; if k is a range, an array of values at those indices is returned. Note that partialsort! may not fully sort the input array.

For the keyword arguments, see the documentation of sort!.


a = [1, 2, 4, 3, 4]
5-element Vector{Int64}:
 1
 2
 4
 3
 4

partialsort!(a, 4)
4

a
5-element Vector{Int64}:
 1
 2
 3
 4
 4

a = [1, 2, 4, 3, 4]
5-element Vector{Int64}:
 1
 2
 4
 3
 4

partialsort!(a, 4, rev=true)
2

a
5-element Vector{Int64}:
 4
 4
 3
 2
 1

# -------------------------
Base.Sort.partialsort
Function partialsort(v, k, by=identity, lt=isless, rev=false)

Variant of partialsort! that copies v before partially sorting it, thereby returning the same thing as partialsort! but leaving v unmodified.

# -------------------------
Base.Sort.partialsortperm
Function partialsortperm(v, k; by=ientity, lt=isless, rev=false)

Return a partial permutation I of the vector v, so that v[I] returns values of a fully sorted version of v at index k. If k is a range, a vector of indices is returned; if k is an integer, a single index is returned. The order is specified using the same keywords as sort!. The permutation is stable: the indices of equal elements will appear in ascending order.

This function is equivalent to, but more efficient than, calling sortperm(...)[k].


v = [3, 1, 2, 1];

v[partialsortperm(v, 1)]
1

p = partialsortperm(v, 1:3)
3-element view(::Vector{Int64}, 1:3) with eltype Int64:
 2
 4
 3

v[p]
3-element Vector{Int64}:
 1
 1
 2

# -------------------------
Base.Sort.partialsortperm!
Function partialsortperm!(ix, v, k; by=identity, lt=isless, rev=false)

Like partialsortperm, but accepts a preallocated index vector ix the same size as v, which is used to store (a permutation of) the indices of v.

ix is initialized to contain the indices of v.

(Typically, the indices of v will be 1:length(v), although if v has an alternative array type with non-one-based indices, such as an OffsetArray, ix must share those same indices)

Upon return, ix is guaranteed to have the indices k in their sorted positions, such that

partialsortperm!(ix, v, k);
v[ix[k]] == partialsort(v, k)

The return value is the kth element of ix if k is an integer, or view into ix if k is a range.

Warning
Behavior can be unexpected when any mutated argument shares memory with any other argument.


v = [3, 1, 2, 1];

ix = Vector{Int}(undef, 4);

partialsortperm!(ix, v, 1)
2

ix = [1:4;];

partialsortperm!(ix, v, 2:3)
2-element view(::Vector{Int64}, 2:3) with eltype Int64:
 4
 3


# -------------------------
Sorting Algorithms
There are currently four sorting algorithms publicly available in base Julia:

InsertionSort
QuickSort
PartialQuickSort(k)
MergeSort
By default, the sort family of functions uses stable sorting algorithms that are fast on most inputs. The exact algorithm choice is an implementation detail to allow for future performance improvements. Currently, a hybrid of RadixSort, ScratchQuickSort, InsertionSort, and CountingSort is used based on input type, size, and composition. Implementation details are subject to change but currently available in the extended help of ??Base.DEFAULT_STABLE and the docstrings of internal sorting algorithms listed there.

You can explicitly specify your preferred algorithm with the alg keyword (e.g. sort!(v, alg=PartialQuickSort(10:20))) or reconfigure the default sorting algorithm for custom types by adding a specialized method to the Base.Sort.defalg function. For example, InlineStrings.jl defines the following method:

Base.Sort.defalg(::AbstractArray{<:Union{SmallInlineStrings, Missing}}) = InlineStringSort

Julia 1.9
The default sorting algorithm (returned by Base.Sort.defalg) is guaranteed to be stable since Julia 1.9. Previous versions had unstable edge cases when sorting numeric arrays.

Alternate Orderings
By default, sort, searchsorted, and related functions use isless to compare two elements in order to determine which should come first. The Base.Order.Ordering abstract type provides a mechanism for defining alternate orderings on the same set of elements: when calling a sorting function like sort!, an instance of Ordering can be provided with the keyword argument order.

Instances of Ordering define an order through the Base.Order.lt function, which works as a generalization of isless. This function's behavior on custom Orderings must satisfy all the conditions of a strict weak order. See sort! for details and examples of valid and invalid lt functions.

Base.Order.Ordering
Type Base.Order.Ordering

Abstract type which represents a total order on some set of elements.

Use Base.Order.lt to compare two elements according to the ordering.

# -------------------------
Base.Order.lt
Function lt(o::Ordering, a, b)

Test whether a is less than b according to the ordering o.

# -------------------------
Base.Order.ord
Function ord(lt, by, rev::Union{Bool, Nothing}, order::Ordering=Forward)

Construct an Ordering object from the same arguments used by sort!. Elements are first transformed by the function by (which may be identity) and are then compared according to either the function lt or an existing ordering order. lt should be isless or a function that obeys the same rules as the lt parameter of sort!. Finally, the resulting order is reversed if rev=true.

Passing an lt other than isless along with an order other than Base.Order.Forward or Base.Order.Reverse is not permitted, otherwise all options are independent and can be used together in all possible combinations.

# -------------------------
Base.Order.Forward
Constant
Base.Order.Forward

Default ordering according to isless.

# -------------------------
Base.Order.ReverseOrdering
Type ReverseOrdering(fwd::Ordering=Forward)

A wrapper which reverses an ordering.

For a given Ordering o, the following holds for all a, b:

lt(ReverseOrdering(o), a, b) == lt(o, b, a)

# -------------------------
Base.Order.Reverse
Constant
Base.Order.Reverse

Reverse ordering according to isless.

# -------------------------
Base.Order.By
Type By(by, order::Ordering=Forward)

Ordering which applies order to elements after they have been transformed by the function by.

# -------------------------
Base.Order.Lt
Type Lt(lt)

Ordering that calls lt(a, b) to compare elements. lt must obey the same rules as the lt parameter of sort!.

# -------------------------
Base.Order.Perm
Type Perm(order::Ordering, data::AbstractVector)

Ordering on the indices of data where i is less than j if data[i] is less than data[j] according to order. In the case that data[i] and data[j] are equal, i and j are compared by numeric value.
