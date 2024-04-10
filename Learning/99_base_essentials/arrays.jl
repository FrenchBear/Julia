# Play with julia arrays
#
# 2024-04-10    PV      Test permute! for rolling permutator

roll(t::Vector{T}, start::Int) where {T} = permute!(t, [1:start-1; start+1:length(t); start])

v = ['a', 'b', 'c', 'd', 'e', 'f']
roll(v, 2)
println(v)
