# dict_play.jl
# Play with Julia dictionaries
# 
# 2024-04-21    PV      First version


# Use dic for memoization, example of efficient Fibonacci number calculation with recursive definition

# Create and initialize dic
fibdic = Dict{Int, Int}(0 => 0, 1 => 1)
function fibo(n, dic = fibdic)
	get!(dic, n) do
		fibo(n - 1) + fibo(n - 2)
	end
end

for i in 0:8
	println("F$i = $(fibo(i))")
end
println()

println("pairs:")
for p in pairs(fibdic)
	println(p)
end
println()

println("keys:")
for k in keys(fibdic)
	println(k)
end
println()

# Insertion order is nor preserved (use OrderedDict for that), but order of keys() and values() are the same
println("values:")
for v in values(fibdic)
	println(v)
end
println()

# Beware! In Julia, direct enumeration returns pairs, while in Python, direct enumeration return keys...
println("direct:")
for z in fibdic
	println(z)
end
println()


# Print dictionary sorted by keys
println("Dictionary sorted by keys")
for k in sort(collect(keys(fibdic)))
	println("$k => $(fibdic[k])")
end
println()

println("Dictionary sorted by values (as strings in this example)")
for (k, v) in sort(collect(fibdic), by = ((k, v),) -> string(v))
	println("$k => $(fibdic[k])")
end
println()
