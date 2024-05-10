
state = 0
nl = 0
np = 0
for line in readlines("base_strings.jl")
	global state, nl, np
	nl += 1

	# Show max 5 problems
	if np == 5
		break
	end

	if length(line) > 125
		println("Line $nl, long line: $(length(line)) characters")
		np += 1
	end

	if startswith(line, "# ------------------------")
		state = 10
		continue
	elseif startswith(line, "# -----------")
		state = 11
		continue
	end

	# In state 0, ignore input
	if state == 0
		continue
	end

	if state == 10
		if startswith(line, "# Base.") || startswith(line, "# Core.")
			state = 11
			continue
		elseif startswith(line, "# Type ")
			state = 11
			continue
		else
			println("Line $nl, state $state: Expect # Base|Core\nFound: $line")
			state = 0
			np += 1
			continue
		end
	end

	if state == 11
		if startswith(line, "# Function ") || startswith(line, "# Method ") || startswith(line, "# Type ") || startswith(line, "# Macro ")
			continue
		elseif rstrip(line) == "#"
			state = 0
			continue
		else
			println("Line $nl, state $state: Expect # or # Function|Method|Type|Macro\nFound: $line")
			np += 1
			state = 0
			continue
		end
	end

	println("Line $nl, state $state: Unexpected")
	np += 1
end

println("\nDone, $nl lines processed.")