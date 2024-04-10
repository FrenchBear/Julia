# str.jl
# Play with julia string and characters (Julia manual §7)
# 
# 2024-03-19    PV      First version
# 2024-03-31    PV      String operations
# 2024-04-01    PV      Trimming (strip)
# 2024-04-10    PV      first, last, chop

using Unicode

sd = "Bonjour à tous!"
println(sd)
println("length (number of codepoints): ", length(sd))
println()

println(reverse(sd))                            # But [end:-1:begin] doesn't work with utf-8 characters
println(repeat(".:Z:.", 3))                     # .:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:.
println(join(["apples", "bananas", "pineapples"], ", ", " and "))   # apples, bananas and pineapples
println(join(['a', 'b', 'c', 'd']))             # abcd
println("[" * join([1, 2, 3, 4], ", ") * "]")   # [1, 2, 3, 4]
println()

ts = split("Il était un petit navire")          # ["Il", "était", "un", "petit", "navire"]
println(ts)
println()

# Case
println("uppercase:      ", uppercase(sd))
println("lowercase:      ", lowercase(sd))
println("tilecase:       ", titlecase(sd))
println("uppercasefirst: ", uppercasefirst(sd))
println("lowercasefirst: ", lowercasefirst(sd))
println()

# Padding
println("lpad:   <", lpad("Hello", 10), ">")
println("rpad:   <", rpad("Hello", 10), ">")
println("rpad:   <", rpad("Hello", 10, '*'), ">")

#function center(s::String, l::Int)::String
#    ls = length(s)
#    if l <= ls
#        s
#    else
#        # lr = l - ls
#        # lpad(s, ls + cld(lr, 2)) * " "^fld(lr, 2)   # A good example of fld (floor integer divide) and cld (ceiling integer divide)
#        rpad(lpad(s, ls + (l - ls) ÷ 2), l)
#    end
#end

center(s::String, l::Int)::String = rpad(lpad(s, (length(s) + l) ÷ 2), l)
println("center: <", center("Hello", 10), ">")

#for lc in 4:12
#    println("<", center("Hello", lc), ">")
#end
println()

ls = [
	"Aé♫山𝄞🐗",               # Simple codepoints
	"œæĳøß≤≠Ⅷﬁﬆ",              # Simple codepoints
	"🧝",                     # Just ELF
	"🧝🏽‍♀️",                     # ELF, FITZ 4, ZWJ, FEMALE SIGN, VS-16
	"🐻‍❄️",                     # BEAR, ZWJ, SNOWFLAKE, VS-16
	"👨🏾‍❤️‍💋‍👨🏻",                     # MAN, FITZ 5, ZWJ, HEAVY BLACK HAT, VS-16, ZWJ, KISS MARK, ZWJ, MAN, FITZ 1-2
	"𝄞𝄡𝄢",                    # Outside BMP
	"␀␁␂␃␄␅␆␇␈",               # Control characters 0-8
	"΀΁΂΃",                    # Unassigned codepoints
	"\uFFD9",                  # Not a character
	"￩￪￫￬",                    # Half-width arrows
	"٠١٢٣٤٥٦٧٨٩",            # Arabic digits
	"scope",                   # Latin small
	"ѕсоре",                   # Cyrillic
]

for s in ls
	#   nb = lastindex(s * "?") - 1 # bytes (UTF8 representation)
	nb = ncodeunits(s)          # bytes (UTF8 representation)
	nc = length(s)              # characters (codepoints)
	ng = length(Unicode.graphemes(s))   # graphemes (glyphs)
	println("nb=$(lpad(string(nb), 2)) nc=$(lpad(string(nc), 2)) ng=$(lpad(string(ng), 2))  $s")
end
println()

# Note that VSCode console doesn't render some combinations such as polar bear, rendered as🐻‍ ❄
# nb=17 nc= 6 ng= 6  Aé♫山𝄞🐗
# nb=25 nc=10 ng=10  œæĳøß≤≠Ⅷﬁﬆ
# nb= 4 nc= 1 ng= 1  🧝
# nb=17 nc= 5 ng= 1  🧝🏽‍♀️
# nb=13 nc= 4 ng= 1  🐻‍❄️
# nb=35 nc=10 ng= 1  👨🏾‍❤️‍💋‍👨🏻
# nb=12 nc= 3 ng= 3  𝄞𝄡𝄢
# nb=27 nc= 9 ng= 9  ␀␁␂␃␄␅␆␇␈
# nb= 8 nc= 4 ng= 4  ΀΁΂΃
# nb= 3 nc= 1 ng= 1  ￙
# nb=12 nc= 4 ng= 4  ￩￪￫￬
# nb=20 nc=10 ng=10  ٠١٢٣٤٥٦٧٨٩
# nb= 5 nc= 5 ng= 5  scope
# nb=10 nc= 5 ng= 5  ѕсоре

