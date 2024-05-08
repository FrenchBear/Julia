# base_io_net.jl
# Julia Base doc, I/O and Network
# 
# 2024-05-01    PV


# I/O and Network

General I/O
Base.stdout
Constant
stdout::IO

Global variable referring to the standard out stream.

# -------------------------
Base.stderr
Constant
stderr::IO

Global variable referring to the standard error stream.

# -------------------------
Base.stdin
Constant
stdin::IO

Global variable referring to the standard input stream.

# -------------------------
Base.open
Function open(f::Function, args...; kwargs...)

Apply the function f to the result of open(args...; kwargs...) and close the resulting file descriptor upon completion.


write("myfile.txt", "Hello world!");

open(io->read(io, String), "myfile.txt")
"Hello world!"

rm("myfile.txt")

# -------------------------
open(filename::AbstractString; lock = true, keywords...) -> IOStream

Open a file in a mode specified by five boolean keyword arguments:

Keyword	Description	Default
read	open for reading	!write
write	open for writing	truncate | append
create	create if non-existent	!read & write | truncate | append
truncate	truncate to zero size	!read & write
append	seek to end	false
The default when no keywords are passed is to open files for reading only. Returns a stream for accessing the opened file.

The lock keyword argument controls whether operations will be locked for safe multi-threaded access.

Julia 1.5
The lock argument is available as of Julia 1.5.

# -------------------------
open(filename::AbstractString, [mode::AbstractString]; lock = true) -> IOStream

Alternate syntax for open, where a string-based mode specifier is used instead of the five booleans. The values of mode correspond to those from fopen(3) or Perl open, and are equivalent to setting the following boolean groups:

Mode	Description	Keywords
r	read	none
w	write, create, truncate	write = true
a	write, create, append	append = true
r+	read, write	read = true, write = true
w+	read, write, create, truncate	truncate = true, read = true
a+	read, write, create, append	append = true, read = true
The lock keyword argument controls whether operations will be locked for safe multi-threaded access.


io = open("myfile.txt", "w");

write(io, "Hello world!");

close(io);

io = open("myfile.txt", "r");

read(io, String)
"Hello world!"

write(io, "This file is read only")
ERROR: ArgumentError: write failed, IOStream is not writeable
[...]

close(io)

io = open("myfile.txt", "a");

write(io, "This stream is not read only")
28

close(io)

rm("myfile.txt")

Julia 1.5
The lock argument is available as of Julia 1.5.

# -------------------------
open(fd::OS_HANDLE) -> IO

Take a raw file descriptor wrap it in a Julia-aware IO type, and take ownership of the fd handle. Call open(Libc.dup(fd)) to avoid the ownership capture of the original handle.

Warning
Do not call this on a handle that's already owned by some other part of the system.

# -------------------------
open(command, mode::AbstractString, stdio=devnull)

Run command asynchronously. Like open(command, stdio; read, write) except specifying the read and write flags via a mode string instead of keyword arguments. Possible mode strings are:

Mode	Description	Keywords
r	read	none
w	write	write = true
r+	read, write	read = true, write = true
w+	read, write	read = true, write = true
# -------------------------
open(command, stdio=devnull; write::Bool = false, read::Bool = !write)

Start running command asynchronously, and return a process::IO object. If read is true, then reads from the process come from the process's standard output and stdio optionally specifies the process's standard input stream. If write is true, then writes go to the process's standard input and stdio optionally specifies the process's standard output stream. The process's standard error stream is connected to the current global stderr.

# -------------------------
open(f::Function, command, args...; kwargs...)

Similar to open(command, args...; kwargs...), but calls f(stream) on the resulting process stream, then closes the input stream and waits for the process to complete. Return the value returned by f on success. Throw an error if the process failed, or if the process attempts to print anything to stdout.

# -------------------------
Base.IOStream
Type IOStream

A buffered IO stream wrapping an OS file descriptor. Mostly used to represent files returned by open.

# -------------------------
Base.IOBuffer
Type IOBuffer([data::AbstractVector{UInt8}]; keywords...) -> IOBuffer

Create an in-memory I/O stream, which may optionally operate on a pre-existing array.

It may take optional keyword arguments:

read, write, append: restricts operations to the buffer; see open for details.
truncate: truncates the buffer size to zero length.
maxsize: specifies a size beyond which the buffer may not be grown.
sizehint: suggests a capacity of the buffer (data must implement sizehint!(data, size)).
When data is not given, the buffer will be both readable and writable by default.


io = IOBuffer();

write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

String(take!(io))
"JuliaLang is a GitHub organization. It has many members."

io = IOBuffer(b"JuliaLang is a GitHub organization.")
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=35, maxsize=Inf, ptr=1, mark=-1)

read(io, String)
"JuliaLang is a GitHub organization."

write(io, "This isn't writable.")
ERROR: ArgumentError: ensureroom failed, IOBuffer is not writeable

io = IOBuffer(UInt8[], read=true, write=true, maxsize=34)
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=0, maxsize=34, ptr=1, mark=-1)

write(io, "JuliaLang is a GitHub organization.")
34

String(take!(io))
"JuliaLang is a GitHub organization"

