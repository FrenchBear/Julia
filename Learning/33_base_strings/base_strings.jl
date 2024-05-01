# base_strings.jl
# Julia Base doc, Strings
# 
# 2024-05-01    PV


# Strings

Core.AbstractString
—
Type
The AbstractString type is the supertype of all string implementations in Julia. Strings are encodings of sequences of Unicode code points as represented by the AbstractChar type. Julia makes a few assumptions about strings:

Strings are encoded in terms of fixed-size "code units"
Code units can be extracted with codeunit(s, i)
The first code unit has index 1
The last code unit has index ncodeunits(s)
Any index i such that 1 ≤ i ≤ ncodeunits(s) is in bounds
String indexing is done in terms of these code units:
Characters are extracted by s[i] with a valid string index i
Each AbstractChar in a string is encoded by one or more code units
Only the index of the first code unit of an AbstractChar is a valid index
The encoding of an AbstractChar is independent of what precedes or follows it
String encodings are [self-synchronizing] – i.e. isvalid(s, i) is O(1)
[self-synchronizing]: https://en.wikipedia.org/wiki/Self-synchronizing_code

Some string functions that extract code units, characters or substrings from strings error if you pass them out-of-bounds or invalid string indices. This includes codeunit(s, i) and s[i]. Functions that do string index arithmetic take a more relaxed approach to indexing and give you the closest valid string index when in-bounds, or when out-of-bounds, behave as if there were an infinite number of characters padding each side of the string. Usually these imaginary padding characters have code unit length 1 but string types may choose different "imaginary" character sizes as makes sense for their implementations (e.g. substrings may pass index arithmetic through to the underlying string they provide a view into). Relaxed indexing functions include those intended for index arithmetic: thisind, nextind and prevind. This model allows index arithmetic to work with out-of- bounds indices as intermediate values so long as one never uses them to retrieve a character, which often helps avoid needing to code around edge cases.

See also codeunit, ncodeunits, thisind, nextind, prevind.

source
Core.AbstractChar
—
Type
The AbstractChar type is the supertype of all character implementations in Julia. A character represents a Unicode code point, and can be converted to an integer via the codepoint function in order to obtain the numerical value of the code point, or constructed from the same integer. These numerical values determine how characters are compared with < and ==, for example. New T <: AbstractChar types should define a codepoint(::T) method and a T(::UInt32) constructor, at minimum.

A given AbstractChar subtype may be capable of representing only a subset of Unicode, in which case conversion from an unsupported UInt32 value may throw an error. Conversely, the built-in Char type represents a superset of Unicode (in order to losslessly encode invalid byte streams), in which case conversion of a non-Unicode value to UInt32 throws an error. The isvalid function can be used to check which codepoints are representable in a given AbstractChar type.

Internally, an AbstractChar type may use a variety of encodings. Conversion via codepoint(char) will not reveal this encoding because it always returns the Unicode value of the character. print(io, c) of any c::AbstractChar produces an encoding determined by io (UTF-8 for all built-in IO types), via conversion to Char if necessary.

write(io, c), in contrast, may emit an encoding depending on typeof(c), and read(io, typeof(c)) should read the same encoding as write. New AbstractChar types must provide their own implementations of write and read.

source
Core.Char
—
Type
Char(c::Union{Number,AbstractChar})

Char is a 32-bit AbstractChar type that is the default representation of characters in Julia. Char is the type used for character literals like 'x' and it is also the element type of String.

In order to losslessly represent arbitrary byte streams stored in a String, a Char value may store information that cannot be converted to a Unicode codepoint — converting such a Char to UInt32 will throw an error. The isvalid(c::Char) function can be used to query whether c represents a valid Unicode character.

source
Base.codepoint
—
Function
codepoint(c::AbstractChar) -> Integer

Return the Unicode codepoint (an unsigned integer) corresponding to the character c (or throw an exception if c does not represent a valid character). For Char, this is a UInt32 value, but AbstractChar types that represent only a subset of Unicode may return a different-sized integer (e.g. UInt8).

source
Base.length
—
Method
length(s::AbstractString) -> Int
length(s::AbstractString, i::Integer, j::Integer) -> Int

Return the number of characters in string s from indices i through j.

This is computed as the number of code unit indices from i to j which are valid character indices. With only a single string argument, this computes the number of characters in the entire string. With i and j arguments it computes the number of indices between i and j inclusive that are valid indices in the string s. In addition to in-bounds values, i may take the out-of-bounds value ncodeunits(s) + 1 and j may take the out-of-bounds value 0.

Note
The time complexity of this operation is linear in general. That is, it will take the time proportional to the number of bytes or characters in the string because it counts the value on the fly. This is in contrast to the method for arrays, which is a constant-time operation.

See also isvalid, ncodeunits, lastindex, thisind, nextind, prevind.

Examples

length("jμΛIα")
5

source
Base.sizeof
—
Method
sizeof(str::AbstractString)

Size, in bytes, of the string str. Equal to the number of code units in str multiplied by the size, in bytes, of one code unit in str.

Examples

sizeof("")
0

sizeof("∀")
3

source
Base.:*
—
Method
*(s::Union{AbstractString, AbstractChar}, t::Union{AbstractString, AbstractChar}...) -> AbstractString

Concatenate strings and/or characters, producing a String. This is equivalent to calling the string function on the arguments. Concatenation of built-in string types always produces a value of type String but other string types may choose to return a string of a different type as appropriate.

Examples

"Hello " * "world"
"Hello world"

'j' * "ulia"
"julia"

source
Base.:^
—
Method
^(s::Union{AbstractString,AbstractChar}, n::Integer) -> AbstractString

Repeat a string or character n times. This can also be written as repeat(s, n).

See also repeat.

Examples

"Test "^3
"Test Test Test "

source
Base.string
—
Function
string(n::Integer; base::Integer = 10, pad::Integer = 1)

Convert an integer n to a string in the given base, optionally specifying a number of digits to pad to.

See also digits, bitstring, count_zeros.

Examples

string(5, base = 13, pad = 4)
"0005"

string(-13, base = 5, pad = 4)
"-0023"

source
string(xs...)

Create a string from any values using the print function.

string should usually not be defined directly. Instead, define a method print(io::IO, x::MyType). If string(x) for a certain type needs to be highly efficient, then it may make sense to add a method to string and define print(io::IO, x::MyType) = print(io, string(x)) to ensure the functions are consistent.

See also: String, repr, sprint, show.

Examples

string("a", 1, true)
"a1true"

source
Base.repeat
—
Method
repeat(s::AbstractString, r::Integer)

