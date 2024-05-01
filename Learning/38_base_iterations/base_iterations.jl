# base_iterations.jl
# Julia Base doc, Iterations
# 
# 2024-05-01    PV


# Iteration utilities

Base.Iterators.Stateful
—
Type
Stateful(itr)

There are several different ways to think about this iterator wrapper:

It provides a mutable wrapper around an iterator and its iteration state.
It turns an iterator-like abstraction into a Channel-like abstraction.
It's an iterator that mutates to become its own rest iterator whenever an item is produced.
Stateful provides the regular iterator interface. Like other mutable iterators (e.g. Base.Channel), if iteration is stopped early (e.g. by a break in a for loop), iteration can be resumed from the same spot by continuing to iterate over the same iterator object (in contrast, an immutable iterator would restart from the beginning).

Examples

a = Iterators.Stateful("abcdef");

isempty(a)
false

popfirst!(a)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

collect(Iterators.take(a, 3))
3-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
 'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)

collect(a)
2-element Vector{Char}:
 'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)
 'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)

Iterators.reset!(a); popfirst!(a)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

Iterators.reset!(a, "hello"); popfirst!(a)
'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)

a = Iterators.Stateful([1,1,1,2,3,4]);

for x in a; x == 1 || break; end

peek(a)
3

sum(a) # Sum the remaining elements
7

source
Base.Iterators.zip
—
Function
zip(iters...)

Run multiple iterators at the same time, until any of them is exhausted. The value type of the zip iterator is a tuple of values of its subiterators.

Note
zip orders the calls to its subiterators in such a way that stateful iterators will not advance when another iterator finishes in the current iteration.

Note
zip() with no arguments yields an infinite iterator of empty tuples.

See also: enumerate, Base.splat.

Examples

a = 1:5
1:5

b = ["e","d","b","c","a"]
5-element Vector{String}:
 "e"
 "d"
 "b"
 "c"
 "a"

c = zip(a,b)
zip(1:5, ["e", "d", "b", "c", "a"])

length(c)
5

first(c)
(1, "e")

source
Base.Iterators.enumerate
—
Function
enumerate(iter)

An iterator that yields (i, x) where i is a counter starting at 1, and x is the ith value from the given iterator. It's useful when you need not only the values x over which you are iterating, but also the number of iterations so far.

Note that i may not be valid for indexing iter, or may index a different element. This will happen if iter has indices that do not start at 1, and may happen for strings, dictionaries, etc. See the pairs(IndexLinear(), iter) method if you want to ensure that i is an index.

Examples

a = ["a", "b", "c"];

for (index, value) in enumerate(a)
           println("$index $value")
       end
1 a
2 b
3 c

str = "naïve";

for (i, val) in enumerate(str)
           print("i = ", i, ", val = ", val, ", ")
           try @show(str[i]) catch e println(e) end
       end
i = 1, val = n, str[i] = 'n'
i = 2, val = a, str[i] = 'a'
i = 3, val = ï, str[i] = 'ï'
i = 4, val = v, StringIndexError("naïve", 4)
i = 5, val = e, str[i] = 'v'

source
Base.Iterators.rest
—
Function
rest(iter, state)

An iterator that yields the same elements as iter, but starting at the given state.

See also: Iterators.drop, Iterators.peel, Base.rest.

Examples

collect(Iterators.rest([1,2,3,4], 2))
3-element Vector{Int64}:
 2
 3
 4

source
Base.Iterators.countfrom
—
Function
countfrom(start=1, step=1)

An iterator that counts forever, starting at start and incrementing by step.

Examples

for v in Iterators.countfrom(5, 2)
           v > 10 && break
           println(v)
       end
5
7
9

source
Base.Iterators.take
—
Function
take(iter, n)

An iterator that generates at most the first n elements of iter.

See also: drop, peel, first, Base.take!.

Examples

a = 1:2:11
1:2:11

collect(a)
6-element Vector{Int64}:
  1
  3
  5
  7
  9
 11

collect(Iterators.take(a,3))
3-element Vector{Int64}:
 1
 3
 5