length(read(IOBuffer(b"data", read=true, truncate=false)))
4

length(read(IOBuffer(b"data", read=true, truncate=true)))
0

# -------------------------
IOBuffer(string::String)

Create a read-only IOBuffer on the data underlying the given string.


io = IOBuffer("Haho");

String(take!(io))
"Haho"

String(take!(io))
"Haho"

# -------------------------
Base.take!
Method take!(b::IOBuffer)

Obtain the contents of an IOBuffer as an array. Afterwards, the IOBuffer is reset to its initial state.


io = IOBuffer();

write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

String(take!(io))
"JuliaLang is a GitHub organization. It has many members."

# -------------------------
Base.fdio
Function fdio([name::AbstractString, ]fd::Integer[, own::Bool=false]) -> IOStream

Create an IOStream object from an integer file descriptor. If own is true, closing this object will close the underlying descriptor. By default, an IOStream is closed when it is garbage collected. name allows you to associate the descriptor with a named file.

# -------------------------
Base.flush
Function flush(stream)

Commit all currently buffered writes to the given stream.

# -------------------------
Base.close
Function close(stream)

Close an I/O stream. Performs a flush first.

# -------------------------
Base.closewrite
Function closewrite(stream)

Shutdown the write half of a full-duplex I/O stream. Performs a flush first. Notify the other end that no more data will be written to the underlying file. This is not supported by all IO types.


io = Base.BufferStream(); # this never blocks, so we can read and write on the same Task

write(io, "request");

# calling `read(io)` here would block forever

closewrite(io);

read(io, String)
"request"

# -------------------------
Base.write
Function write(io::IO, x)

Write the canonical binary representation of a value to the given I/O stream or file. Return the number of bytes written into the stream. See also print to write a text representation (with an encoding that may depend upon io).

The endianness of the written value depends on the endianness of the host system. Convert to/from a fixed endianness when writing/reading (e.g. using htol and ltoh) to get results that are consistent across platforms.

You can write multiple values with the same write call. i.e. the following are equivalent:

write(io, x, y...)
write(io, x) + write(io, y...)


Consistent serialization:

fname = tempname(); # random temporary filename

open(fname,"w") do f
           # Make sure we write 64bit integer in little-endian byte order
           write(f,htol(Int64(42)))
       end
8

open(fname,"r") do f
           # Convert back to host byte order and host integer type
           Int(ltoh(read(f,Int64)))
       end
42

Merging write calls:

io = IOBuffer();

write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

String(take!(io))
"JuliaLang is a GitHub organization. It has many members."

write(io, "Sometimes those members") + write(io, " write documentation.")
44

String(take!(io))
"Sometimes those members write documentation."

User-defined plain-data types without write methods can be written when wrapped in a Ref:

struct MyStruct; x::Float64; end

io = IOBuffer()
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=0, maxsize=Inf, ptr=1, mark=-1)

write(io, Ref(MyStruct(42.0)))
8

seekstart(io); read!(io, Ref(MyStruct(NaN)))
Base.RefValue{MyStruct}(MyStruct(42.0))

# -------------------------
Base.read
Function read(io::IO, T)

Read a single value of type T from io, in canonical binary representation.

Note that Julia does not convert the endianness for you. Use ntoh or ltoh for this purpose.

read(io::IO, String)

Read the entirety of io, as a String (see also readchomp).


io = IOBuffer("JuliaLang is a GitHub organization");

read(io, Char)
'J': ASCII/Unicode U+004A (category Lu: Letter, uppercase)

io = IOBuffer("JuliaLang is a GitHub organization");

read(io, String)
"JuliaLang is a GitHub organization"

# -------------------------
read(filename::AbstractString)

Read the entire contents of a file as a Vector{UInt8}.

read(filename::AbstractString, String)

Read the entire contents of a file as a string.

read(filename::AbstractString, args...)

Open a file and read its contents. args is passed to read: this is equivalent to open(io->read(io, args...), filename).

# -------------------------
read(s::IO, nb=typemax(Int))

Read at most nb bytes from s, returning a Vector{UInt8} of the bytes read.

# -------------------------
read(s::IOStream, nb::Integer; all=true)

Read at most nb bytes from s, returning a Vector{UInt8} of the bytes read.

If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

# -------------------------
read(command::Cmd)

Run command and return the resulting output as an array of bytes.

# -------------------------
read(command::Cmd, String)

Run command and return the resulting output as a String.

# -------------------------
Base.read!
Function read!(stream::IO, array::AbstractArray)
read!(filename::AbstractString, array::AbstractArray)

Read binary data from an I/O stream or file, filling in array.

# -------------------------
Base.readbytes!
Function readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))

Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.

# -------------------------
readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)

Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.

If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

# -------------------------
Base.unsafe_read
Function unsafe_read(io::IO, ref, nbytes::UInt)

Copy nbytes from the IO stream object into ref (converted to a pointer).

It is recommended that subtypes T<:IO override the following method signature to provide more efficient implementations: unsafe_read(s::T, p::Ptr{UInt8}, n::UInt)

# -------------------------
Base.unsafe_write
Function unsafe_write(io::IO, ref, nbytes::UInt)

