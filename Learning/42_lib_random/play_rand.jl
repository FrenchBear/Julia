# play_rand.jl
# Tests with Julia random functions
#
# 2024-05-12    PV

using Random

# Test that randcycle generates a cycle
c = randcycle(100)
s = Set{Int}()
i = 1
for _ in 1:100
    global i
    push!(s, i)
    i = c[i]
end
@assert i==1
@assert length(s)==100


# Generate a random number of 10 digits as a string without leading zeroes (proba we het an empty string: 10^⁻¹⁰)
for _ in 1:100
    ns = lstrip(randstring('0':'9', 10), '0')
    ns2 = lstrip(join(shuffle(collect(ns))), '0')   # shuffle digits
    @assert parse(Int, ns)%3 == parse(Int, ns2)%3   # Remainder of ÷3 is unchanged by swapping digits
end

