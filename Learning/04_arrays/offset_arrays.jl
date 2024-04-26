# offset_arrays.jl
# Test custom array indices in Julia to build arrays with indices starting at 0
# https://julialang.org/blog/2017/04/offset-arrays/
# 
# 2024-03-19    PV      First version

using OffsetArrays

t1 = ["once", "upon", "a", "time"]

# 0 based array
t0 = OffsetArray(t1, 0:3)
for i in 0:3
    print(t0[i],' ')
end
println()

# Array with indices from -3 to 0!
tm = OffsetArray(t1, -3:0)
for i in -3:0
    print(tm[i],' ')
end
println()
# eachindex returns an iterable range for vectors (use axes for matrices, since eachindex returns a global one-variable-fits-all-dimenstions index)
for i in eachindex(tm)
    print(tm[i],' ')
end
println()


m1 = [1 2; 3 4]
# Matrix rebased with indices starting at 0, just specifying new origin
m0 = OffsetArray(m1, OffsetArrays.Origin(0, 0))
for r in 0:1
    for c in 0:1
        print(m0[r,c],' ')
    end
    println()
end
println()

t44 = [1 2 3 4;5 6 7 8;9 10 11 12;13 14 15 16]
# In this case, we just specify an offset to add to indices (-1) to rebase them to 0, not a range
t28 = OffsetArray(reshape(t44, 2, 8), -1, -1)
# now t28 is a matrix [0..1, 0..7]
println(typeof(t28))
println(t28[0,0],' ',t28[1,7])
# axes returns an iterator for eaxh dimension
for r in axes(t28, 1)               # or firstindex(t28,1):lastindex(t28,1)
    for c in axes(t28, 2)           # or firstindex(t28,2):lastindex(t28,2)
        print(t28[r,c],' ')
    end
    println()
end
println()