Copy nbytes from ref (converted to a pointer) into the IO object.

It is recommended that subtypes T<:IO override the following method signature to provide more efficient implementations: unsafe_write(s::T, p::Ptr{UInt8}, n::UInt)

# -------------------------
Base.readeach
Function readeach(io::IO, T)

Return an iterable object yielding read(io, T).

See also skipchars, eachline, readuntil.

Julia 1.6
readeach requires Julia 1.6 or later.


io = IOBuffer("JuliaLang is a GitHub organization.\n It has many members.\n");

for c in readeach(io, Char)
           c == '\n' && break
           print(c)
       end
JuliaLang is a GitHub organization.

# -------------------------
Base.peek
Function peek(stream[, T=UInt8])

Read and return a value of type T from a stream without advancing the current position in the stream. See also startswith(stream, char_or_string).


b = IOBuffer("julia");

peek(b)
0x6a

position(b)
0

peek(b, Char)
'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)

Julia 1.5
The method which accepts a type requires Julia 1.5 or later.

# -------------------------
Base.position
Function position(l::Lexer)

Returns the current position.

position(s)

Get the current position of a stream.


io = IOBuffer("JuliaLang is a GitHub organization.");

seek(io, 5);

position(io)
5

skip(io, 10);

position(io)
15

seekend(io);

position(io)
35

# -------------------------
Base.seek
Function seek(s, pos)

Seek a stream to the given position.


io = IOBuffer("JuliaLang is a GitHub organization.");

seek(io, 5);

read(io, Char)
'L': ASCII/Unicode U+004C (category Lu: Letter, uppercase)

# -------------------------
Base.seekstart
Function seekstart(s)

Seek a stream to its beginning.


io = IOBuffer("JuliaLang is a GitHub organization.");

seek(io, 5);

read(io, Char)
'L': ASCII/Unicode U+004C (category Lu: Letter, uppercase)

seekstart(io);

read(io, Char)
'J': ASCII/Unicode U+004A (category Lu: Letter, uppercase)

# -------------------------
Base.seekend
Function seekend(s)

Seek a stream to its end.

# -------------------------
Base.skip
Function skip(s, offset)

Seek a stream relative to the current position.


io = IOBuffer("JuliaLang is a GitHub organization.");

seek(io, 5);

skip(io, 10);

read(io, Char)
'G': ASCII/Unicode U+0047 (category Lu: Letter, uppercase)

# -------------------------
Base.mark
Function mark(s::IO)

Add a mark at the current position of stream s. Return the marked position.

See also unmark, reset, ismarked.

# -------------------------
Base.unmark
Function unmark(s::IO)

Remove a mark from stream s. Return true if the stream was marked, false otherwise.

See also mark, reset, ismarked.

# -------------------------
Base.reset
Method reset(s::IO)

Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked.

See also mark, unmark, ismarked.

# -------------------------
Base.ismarked
Function ismarked(s::IO)

Return true if stream s is marked.

See also mark, unmark, reset.

# -------------------------
Base.eof
Function eof(stream) -> Bool

Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.


b = IOBuffer("my buffer");

eof(b)
false

seekend(b);

eof(b)
true

# -------------------------
Base.isreadonly
Function isreadonly(io) -> Bool

Determine whether a stream is read-only.


io = IOBuffer("JuliaLang is a GitHub organization");

isreadonly(io)
true

io = IOBuffer();

isreadonly(io)
false

# -------------------------
Base.iswritable
Function iswritable(io) -> Bool

Return false if the specified IO object is not writable.


open("myfile.txt", "w") do io
           print(io, "Hello world!");
           iswritable(io)
       end
true

open("myfile.txt", "r") do io
           iswritable(io)
       end
false

rm("myfile.txt")

# -------------------------
Base.isreadable
Function isreadable(io) -> Bool

Return false if the specified IO object is not readable.


open("myfile.txt", "w") do io
           print(io, "Hello world!");
           isreadable(io)
       end
false

open("myfile.txt", "r") do io
           isreadable(io)
       end
true

rm("myfile.txt")

# -------------------------
Base.isopen
Function isopen(object) -> Bool

Determine whether an object - such as a stream or timer – is not yet closed. Once an object is closed, it will never produce a new event. However, since a closed stream may still have data to read in its buffer, use eof to check for the ability to read data. Use the FileWatching package to be notified when a stream might be writable or readable.


io = open("my_file.txt", "w+");

isopen(io)
true

close(io)

isopen(io)
false

# -------------------------
Base.fd
Function fd(stream)

Return the file descriptor backing the stream or file. Note that this function only applies to synchronous File's and IOStream's not to any of the asynchronous streams.

# -------------------------
Base.redirect_stdio
Function redirect_stdio(;stdin=stdin, stderr=stderr, stdout=stdout)

Redirect a subset of the streams stdin, stderr, stdout. Each argument must be an IOStream, TTY, Pipe, socket, or devnull.

Julia 1.7
redirect_stdio requires Julia 1.7 or later.

# -------------------------
redirect_stdio(f; stdin=nothing, stderr=nothing, stdout=nothing)

Redirect a subset of the streams stdin, stderr, stdout, call f() and restore each stream.

