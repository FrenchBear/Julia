# Use code analysis
#
# 2024-05-04    PV

# Note: Declaring
# res::Int = 0
# for c::Char in s
# actually generates twice the code ouput of @code_warntype and @code_lowered
# @code_typed output is equivalent
# at the end, @code_llvm and @code_native are equivalent
function CountChar(s::String, letter::Char)::Int
	res = 0
	for c in s
		if c == letter
			res += 1
		end
	end
	res
end

using InteractiveUtils



for action::Function in [CountChar]
	println("\n\n----------------------------------------------------------- $(Symbol(action))\n")

	println("--------- @code_warntype $(Symbol(action))")
	@code_warntype action("mississippi", 's')
	println()

	println("--------- @code_lowered $(Symbol(action))")
	s = @code_lowered action("mississippi", 's')
	println(s, "\n\n")

	println("--------- @code_typed $(Symbol(action))")
	t = @code_typed action("mississippi", 's')
	println(t, "\n\n")

	println("--------- @code_llvm $(Symbol(action))")
	@code_llvm action("mississippi", 's')
	println()

	println("--------- @code_native $(Symbol(action))")
	@code_native action("mississippi", 's')
	println()
end
