# modules.jl
# Play with julia modules (Julia manual §16)
#
# 2024-04-08    PV      First version

Γ(z) = √(2π/z)*((z+1/(12z-1/(10z)))/ℯ)^z
fact(n) = round(Γ(BigInt(n+1)))

for i in 1:50
    println(i, ' ', fact(i)/factorial(big(i)))
end