Possible values for each stream are:

nothing indicating the stream should not be redirected.
path::AbstractString redirecting the stream to the file at path.
io an IOStream, TTY, Pipe, socket, or devnull.

redirect_stdio(stdout="stdout.txt", stderr="stderr.txt") do
           print("hello stdout")
           print(stderr, "hello stderr")
       end

read("stdout.txt", String)
"hello stdout"

read("stderr.txt", String)
"hello stderr"

Edge cases

It is possible to pass the same argument to stdout and stderr:

redirect_stdio(stdout="log.txt", stderr="log.txt", stdin=devnull) do
    ...
end

However it is not supported to pass two distinct descriptors of the same file.

io1 = open("same/path", "w")

io2 = open("same/path", "w")

redirect_stdio(f, stdout=io1, stderr=io2) # not supported

Also the stdin argument may not be the same descriptor as stdout or stderr.

io = open(...)

redirect_stdio(f, stdout=io, stdin=io) # not supported

Julia 1.7
redirect_stdio requires Julia 1.7 or later.

# -------------------------
Base.redirect_stdout
Function redirect_stdout([stream]) -> stream

Create a pipe to which all C and Julia level stdout output will be redirected. Return a stream representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe.

Note: stream must be a compatible objects, such as an IOStream, TTY, Pipe, socket, or devnull.

See also redirect_stdio.

# -------------------------
Base.redirect_stdout
Method redirect_stdout(f::Function, stream)

Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.

# -------------------------
Base.redirect_stderr
Function redirect_stderr([stream]) -> stream

Like redirect_stdout, but for stderr.

Note: stream must be a compatible objects, such as an IOStream, TTY, Pipe, socket, or devnull.

See also redirect_stdio.

# -------------------------
Base.redirect_stderr
Method redirect_stderr(f::Function, stream)

Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.

# -------------------------
Base.redirect_stdin
Function redirect_stdin([stream]) -> stream

Like redirect_stdout, but for stdin. Note that the direction of the stream is reversed.

Note: stream must be a compatible objects, such as an IOStream, TTY, Pipe, socket, or devnull.

See also redirect_stdio.

# -------------------------
Base.redirect_stdin
Method redirect_stdin(f::Function, stream)

Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

# -------------------------
Base.readchomp
Function readchomp(x)

Read the entirety of x as a string and remove a single trailing newline if there is one. Equivalent to chomp(read(x, String)).


write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

readchomp("my_file.txt")
"JuliaLang is a GitHub organization.\nIt has many members."

rm("my_file.txt");

# -------------------------
Base.truncate
Function truncate(file, n)

Resize the file or buffer given by the first argument to exactly n bytes, filling previously unallocated space with '\0' if the file or buffer is grown.


io = IOBuffer();

write(io, "JuliaLang is a GitHub organization.")
35

truncate(io, 15)
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=15, maxsize=Inf, ptr=16, mark=-1)

String(take!(io))
"JuliaLang is a "

io = IOBuffer();

write(io, "JuliaLang is a GitHub organization.");

truncate(io, 40);

String(take!(io))
"JuliaLang is a GitHub organization.\0\0\0\0\0"

# -------------------------
Base.skipchars
Function skipchars(predicate, io::IO; linecomment=nothing)

Advance the stream io such that the next-read character will be the first remaining for which predicate returns false. If the keyword argument linecomment is specified, all characters from that character until the start of the next line are ignored.


buf = IOBuffer("    text")
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=8, maxsize=Inf, ptr=1, mark=-1)

skipchars(isspace, buf)
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=8, maxsize=Inf, ptr=5, mark=-1)

String(readavailable(buf))
"text"

# -------------------------
Base.countlines
Function countlines(io::IO; eol::AbstractChar = '\n')
countlines(filename::AbstractString; eol::AbstractChar = '\n')

Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

To count lines of a String, countlines(IOBuffer(str)) can be used.


io = IOBuffer("JuliaLang is a GitHub organization.\n");

countlines(io)
1

io = IOBuffer("JuliaLang is a GitHub organization.");

countlines(io)
1

eof(io) # counting lines moves the file pointer
true

io = IOBuffer("JuliaLang is a GitHub organization.");

countlines(io, eol = '.')
1

write("my_file.txt", "JuliaLang is a GitHub organization.\n")
36

countlines("my_file.txt")
1

countlines("my_file.txt", eol = 'n')
4

rm("my_file.txt")

# -------------------------
Base.PipeBuffer
Function PipeBuffer(data::Vector{UInt8}=UInt8[]; maxsize::Integer = typemax(Int))

An IOBuffer that allows reading and performs writes by appending. Seeking and truncating are not supported. See IOBuffer for the available constructors. If data is given, creates a PipeBuffer to operate on a data vector, optionally specifying a size beyond which the underlying Array may not be grown.

# -------------------------
Base.readavailable
Function readavailable(stream)

Read available buffered data from a stream. Actual I/O is performed only if no data has already been buffered. The result is a Vector{UInt8}.

Warning
The amount of data returned is implementation-dependent; for example it can depend on the internal choice of buffer size. Other functions such as read should generally be used instead.

