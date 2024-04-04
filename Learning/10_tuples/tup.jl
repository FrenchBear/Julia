# tup.jl
# Play with julia tuples (Julia manual §8)
# 
# 2024-03-20    PV      First version

# A tuple is immutable
t1 = (8, 46)
t2 = (3 + 2,)       # length 1 tuple
t3 = (0.0, "Hello", true)
t4 = ()             # empty tuple
println(t3[2])        # Usual indexing
println()

# Named tuples
x = (a=2, b=1 + 2)
println(x)
println(x.a)

# A tuple is iterable
for i in t3
    print(i, ' ')
end
println()

# A tuple is destructurable
f, s, b = t3
println(f, ' ', s, ' ', b)

t = (1, (2, 3))
a, (b, c) = t
println("t=$t")
println("a=$a, b=$b, c=$c")
println()

# if the last symbol is followed by ... (slurping) then it'll get a collection or a lazy iterator of remaining elements on the right side
a, b... = (1, 2, 3, 4)
println("a=$a, b=$b")
#b[1] = -2          # MethodError, no setindex! on Tuple
a, b... = "Hello"
println("a=$a, b=$b")
println()

# ... can also be used in any other position (since Julia 1.9)
a, b..., c = 1:5
println("a=$a, b=$b, c=$c")
println(typeof(b))  # Note that b is a Vector, while in the example of last position, it's a Tuple...
b[1] = -2           # So it's mutable
println("b=$b")
front..., tail = "Hi!"
println("front=$front, tail=$tail")
println()


# swapping variables
x = 2;
y = 3;
println("x=$x, y=$y")
x, y = y, x
println("x=$x, y=$y")
println()

# Property destructuring
(; b, a) = (a=1, b=2, c=3)      # use getproperty for destructuring instead of using iterator
println("a=$a, b=$b")           # a=1, b=2
(_, b, a) = (a=1, b=2, c=3)     # "Usual" destructuring using an interator
println("a=$a, b=$b")           # a=3, b=2
println()

