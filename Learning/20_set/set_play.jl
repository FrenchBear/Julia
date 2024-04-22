# set_play.jl
# Play with Julia sets
# 
# 2024-04-21    PV      First version

# Erathosthere's crible using BitSet
max = 1000
rmax = ceil(Int, √max)
p = BitSet(3:2:max)

pc = 1
print(2, ' ')

while true
	np = popfirst!(p)
	global pc += 1
	print(np, ' ')
	if np >= rmax
		break
	end
	for m in np*np:np+np:max
		delete!(p, m)
	end
end

for np in p
	print(np, ' ')
	global pc += 1
end
println()
println("$pc primes found in 2..$max")