sd = "Où ça? Là!"                       # Combining accents
sc = Unicode.normalize(sd, :NFC)
ss = Unicode.normalize(sc, stripmark = true)
sf = Unicode.normalize(sc, casefold = true)
ssf = Unicode.normalize(sc, stripmark = true, casefold = true)
println("NFD l=$(length(sd)) ", sd)     # l=13 Où ça? Là!
println("NFC l=$(length(sc)) ", sc)     # l=10 Où ça? Là!
println("STR l=$(length(ss)) ", ss)     # l=10 Ou ca? La!
println("CF  l=$(length(sf)) ", sf)     # l=10 où ça? là!
println("CFS l=$(length(ssf)) ", ssf)   # l=10 ou ca? la!
println()


isBMP(cp::UInt)::Bool = cp <= 0xD7FF || 0xE000 <= cp <= 0xFFFF
isBMP(c::Char)::Bool = isBMP(UInt(c))

h2(n::UInt)::String = string(n, base = 16, pad = 2)
h4(n::UInt)::String = string(n, base = 16, pad = 4)
h8(n::UInt)::String = string(n, base = 16, pad = 8)

UTF16(cp::UInt)::String = isBMP(cp) ? h4(cp) : h4(0xD800 + ((cp - 0x10000) >> 10)) * " " * h4(0xDC00 + (cp & 0x3ff))
UTF16(c::Char)::String = UTF16(UInt(c))

function UTF8(cp::UInt)::String
	if cp <= 0x7F
		return h2(cp)
	elseif cp <= 0x7FF
		return h2(0xC0 + cp ÷ 0x40) * " " * h2(0x80 + cp % 0x40)
	elseif cp <= 0xFFFF
		return h2(0xE0 + cp ÷ 0x40 ÷ 0x40) * " " * h2(0x80 + cp ÷ 0x40 % 0x40) * " " * h2(0x80 + cp % 0x40)
	elseif (cp <= 0x1FFFFF)
		return h2(0xF0 + cp ÷ 0x40 ÷ 0x40 ÷ 0x40) * " " * h2(0x80 + cp ÷ 0x40 ÷ 0x40 % 0x40) * " " * h2(0x80 + cp ÷ 0x40 % 0x40) * " " * h2(0x80 + cp % 0x40)
	else
		return "?" * h8(cp)
	end
end
UTF8(c::Char)::String = UTF8(UInt(c))
# Alt version
UTF8_Alt(c::Char)::String = join([h2(codeunit(string(c), i)) for i in 1:ncodeunits(c)], ' ')

function charinfo(c::Char)
	cp = UInt(c)
	println(h8(cp), "  ", rpad(UTF16(cp), 9), "  ", rpad(UTF8(cp), 11), "  ", rpad(Base.Unicode.category_abbrev(c), 2), "  ", c)
end

charinfo('A')
charinfo('é')
charinfo('♫')
charinfo('山')
charinfo('𝄞')
charinfo('🐗')
println()

# Limited arithmetic
@assert 'B' - 'A' == 1
@assert 'a' + 1 == 'b'

# Iterate over a string
s = "Aé♫𝄞"                     # 4 chars, 4 grapheles
for c in s
	print("<$c>")
end
println()
for ss in Unicode.graphemes(s)
	print("<$ss>")
end
println()

s = "👨🏾‍❤️‍💋‍👨🏻"                          # 10 chars, 1 grapheme
for c in s
	print("<$c>")
end
println()
for ss in Unicode.graphemes(s)
	print("<$ss>")
end
println()

typename(z) = Base.typename(typeof(z)).wrapper      # Get simple type name
println(typename(s[1]), ' ', typename(s[1:1]))
println()

s = "∀x ∃y"
for c in s
	print("<$c>")
end
println()

# Numeric indexes falling in the middle of a UTF sequence cause an error
for i in firstindex(s):lastindex(s)
	try
		c = s[i]
		println("$i: $c")
	catch err
		println("$i: ERROR: $err")
	end