# -------------------------
Base.IOContext
Type IOContext

IOContext provides a mechanism for passing output configuration settings among show methods.

In short, it is an immutable dictionary that is a subclass of IO. It supports standard dictionary operations such as getindex, and can also be used as an I/O stream.

# -------------------------
Base.IOContext
Method IOContext(io::IO, KV::Pair...)

Create an IOContext that wraps a given stream, adding the specified key=>value pairs to the properties of that stream (note that io can itself be an IOContext).

use (key => value) in io to see if this particular combination is in the properties set
use get(io, key, default) to retrieve the most recent value for a particular key
The following properties are in common use:

:compact: Boolean specifying that values should be printed more compactly, e.g. that numbers should be printed with fewer digits. This is set when printing array elements. :compact output should not contain line breaks.
:limit: Boolean specifying that containers should be truncated, e.g. showing … in place of most elements.
:displaysize: A Tuple{Int,Int} giving the size in rows and columns to use for text output. This can be used to override the display size for called functions, but to get the size of the screen use the displaysize function.
:typeinfo: a Type characterizing the information already printed concerning the type of the object about to be displayed. This is mainly useful when displaying a collection of objects of the same type, so that redundant type information can be avoided (e.g. [Float16(0)] can be shown as "Float16[0.0]" instead of "Float16[Float16(0.0)]" : while displaying the elements of the array, the :typeinfo property will be set to Float16).
:color: Boolean specifying whether ANSI color/escape codes are supported/expected. By default, this is determined by whether io is a compatible terminal and by any --color command-line flag when julia was launched.

io = IOBuffer();

printstyled(IOContext(io, :color => true), "string", color=:red)

String(take!(io))
"\e[31mstring\e[39m"

printstyled(io, "string", color=:red)

String(take!(io))
"string"

print(IOContext(stdout, :compact => false), 1.12341234)
1.12341234
print(IOContext(stdout, :compact => true), 1.12341234)
1.12341

function f(io::IO)
           if get(io, :short, false)
               print(io, "short")
           else
               print(io, "loooooong")
           end
       end
f (generic function with 1 method)

f(stdout)
loooooong
f(IOContext(stdout, :short => true))
short

# -------------------------
Base.IOContext
Method IOContext(io::IO, context::IOContext)

Create an IOContext that wraps an alternate IO but inherits the properties of context.

# -------------------------
Text I/O
Base.show
Method show([io::IO = stdout], x)

Write a text representation of a value x to the output stream io. New types T should overload show(io::IO, x::T). The representation used by show generally includes Julia-specific formatting and type information, and should be parseable Julia code when possible.

repr returns the output of show as a string.

For a more verbose human-readable text output for objects of type T, define show(io::IO, ::MIME"text/plain", ::T) in addition. Checking the :compact IOContext key (often checked as get(io, :compact, false)::Bool) of io in such methods is recommended, since some containers show their elements by calling this method with :compact => true.

See also print, which writes un-decorated representations.


show("Hello World!")
"Hello World!"
print("Hello World!")
Hello World!

# -------------------------
Base.summary
Function summary(io::IO, x)
str = summary(x)

Print to a stream io, or return a string str, giving a brief description of a value. By default returns string(typeof(x)), e.g. Int64.

For arrays, returns a string of size and type info, e.g. 10-element Array{Int64,1}.


summary(1)
"Int64"

summary(zeros(2))
"2-element Vector{Float64}"

# -------------------------
Base.print
Function print([io::IO], xs...)

Write to io (or to the default output stream stdout if io is not given) a canonical (un-decorated) text representation. The representation used by print includes minimal formatting and tries to avoid Julia-specific details.

print falls back to calling show, so most types should just define show. Define print if your type has a separate "plain" representation. For example, show displays strings with quotes, and print displays strings without quotes.

See also println, string, printstyled.


print("Hello World!")
Hello World!
io = IOBuffer();

print(io, "Hello", ' ', :World!)

String(take!(io))
"Hello World!"

# -------------------------
Base.println
Function println([io::IO], xs...)

Print (using print) xs to io followed by a newline. If io is not supplied, prints to the default output stream stdout.

See also printstyled to add colors etc.


println("Hello, world")
Hello, world

io = IOBuffer();

println(io, "Hello", ',', " world.")

String(take!(io))
"Hello, world.\n"

# -------------------------
Base.printstyled
Function printstyled([io], xs...; bold::Bool=false, italic::Bool=false, underline::Bool=false, blink::Bool=false, reverse::Bool=false, hidden::Bool=false, color::Union{Symbol,Int}=:normal)

Print xs in a color specified as a symbol or integer, optionally in bold.

Keyword color may take any of the values :normal, :italic, :default, :bold, :black, :blink, :blue, :cyan, :green, :hidden, :light_black, :light_blue, :light_cyan, :light_green, :light_magenta, :light_red, :light_white, :light_yellow, :magenta, :nothing, :red, :reverse, :underline, :white, or :yellow or an integer between 0 and 255 inclusive. Note that not all terminals support 256 colors.

Keywords bold=true, italic=true, underline=true, blink=true are self-explanatory. Keyword reverse=true prints with foreground and background colors exchanged, and hidden=true should be invisible in the terminal but can still be copied. These properties can be used in any combination.

