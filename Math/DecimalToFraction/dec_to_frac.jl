# Stern-Brocot algorithm to convert a float number to a faction with error<ε
# Testing absolute error to keep things simple
#
# 2024-04-21    PV
# 2024-05-07    PV      Actually Julia contains Base.rationalize([T<:Integer=Int,] x; tol::Real=eps(x)) which does the same thing...
# 2024-07-15    PV      Code cleanup, align with F# version

Fraction = Rational{Int64}

# Returns fraction n//d matching f with |f - n/d| < ε
function double_to_fraction(f::Float64, ε = 1e-6)::Fraction
	# Special case
	f == 0 && return 1 // 0

	sign = 1
	if f < 0
		sign = -1
		f = -f
	end

	off = floor(Int64, f)
	f -= off
	f <= ε && return copysign(off, sign) // 1

	infNum = 0
	infDen = 1
	supNum = 1
	supDen = 0
	while true
		rNum = infNum + supNum
		rDen = infDen + supDen

		r = rNum / rDen
 		if abs(r - f) < ε
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


println("Decimal to fraction in Julia")
println("Stern-Brocot algorithm to transform a periodic decimal suite into a fraction\n")

function test(f::Float64, expected::Fraction)
	ans = double_to_fraction(f)
	if ans == expected
		println("Ok: $f = $ans")
	else
		error("KO: $f expected $expected, found $ans")
	end
end

test(0.1415926535, 16 // 113)
test(3.1415926535, 355 // 113)
test(-0.1415926535, -16 // 113)
test(-3.1415926535, -355 // 113)

# If n and d <= 1000, exact fraction will be found. Beyond this, it's not true anymore, another fraction with error<ε can be returned.
# Note: Don't run this in debugger, it's way too slow
println("\nTesting 1M fractions with n,d in [1..1000]")
for i in 1:1000
	for j in 1:1000
		ans = double_to_fraction(i / j)
		pgdc = gcd(i, j)
		if i != ans.num * pgdc || j != ans.den * pgdc
			error("Check failed")
		end
	end
end

println("Test Ok!")