end
println()

# Extend string interpolation: actually string interpolation call print, so we must add a method to print
struct Zarbi
	a::Int
	b::Int
end

function print(io::IO, z::Zarbi)
	print(io, "Zarbi[$(z.a), $(z.b)]")
end

z = Zarbi(5, -7)
println(z)
println("z=$z")
println()

# Line continuation
lcs = "Once \
upon \
a \
time"
println(lcs)

# Triple-quote strings
# The dedentation level is determined as the longest common starting sequence of spaces or tabs in all lines, excluding the line 
# following the opening """ and lines containing only spaces or tabs (the line containing the closing """ is always included).
# Then for all lines, excluding the text following the opening """, the common starting sequence is removed (including lines
# containing only spaces and tabs if they start with this sequence)
tqs = """    This
		 is
		   a test"""
println(tqs)
println()

# Search char in string
println(findfirst('o', "xylophone"))    # 4
println(findlast('o', "xylophone"))     # 7
println(findfirst('z', "xylophone"))    # nothing
println()

# check if a substring (or char) is found within a string:
println(occursin("world", "Hello, world."))     # true
println(occursin("o", "Xylophon"))              # true
println(occursin("a", "Xylophon"))              # false
println(occursin('o', "Xylophon"))              # true
println()

#=
Some other useful functions include:

firstindex(str) gives the minimal (byte) index that can be used to index into str (always 1 for strings, not necessarily true for other containers).
lastindex(str) gives the maximal (byte) index that can be used to index into str.
length(str) the number of characters in str.
length(str, i, j) the number of valid character indices in str from i to j.
ncodeunits(str) number of code units in a string.
codeunit(str, i) gives the code unit value in the string str at index i.
thisind(str, i) given an arbitrary index into a string find the first index of the character into which the index points.
nextind(str, i, n=1) find the start of the nth character starting after index i.
prevind(str, i, n=1) find the start of the nth character starting before index i.
isvalid(s) finds if a is a valid utf8 string, also isvalid(Char, x)
=#

# Note that strings don't have to be valid UTF8 representations:
b = isvalid("DATA\xff\u2200")   # false


# Raw strings
path = raw"C:\utils\astructx.exe"
htap = raw"$1$2$3"


# Version number literals
println(VERSION)                # Julia version
VER = v"0.2-rc1"
if v"0.2" <= VER < v"0.3-"      # v"0.3-" is used, with a trailing -: this notation is a Julia extension of the standard, and it's used to indicate a version which is lower than any 0.3 release
	# do something specific to 0.2 release series
end
# VERSION > v"0.2-rc1+" can be used to mean any version above 0.2-rc1 and any of its builds: it will return false for version v"0.2-rc1+win64" and true for v"0.2-rc2"
println()

# byte arrays litterals
tb = b"DATA\xff\u2200"          # 8-element Base.CodeUnits{UInt8, String}, behaves like read only array of UInt8
vb = Vector{UInt8}(b"123")
vb[1] = 0x32
println(vb)                     # UInt8[0x32, 0x32, 0x33]
println()

# String operations
println("Bon" * "jour")         # Concatenation of Strings
println("Waow" * '!')           # Also work for String and Char
println("Ho! "^3)               # Repetition
println()

# Trimming strings
chaine = "  Hello  "
println("strip:  <$(strip(chaine))>")       # Trim whitespaces on both ends
println("lstrip: <$(lstrip(chaine))>")      # Trim left (heading) whitespaces
println("rstrip: <$(rstrip(chaine))>")      # Trim right (tailing) whitespaces
chaine = "\t\t  Hello \r\n\r\n"
println("strip: <$(strip(chaine))>")        # Whitespaces include (not limited to) space, \t, \r, \n
chaine="__Main__"
println("strip: <$(strip(chaine, '_' ))>")  # Can specify char, or vector or set of chars 
println()


# Other string operations

str = "😄 Hello! 👋"                       # "😄 Hello! 👋"
last(first(str, 9), 7)                      # "Hello! "
chop(str, head=2, tail=length(str)-9)       # "Hello! "
chop(first(str, 9), head=2, tail=0)         # "Hello! "
str[(:)(nextind.(str, 0, (3, 9))...)]       # "Hello! "

chop("Hello")                               # "Hell"
chop("Hello", tail=2)                       # "Hel"
chop("Hello", head=2, tail=0)               # "llo"     (by default, tail=1)
