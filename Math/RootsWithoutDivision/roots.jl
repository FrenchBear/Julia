# Square root calculation without division
# See tangente #214, p. 17
#
# 2024-07-15    PV      Rewrite code from scratch, original version has been lost...

# Maximum relative difference
εr = 1e-14

# Usual method, quadratic convergence, but requres float division
function square_root_heron(r::Float64)::Float64
	uₙ = 0.5 * r    # Ok for reasonably small values of r
	while true
		uₙ₊₁ = (uₙ + r / uₙ) / 2
		if abs(uₙ₊₁ - uₙ) / uₙ < εr
			return uₙ₊₁
		end
		uₙ = uₙ₊₁
	end
end

# Schönage method, no float division (relative error calculation here doesn't count)
function square_root_nodiv(r::Float64)::Float64
	uₙ = 0.5 * r
	vₙ = 1 / (2 * uₙ)
	while true
		uₙ₊₁ = uₙ + (r - uₙ * uₙ) * vₙ
		vₙ₊₁ = vₙ + (1 - 2 * uₙ * vₙ) * vₙ
		if abs(uₙ₊₁ - uₙ) / uₙ < εr
			return uₙ₊₁
		end
		uₙ = uₙ₊₁
		vₙ = vₙ₊₁
	end
end

function inverse_nodiv(b::Float64)::Float64
	vₙ = 0.1    # Need a starting value <1/b, so here it works if b<10
	while true
		vₙ₊₁ = vₙ * (2 - b * vₙ)
		if abs(vₙ₊₁ - vₙ) / vₙ < εr
			return vₙ₊₁
		end
		vₙ = vₙ₊₁
	end
end


println("Square root calculation without division in Julia\n")

r = √2.0
println("√2 math  = $r")

r = square_root_heron(2.0)
println("√2 héron = $r")

r = square_root_nodiv(2.0)
println("√2 nodiv = $r\n")

r = 1 / 7.0
println("1/7 math  = $r")

r = inverse_nodiv(7.0)
println("1/7 nodiv = $r")