See also print, println, show.

Note: Not all terminals support italic output. Some terminals interpret italic as reverse or blink.

Julia 1.7
Keywords except color and bold were added in Julia 1.7.

Julia 1.10
Support for italic output was added in Julia 1.10.

# -------------------------
Base.sprint
Function sprint(f::Function, args...; context=nothing, sizehint=0)

Call the given function with an I/O stream and the supplied extra arguments. Everything written to this I/O stream is returned as a string. context can be an IOContext whose properties will be used, a Pair specifying a property and its value, or a tuple of Pair specifying multiple properties and their values. sizehint suggests the capacity of the buffer (in bytes).

The optional keyword argument context can be set to a :key=>value pair, a tuple of :key=>value pairs, or an IO or IOContext object whose attributes are used for the I/O stream passed to f. The optional sizehint is a suggested size (in bytes) to allocate for the buffer used to write the string.

Julia 1.7
Passing a tuple to keyword context requires Julia 1.7 or later.


sprint(show, 66.66666; context=:compact => true)
"66.6667"

sprint(showerror, BoundsError([1], 100))
"BoundsError: attempt to access 1-element Vector{Int64} at index [100]"

# -------------------------
Base.showerror
Function showerror(io, e)

Show a descriptive representation of an exception object e. This method is used to display the exception after a call to throw.


struct MyException <: Exception
           msg::String
       end

function Base.showerror(io::IO, err::MyException)
           print(io, "MyException: ")
           print(io, err.msg)
       end

err = MyException("test exception")
MyException("test exception")

sprint(showerror, err)
"MyException: test exception"

throw(MyException("test exception"))
ERROR: MyException: test exception

# -------------------------
Base.dump
Function dump(x; maxdepth=8)

Show every part of the representation of a value. The depth of the output is truncated at maxdepth.


struct MyStruct
           x
           y
       end

x = MyStruct(1, (2,3));

dump(x)
MyStruct
  x: Int64 1
  y: Tuple{Int64, Int64}
    1: Int64 2
    2: Int64 3

dump(x; maxdepth = 1)
MyStruct
  x: Int64 1
  y: Tuple{Int64, Int64}

# -------------------------
Base.Meta.@dump
Macro
@dump expr

Show every part of the representation of the given expression. Equivalent to dump(:(expr)).

# -------------------------
Base.readline
Function readline(io::IO=stdin; keep::Bool=false)
readline(filename::AbstractString; keep::Bool=false)

Read a single line of text from the given I/O stream or file (defaults to stdin). When reading from a file, the text is assumed to be encoded in UTF-8. Lines in the input end with '\n' or "\r\n" or the end of an input stream. When keep is false (as it is by default), these trailing newline characters are removed from the line before it is returned. When keep is true, they are returned as part of the line.


write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

readline("my_file.txt")
"JuliaLang is a GitHub organization."

readline("my_file.txt", keep=true)
"JuliaLang is a GitHub organization.\n"

rm("my_file.txt")

print("Enter your name: ")
Enter your name:

your_name = readline()
Logan
"Logan"

# -------------------------
Base.readuntil
Function readuntil(stream::IO, delim; keep::Bool = false)
readuntil(filename::AbstractString, delim; keep::Bool = false)

Read a string from an I/O stream or a file, up to the given delimiter. The delimiter can be a UInt8, AbstractChar, string, or vector. Keyword argument keep controls whether the delimiter is included in the result. The text is assumed to be encoded in UTF-8.


write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

readuntil("my_file.txt", 'L')
"Julia"

readuntil("my_file.txt", '.', keep = true)
"JuliaLang is a GitHub organization."

rm("my_file.txt")

# -------------------------
Base.readlines
Function readlines(io::IO=stdin; keep::Bool=false)
readlines(filename::AbstractString; keep::Bool=false)

Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings. See also eachline to iterate over the lines without reading them all at once.


write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

readlines("my_file.txt")
2-element Vector{String}:
 "JuliaLang is a GitHub organization."
 "It has many members."

readlines("my_file.txt", keep=true)
2-element Vector{String}:
 "JuliaLang is a GitHub organization.\n"
 "It has many members.\n"

rm("my_file.txt")

# -------------------------
Base.eachline
Function eachline(io::IO=stdin; keep::Bool=false)
eachline(filename::AbstractString; keep::Bool=false)

Create an iterable EachLine object that will yield each line from an I/O stream or a file. Iteration calls readline on the stream argument repeatedly with keep passed through, determining whether trailing end-of-line characters are retained. When called with a file name, the file is opened once at the beginning of iteration and closed at the end. If iteration is interrupted, the file will be closed when the EachLine object is garbage collected.

To iterate over each line of a String, eachline(IOBuffer(str)) can be used.

Iterators.reverse can be used on an EachLine object to read the lines in reverse order (for files, buffers, and other I/O streams supporting seek), and first or last can be used to extract the initial or final lines, respectively.


write("my_file.txt", "JuliaLang is a GitHub organization.\n It has many members.\n");

for line in eachline("my_file.txt")
           print(line)
       end
