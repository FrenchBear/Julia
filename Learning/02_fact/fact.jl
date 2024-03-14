function fact(n::Int)
    f = BigInt(1)
    for i in 2:n
        f *= i
    end
    return f
end