Repeat a string r times. This can be written as s^r.

See also ^.

Examples

repeat("ha", 3)
"hahaha"

source
Base.repeat
—
Method
repeat(c::AbstractChar, r::Integer) -> String

Repeat a character r times. This can equivalently be accomplished by calling c^r.

Examples

repeat('A', 3)
"AAA"

source
Base.repr
—
Method
repr(x; context=nothing)

Create a string from any value using the show function. You should not add methods to repr; define a show method instead.

The optional keyword argument context can be set to a :key=>value pair, a tuple of :key=>value pairs, or an IO or IOContext object whose attributes are used for the I/O stream passed to show.

Note that repr(x) is usually similar to how the value of x would be entered in Julia. See also repr(MIME("text/plain"), x) to instead return a "pretty-printed" version of x designed more for human consumption, equivalent to the REPL display of x.

Julia 1.7
Passing a tuple to keyword context requires Julia 1.7 or later.

Examples

repr(1)
"1"

repr(zeros(3))
"[0.0, 0.0, 0.0]"

repr(big(1/3))
"0.333333333333333314829616256247390992939472198486328125"

repr(big(1/3), context=:compact => true)
"0.333333"

source
Core.String
—
Method
String(s::AbstractString)

Create a new String from an existing AbstractString.

source
Base.SubString
—
Type
SubString(s::AbstractString, i::Integer, j::Integer=lastindex(s))
SubString(s::AbstractString, r::UnitRange{<:Integer})

Like getindex, but returns a view into the parent string s within range i:j or r respectively instead of making a copy.

The @views macro converts any string slices s[i:j] into substrings SubString(s, i, j) in a block of code.

Examples

SubString("abc", 1, 2)
"ab"

SubString("abc", 1:2)
"ab"

SubString("abc", 2)
"bc"

source
Base.LazyString
—
Type
LazyString <: AbstractString

A lazy representation of string interpolation. This is useful when a string needs to be constructed in a context where performing the actual interpolation and string construction is unnecessary or undesirable (e.g. in error paths of functions).

This type is designed to be cheap to construct at runtime, trying to offload as much work as possible to either the macro or later printing operations.

Examples

n = 5; str = LazyString("n is ", n)
"n is 5"

See also @lazy_str.

Julia 1.8
LazyString requires Julia 1.8 or later.

Extended help

Safety properties for concurrent programs

A lazy string itself does not introduce any concurrency problems even if it is printed in multiple Julia tasks. However, if print methods on a captured value can have a concurrency issue when invoked without synchronizations, printing the lazy string may cause an issue. Furthermore, the print methods on the captured values may be invoked multiple times, though only exactly one result will be returned.

Julia 1.9
LazyString is safe in the above sense in Julia 1.9 and later.

source
Base.@lazy_str
—
Macro
lazy"str"

Create a LazyString using regular string interpolation syntax. Note that interpolations are evaluated at LazyString construction time, but printing is delayed until the first access to the string.

See LazyString documentation for the safety properties for concurrent programs.

Examples

n = 5; str = lazy"n is $n"
"n is 5"

typeof(str)
LazyString

Julia 1.8
lazy"str" requires Julia 1.8 or later.

source
Base.transcode
—
Function
transcode(T, src)

Convert string data between Unicode encodings. src is either a String or a Vector{UIntXX} of UTF-XX code units, where XX is 8, 16, or 32. T indicates the encoding of the return value: String to return a (UTF-8 encoded) String or UIntXX to return a Vector{UIntXX} of UTF-XX data. (The alias Cwchar_t can also be used as the integer type, for converting wchar_t* strings used by external C libraries.)

The transcode function succeeds as long as the input data can be reasonably represented in the target encoding; it always succeeds for conversions between UTF-XX encodings, even for invalid Unicode data.

Only conversion to/from UTF-8 is currently supported.

Examples

str = "αβγ"
"αβγ"

transcode(UInt16, str)
3-element Vector{UInt16}:
 0x03b1
 0x03b2
 0x03b3

transcode(String, transcode(UInt16, str))
"αβγ"

source
Base.unsafe_string
—
Function
unsafe_string(p::Ptr{UInt8}, [length::Integer])

Copy a string from the address of a C-style (NUL-terminated) string encoded as UTF-8. (The pointer can be safely freed afterwards.) If length is specified (the length of the data in bytes), the string does not have to be NUL-terminated.

This function is labeled "unsafe" because it will crash if p is not a valid memory address to data of the requested length.

source
Base.ncodeunits
—
Method
ncodeunits(s::AbstractString) -> Int

Return the number of code units in a string. Indices that are in bounds to access this string must satisfy 1 ≤ i ≤ ncodeunits(s). Not all such indices are valid – they may not be the start of a character, but they will return a code unit value when calling codeunit(s,i).

Examples

ncodeunits("The Julia Language")
18

ncodeunits("∫eˣ")
6

ncodeunits('∫'), ncodeunits('e'), ncodeunits('ˣ')
(3, 1, 2)

See also codeunit, checkbounds, sizeof, length, lastindex.

source
Base.codeunit
—
Function
codeunit(s::AbstractString) -> Type{<:Union{UInt8, UInt16, UInt32}}

Return the code unit type of the given string object. For ASCII, Latin-1, or UTF-8 encoded strings, this would be UInt8; for UCS-2 and UTF-16 it would be UInt16; for UTF-32 it would be UInt32. The code unit type need not be limited to these three types, but it's hard to think of widely used string encodings that don't use one of these units. codeunit(s) is the same as typeof(codeunit(s,1)) when s is a non-empty string.

See also ncodeunits.

source
codeunit(s::AbstractString, i::Integer) -> Union{UInt8, UInt16, UInt32}

Return the code unit value in the string s at index i. Note that

codeunit(s, i) :: codeunit(s)

I.e. the value returned by codeunit(s, i) is of the type returned by codeunit(s).

Examples

a = codeunit("Hello", 2)
0x65

typeof(a)
UInt8

See also ncodeunits, checkbounds.

source
Base.codeunits
—
Function
codeunits(s::AbstractString)

Obtain a vector-like object containing the code units of a string. Returns a CodeUnits wrapper by default, but codeunits may optionally be defined for new string types if necessary.

Examples

codeunits("Juλia")
6-element Base.CodeUnits{UInt8, String}:
 0x4a
 0x75
 0xce
 0xbb
 0x69
 0x61

source
Base.ascii
—
Function
ascii(s::AbstractString)

Convert a string to String type and check that it contains only ASCII data, otherwise throwing an ArgumentError indicating the position of the first non-ASCII byte.

