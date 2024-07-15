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


println("Fraction development in Julia\n")


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
test(1 // 9801, "0.[000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969799]") # 0.[00 01 02 03... 96 97 99] (no 98)
test(0 // 5, "0")
test(5 // 0, "/0 error")

# Performance
t = @elapsed begin
    for i in 1:100_000
        _ = develop(100//23)
    end
end
println("\n100K developments of 100/23: Elapsed: $(round(t; digits=3))s")

t = @elapsed begin
    for i in 1:1000
        for j in 1:1000
            _ = develop(i//j)
        end
    end
end
println("1M developments: Elapsed: $(round(t; digits=3))s")
