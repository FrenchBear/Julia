# All using
# Quick way to load common packages
#
# 2024-05-03    PV
# 2025-01-02	PV		StaticArrays for Pentomino
# 2025-09-16	PV		Added Images and Colors for rotor_router

import Pkg

function u(m::String)
    println("--- Package $m")
    Pkg.add(m)
end

u("BenchmarkTools")
u("CSV")
u("DataFrames")
u("DataStructures")
u("Dates")
u("Distributed")
u("Distributions")
u("Format")
u("Getopt")
u("InteractiveUtils")
u("LinearAlgebra")
u("MethodAnalysis")
u("OffsetArrays")
u("Permutations")
u("Plots")
u("Printf")
u("Random")
u("Sockets")
u("SpecialFunctions")
u("Statistics")
u("StatsPlots")
u("Test")
u("TOML")
u("Unicode")
u("StaticArrays")
u("Images")
u("Colors")
