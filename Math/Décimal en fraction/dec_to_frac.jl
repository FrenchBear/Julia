# Algorithme de Stern-Brocot pour convertir une suite décimale péridique en fraction
#
# 2024-04-21    PV
# 2024-05-07    PV      Actually Julia contains Base.rationalize([T<:Integer=Int,] x; tol::Real=eps(x)) which does the same thing...

Fraction = Rational{Int64}

function double_to_fraction(f::Float64, epsilon=1e-6)::Fraction
	# Special case
	f == 0 && return 1 // 0

	sign = 1
	if f < 0
		sign = -1
		f = -f
	end

	off = floor(Int64, f)
	f -= off
	f <= epsilon && return copysign(off, sign) // 1

	infNum = 0
	infDen = 1
	supNum = 1
	supDen = 0
	while true
		rNum = infNum + supNum
		rDen = infDen + supDen

		r = rNum / rDen
		if abs(r - f) < epsilon
			rNum = copysign(rNum + off * rDen, sign)
			return rNum // rDen
		elseif r < f
			infNum = rNum
			infDen = rDen
		else
			supNum = rNum
			supDen = rDen
		end
	end
end

println("Stern-Brocot algorithm to transform a periodic decimal suite into a fraction\n")

epsilon=1e-6
f = 0.1415926535
println("$f = $(double_to_fraction(f))")
println("$f = $(rationalize(f, tol=epsilon)) (Base.rationalize)")

f = 3.1415926535
println("$f = $(double_to_fraction(f))")

f = -0.1415926535
println("$f = $(double_to_fraction(f))")

f = -3.1415926535
println("$f = $(double_to_fraction(f))")

# Check we get expected results
println("\nTesting 1 million fractions with n,d in [1..1000]")
for i in 1:1000
	for j in 1:1000
		fr = double_to_fraction(i / j)
		pgdc = gcd(i, j)
		if i != fr.num * pgdc || j != fr.den * pgdc
			error("Check failed")
		end
	end
end

println("Test Ok!")
