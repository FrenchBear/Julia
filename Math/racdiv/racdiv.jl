# Calculs de racines et d'inverses
# Tangente n°214 page 17
#
# 2024-03-14    PV

# Calcul de √n avec la suite de Héron
n = 7
uₙ = 0
uₙ₊₁ = n / 2
while uₙ != uₙ₊₁
	global uₙ, uₙ₊₁
	uₙ = uₙ₊₁
	uₙ₊₁ = (uₙ + n / uₙ) / 2
	println(uₙ)
end
println("√$n = $uₙ₊₁")
println()

# Calcul de n⁻¹ avec une suite issue de la méthode de Newton, vₙ₊₁ = vₙ(2-n.vₙ)
# Il fait partir avec 0 < v0 <= n⁻¹
n = 7
uₙ = 0
uₙ₊₁ = 1/(n+1)      # Truc rapide pour garantir qu'on part au-dessous de 1/n
while uₙ != uₙ₊₁
	global uₙ, uₙ₊₁
	uₙ = uₙ₊₁
	uₙ₊₁ = uₙ * (2 - n * uₙ)
	println(uₙ)
end
println("$(n)⁻¹ = $uₙ₊₁")
println()

# Méthode de Schönage, combiant les deux précédentes pour obtenir la racine sans division
n = 7
uₙ₊₁ = n / 2
vₙ₊₁ = 1 / (2uₙ₊₁)
while uₙ != uₙ₊₁
	global uₙ, uₙ₊₁, vₙ, vₙ₊₁
	uₙ, vₙ = uₙ₊₁, vₙ₊₁
	uₙ₊₁ = uₙ + (n - uₙ^2) * vₙ
	vₙ₊₁ = 2 * vₙ * (1 - uₙ * vₙ)
	println(uₙ, ' ', vₙ)
end
println("√$n = $uₙ₊₁")
println()

function sqrtn(n::Float64)::Float64
	uₙ = 0
	uₙ₊₁ = n / 2
	while uₙ != uₙ₊₁
		uₙ = uₙ₊₁
		uₙ₊₁ = (uₙ + n / uₙ) / 2
	end
	uₙ
end

function invn(n::Float64)::Float64
	uₙ = 0
    uₙ₊₁ = 1/(n+1)      # Truc rapide pour garantir qu'on part au-dessous de 1/n, on doit faire mieux!!!
	while uₙ != uₙ₊₁
		uₙ = uₙ₊₁
		uₙ₊₁ = uₙ * (2 - n * uₙ)
	end
	uₙ
end

println(sqrtn(2.0))
println(invn(3.0))
println()
println(355/113)
println(355*invn(113.0))