source
Base.Iterators.takewhile
—
Function
takewhile(pred, iter)

An iterator that generates element from iter as long as predicate pred is true, afterwards, drops every element.

Julia 1.4
This function requires at least Julia 1.4.

Examples

s = collect(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

collect(Iterators.takewhile(<(3),s))
2-element Vector{Int64}:
 1
 2

source
Base.Iterators.drop
—
Function
drop(iter, n)

An iterator that generates all but the first n elements of iter.

Examples

a = 1:2:11
1:2:11

collect(a)
6-element Vector{Int64}:
  1
  3
  5
  7
  9
 11

collect(Iterators.drop(a,4))
2-element Vector{Int64}:
  9
 11

source
Base.Iterators.dropwhile
—
Function
dropwhile(pred, iter)

An iterator that drops element from iter as long as predicate pred is true, afterwards, returns every element.

Julia 1.4
This function requires at least Julia 1.4.

Examples

s = collect(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

collect(Iterators.dropwhile(<(3),s))
3-element Vector{Int64}:
 3
 4
 5

source
Base.Iterators.cycle
—
Function
cycle(iter)

An iterator that cycles through iter forever. If iter is empty, so is cycle(iter).

See also: Iterators.repeated, Base.repeat.

Examples

for (i, v) in enumerate(Iterators.cycle("hello"))
           print(v)
           i > 10 && break
       end
hellohelloh

source
Base.Iterators.repeated
—
Function
repeated(x[, n::Int])

An iterator that generates the value x forever. If n is specified, generates x that many times (equivalent to take(repeated(x), n)).

See also: Iterators.cycle, Base.repeat.

Examples

a = Iterators.repeated([1 2], 4);

collect(a)
4-element Vector{Matrix{Int64}}:
 [1 2]
 [1 2]
 [1 2]
 [1 2]

source
Base.Iterators.product
—
Function
product(iters...)

Return an iterator over the product of several iterators. Each generated element is a tuple whose ith element comes from the ith argument iterator. The first iterator changes the fastest.

See also: zip, Iterators.flatten.

Examples

collect(Iterators.product(1:2, 3:5))
2×3 Matrix{Tuple{Int64, Int64}}:
 (1, 3)  (1, 4)  (1, 5)
 (2, 3)  (2, 4)  (2, 5)

ans == [(x,y) for x in 1:2, y in 3:5]  # collects a generator involving Iterators.product
true

source
Base.Iterators.flatten
—
Function
flatten(iter)

Given an iterator that yields iterators, return an iterator that yields the elements of those iterators. Put differently, the elements of the argument iterator are concatenated.

Examples

collect(Iterators.flatten((1:2, 8:9)))
4-element Vector{Int64}:
 1
 2
 8
 9

[(x,y) for x in 0:1 for y in 'a':'c']  # collects generators involving Iterators.flatten
6-element Vector{Tuple{Int64, Char}}:
 (0, 'a')
 (0, 'b')
 (0, 'c')
 (1, 'a')
 (1, 'b')
 (1, 'c')

source
Base.Iterators.flatmap
—
Function
Iterators.flatmap(f, iterators...)

Equivalent to flatten(map(f, iterators...)).

See also Iterators.flatten, Iterators.map.

Julia 1.9
This function was added in Julia 1.9.

Examples

Iterators.flatmap(n -> -n:2:n, 1:3) |> collect
9-element Vector{Int64}:
 -1
  1
 -2
  0
  2
 -3
 -1
  1
  3

stack(n -> -n:2:n, 1:3)
ERROR: DimensionMismatch: stack expects uniform slices, got axes(x) == (1:3,) while first had (1:2,)
[...]

Iterators.flatmap(n -> (-n, 10n), 1:2) |> collect
4-element Vector{Int64}:
 -1
 10
 -2
 20

ans == vec(stack(n -> (-n, 10n), 1:2))
true

source
Base.Iterators.partition
—
Function
partition(collection, n)

Iterate over a collection n elements at a time.

Examples

collect(Iterators.partition([1,2,3,4,5], 2))
3-element Vector{SubArray{Int64, 1, Vector{Int64}, Tuple{UnitRange{Int64}}, true}}:
 [1, 2]
 [3, 4]
 [5]

source
Base.Iterators.map
—
Function
Iterators.map(f, iterators...)

Create a lazy mapping. This is another syntax for writing (f(args...) for args in zip(iterators...)).

Julia 1.6
This function requires at least Julia 1.6.

Examples

collect(Iterators.map(x -> x^2, 1:3))
3-element Vector{Int64}:
 1
 4
 9

source
Base.Iterators.filter
—
Function
Iterators.filter(flt, itr)

Given a predicate function flt and an iterable object itr, return an iterable object which upon iteration yields the elements x of itr that satisfy flt(x). The order of the original iterator is preserved.

This function is lazy; that is, it is guaranteed to return in 
Θ
(
1
)
Θ(1) time and use 
Θ
(
1
)
Θ(1) additional space, and flt will not be called by an invocation of filter. Calls to flt will be made when iterating over the returned iterable object. These calls are not cached and repeated calls will be made when reiterating.

See Base.filter for an eager implementation of filtering for arrays.

Examples

f = Iterators.filter(isodd, [1, 2, 3, 4, 5])
Base.Iterators.Filter{typeof(isodd), Vector{Int64}}(isodd, [1, 2, 3, 4, 5])

foreach(println, f)
1
3
5

[x for x in [1, 2, 3, 4, 5] if isodd(x)]  # collects a generator over Iterators.filter
3-element Vector{Int64}:
 1
 3
 5

source
Base.Iterators.accumulate
—
Function
Iterators.accumulate(f, itr; [init])

Given a 2-argument function f and an iterator itr, return a new iterator that successively applies f to the previous value and the next element of itr.

This is effectively a lazy version of Base.accumulate.

Julia 1.5
Keyword argument init is added in Julia 1.5.

Examples

a = Iterators.accumulate(+, [1,2,3,4]);

foreach(println, a)
1
3
6
10

b = Iterators.accumulate(/, (2, 5, 2, 5); init = 100);

collect(b)
4-element Vector{Float64}:
 50.0
 10.0
  5.0
  1.0

source
Base.Iterators.reverse
—
Function
Iterators.reverse(itr)

Given an iterator itr, then reverse(itr) is an iterator over the same collection but in the reverse order. This iterator is "lazy" in that it does not make a copy of the collection in order to reverse it; see Base.reverse for an eager implementation.

(By default, this returns an Iterators.Reverse object wrapping itr, which is iterable if the corresponding iterate methods are defined, but some itr types may implement more specialized Iterators.reverse behaviors.)

Not all iterator types T support reverse-order iteration. If T doesn't, then iterating over Iterators.reverse(itr::T) will throw a MethodError because of the missing iterate methods for Iterators.Reverse{T}. (To implement these methods, the original iterator itr::T can be obtained from an r::Iterators.Reverse{T} object by r.itr; more generally, one can use Iterators.reverse(r).)

Examples

foreach(println, Iterators.reverse(1:5))
5
4
3
2
1

source
Base.Iterators.only
—
Function
only(x)

Return the one and only element of collection x, or throw an ArgumentError if the collection has zero or multiple elements.

See also first, last.

Julia 1.4
This method requires at least Julia 1.4.

Examples

only(["a"])
"a"

only("a")
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

only(())
ERROR: ArgumentError: Tuple contains 0 elements, must contain exactly 1 element
Stacktrace:
[...]

only(('a', 'b'))
ERROR: ArgumentError: Tuple contains 2 elements, must contain exactly 1 element
Stacktrace:
[...]

source
Base.Iterators.peel
—
Function
peel(iter)

Returns the first element and an iterator over the remaining elements.

If the iterator is empty return nothing (like iterate).

Julia 1.7
Prior versions throw a BoundsError if the iterator is empty.

See also: Iterators.drop, Iterators.take.

Examples

(a, rest) = Iterators.peel("abc");

a
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

collect(rest)
2-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
