# Cordic calculations
#
# 2024-05-07    PV      First version, using FLoat64
#
# ToDo: rewrite calculation formula so if can accept Float32, Float64, BigFloat, Irrational{:π}, Rational{Int64}, ...
# Exactly how sin does it: sin(Float32)->Float42, sin(rational[Int64,Int64])->Float64, sin(Float64->Float64), sin(BigFloat->BigFloat), sin(Irrational{:π})->Float64, sin(Int)->Float64, ...

using Format

function CordicCompute(angle::Float64)::Tuple{Float64, Float64}   # Returns (sin(angle), cos(angle))
	# Note that angle is expressed in radians, but CORDIC algorithm does not care about it, just
	# change initial variable a to 45 to work in degrees for instance

	# Start at π/4, with both sin and cos = (√2)/2
	a::Float64 = π / 4           # Alt: π / 2
	s::Float64 = √2.0 / 2.0      # Alt: 1.0
	c::Float64 = s               # Alt: 0.0

	# Start with horizontal unitary vector for result
	vcos::Float64 = 1.0
	vsin::Float64 = 0.0

	# Simple time-saver
	angle == zero(Float64) && return (vsin, vcos)

	while true
		# If angle remaining to rotate is more than currently computed angle/s/c, we do the rotation
		if (angle >= a)
			angle -= a
			# Standard rotation matrix times vector (cos, sin)
			vcos, vsin = vcos * c - vsin * s, vcos * s + vsin * c
		end

		# Compute sin and cos of half-angle for next step
		a /= Float64(2.0)
		a < Float64(1e-17) && break

		# Half-trig computation, sin(a/2) and cos(a/2)
		c2 = c
		c = √((c + 1.0) / 2.0)
		s /= √(2 * (1.0 + c2))
	end
	(vsin, vcos)
end

function SinCordic(angle::Float64)::Float64
    # Get back into [0, π/2]
	sign = 1
	if angle < 0
		angle = -angle
		sign = -1
	end
    angle = mod2pi(angle)       # Use modulo to be in [0,2π[
	if (angle >= π)             # Now get in [0,π]
		angle -= π
		sign = -sign
	end
	angle > π / 2 && (angle = π - angle)    # Get in [0, π/2]

	(vsin, _) = CordicCompute(angle)
    flipsign(vsin, sign)
end

function CosCordic(angle::Float64)::Float64 where Float64<:Real
    SinCordic(angle + π / 2)
end


# Tests, just use Float64
for z in -9.75:0.25:10.0
	s = SinCordic(z)
	printfmt("sin({:5.2f}) = {:15.12f} ", z, s)
    println(" "^round(Int, 20*(1+s)), '*')
end
println()

# Take a random angle (0..Pi/2)
a0 = 1.1823614786
(vsin, vcos) = CordicCompute(a0)

println("a=$a0")
println("Math:   c=$(cos(a0))\t\t\ts=$(sin(a0))\t\t\t(Math.Cos and Math.Sin)")
println("Cordic: c=$vcos\t\t\ts=$vsin\t\t\t(Cordic Cos and Sin)")
println("Maple:  c=0.378740326955891541643393287014\ts=0.925502979323861698653734026619\n")


# Just checking I'm not working at HP, sin(π) is zero! :-)
# And typeof(π) in Julia is Irrational{:π}, which is a type <:Real, hence the conversion to Float64 (ToDo: integrate that in function code)
vsin = SinCordic(Float64(π))
println("Cordic sin(π):  $vsin")
