# re.jl
# Play with julia regular expressions (Julia manual §7)
# 
# 2024-03-20    PV      First version
# 2024-03-31    over    Split a string using regex

source = "# 2024-03-20    PV      First version"

re = r"^\s*(?:#|$)"
re = Regex(raw"^\d+$")

# occursin just retruns true or false
occursin(r"^\s*(?:#|$)", "not a comment")       # false
occursin(r"^\s*(?:#|$)", "# a comment")         # true

# match retruns a single match or nothing
ma::RegexMatch = match(r"(\d{4})-(\d\d)-(\d\d)", source)
if ma === nothing           # or isnothing(ma)
    println("Not a match")
else
    println("ma.match:    ", ma.match)
    println("ma.offset:   ", ma.offset)
    println("length(ma):  ", length(ma))        # 3 for 3 captures
end
println("ma.captures: ", ma.captures)
println("ma.offsets: ", ma.offsets)             # 0 for a group that was not captured
println("d=$(ma.captures[3]) m=$(ma.captures[2]) y=$(ma.captures[1])")

# named captures
ma::RegexMatch = match(r"(?<year>\d{4})-(?<month>\d\d)-(?<day>\d\d)", source)
println("d=$(ma["day"]) m=$(ma["month"]) y=$(ma["year"])")
println("d=$(ma[:day]) m=$(ma[:month]) y=$(ma[:year])")

# deconstruct capture groups
y, m, d = ma
println("$d/$m/$y")

# Replace a regexp with a s-string (substitution), but severely limited, can't call a function since s special members such as \0 are intepreted inside replace function
println(replace("1+2*3^4=163", r"(\d+)" => s"<\0>"))
# ToDo: write a function betterreplace
function betterreplace(re::Regex, f)
end

# Special options after a regexp: some combination of the flags i, m, s, and x after the closing double quote mark.
r = r"Janvier"i         # Case insensitive matching
# m: trat string as multiple lines, ^ and $ match the start or the end of any line within the string
# s: treat the string as a single line, . also match a newline that is not the case without this option
# x: ignore non-escaped whilespaces in the regex. # introduces a comment in the regex

# note that $ is not processed as an interpolation in a regex string nor characters escpaping (except " that must still be escaped)

# multimatches: eachmatch gives an iterator over regex multimatches
println()
for ma in eachmatch(r"\d+", source)
    print("<", ma.match, ">")
end
println()

# transform into array of matches
tm = [ma for ma in eachmatch(r"\d+", source)]
println(tm)                                                         # RegexMatch[RegexMatch("2024"), RegexMatch("03"), RegexMatch("20")]

# Array of strings
println([ma.match for ma in eachmatch(r"\d+", source)])             # SubString{String}["2024", "03", "20"]
println(map(x->getfield(x,:match), eachmatch(r"\d+", source)))
println(getfield.(collect(eachmatch(r"\d+", source)), [:match]))
println(SubString.(source, findall(r"\d+", source)))

# Find offsets
println([ma.offset for ma in eachmatch(r"\d+", source)])            # [3, 8, 11]
println(map(x->getfield(x,:offset), eachmatch(r"\d+", source)))
println(getfield.(collect(eachmatch(r"\d+", source)), [:offset]))

# Find matching ranges
println(findall(r"\d+", source))                                    # UnitRange{Int64}[3:6, 8:9, 11:12] 
println()

# Split a string using regex
reSplit = r"[ \t\r\n]+"  # Extract all words separated by white spaces
s = "Once\t\tupon a\ntime\r\nwas   a\rprince"
vs = split(s, reSplit)
println(vs)                     # ["Once", "upon", "a", "time", "was", "a", "prince"]
