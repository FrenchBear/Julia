# Hamming ditance calculations
# The Hamming distance between two strings or vectors of equal length is the number of positions at which the
# corresponding symbols are different
#
# 2024-05-08    PV      First version

function hamming_distance(hash1::UInt64, hash2::UInt64)::Int
	x = hash1 ⊻ hash2
	m1::UInt64 = 0x5555555555555555
	m2::UInt64 = 0x3333333333333333
	h01::UInt64 = 0x0101010101010101
	m4::UInt64 = 0x0f0f0f0f0f0f0f0f
	x -= (x >> 1) & m1
	x = (x & m2) + ((x >> 2) & m2)
	x = (x + (x >> 4)) & m4
	return Int((x * h01) >> 56)
end

hamming_distance_intrinsics(hash1::UInt64, hash2::UInt64)::Int = count_ones(xor(hash1, hash2))

@assert hamming_distance(UInt64(871234), UInt64(162332)) == 12

for i in 0:64
	m = i == 64 ? typemax(UInt64) : UInt64((1 << i) - 1)
	n = UInt64(0)
	d = hamming_distance(m, n)
	println(string(i, pad = 2), ' ', string(m, pad = 64, base = 2), ' ', string(n, pad = 64, base = 2), ' ', d)
    @assert d==i
    @assert hamming_distance_intrinsics(m, n)==d
end