JuliaLang is a GitHub organization. It has many members.

rm("my_file.txt");

Julia 1.8
Julia 1.8 is required to use Iterators.reverse or last with eachline iterators.

# -------------------------
Base.displaysize
Function displaysize([io::IO]) -> (lines, columns)

Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.


withenv("LINES" => 30, "COLUMNS" => 100) do
           displaysize()
       end
(30, 100)

To get your TTY size,

displaysize(stdout)
(34, 147)

# -------------------------
Multimedia I/O
Just as text output is performed by print and user-defined types can indicate their textual representation by overloading show, Julia provides a standardized mechanism for rich multimedia output (such as images, formatted text, or even audio and video), consisting of three parts:

A function display(x) to request the richest available multimedia display of a Julia object x (with a plain-text fallback).
Overloading show allows one to indicate arbitrary multimedia representations (keyed by standard MIME types) of user-defined types.
Multimedia-capable display backends may be registered by subclassing a generic AbstractDisplay type and pushing them onto a stack of display backends via pushdisplay.
The base Julia runtime provides only plain-text display, but richer displays may be enabled by loading external modules or by using graphical Julia environments (such as the IPython-based IJulia notebook).

Base.Multimedia.AbstractDisplay
Type AbstractDisplay

Abstract supertype for rich display output devices. TextDisplay is a subtype of this.

# -------------------------
Base.Multimedia.display
Function display(x)
display(d::AbstractDisplay, x)
display(mime, x)
display(d::AbstractDisplay, mime, x)

Display x using the topmost applicable display in the display stack, typically using the richest supported multimedia output for x, with plain-text stdout output as a fallback. The display(d, x) variant attempts to display x on the given display d only, throwing a MethodError if d cannot display objects of this type.

In general, you cannot assume that display output goes to stdout (unlike print(x) or show(x)). For example, display(x) may open up a separate window with an image. display(x) means "show x in the best way you can for the current output device(s)." If you want REPL-like text output that is guaranteed to go to stdout, use show(stdout, "text/plain", x) instead.

There are also two variants with a mime argument (a MIME type string, such as "image/png"), which attempt to display x using the requested MIME type only, throwing a MethodError if this type is not supported by either the display(s) or by x. With these variants, one can also supply the "raw" data in the requested MIME type by passing x::AbstractString (for MIME types with text-based storage, such as text/html or application/postscript) or x::Vector{UInt8} (for binary MIME types).

To customize how instances of a type are displayed, overload show rather than display, as explained in the manual section on custom pretty-printing.

# -------------------------
Base.Multimedia.redisplay
Function redisplay(x)
redisplay(d::AbstractDisplay, x)
redisplay(mime, x)
redisplay(d::AbstractDisplay, mime, x)

By default, the redisplay functions simply call display. However, some display backends may override redisplay to modify an existing display of x (if any). Using redisplay is also a hint to the backend that x may be redisplayed several times, and the backend may choose to defer the display until (for example) the next interactive prompt.

# -------------------------
Base.Multimedia.displayable
Function displayable(mime) -> Bool
displayable(d::AbstractDisplay, mime) -> Bool

Return a boolean value indicating whether the given mime type (string) is displayable by any of the displays in the current display stack, or specifically by the display d in the second variant.

# -------------------------
Base.show
Method show(io::IO, mime, x)

The display functions ultimately call show in order to write an object x as a given mime type to a given I/O stream io (usually a memory buffer), if possible. In order to provide a rich multimedia representation of a user-defined type T, it is only necessary to define a new show method for T, via: show(io, ::MIME"mime", x::T) = ..., where mime is a MIME-type string and the function body calls write (or similar) to write that representation of x to io. (Note that the MIME"" notation only supports literal strings; to construct MIME types in a more flexible manner use MIME{Symbol("")}.)

For example, if you define a MyImage type and know how to write it to a PNG file, you could define a function show(io, ::MIME"image/png", x::MyImage) = ... to allow your images to be displayed on any PNG-capable AbstractDisplay (such as IJulia). As usual, be sure to import Base.show in order to add new methods to the built-in Julia function show.

Technically, the MIME"mime" macro defines a singleton type for the given mime string, which allows us to exploit Julia's dispatch mechanisms in determining how to display objects of any given type.

The default MIME type is MIME"text/plain". There is a fallback definition for text/plain output that calls show with 2 arguments, so it is not always necessary to add a method for that case. If a type benefits from custom human-readable output though, show(::IO, ::MIME"text/plain", ::T) should be defined. For example, the Day type uses 1 day as the output for the text/plain MIME type, and Day(1) as the output of 2-argument show.


struct Day
           n::Int
       end

Base.show(io::IO, ::MIME"text/plain", d::Day) = print(io, d.n, " day")

Day(1)
1 day

Container types generally implement 3-argument show by calling show(io, MIME"text/plain"(), x) for elements x, with :compact => true set in an IOContext passed as the first argument.

# -------------------------
Base.Multimedia.showable
Function showable(mime, x)

Return a boolean value indicating whether or not the object x can be written as the given mime type.

(By default, this is determined automatically by the existence of the corresponding show method for typeof(x). Some types provide custom showable methods; for example, if the available MIME formats depend on the value of x.)


