# test_erf.jl
# Just test error function
# https://en.wikipedia.org/wiki/Error_function
# 
# 2024-03-18    PV      First version

#using Random
using SpecialFunctions

const N=10_000
const P=0.75

println("Generation of $(N) random numbers, normal distribution(µ=0, σ=1)")

v = randn(N)

# Estimate the number of values in [-P, P]. Divide by √2 since erf is for a normal distribution with σ=1/√2
est = round(Int, N*erf(P/√2))

# Calculate the real number of values in this interval
found = sum(-P .< v .< P)

println("Estimated count of numbers in [$(-P), $(P)]: $(est)")
println("Measured count of numbers in [$(-P), $(P)]:  $(found)")
