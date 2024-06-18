# types_tree.jl
# Draw a hierarchy of subtypes for a given type
#
# 2024-05-11    PV

using InteractiveUtils      # subtypes()

function tt(t::Type, prefix::String = "")
	prefix == "" && println(t)
	st = subtypes(t)
	isempty(st) && return
	n = length(st)
	for (i, st) in enumerate(st)
		st == Any && continue             # Since Any is a subtype of Any...
		if i < n
			println(prefix, "├─", st)
			tt(st, prefix * "│ ")
		else
			println(prefix, "└─", st)
			tt(st, prefix * "  ")
		end
	end
end

tt(Number)

using Dates
tt(Dates.Period)