showable(MIME("text/plain"), rand(5))
true

showable("image/png", rand(5))
false

# -------------------------
Base.repr
Method repr(mime, x; context=nothing)

Return an AbstractString or Vector{UInt8} containing the representation of x in the requested mime type, as written by show(io, mime, x) (throwing a MethodError if no appropriate show is available). An AbstractString is returned for MIME types with textual representations (such as "text/html" or "application/postscript"), whereas binary data is returned as Vector{UInt8}. (The function istextmime(mime) returns whether or not Julia treats a given mime type as text.)

The optional keyword argument context can be set to :key=>value pair or an IO or IOContext object whose attributes are used for the I/O stream passed to show.

As a special case, if x is an AbstractString (for textual MIME types) or a Vector{UInt8} (for binary MIME types), the repr function assumes that x is already in the requested mime format and simply returns x. This special case does not apply to the "text/plain" MIME type. This is useful so that raw data can be passed to display(m::MIME, x).

In particular, repr("text/plain", x) is typically a "pretty-printed" version of x designed for human consumption. See also repr(x) to instead return a string corresponding to show(x) that may be closer to how the value of x would be entered in Julia.


A = [1 2; 3 4];

repr("text/plain", A)
"2×2 Matrix{Int64}:\n 1  2\n 3  4"

# -------------------------
Base.Multimedia.MIME
Type MIME

A type representing a standard internet data format. "MIME" stands for "Multipurpose Internet Mail Extensions", since the standard was originally used to describe multimedia attachments to email messages.

A MIME object can be passed as the second argument to show to request output in that format.


show(stdout, MIME("text/plain"), "hi")
"hi"

# -------------------------
Base.Multimedia.@MIME_str
Macro
@MIME_str

A convenience macro for writing MIME types, typically used when adding methods to show. For example the syntax show(io::IO, ::MIME"text/html", x::MyType) = ... could be used to define how to write an HTML representation of MyType.

# -------------------------
As mentioned above, one can also define new display backends. For example, a module that can display PNG images in a window can register this capability with Julia, so that calling display(x) on types with PNG representations will automatically display the image using the module's window.

In order to define a new display backend, one should first create a subtype D of the abstract class AbstractDisplay. Then, for each MIME type (mime string) that can be displayed on D, one should define a function display(d::D, ::MIME"mime", x) = ... that displays x as that MIME type, usually by calling show(io, mime, x) or repr(io, mime, x). A MethodError should be thrown if x cannot be displayed as that MIME type; this is automatic if one calls show or repr. Finally, one should define a function display(d::D, x) that queries showable(mime, x) for the mime types supported by D and displays the "best" one; a MethodError should be thrown if no supported MIME types are found for x. Similarly, some subtypes may wish to override redisplay(d::D, ...). (Again, one should import Base.display to add new methods to display.) The return values of these functions are up to the implementation (since in some cases it may be useful to return a display "handle" of some type). The display functions for D can then be called directly, but they can also be invoked automatically from display(x) simply by pushing a new display onto the display-backend stack with:

Base.Multimedia.pushdisplay
Function pushdisplay(d::AbstractDisplay)

Pushes a new display d on top of the global display-backend stack. Calling display(x) or display(mime, x) will display x on the topmost compatible backend in the stack (i.e., the topmost backend that does not throw a MethodError).

# -------------------------
Base.Multimedia.popdisplay
Function popdisplay()
popdisplay(d::AbstractDisplay)

Pop the topmost backend off of the display-backend stack, or the topmost copy of d in the second variant.

# -------------------------
Base.Multimedia.TextDisplay
Type TextDisplay(io::IO)

Return a TextDisplay <: AbstractDisplay, which displays any object as the text/plain MIME type (by default), writing the text representation to the given I/O stream. (This is how objects are printed in the Julia REPL.)

# -------------------------
Base.Multimedia.istextmime
Function istextmime(m::MIME)

Determine whether a MIME type is text data. MIME types are assumed to be binary data except for a set of types known to be text data (possibly Unicode).


istextmime(MIME("text/plain"))
true

istextmime(MIME("image/png"))
false

# -------------------------
Network I/O
Base.bytesavailable
Function bytesavailable(io)

Return the number of bytes available for reading before a read from this stream or buffer will block.


io = IOBuffer("JuliaLang is a GitHub organization");

bytesavailable(io)
34

# -------------------------
Base.ntoh
Function ntoh(x)

Convert the endianness of a value from Network byte order (big-endian) to that used by the Host.

# -------------------------
Base.hton
Function hton(x)

Convert the endianness of a value from that used by the Host to Network byte order (big-endian).

# -------------------------
Base.ltoh
Function ltoh(x)

Convert the endianness of a value from Little-endian to that used by the Host.

# -------------------------
Base.htol
Function htol(x)

Convert the endianness of a value from that used by the Host to Little-endian.

# -------------------------
Base.ENDIAN_BOM
Constant
ENDIAN_BOM

The 32-bit byte-order-mark indicates the native byte order of the host machine. Little-endian machines will contain the value 0x04030201. Big-endian machines will contain the value 0x01020304.
