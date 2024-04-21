# Fraction development
#
# 2024-04-21    PV

Fraction = Rational{Int64}

function develop(f::Fraction)::String
	f.den == 0 && return "/0 error"

	dic::Dict{Int, Int} = Dict()
	sint = ""
	if f.num < 0      # In fractions, num only bears sign
		sint = "-"
		f = -f
	end
	n = f.num
	d = f.den
	sint *= string(n ÷ d)
	n %= d
	n == 0 && return sint
	sint *= '.'
	sfrac = ""
	for i in 0:d-1
		n == 0 && return sint * sfrac     # Division ends
		haskey(dic, n) && return sint * sfrac[begin:dic[n]] * "[" * sfrac[dic[n]+1:end] * "]"  # Found period

		# Record position for remainder and decimal, continue to next decimal 
		dic[n] = i

		n *= 10
		dec = n ÷ d
		n %= d
        
		sfrac *= string(dec)
	end
end

function test(f::Fraction, res::String)
	x = develop(f)
	if x == res
		println("Ok: $f = $res")
	else
		println("KO: $f found $x, expected $res")
	end
end


test(100 // 250, "0.4")
test(100 // 4, "25")
test(8 // 2, "4")
test(1 // 3, "0.[3]")
test(-1 // 3, "-0.[3]")
test(1 // -3, "-0.[3]")
test(-1 // -3, "0.[3]")
test(1 // 5, "0.2")
test(1 // 7, "0.[142857]")
test(100 // 23, "4.[3478260869565217391304]")
test(679 // 550, "1.23[45]")
test(0 // 5, "0")
test(5 // 0, "/0 error")

t = @elapsed begin
    for i in 1:100_000
        _ = develop(100//23)
    end
end
println("\nElapsed: $(round(t; digits=3))s")
