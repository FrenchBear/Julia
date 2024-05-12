# check.jl
# Checks leaning julia source files for simple formatting rules
#
# 2024-05-11    PV


state = 0
nl = 0
np = 0
for line in readlines("lib_dates.jl")
	global state, nl, np
	nl += 1

	# Show max 5 problems
	if np >= 5
		break
	end

	if length(line) > 125
		println("Line $nl, long line: $(length(line)) characters")
		np += 1
	end

	if startswith(line, "# ----------------------------------------------------")
		# Long headers are just ignored
		state = 0
		continue
	elseif startswith(line, "# ------------------------")
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

	# After a medium separatot line
	if state == 10
		if any(map(x->startswith(line, x), ["# Base.", "# Core.", "# Dates."])) || any(line .== ["# &&", "# ||"])
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

	# Header Function/Method... after Base/Code header
	# or after a small separator line
	if state == 11
		if startswith(line, "# Function ") || startswith(line, "# Method ") || startswith(line, "# Type ") || startswith(line, "# Macro ") || startswith(line, "# Constant ") || startswith(line, "# Keyword ")
			continue
		elseif strip(line) == ""
			state = 0
			continue
		elseif rstrip(line) == "#"
			state = 12
			continue
		else
			println("Line $nl, state $state: Expect # or # Function|Method|Type|Macro\nFound: $line")
			np += 1
			state = 0
			continue
		end
	end

	# In comments block after Functin/Method...
	if state == 12
		if strip(line) == ""
			state = 0
			continue
		elseif startswith(line, "#")
			continue
		else
			println("Line $nl, state $state: Expect empty line\nFound: $line")
			np += 1
			state = 0
			continue
		end
	end

	println("Line $nl, state $state: Unexpected")
	np += 1
end

println("\nDone, $nl lines processed.")