See also the isascii predicate to filter or replace non-ASCII characters.

Examples

ascii("abcdeγfgh")
ERROR: ArgumentError: invalid ASCII at index 6 in "abcdeγfgh"
Stacktrace:
[...]

ascii("abcdefgh")
"abcdefgh"

source
Base.Regex
—
Type
Regex(pattern[, flags]) <: AbstractPattern

A type representing a regular expression. Regex objects can be used to match strings with match.

Regex objects can be created using the @r_str string macro. The Regex(pattern[, flags]) constructor is usually used if the pattern string needs to be interpolated. See the documentation of the string macro for details on flags.

Note
To escape interpolated variables use \Q and \E (e.g. Regex("\\Q$x\\E"))

source
Base.@r_str
—
Macro
@r_str -> Regex

Construct a regex, such as r"^[a-z]*$", without interpolation and unescaping (except for quotation mark " which still has to be escaped). The regex also accepts one or more flags, listed after the ending quote, to change its behaviour:

i enables case-insensitive matching
m treats the ^ and $ tokens as matching the start and end of individual lines, as opposed to the whole string.
s allows the . modifier to match newlines.
x enables "comment mode": whitespace is enabled except when escaped with \, and # is treated as starting a comment.
a enables ASCII mode (disables UTF and UCP modes). By default \B, \b, \D, \d, \S, \s, \W, \w, etc. match based on Unicode character properties. With this option, these sequences only match ASCII characters. This includes \u also, which will emit the specified character value directly as a single byte, and not attempt to encode it into UTF-8. Importantly, this option allows matching against invalid UTF-8 strings, by treating both matcher and target as simple bytes (as if they were ISO/IEC 8859-1 / Latin-1 bytes) instead of as character encodings. In this case, this option is often combined with s. This option can be further refined by starting the pattern with (UCP) or (UTF).
See Regex if interpolation is needed.

Examples

match(r"a+.*b+.*?d$"ism, "Goodbye,\nOh, angry,\nBad world\n")
RegexMatch("angry,\nBad world")

This regex has the first three flags enabled.

source
Base.SubstitutionString
—
Type
SubstitutionString(substr) <: AbstractString

Stores the given string substr as a SubstitutionString, for use in regular expression substitutions. Most commonly constructed using the @s_str macro.

Examples

SubstitutionString("Hello \\g<name>, it's \\1")
s"Hello \g<name>, it's \1"

subst = s"Hello \g<name>, it's \1"
s"Hello \g<name>, it's \1"

typeof(subst)
SubstitutionString{String}

source
Base.@s_str
—
Macro
@s_str -> SubstitutionString

Construct a substitution string, used for regular expression substitutions. Within the string, sequences of the form \N refer to the Nth capture group in the regex, and \g<groupname> refers to a named capture group with name groupname.

Examples

msg = "#Hello# from Julia";

replace(msg, r"#(.+)# from (?<from>\w+)" => s"FROM: \g<from>; MESSAGE: \1")
"FROM: Julia; MESSAGE: Hello"

source
Base.@raw_str
—
Macro
@raw_str -> String

Create a raw string without interpolation and unescaping. The exception is that quotation marks still must be escaped. Backslashes escape both quotation marks and other backslashes, but only when a sequence of backslashes precedes a quote character. Thus, 2n backslashes followed by a quote encodes n backslashes and the end of the literal while 2n+1 backslashes followed by a quote encodes n backslashes followed by a quote character.

Examples

println(raw"\ $x")
\ $x

println(raw"\"")
"

println(raw"\\\"")
\"

println(raw"\\x \\\"")
\\x \"

source
Base.@b_str
—
Macro
@b_str

Create an immutable byte (UInt8) vector using string syntax.

Examples

v = b"12\x01\x02"
4-element Base.CodeUnits{UInt8, String}:
 0x31
 0x32
 0x01
 0x02

v[2]
0x32

source
Base.Docs.@html_str
—
Macro
@html_str -> Docs.HTML

Create an HTML object from a literal string.

Examples

html"Julia"
HTML{String}("Julia")

source
Base.Docs.@text_str
—
Macro
@text_str -> Docs.Text

Create a Text object from a literal string.

Examples

text"Julia"
Julia

source
Base.isvalid
—
Method
isvalid(value) -> Bool

Return true if the given value is valid for its type, which currently can be either AbstractChar or String or SubString{String}.

Examples

isvalid(Char(0xd800))
false

isvalid(SubString(String(UInt8[0xfe,0x80,0x80,0x80,0x80,0x80]),1,2))
false

isvalid(Char(0xd799))
true

source
Base.isvalid
—
Method
isvalid(T, value) -> Bool

Return true if the given value is valid for that type. Types currently can be either AbstractChar or String. Values for AbstractChar can be of type AbstractChar or UInt32. Values for String can be of that type, SubString{String}, Vector{UInt8}, or a contiguous subarray thereof.

Examples

isvalid(Char, 0xd800)
false

isvalid(String, SubString("thisisvalid",1,5))
true

isvalid(Char, 0xd799)
true

Julia 1.6
Support for subarray values was added in Julia 1.6.

source
Base.isvalid
—
Method
isvalid(s::AbstractString, i::Integer) -> Bool

Predicate indicating whether the given index is the start of the encoding of a character in s or not. If isvalid(s, i) is true then s[i] will return the character whose encoding starts at that index, if it's false, then s[i] will raise an invalid index error or a bounds error depending on if i is in bounds. In order for isvalid(s, i) to be an O(1) function, the encoding of s must be self-synchronizing. This is a basic assumption of Julia's generic string support.

See also getindex, iterate, thisind, nextind, prevind, length.

Examples

str = "αβγdef";

isvalid(str, 1)
true

str[1]
'α': Unicode U+03B1 (category Ll: Letter, lowercase)

isvalid(str, 2)
false

str[2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'α', [3]=>'β'
Stacktrace:
[...]

source
Base.match
—
Function
match(r::Regex, s::AbstractString[, idx::Integer[, addopts]])

Search for the first match of the regular expression r in s and return a RegexMatch object containing the match, or nothing if the match failed. The matching substring can be retrieved by accessing m.match and the captured sequences can be retrieved by accessing m.captures The optional idx argument specifies an index at which to start the search.

Examples

rx = r"a(.)a"
r"a(.)a"

m = match(rx, "cabac")
RegexMatch("aba", 1="b")

m.captures
1-element Vector{Union{Nothing, SubString{String}}}:
 "b"

m.match
"aba"

match(rx, "cabac", 3) === nothing
true

source
Base.eachmatch
—
Function
eachmatch(r::Regex, s::AbstractString; overlap::Bool=false)

Search for all matches of the regular expression r in s and return an iterator over the matches. If overlap is true, the matching sequences are allowed to overlap indices in the original string, otherwise they must be from distinct character ranges.

Examples

rx = r"a.a"
r"a.a"

m = eachmatch(rx, "a1a2a3a")
Base.RegexMatchIterator(r"a.a", "a1a2a3a", false)

collect(m)
2-element Vector{RegexMatch}:
 RegexMatch("a1a")
 RegexMatch("a3a")

collect(eachmatch(rx, "a1a2a3a", overlap = true))
3-element Vector{RegexMatch}:
 RegexMatch("a1a")
 RegexMatch("a2a")
 RegexMatch("a3a")

source
Base.RegexMatch
—
Type
RegexMatch <: AbstractMatch

A type representing a single match to a Regex found in a string. Typically created from the match function.

The match field stores the substring of the entire matched string. The captures field stores the substrings for each capture group, indexed by number. To index by capture group name, the entire match object should be indexed instead, as shown in the examples. The location of the start of the match is stored in the offset field. The offsets field stores the locations of the start of each capture group, with 0 denoting a group that was not captured.

This type can be used as an iterator over the capture groups of the Regex, yielding the substrings captured in each group. Because of this, the captures of a match can be destructured. If a group was not captured, nothing will be yielded instead of a substring.

Methods that accept a RegexMatch object are defined for iterate, length, eltype, keys, haskey, and getindex, where keys are the the names or numbers of a capture group. See keys for more information.

Examples

m = match(r"(?<hour>\d+):(?<minute>\d+)(am|pm)?", "11:30 in the morning")
RegexMatch("11:30", hour="11", minute="30", 3=nothing)

m.match
"11:30"

m.captures
3-element Vector{Union{Nothing, SubString{String}}}:
 "11"
 "30"
 nothing


m["minute"]
"30"

hr, min, ampm = m; # destructure capture groups by iteration

hr
"11"

source
Base.keys
—
Method
keys(m::RegexMatch) -> Vector

Return a vector of keys for all capture groups of the underlying regex. A key is included even if the capture group fails to match. That is, idx will be in the return value even if m[idx] == nothing.

Unnamed capture groups will have integer keys corresponding to their index. Named capture groups will have string keys.

Julia 1.7
This method was added in Julia 1.7

Examples

keys(match(r"(?<hour>\d+):(?<minute>\d+)(am|pm)?", "11:30"))
3-element Vector{Any}:
  "hour"
  "minute"
 3

source
Base.isless
—
Method
isless(a::AbstractString, b::AbstractString) -> Bool

Test whether string a comes before string b in alphabetical order (technically, in lexicographical order by Unicode code points).

Examples

isless("a", "b")
true

isless("β", "α")
false

isless("a", "a")
false

source
Base.:==
—
Method
==(a::AbstractString, b::AbstractString) -> Bool

Test whether two strings are equal character by character (technically, Unicode code point by code point).

Examples

"abc" == "abc"
true

"abc" == "αβγ"
false

source
Base.cmp
—
Method
cmp(a::AbstractString, b::AbstractString) -> Int

Compare two strings. Return 0 if both strings have the same length and the character at each index is the same in both strings. Return -1 if a is a prefix of b, or if a comes before b in alphabetical order. Return 1 if b is a prefix of a, or if b comes before a in alphabetical order (technically, lexicographical order by Unicode code points).

Examples

cmp("abc", "abc")
0

cmp("ab", "abc")
-1

cmp("abc", "ab")
1

cmp("ab", "ac")
-1

cmp("ac", "ab")
1

cmp("α", "a")
1

cmp("b", "β")
-1

source
Base.lpad
—
Function
lpad(s, n::Integer, p::Union{AbstractChar,AbstractString}=' ') -> String

Stringify s and pad the resulting string on the left with p to make it n characters (in textwidth) long. If s is already n characters long, an equal string is returned. Pad with spaces by default.

Examples

lpad("March", 10)
"     March"

Julia 1.7
In Julia 1.7, this function was changed to use textwidth rather than a raw character (codepoint) count.

source
Base.rpad
—
Function
rpad(s, n::Integer, p::Union{AbstractChar,AbstractString}=' ') -> String

Stringify s and pad the resulting string on the right with p to make it n characters (in textwidth) long. If s is already n characters long, an equal string is returned. Pad with spaces by default.

Examples

rpad("March", 20)
"March               "

Julia 1.7
In Julia 1.7, this function was changed to use textwidth rather than a raw character (codepoint) count.

source
Base.findfirst
—
Method
findfirst(pattern::AbstractString, string::AbstractString)
findfirst(pattern::AbstractPattern, string::String)

Find the first occurrence of pattern in string. Equivalent to findnext(pattern, string, firstindex(s)).

Examples

findfirst("z", "Hello to the world") # returns nothing, but not printed in the REPL

findfirst("Julia", "JuliaLang")
1:5

source
Base.findnext
—
Method
findnext(pattern::AbstractString, string::AbstractString, start::Integer)
findnext(pattern::AbstractPattern, string::String, start::Integer)

Find the next occurrence of pattern in string starting at position start. pattern can be either a string, or a regular expression, in which case string must be of type String.

The return value is a range of indices where the matching sequence is found, such that s[findnext(x, s, i)] == x:

findnext("substring", string, i) == start:stop such that string[start:stop] == "substring" and i <= start, or nothing if unmatched.

Examples

findnext("z", "Hello to the world", 1) === nothing
true

findnext("o", "Hello to the world", 6)
8:8

findnext("Lang", "JuliaLang", 2)
6:9

source
Base.findnext
—
Method
findnext(ch::AbstractChar, string::AbstractString, start::Integer)

Find the next occurrence of character ch in string starting at position start.

Julia 1.3
This method requires at least Julia 1.3.

Examples

findnext('z', "Hello to the world", 1) === nothing
true

findnext('o', "Hello to the world", 6)
8

source
Base.findlast
—
Method
findlast(pattern::AbstractString, string::AbstractString)

Find the last occurrence of pattern in string. Equivalent to findprev(pattern, string, lastindex(string)).

Examples

findlast("o", "Hello to the world")
15:15

findfirst("Julia", "JuliaLang")
1:5

source
Base.findlast
—
Method
findlast(ch::AbstractChar, string::AbstractString)

Find the last occurrence of character ch in string.

Julia 1.3
This method requires at least Julia 1.3.

Examples

findlast('p', "happy")
4

findlast('z', "happy") === nothing
true

source
Base.findprev
—
Method
findprev(pattern::AbstractString, string::AbstractString, start::Integer)

Find the previous occurrence of pattern in string starting at position start.

The return value is a range of indices where the matching sequence is found, such that s[findprev(x, s, i)] == x:

findprev("substring", string, i) == start:stop such that string[start:stop] == "substring" and stop <= i, or nothing if unmatched.

Examples

findprev("z", "Hello to the world", 18) === nothing
true

findprev("o", "Hello to the world", 18)
15:15

findprev("Julia", "JuliaLang", 6)
1:5

source
Base.occursin
—
Function
occursin(needle::Union{AbstractString,AbstractPattern,AbstractChar}, haystack::AbstractString)

Determine whether the first argument is a substring of the second. If needle is a regular expression, checks whether haystack contains a match.

Examples

occursin("Julia", "JuliaLang is pretty cool!")
true

occursin('a', "JuliaLang is pretty cool!")
true

occursin(r"a.a", "aba")
true

occursin(r"a.a", "abba")
false

See also contains.

source
occursin(haystack)

Create a function that checks whether its argument occurs in haystack, i.e. a function equivalent to needle -> occursin(needle, haystack).

The returned function is of type Base.Fix2{typeof(occursin)}.

Julia 1.6
This method requires Julia 1.6 or later.

Examples

search_f = occursin("JuliaLang is a programming language");

search_f("JuliaLang")
true

search_f("Python")
false

source
Base.reverse
—
Method
reverse(s::AbstractString) -> AbstractString

Reverses a string. Technically, this function reverses the codepoints in a string and its main utility is for reversed-order string processing, especially for reversed regular-expression searches. See also reverseind to convert indices in s to indices in reverse(s) and vice-versa, and graphemes from module Unicode to operate on user-visible "characters" (graphemes) rather than codepoints. See also Iterators.reverse for reverse-order iteration without making a copy. Custom string types must implement the reverse function themselves and should typically return a string with the same type and encoding. If they return a string with a different encoding, they must also override reverseind for that string type to satisfy s[reverseind(s,i)] == reverse(s)[i].

Examples

reverse("JuliaLang")
"gnaLailuJ"

Note
The examples below may be rendered differently on different systems. The comments indicate how they're supposed to be rendered

Combining characters can lead to surprising results:

reverse("ax̂e") # hat is above x in the input, above e in the output
"êxa"

using Unicode

join(reverse(collect(graphemes("ax̂e")))) # reverses graphemes; hat is above x in both in- and output
"ex̂a"

source
Base.replace
—
Method
replace([io::IO], s::AbstractString, pat=>r, [pat2=>r2, ...]; [count::Integer])

Search for the given pattern pat in s, and replace each occurrence with r. If count is provided, replace at most count occurrences. pat may be a single character, a vector or a set of characters, a string, or a regular expression. If r is a function, each occurrence is replaced with r(s) where s is the matched substring (when pat is a AbstractPattern or AbstractString) or character (when pat is an AbstractChar or a collection of AbstractChar). If pat is a regular expression and r is a SubstitutionString, then capture group references in r are replaced with the corresponding matched text. To remove instances of pat from string, set r to the empty String ("").

The return value is a new string after the replacements. If the io::IO argument is supplied, the transformed string is instead written to io (returning io). (For example, this can be used in conjunction with an IOBuffer to re-use a pre-allocated buffer array in-place.)

Multiple patterns can be specified, and they will be applied left-to-right simultaneously, so only one pattern will be applied to any character, and the patterns will only be applied to the input text, not the replacements.

Julia 1.7
Support for multiple patterns requires version 1.7.

Julia 1.10
The io::IO argument requires version 1.10.

Examples

replace("Python is a programming language.", "Python" => "Julia")
"Julia is a programming language."

replace("The quick foxes run quickly.", "quick" => "slow", count=1)
"The slow foxes run quickly."

replace("The quick foxes run quickly.", "quick" => "", count=1)
"The  foxes run quickly."

replace("The quick foxes run quickly.", r"fox(es)?" => s"bus\1")
"The quick buses run quickly."

replace("abcabc", "a" => "b", "b" => "c", r".+" => "a")
"bca"

source
Base.eachsplit
—
Function
eachsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
eachsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)

Split str on occurrences of the delimiter(s) dlm and return an iterator over the substrings. dlm can be any of the formats allowed by findnext's first argument (i.e. as a string, regular expression or a function), or as a single character or collection of characters.

If dlm is omitted, it defaults to isspace.

The optional keyword arguments are:

limit: the maximum size of the result. limit=0 implies no maximum (default)
keepempty: whether empty fields should be kept in the result. Default is false without a dlm argument, true with a dlm argument.
See also split.

Julia 1.8
The eachsplit function requires at least Julia 1.8.

Examples

a = "Ma.rch"
"Ma.rch"

b = eachsplit(a, ".")
Base.SplitIterator{String, String}("Ma.rch", ".", 0, true)

collect(b)
2-element Vector{SubString{String}}:
 "Ma"
 "rch"

source
Base.split
—
Function
split(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
split(str::AbstractString; limit::Integer=0, keepempty::Bool=false)

Split str into an array of substrings on occurrences of the delimiter(s) dlm. dlm can be any of the formats allowed by findnext's first argument (i.e. as a string, regular expression or a function), or as a single character or collection of characters.

If dlm is omitted, it defaults to isspace.

The optional keyword arguments are:

limit: the maximum size of the result. limit=0 implies no maximum (default)
keepempty: whether empty fields should be kept in the result. Default is false without a dlm argument, true with a dlm argument.
See also rsplit, eachsplit.

Examples

a = "Ma.rch"
"Ma.rch"

split(a, ".")
2-element Vector{SubString{String}}:
 "Ma"
 "rch"

source
Base.rsplit
—
Function
rsplit(s::AbstractString; limit::Integer=0, keepempty::Bool=false)
rsplit(s::AbstractString, chars; limit::Integer=0, keepempty::Bool=true)

Similar to split, but starting from the end of the string.

Examples

a = "M.a.r.c.h"
"M.a.r.c.h"

rsplit(a, ".")
5-element Vector{SubString{String}}:
 "M"
 "a"
 "r"
 "c"
 "h"

rsplit(a, "."; limit=1)
1-element Vector{SubString{String}}:
 "M.a.r.c.h"

rsplit(a, "."; limit=2)
2-element Vector{SubString{String}}:
 "M.a.r.c"
 "h"

source
Base.strip
—
Function
strip([pred=isspace,] str::AbstractString) -> SubString
strip(str::AbstractString, chars) -> SubString

Remove leading and trailing characters from str, either those specified by chars or those for which the function pred returns true.

The default behaviour is to remove leading and trailing whitespace and delimiters: see isspace for precise details.

The optional chars argument specifies which characters to remove: it can be a single character, vector or set of characters.

See also lstrip and rstrip.

Julia 1.2
The method which accepts a predicate function requires Julia 1.2 or later.

Examples

strip("{3, 5}\n", ['{', '}', '\n'])
"3, 5"

source
Base.lstrip
—
Function
lstrip([pred=isspace,] str::AbstractString) -> SubString
lstrip(str::AbstractString, chars) -> SubString

Remove leading characters from str, either those specified by chars or those for which the function pred returns true.

The default behaviour is to remove leading whitespace and delimiters: see isspace for precise details.

The optional chars argument specifies which characters to remove: it can be a single character, or a vector or set of characters.

See also strip and rstrip.

Examples

a = lpad("March", 20)
"               March"

lstrip(a)
"March"

source
Base.rstrip
—
Function
rstrip([pred=isspace,] str::AbstractString) -> SubString
rstrip(str::AbstractString, chars) -> SubString

Remove trailing characters from str, either those specified by chars or those for which the function pred returns true.

The default behaviour is to remove trailing whitespace and delimiters: see isspace for precise details.

The optional chars argument specifies which characters to remove: it can be a single character, or a vector or set of characters.

See also strip and lstrip.

Examples

a = rpad("March", 20)
"March               "

rstrip(a)
"March"

source
Base.startswith
—
Function
startswith(s::AbstractString, prefix::AbstractString)

Return true if s starts with prefix. If prefix is a vector or set of characters, test whether the first character of s belongs to that set.

See also endswith, contains.

Examples

startswith("JuliaLang", "Julia")
true

source
startswith(io::IO, prefix::Union{AbstractString,Base.Chars})

Check if an IO object starts with a prefix. See also peek.

source
startswith(prefix)

Create a function that checks whether its argument starts with prefix, i.e. a function equivalent to y -> startswith(y, prefix).

The returned function is of type Base.Fix2{typeof(startswith)}, which can be used to implement specialized methods.

Julia 1.5
The single argument startswith(prefix) requires at least Julia 1.5.

Examples

startswith("Julia")("JuliaLang")
true

startswith("Julia")("Ends with Julia")
false

source
startswith(s::AbstractString, prefix::Regex)

Return true if s starts with the regex pattern, prefix.

Note
startswith does not compile the anchoring into the regular expression, but instead passes the anchoring as match_option to PCRE. If compile time is amortized, occursin(r"^...", s) is faster than startswith(s, r"...").

See also occursin and endswith.

Julia 1.2
This method requires at least Julia 1.2.

Examples

startswith("JuliaLang", r"Julia|Romeo")
true

source
Base.endswith
—
Function
endswith(s::AbstractString, suffix::AbstractString)

Return true if s ends with suffix. If suffix is a vector or set of characters, test whether the last character of s belongs to that set.

See also startswith, contains.

Examples

endswith("Sunday", "day")
true

source
endswith(suffix)

Create a function that checks whether its argument ends with suffix, i.e. a function equivalent to y -> endswith(y, suffix).

The returned function is of type Base.Fix2{typeof(endswith)}, which can be used to implement specialized methods.

Julia 1.5
The single argument endswith(suffix) requires at least Julia 1.5.

Examples

endswith("Julia")("Ends with Julia")
true

endswith("Julia")("JuliaLang")
false

source
endswith(s::AbstractString, suffix::Regex)

Return true if s ends with the regex pattern, suffix.

Note
endswith does not compile the anchoring into the regular expression, but instead passes the anchoring as match_option to PCRE. If compile time is amortized, occursin(r"...$", s) is faster than endswith(s, r"...").

See also occursin and startswith.

Julia 1.2
This method requires at least Julia 1.2.

Examples

endswith("JuliaLang", r"Lang|Roberts")
true

source
Base.contains
—
Function
contains(haystack::AbstractString, needle)

Return true if haystack contains needle. This is the same as occursin(needle, haystack), but is provided for consistency with startswith(haystack, needle) and endswith(haystack, needle).

See also occursin, in, issubset.

Examples

contains("JuliaLang is pretty cool!", "Julia")
true

contains("JuliaLang is pretty cool!", 'a')
true

contains("aba", r"a.a")
true

contains("abba", r"a.a")
false

Julia 1.5
The contains function requires at least Julia 1.5.

source
contains(needle)

Create a function that checks whether its argument contains needle, i.e. a function equivalent to haystack -> contains(haystack, needle).

The returned function is of type Base.Fix2{typeof(contains)}, which can be used to implement specialized methods.

source
Base.first
—
Method
first(s::AbstractString, n::Integer)

Get a string consisting of the first n characters of s.

Examples

first("∀ϵ≠0: ϵ²>0", 0)
""

first("∀ϵ≠0: ϵ²>0", 1)
"∀"

first("∀ϵ≠0: ϵ²>0", 3)
"∀ϵ≠"

source
Base.last
—
Method
last(s::AbstractString, n::Integer)

Get a string consisting of the last n characters of s.

Examples

last("∀ϵ≠0: ϵ²>0", 0)
""

last("∀ϵ≠0: ϵ²>0", 1)
"0"

last("∀ϵ≠0: ϵ²>0", 3)
"²>0"

source
Base.Unicode.uppercase
—
Function
uppercase(c::AbstractChar)

Convert c to uppercase.

See also lowercase, titlecase.

Examples

uppercase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

uppercase('ê')
'Ê': Unicode U+00CA (category Lu: Letter, uppercase)

source
uppercase(s::AbstractString)

Return s with all characters converted to uppercase.

See also lowercase, titlecase, uppercasefirst.

Examples

uppercase("Julia")
"JULIA"

source
Base.Unicode.lowercase
—
Function
lowercase(c::AbstractChar)

Convert c to lowercase.

See also uppercase, titlecase.

Examples

lowercase('A')
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

lowercase('Ö')
'ö': Unicode U+00F6 (category Ll: Letter, lowercase)

source
lowercase(s::AbstractString)

Return s with all characters converted to lowercase.

See also uppercase, titlecase, lowercasefirst.

Examples

lowercase("STRINGS AND THINGS")
"strings and things"

source
Base.Unicode.titlecase
—
Function
titlecase(c::AbstractChar)

Convert c to titlecase. This may differ from uppercase for digraphs, compare the example below.

See also uppercase, lowercase.

Examples

titlecase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

titlecase('ǆ')
'ǅ': Unicode U+01C5 (category Lt: Letter, titlecase)

uppercase('ǆ')
'Ǆ': Unicode U+01C4 (category Lu: Letter, uppercase)

source
titlecase(s::AbstractString; [wordsep::Function], strict::Bool=true) -> String

Capitalize the first character of each word in s; if strict is true, every other character is converted to lowercase, otherwise they are left unchanged. By default, all non-letters beginning a new grapheme are considered as word separators; a predicate can be passed as the wordsep keyword to determine which characters should be considered as word separators. See also uppercasefirst to capitalize only the first character in s.

See also uppercase, lowercase, uppercasefirst.

Examples

titlecase("the JULIA programming language")
"The Julia Programming Language"

titlecase("ISS - international space station", strict=false)
"ISS - International Space Station"

titlecase("a-a b-b", wordsep = c->c==' ')
"A-a B-b"

source
Base.Unicode.uppercasefirst
—
Function
uppercasefirst(s::AbstractString) -> String

Return s with the first character converted to uppercase (technically "title case" for Unicode). See also titlecase to capitalize the first character of every word in s.

See also lowercasefirst, uppercase, lowercase, titlecase.

Examples

uppercasefirst("python")
"Python"

source
Base.Unicode.lowercasefirst
—
Function
lowercasefirst(s::AbstractString)

Return s with the first character converted to lowercase.

See also uppercasefirst, uppercase, lowercase, titlecase.

Examples

lowercasefirst("Julia")
"julia"

source
Base.join
—
Function
join([io::IO,] iterator [, delim [, last]])

Join any iterator into a single string, inserting the given delimiter (if any) between adjacent items. If last is given, it will be used instead of delim between the last two items. Each item of iterator is converted to a string via print(io::IOBuffer, x). If io is given, the result is written to io rather than returned as a String.

Examples

join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"

join([1,2,3,4,5])
"12345"

source
Base.chop
—
Function
chop(s::AbstractString; head::Integer = 0, tail::Integer = 1)

Remove the first head and the last tail characters from s. The call chop(s) removes the last character from s. If it is requested to remove more characters than length(s) then an empty string is returned.

See also chomp, startswith, first.

Examples

a = "March"
"March"

chop(a)
"Marc"

chop(a, head = 1, tail = 2)
"ar"

chop(a, head = 5, tail = 5)
""

source
Base.chopprefix
—
Function
chopprefix(s::AbstractString, prefix::Union{AbstractString,Regex}) -> SubString

Remove the prefix prefix from s. If s does not start with prefix, a string equal to s is returned.

See also chopsuffix.

Julia 1.8
This function is available as of Julia 1.8.

Examples

chopprefix("Hamburger", "Ham")
"burger"

chopprefix("Hamburger", "hotdog")
"Hamburger"

source
Base.chopsuffix
—
Function
chopsuffix(s::AbstractString, suffix::Union{AbstractString,Regex}) -> SubString

Remove the suffix suffix from s. If s does not end with suffix, a string equal to s is returned.

See also chopprefix.

Julia 1.8
This function is available as of Julia 1.8.

Examples

chopsuffix("Hamburger", "er")
"Hamburg"

chopsuffix("Hamburger", "hotdog")
"Hamburger"

source
Base.chomp
—
Function
chomp(s::AbstractString) -> SubString

Remove a single trailing newline from a string.

See also chop.

Examples

chomp("Hello\n")
"Hello"

source
Base.thisind
—
Function
thisind(s::AbstractString, i::Integer) -> Int

If i is in bounds in s return the index of the start of the character whose encoding code unit i is part of. In other words, if i is the start of a character, return i; if i is not the start of a character, rewind until the start of a character and return that index. If i is equal to 0 or ncodeunits(s)+1 return i. In all other cases throw BoundsError.

Examples

thisind("α", 0)
0

thisind("α", 1)
1

thisind("α", 2)
1

thisind("α", 3)
3

thisind("α", 4)
ERROR: BoundsError: attempt to access 2-codeunit String at index [4]
[...]

thisind("α", -1)
ERROR: BoundsError: attempt to access 2-codeunit String at index [-1]
[...]

source
Base.nextind
—
Function
nextind(str::AbstractString, i::Integer, n::Integer=1) -> Int

Case n == 1

If i is in bounds in s return the index of the start of the character whose encoding starts after index i. In other words, if i is the start of a character, return the start of the next character; if i is not the start of a character, move forward until the start of a character and return that index. If i is equal to 0 return 1. If i is in bounds but greater or equal to lastindex(str) return ncodeunits(str)+1. Otherwise throw BoundsError.

Case n > 1

Behaves like applying n times nextind for n==1. The only difference is that if n is so large that applying nextind would reach ncodeunits(str)+1 then each remaining iteration increases the returned value by 1. This means that in this case nextind can return a value greater than ncodeunits(str)+1.

Case n == 0

Return i only if i is a valid index in s or is equal to 0. Otherwise StringIndexError or BoundsError is thrown.

Examples

nextind("α", 0)
1

nextind("α", 1)
3

nextind("α", 3)
ERROR: BoundsError: attempt to access 2-codeunit String at index [3]
[...]

nextind("α", 0, 2)
3

nextind("α", 1, 2)
4

source
Base.prevind
—
Function
prevind(str::AbstractString, i::Integer, n::Integer=1) -> Int

Case n == 1

If i is in bounds in s return the index of the start of the character whose encoding starts before index i. In other words, if i is the start of a character, return the start of the previous character; if i is not the start of a character, rewind until the start of a character and return that index. If i is equal to 1 return 0. If i is equal to ncodeunits(str)+1 return lastindex(str). Otherwise throw BoundsError.

Case n > 1

Behaves like applying n times prevind for n==1. The only difference is that if n is so large that applying prevind would reach 0 then each remaining iteration decreases the returned value by 1. This means that in this case prevind can return a negative value.

Case n == 0

Return i only if i is a valid index in str or is equal to ncodeunits(str)+1. Otherwise StringIndexError or BoundsError is thrown.

Examples

prevind("α", 3)
1

prevind("α", 1)
0

prevind("α", 0)
ERROR: BoundsError: attempt to access 2-codeunit String at index [0]
[...]

prevind("α", 2, 2)
0

prevind("α", 2, 3)
-1

source
Base.Unicode.textwidth
—
Function
textwidth(c)

Give the number of columns needed to print a character.

Examples

textwidth('α')
1

textwidth('⛵')
2

source
textwidth(s::AbstractString)

Give the number of columns needed to print a string.

Examples

textwidth("March")
5

source
Base.isascii
—
Function
isascii(c::Union{AbstractChar,AbstractString}) -> Bool

Test whether a character belongs to the ASCII character set, or whether this is true for all elements of a string.

Examples

isascii('a')
true

isascii('α')
false

isascii("abc")
true

isascii("αβγ")
false

For example, isascii can be used as a predicate function for filter or replace to remove or replace non-ASCII characters, respectively:

filter(isascii, "abcdeγfgh") # discard non-ASCII chars
"abcdefgh"

replace("abcdeγfgh", !isascii=>' ') # replace non-ASCII chars with spaces
"abcde fgh"

source
isascii(cu::AbstractVector{CU}) where {CU <: Integer} -> Bool

Test whether all values in the vector belong to the ASCII character set (0x00 to 0x7f). This function is intended to be used by other string implementations that need a fast ASCII check.

source
Base.Unicode.iscntrl
—
Function
iscntrl(c::AbstractChar) -> Bool

Tests whether a character is a control character. Control characters are the non-printing characters of the Latin-1 subset of Unicode.

Examples

iscntrl('\x01')
true

iscntrl('a')
false

source
Base.Unicode.isdigit
—
Function
isdigit(c::AbstractChar) -> Bool

Tests whether a character is a decimal digit (0-9).

See also: isletter.

Examples

isdigit('❤')
false

isdigit('9')
true

isdigit('α')
false

source
Base.Unicode.isletter
—
Function
isletter(c::AbstractChar) -> Bool

Test whether a character is a letter. A character is classified as a letter if it belongs to the Unicode general category Letter, i.e. a character whose category code begins with 'L'.

See also: isdigit.

Examples

isletter('❤')
false

isletter('α')
true

isletter('9')
false

source
Base.Unicode.islowercase
—
Function
islowercase(c::AbstractChar) -> Bool

Tests whether a character is a lowercase letter (according to the Unicode standard's Lowercase derived property).

See also isuppercase.

Examples

islowercase('α')
true

islowercase('Γ')
false

islowercase('❤')
false

source
Base.Unicode.isnumeric
—
Function
isnumeric(c::AbstractChar) -> Bool

Tests whether a character is numeric. A character is classified as numeric if it belongs to the Unicode general category Number, i.e. a character whose category code begins with 'N'.

Note that this broad category includes characters such as ¾ and ௰. Use isdigit to check whether a character is a decimal digit between 0 and 9.

Examples

isnumeric('௰')
true

isnumeric('9')
true

isnumeric('α')
false

isnumeric('❤')
false

source
Base.Unicode.isprint
—
Function
isprint(c::AbstractChar) -> Bool

Tests whether a character is printable, including spaces, but not a control character.

Examples

isprint('\x01')
false

isprint('A')
true

source
Base.Unicode.ispunct
—
Function
ispunct(c::AbstractChar) -> Bool

Tests whether a character belongs to the Unicode general category Punctuation, i.e. a character whose category code begins with 'P'.

Examples

ispunct('α')
false

ispunct('/')
true

ispunct(';')
true

source
Base.Unicode.isspace
—
Function
isspace(c::AbstractChar) -> Bool

Tests whether a character is any whitespace character. Includes ASCII characters '\t', '\n', '\v', '\f', '\r', and ' ', Latin-1 character U+0085, and characters in Unicode category Zs.

Examples

isspace('\n')
true

isspace('\r')
true

isspace(' ')
true

isspace('\x20')
true

source
Base.Unicode.isuppercase
—
Function
isuppercase(c::AbstractChar) -> Bool

Tests whether a character is an uppercase letter (according to the Unicode standard's Uppercase derived property).

See also islowercase.

Examples

isuppercase('γ')
false

isuppercase('Γ')
true

isuppercase('❤')
false

source
Base.Unicode.isxdigit
—
Function
isxdigit(c::AbstractChar) -> Bool

Test whether a character is a valid hexadecimal digit. Note that this does not include x (as in the standard 0x prefix).

Examples

isxdigit('a')
true

isxdigit('x')
false

source
Base.escape_string
—
Function
escape_string(str::AbstractString[, esc]; keep = ())::AbstractString
escape_string(io, str::AbstractString[, esc]; keep = ())::Nothing

General escaping of traditional C and Unicode escape sequences. The first form returns the escaped string, the second prints the result to io.

Backslashes (\) are escaped with a double-backslash ("\\"). Non-printable characters are escaped either with their standard C escape codes, "\0" for NUL (if unambiguous), unicode code point ("\u" prefix) or hex ("\x" prefix).

The optional esc argument specifies any additional characters that should also be escaped by a prepending backslash (" is also escaped by default in the first form).

The argument keep specifies a collection of characters which are to be kept as they are. Notice that esc has precedence here.

See also unescape_string for the reverse operation.

Julia 1.7
The keep argument is available as of Julia 1.7.

Examples

escape_string("aaa\nbbb")
"aaa\\nbbb"

escape_string("aaa\nbbb"; keep = '\n')
"aaa\nbbb"

escape_string("\xfe\xff") # invalid utf-8
"\\xfe\\xff"

escape_string(string('\u2135','\0')) # unambiguous
"ℵ\\0"

escape_string(string('\u2135','\0','0')) # \0 would be ambiguous
"ℵ\\x000"

source
Base.unescape_string
—
Function
unescape_string(str::AbstractString, keep = ())::AbstractString
unescape_string(io, s::AbstractString, keep = ())::Nothing

General unescaping of traditional C and Unicode escape sequences. The first form returns the escaped string, the second prints the result to io. The argument keep specifies a collection of characters which (along with backlashes) are to be kept as they are.

The following escape sequences are recognised:

Escaped backslash (\\)
Escaped double-quote (\")
Standard C escape sequences (\a, \b, \t, \n, \v, \f, \r, \e)
Unicode BMP code points (\u with 1-4 trailing hex digits)
All Unicode code points (\U with 1-8 trailing hex digits; max value = 0010ffff)
Hex bytes (\x with 1-2 trailing hex digits)
Octal bytes (\ with 1-3 trailing octal digits)
See also escape_string.

Examples

unescape_string("aaa\\nbbb") # C escape sequence
"aaa\nbbb"

unescape_string("\\u03c0") # unicode
"π"

unescape_string("\\101") # octal
"A"

unescape_string("aaa \\g \\n", ['g']) # using `keep` argument
"aaa \\g \n"
