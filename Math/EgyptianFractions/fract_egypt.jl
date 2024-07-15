# Calculs de fractions égyptiennes, convertit une fraction en somme de franctions "1/k"
#
# 2024-04-21    PV

Fraction = Rational{Int64}

# Recursive descent: start with the largest egyption fraction that fits in f, and decompose the remanining difference
function decompose(f::Fraction)::Vector{Fraction}
	f.num == 1 && return [f]

	d1 = f.den ÷ f.num + 1
	f1 = 1 // d1
	f2 = f - f1
	[f1; decompose(f2)]
end

println("Factions Égyptiennes en Julia\n")

const max = 13
for num in 2:max
	for den in num+1:max
		f = num // den
		if f.num == num
			println("$num/$den = ", join(decompose(f), " + "))
		end
	end
	println()
end
