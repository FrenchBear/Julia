# lib_interactive_utils.jl
# Julia Std Library doc, InteractiveUtils
# 
# 2024-05-11    PV


# Interactive Utilities

# This module is intended for interactive work. It is loaded automatically in interactive mode.

# -------------------------
# Base.Docs.apropos
# Function apropos([io::IO=stdout], pattern::Union{AbstractString,Regex})
# 
# Search available docstrings for entries containing pattern.
# When pattern is a string, case is ignored. Results are printed to io.
# apropos can be called from the help mode in the REPL by wrapping the query in double quotes:
#   help?> "pattern"


# -------------------------
# InteractiveUtils.varinfo
# Function varinfo(m::Module=Main, pattern::Regex=r""; all=false, imported=false, recursive=false, sortby::Symbol=:name, minsize::Int=0)

# Return a markdown table giving information about exported global variables in a module, optionally restricted to those
# matching pattern.
# The memory consumption estimate is an approximate lower bound on the size of the internal structure of the object.
# - all : also list non-exported objects defined in the module, deprecated objects, and compiler-generated objects.
# - imported : also list objects explicitly imported from other modules.
# - recursive : recursively include objects in sub-modules, observing the same settings in each.
# - sortby : the column to sort results by. Options are :name (default), :size, and :summary.
# - minsize : only includes objects with size at least minsize bytes. Defaults to 0.

md"""C1|C2
       :--------|-------:
       1|2
       abcd|efghij
       """
# C1       C2
# –––– ––––––
# 1         2
# abcd efghij

# The output of varinfo is intended for display purposes only. See also names to get an array of symbols defined in a
# module, which is suitable for more general manipulations.

# -------------------------
# InteractiveUtils.versioninfo
# Function versioninfo(io::IO=stdout; verbose::Bool=false)
# 
# Print information about the version of Julia in use. The output is controlled with boolean keyword arguments:
# - verbose: print all additional information
# Warning: The output of this function may contain sensitive information. Before sharing the output, please review the output and remove any data that should not be shared publicly.
# See also: VERSION.

versioninfo()
# Julia Version 1.10.3
# Commit 0b4590a550 (2024-04-30 10:59 UTC)
# Build Info:
#   Official https://julialang.org/ release
# Platform Info:
#   OS: Windows (x86_64-w64-mingw32)
#   CPU: 24 × 12th Gen Intel(R) Core(TM) i9-12900
#   WORD_SIZE: 64
#   LIBM: libopenlibm
#   LLVM: libLLVM-15.0.7 (ORCJIT, alderlake)
# Threads: 24 default, 1 interactive, 12 GC (on 24 virtual cores)

versioninfo(verbose=true)
# Julia Version 1.10.3
# Commit 0b4590a550 (2024-04-30 10:59 UTC)
# Build Info:
#   Official https://julialang.org/ release
# Platform Info:
#   OS: Windows (x86_64-w64-mingw32)
#       Microsoft Windows [Version 10.0.22621.3447]
#   CPU: 12th Gen Intel(R) Core(TM) i9-12900:
#                speed         user         nice          sys         idle          irq
#        #1-24  2419 MHz    1587271            0      2574974    274685504        55895  ticks
#   Memory: 31.582298278808594 GB (16700.33984375 MB free)
#   Uptime: 14294.296 sec
#   Load Avg:  0.0  0.0  0.0
#   WORD_SIZE: 64
#   LIBM: libopenlibm
#   LLVM: libLLVM-15.0.7 (ORCJIT, alderlake)
# Threads: 24 default, 1 interactive, 12 GC (on 24 virtual cores)
# Environment:
#   GOPATH = C:\Users\Pierr\go
#   HOMEDRIVE = C:
#   HOMEPATH = \Users\Pierr
#   PATH = C:\Program Files\ImageMagick-7;C:\Utils;C:\Utils\BookApps;C:\Users\Pierr\AppData\Roaming\Python\Python312\Scripts;C:\Program Files\Python312\Scripts\;C:\Program Files\Python312\;C:\Program Files\Microsoft MPI\Bin\;C:\Program Files\Common Files\Oracle\Java\javapath;C:\Program Files\Microsoft\jdk-11.0.16.101-hotspot\bin;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\dotnet\;C:\Program Files\Microsoft VS Code\bin;C:\Program Files\Lua;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files (x86)\Vim\vim90;C:\Program Files\Microsoft SQL Server\150\Tools\Binn\;C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\;C:\Program Files\GTK3-Runtime Win64\bin;C:\Program Files\Calibre2\;C:\Program Files\Git\cmd;C:\Program Files\Go\bin;C:\Program Files\nodejs\;C:\Program Files\PowerShell\7\;C:\Users\Pierr\AppData\Local\Microsoft\WindowsApps;C:\Users\Pierr\.cargo\bin;C:\Users\Pierr\.dotnet\tools;C:\Users\Pierr\go\bin;C:\Users\Pierr\AppData\Roaming\npm;
#   PATHEXT = .COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY;.PYW
#   PSMODULEPATH = C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
#   PYTHONPATH = C:\Development\GitHub\Python\Learning\Common

# -------------------------
# InteractiveUtils.methodswith
# Function methodswith(typ[, module or function]; supertypes::Bool=false])
#
# Return an array of methods with an argument of type typ.
# The optional second argument restricts the search to a particular module or function (the default is all top-level modules).
# If keyword supertypes is true, also return arguments with a parent type of typ, excluding type Any.

methodswith(Task)
# [1] TaskFailedException(task::Task) @ Base task.jl:77
# [2] bind(c::Channel, task::Task) @ Base channels.jl:273
# [3] current_exceptions(task::Task; backtrace) @ Base error.jl:150
# [4] errormonitor(t::Task) @ Base task.jl:573
# [5] fetch(t::Task) @ Base task.jl:371
# [6] getproperty(t::Task, field::Symbol) @ Base task.jl:162
# [7] istaskdone(t::Task) @ Base task.jl:208
# [8] istaskfailed(t::Task) @ Base task.jl:252
# [9] istaskstarted(t::Task) @ Base task.jl:225
# [10] schedule(t::Task) @ Base task.jl:813
# [11] schedule(t::Task, arg; error) @ Base task.jl:849
# [12] show(io::IO, ::MIME{Symbol("text/plain")}, t::Task) @ Base show.jl:271
# [13] show(io::IO, t::Task) @ Base task.jl:106
# [14] wait(t::Task) @ Base task.jl:348
# [15] yield(t::Task) @ Base task.jl:890
# [16] yield(t::Task, x) @ Base task.jl:890
# [17] yieldto(t::Task) @ Base task.jl:906
# [18] yieldto(t::Task, x) @ Base task.jl:906
# [19] serialize(s::Serialization.AbstractSerializer, t::Task) @ Serialization C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\Serialization\src\Serialization.jl:461

# -------------------------
# InteractiveUtils.subtypes
# Function subtypes(T::DataType)
#
# Return a list of immediate subtypes of DataType T. Note that all currently loaded subtypes are included, including
# those not visible in the current module.
# See also supertype, supertypes, methodswith.

subtypes(Integer)
# 3-element Vector{Any}:
#  Bool
#  Signed
#  Unsigned

# -------------------------
# InteractiveUtils.supertypes
# Function supertypes(T::Type)
#
# Return a tuple (T, ..., Any) of T and all its supertypes, as determined by successive calls to the supertype function,
# listed in order of <: and terminated by Any.
# See also subtypes.

supertypes(Int)
# (Int64, Signed, Integer, Real, Number, Any)

# -------------------------
# InteractiveUtils.edit
# Method edit(path::AbstractString, line::Integer=0, column::Integer=0)
# 
# Edit a file or directory optionally providing a line number to edit the file at. Return to the julia prompt when you
# quit the editor. The editor can be changed by setting JULIA_EDITOR, VISUAL or EDITOR as an environment variable.
# See also define_editor.

# -----------
# Method edit(function, [types])
# edit(module)
 
# Edit the definition of a function, optionally specifying a tuple of types to indicate which method to edit. For
# modules, open the main source file. The module needs to be loaded with using or import first.
# To ensure that the file can be opened at the given line, you may need to call define_editor first.

InteractiveUtils.edit(unique, (AbstractRange,))

InteractiveUtils.edit(zip, (Any,))

# -------------------------
# InteractiveUtils.@edit
# Macro @edit
#
# Evaluates the arguments to the function or macro call, determines their types, and calls the edit function on the
# resulting expression.
# See also: @less, @which.

# -------------------------
# InteractiveUtils.define_editor
# Function define_editor(fn, pattern; wait=false)
# 
# Define a new editor matching pattern that can be used to open a file (possibly at a given line number) using fn.

# The fn argument is a function that determines how to open a file with the given editor. It should take four arguments,
# as follows:
# - cmd - a base command object for the editor
# - path - the path to the source file to open
# - line - the line number to open the editor at
# - column - the column number to open the editor at

# Editors which cannot open to a specific line with a command or a specific column may ignore the line and/or column
# argument. The fn callback must return either an appropriate Cmd object to open a file or nothing to indicate that they
# cannot edit this file. Use nothing to indicate that this editor is not appropriate for the current environment and
# another editor should be attempted. It is possible to add more general editing hooks that need not spawn external
# commands by pushing a callback directly to the vector EDITOR_CALLBACKS.
# 
# The pattern argument is a string, regular expression, or an array of strings and regular expressions. For the fn to be
# called, one of the patterns must match the value of EDITOR, VISUAL or JULIA_EDITOR. For strings, the string must equal
# the basename of the first word of the editor command, with its extension, if any, removed. E.g. "vi" doesn't match
# "vim -g" but matches "/usr/bin/vi -m"; it also matches vi.exe. If pattern is a regex it is matched against all of the
# editor command as a shell-escaped string. An array pattern matches if any of its items match. If multiple editors
# match, the one added most recently is used.
# 
# By default julia does not wait for the editor to close, running it in the background. However, if the editor is
# terminal based, you will probably want to set wait=true and julia will wait for the editor to close before resuming.
# 
# If one of the editor environment variables is set, but no editor entry matches it, the default editor entry is
# invoked:
# (cmd, path, line, column) -> `$cmd $path`

# Note that many editors are already defined. All of the following commands should already work:
# - emacs
# - emacsclient
# - vim
# - nvim
# - nano
# - micro
# - kak
# - helix
# - textmate
# - mate
# - kate
# - subl
# - atom
# - notepad++
# - Visual Studio Code
# - open
# - pycharm
# - bbedit


# Example:
# The following defines the usage of terminal-based emacs:
define_editor(
    r"\bemacs\b.*\s(-nw|--no-window-system)\b", wait=true) do cmd, path, line
    `$cmd +$line $path`
end

# -------------------------
# InteractiveUtils.less
# Method less(file::AbstractString, [line::Integer])
#
# Show a file using the default pager, optionally providing a starting line number. Returns to the julia prompt when you
# quit the pager.

# -----------
# Method less(function, [types])
#
# Show the definition of a function using the default pager, optionally specifying a tuple of types to indicate which
# method to see.

less(unique, (AbstractRange,))

# -------------------------
# InteractiveUtils.@less
# Macro @less
# 
# Evaluates the arguments to the function or macro call, determines their types, and calls the less function on the resulting expression.
# See also: @edit, @which, @code_lowered.

@less zip(1:3, 2:4)

# -------------------------
# InteractiveUtils.@which
# Macro @which
# 
# Applied to a function or macro call, it evaluates the arguments to the specified call, and returns the Method object
# for the method that would be called for those arguments. Applied to a variable, it returns the module in which the
# variable was bound. It calls out to the which function.
# See also: @less, @edit.

@which zip(1:3, 2:4)
# zip(a...)
#      @ Base.Iterators iterators.jl:374

# -------------------------
# InteractiveUtils.@functionloc
# Macro @functionloc
# 
# Applied to a function or macro call, it evaluates the arguments to the specified call, and returns a tuple
# (filename,line) giving the location for the method that would be called for those arguments. It calls out to the
# functionloc function.

@functionloc zip(1:3, 2:4)
# ("C:\\Users\\Pierr\\.julia\\juliaup\\julia-1.10.3+0.x64.w64.mingw32\\share\\julia\\base\\iterators.jl", 374)

# -------------------------
# InteractiveUtils.@code_lowered
# Macro @code_lowered
#
# Evaluates the arguments to the function or macro call, determines their types, and calls code_lowered on the resulting
# expression.

function choice(source::Range{T}) where T
    source[rand(1:length(source))]
end

@code_lowered choice(collect(1:6))
# CodeInfo(
#     @ REPL[156]:2 within `choice`
# 1 ─ %1 = Main.length(source)
# │   %2 = 1:%1
# │   %3 = Main.rand(%2)
# │   %4 = Base.getindex(source, %3)
# └──      return %4
# )

# -------------------------
# InteractiveUtils.@code_typed
# Macro @code_typed
# 
# Evaluates the arguments to the function or macro call, determines their types, and calls code_typed on the resulting
# expression. Use the optional argument optimize with

@code_typed choice(collect(1:6))
# CodeInfo(
#      @ REPL[156]:2 within `choice`
#     ┌ @ essentials.jl:10 within `length`
# 1 ──│ %1  = Base.arraylen(source)::Int64
# │   └
# │   ┌ @ range.jl:5 within `Colon`
# │   │┌ @ range.jl:403 within `UnitRange`
# │   ││┌ @ range.jl:414 within `unitrange_last`
# │   │││┌ @ operators.jl:425 within `>=`
# │   ││││┌ @ int.jl:514 within `<=`
# │   │││││ %2  = Base.sle_int(1, %1)::Bool
# │   │││└└
# └───│││       goto #3 if not %2
# 2 ──│││       goto #4
# 3 ──│││       goto #4
#     ││└
# 4 ┄─││ %6  = φ (#2 => %1, #3 => 0)::Int64
# └───││       goto #5
# 5 ──││       goto #6
#     └└
#     ┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:260 within `rand` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:255
#     │┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:139 within `Sampler` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:189
#     ││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:333 within `SamplerRangeNDL`
#     │││┌ @ range.jl:672 within `isempty`
#     ││││┌ @ operators.jl:378 within `>`
#     │││││┌ @ int.jl:83 within `<`
# 6 ──││││││ %9  = Base.slt_int(%6, 1)::Bool
# │   │││└└└
# └───│││       goto #8 if not %9
# 7 ──│││ %11 = invoke Random.ArgumentError("collection must be non-empty"::String)::ArgumentError
# │   │││       Random.throw(%11)::Union{}
# └───│││       unreachable
#     │││ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:336 within `SamplerRangeNDL`
#     │││┌ @ int.jl:86 within `-`
# 8 ──││││ %14 = Base.sub_int(%6, 1)::Int64
# │   │││└
# │   │││┌ @ int.jl:554 within `rem`
# │   ││││ %15 = Base.bitcast(UInt64, %14)::UInt64
# │   │││└
# │   │││┌ @ int.jl:87 within `+`
# │   ││││ %16 = Base.add_int(%15, 0x0000000000000001)::UInt64
# │   │││└
# │   │││ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:339 within `SamplerRangeNDL` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:328
# │   │││ %17 = %new(Random.SamplerRangeNDL{UInt64, Int64}, 1, %16)::Random.SamplerRangeNDL{UInt64, Int64}
# └───│││       goto #9
# 9 ──│││       goto #10
# 10 ─│││       goto #11
#     │└└
# 11 ─│ %21 = invoke Random.rand($(QuoteNode(Random.TaskLocalRNG()))::Random.TaskLocalRNG, %17::Random.SamplerRangeNDL{UInt64, Int64})::Int64
# └───│       goto #12
# 12 ─│       goto #13
#     └
#     ┌ @ essentials.jl:13 within `getindex`
# 13 ─│ %24 = Base.arrayref(true, source, %21)::Int64
# └───│       return %24
#     └
# ) => Int64

# -----------
# @Macro @code_typed optimize=true foo(x)
# 
# to control whether additional optimizations, such as inlining, are also applied.

# -------------------------
# InteractiveUtils.code_warntype
# Function code_warntype([io::IO], f, types; debuginfo=:default)
#
# Prints lowered and type-inferred ASTs for the methods matching the given generic function and type signature to io
# which defaults to stdout. The ASTs are annotated in such a way as to cause "non-leaf" types which may be problematic
# for performance to be emphasized (if color is available, displayed in red). This serves as a warning of potential type
# instability.
# 
# Not all non-leaf types are particularly problematic for performance, and the performance characteristics of a
# particular type is an implementation detail of the compiler. code_warntype will err on the side of coloring types red
# if they might be a performance concern, so some types may be colored red even if they do not impact performance. Small
# unions of concrete types are usually not a concern, so these are highlighted in yellow. 
# Keyword argument debuginfo may be one of :source or :none (default), to specify the verbosity of code comments.
# See the @code_warntype section in the Performance Tips page of the manual for more information.

# -------------------------
# InteractiveUtils.@code_warntype
# Macro @code_warntype
#
# Evaluates the arguments to the function or macro call, determines their types, and calls code_warntype on the
# resulting expression.

@code_warntype optimize=true choice(collect(1:6))
# MethodInstance for choice(::Vector{Int64})
#   from choice(source::Vector{T}) where T @ Main REPL[156]:1
# Static Parameters
#   T = Int64
# Arguments
#   #self#::Core.Const(choice)
#   source::Vector{Int64}
# Body::Int64
#      @ REPL[156]:2 within `choice`
#     ┌ @ essentials.jl:10 within `length`
# 1 ──│ %1  = Base.arraylen(source)::Int64
# │   └
# │   ┌ @ range.jl:5 within `Colon`
# │   │┌ @ range.jl:403 within `UnitRange`
# │   ││┌ @ range.jl:414 within `unitrange_last`
# │   │││┌ @ operators.jl:425 within `>=`
# │   ││││┌ @ int.jl:514 within `<=`
# │   │││││ %2  = Base.sle_int(1, %1)::Bool
# │   │││└└
# └───│││       goto #3 if not %2
# 2 ──│││       goto #4
# 3 ──│││       goto #4
#     ││└
# 4 ┄─││ %6  = φ (#2 => %1, #3 => 0)::Int64
# └───││       goto #5
# 5 ──││       goto #6
#     └└
#     ┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:260 within `rand` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:255
#     │┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:139 within `Sampler` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:189
#     ││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:333 within `SamplerRangeNDL`
#     │││┌ @ range.jl:672 within `isempty`
#     ││││┌ @ operators.jl:378 within `>`
#     │││││┌ @ int.jl:83 within `<`
# 6 ──││││││ %9  = Base.slt_int(%6, 1)::Bool
# │   │││└└└
# └───│││       goto #8 if not %9
# 7 ──│││ %11 = invoke Random.ArgumentError("collection must be non-empty"::String)::ArgumentError
# │   │││       Random.throw(%11)
# └───│││       unreachable
#     │││ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:336 within `SamplerRangeNDL`
#     │││┌ @ int.jl:86 within `-`
# 8 ──││││ %14 = Base.sub_int(%6, 1)::Int64
# │   │││└
# │   │││┌ @ int.jl:554 within `rem`
# │   ││││ %15 = Base.bitcast(UInt64, %14)::UInt64
# │   │││└
# │   │││┌ @ int.jl:87 within `+`
# │   ││││ %16 = Base.add_int(%15, 0x0000000000000001)::UInt64
# │   │││└
# │   │││ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:339 within `SamplerRangeNDL` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:328
# │   │││ %17 = %new(Random.SamplerRangeNDL{UInt64, Int64}, 1, %16)::Random.SamplerRangeNDL{UInt64, Int64}
# └───│││       goto #9
# 9 ──│││       goto #10
# 10 ─│││       goto #11
#     │└└
# 11 ─│ %21 = invoke Random.rand($(QuoteNode(Random.TaskLocalRNG()))::Random.TaskLocalRNG, %17::Random.SamplerRangeNDL{UInt64, Int64})::Int64
# └───│       goto #12
# 12 ─│       goto #13
#     └
#     ┌ @ essentials.jl:13 within `getindex`
# 13 ─│ %24 = Base.arrayref(true, source, %21)::Int64
# └───│       return %24
#     └

# -------------------------
# InteractiveUtils.code_llvm
# Function code_llvm([io=stdout,], f, types; raw=false, dump_module=false, optimize=true, debuginfo=:default)
# 
# Prints the LLVM bitcodes generated for running the method matching the given generic function and type signature to
# io.
# 
# If the optimize keyword is unset, the code will be shown before LLVM optimizations. All metadata and dbg.* calls are
# removed from the printed bitcode. For the full IR, set the raw keyword to true. To dump the entire module that
# encapsulates the function (with declarations), set the dump_module keyword to true. Keyword argument debuginfo may be
# one of source (default) or none, to specify the verbosity of code comments.

# -------------------------
# InteractiveUtils.@code_llvm
# Macro @code_llvm
# 
# Evaluates the arguments to the function or macro call, determines their types, and calls code_llvm on the resulting
# expression. Set the optional keyword arguments raw, dump_module, debuginfo, optimize by putting them and their value
# before the function call, like this:
#   @code_llvm raw=true dump_module=true debuginfo=:default f(x)
#   @code_llvm optimize=false f(x)
#
# optimize controls whether additional optimizations, such as inlining, are also applied. raw makes all metadata and
# dbg.* calls visible. debuginfo may be one of :source (default) or :none, to specify the verbosity of code comments.
# dump_module prints the entire module that encapsulates the function.

@code_llvm choice(collect(1:6))
# ;  @ REPL[156]:1 within `choice`
# ; Function Attrs: uwtable
# define i64 @julia_choice_2331({}* noundef nonnull align 16 dereferenceable(40) %0) #0 {
# top:
#   %gcframe8 = alloca [3 x {}*], align 16
#   %gcframe8.sub = getelementptr inbounds [3 x {}*], [3 x {}*]* %gcframe8, i64 0, i64 0
#   %1 = bitcast [3 x {}*]* %gcframe8 to i8*
#   call void @llvm.memset.p0i8.i64(i8* align 16 %1, i8 0, i64 24, i1 true)
#   %newstruct = alloca [2 x i64], align 8
#   %2 = call {}*** inttoptr (i64 140712659899440 to {}*** ()*)() #10
# ;  @ REPL[156]:2 within `choice`
# ; ┌ @ essentials.jl:10 within `length`
#    %3 = bitcast [3 x {}*]* %gcframe8 to i64*
#    store i64 4, i64* %3, align 16
#    %4 = getelementptr inbounds [3 x {}*], [3 x {}*]* %gcframe8, i64 0, i64 1
#    %5 = bitcast {}** %4 to {}***
#    %6 = load {}**, {}*** %2, align 8
#    store {}** %6, {}*** %5, align 8
#    %7 = bitcast {}*** %2 to {}***
#    store {}** %gcframe8.sub, {}*** %7, align 8
#    %8 = bitcast {}* %0 to { i8*, i64, i16, i16, i32 }*
#    %arraylen_ptr = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %8, i64 0, i32 1
#    %arraylen = load i64, i64* %arraylen_ptr, align 8
# ; └
# ; ┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:260 within `rand` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:255
# ; │┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:139 within `Sampler` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:189
# ; ││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:333 within `SamplerRangeNDL`
# ; │││┌ @ range.jl:672 within `isempty`
# ; ││││┌ @ operators.jl:378 within `>`
# ; │││││┌ @ int.jl:83 within `<`
#         %.not = icmp eq i64 %arraylen, 0
# ; │││└└└
#      br i1 %.not, label %L11, label %L14
# 
# L11:                                              ; preds = %top
#      %9 = call [1 x {}*] @j_ArgumentError_2333({}* inttoptr (i64 140712187852976 to {}*))
#      %10 = getelementptr inbounds [3 x {}*], [3 x {}*]* %gcframe8, i64 0, i64 2
#      %11 = extractvalue [1 x {}*] %9, 0
#      store {}* %11, {}** %10, align 16
#      %ptls_field9 = getelementptr inbounds {}**, {}*** %2, i64 2
#      %12 = bitcast {}*** %ptls_field9 to i8**
#      %ptls_load1011 = load i8*, i8** %12, align 8
#      %box = call noalias nonnull dereferenceable(16) {}* @ijl_gc_pool_alloc(i8* %ptls_load1011, i32 752, i32 16) #8
#      %13 = bitcast {}* %box to i64*
#      %14 = getelementptr inbounds i64, i64* %13, i64 -1
#      store atomic i64 140712153711872, i64* %14 unordered, align 8
#      %15 = bitcast {}* %box to {}**
#      store {}* %11, {}** %15, align 8
#      call void @ijl_throw({}* %box)
#      unreachable
# 
# L14:                                              ; preds = %top
# ; │││ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:339 within `SamplerRangeNDL` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:328
#      %memcpy_refined_dst = getelementptr inbounds [2 x i64], [2 x i64]* %newstruct, i64 0, i64 0
#      store i64 1, i64* %memcpy_refined_dst, align 8
#      %16 = getelementptr inbounds [2 x i64], [2 x i64]* %newstruct, i64 0, i64 1
#      store i64 %arraylen, i64* %16, align 8
# ; │└└
#    %17 = call i64 @j_rand_2334([2 x i64]* nocapture readonly %newstruct)
# ; └
# ; ┌ @ essentials.jl:13 within `getindex`
#    %18 = add i64 %17, -1
#    %arraylen3 = load i64, i64* %arraylen_ptr, align 8
#    %inbounds = icmp ult i64 %18, %arraylen3
#    br i1 %inbounds, label %idxend, label %oob
# 
# oob:                                              ; preds = %L14
#    %errorbox = alloca i64, align 8
#    store i64 %17, i64* %errorbox, align 8
#    call void @ijl_bounds_error_ints({}* %0, i64* nonnull %errorbox, i64 1)
#    unreachable
# 
# idxend:                                           ; preds = %L14
#    %19 = bitcast {}* %0 to i64**
#    %arrayptr6 = load i64*, i64** %19, align 8
#    %20 = getelementptr inbounds i64, i64* %arrayptr6, i64 %18
#    %arrayref = load i64, i64* %20, align 8
#    %21 = load {}*, {}** %4, align 8
#    %22 = bitcast {}*** %2 to {}**
#    store {}* %21, {}** %22, align 8
#    ret i64 %arrayref
# ; └
# }

# -------------------------
# InteractiveUtils.code_native
# Function code_native([io=stdout,], f, types; syntax=:intel, debuginfo=:default, binary=false, dump_module=true)
#
# Prints the native assembly instructions generated for running the method matching the given generic function and type
# signature to io.
#
# Set assembly syntax by setting syntax to :intel (default) for intel syntax or :att for AT&T syntax.
# Specify verbosity of code comments by setting debuginfo to :source (default) or :none.
# If binary is true, also print the binary machine code for each instruction precedented by an abbreviated address.
# If dump_module is false, do not print metadata such as rodata or directives.
# If raw is false, uninteresting instructions (like the safepoint function prologue) are elided.
# See also: @code_native, code_llvm, code_typed and code_lowered

# -------------------------
# InteractiveUtils.@code_native
# Macro @code_native
#
# Evaluates the arguments to the function or macro call, determines their types, and calls code_native on the resulting
# expression.
# 
# Set any of the optional keyword arguments syntax, debuginfo, binary or dump_module by putting it before the function
# call, like this:
#   @code_native syntax=:intel debuginfo=:default binary=true dump_module=false f(x)
# 
# Set assembly syntax by setting syntax to :intel (default) for Intel syntax or :att for AT&T syntax.
# Specify verbosity of code comments by setting debuginfo to :source (default) or :none.
# If binary is true, also print the binary machine code for each instruction precedented by an abbreviated address.
# If dump_module is false, do not print metadata such as rodata or directives.
# See also: code_native, @code_llvm, @code_typed and @code_lowered

@code_native choice(collect(1:6))
#         .text
#         .file   "choice"
#         .globl  julia_choice_2335               # -- Begin function julia_choice_2335
#         .p2align        4, 0x90
#         .type   julia_choice_2335,@function
# julia_choice_2335:                      # @julia_choice_2335
# ; ┌ @ REPL[156]:1 within `choice`
#         .cfi_startproc
# # %bb.0:                                # %top
#         push    rbp
#         .cfi_def_cfa_offset 16
#         .cfi_offset rbp, -16
#         mov     rbp, rsp
#         .cfi_def_cfa_register rbp
#         push    rsi
#         push    rdi
#         push    rbx
#         sub     rsp, 40
#         .cfi_offset rbx, -40
#         .cfi_offset rdi, -32
#         .cfi_offset rsi, -24
#         mov     rsi, rcx
#         movabs  rbx, 140712153711872
#         vxorps  xmm0, xmm0, xmm0
#         vmovaps xmmword ptr [rbp - 48], xmm0
#         mov     qword ptr [rbp - 32], 0
#         lea     rax, [rbx + 506187568]
#         sub     rsp, 32
#         call    rax
#         add     rsp, 32
#         mov     rdi, rax
# ; │ @ REPL[156]:2 within `choice`
# ; │┌ @ essentials.jl:10 within `length`
#         mov     qword ptr [rbp - 48], 4
#         mov     rax, qword ptr [rax]
#         mov     qword ptr [rbp - 40], rax
#         lea     rax, [rbp - 48]
#         mov     qword ptr [rdi], rax
#         mov     rax, qword ptr [rsi + 8]
# ; │└
# ; │┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:260 within `rand` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:255
# ; ││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:139 within `Sampler` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:189
# ; │││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:333 within `SamplerRangeNDL`
# ; ││││┌ @ range.jl:672 within `isempty`
# ; │││││┌ @ operators.jl:378 within `>`
# ; ││││││┌ @ int.jl:83 within `<`
#         test    rax, rax
# ; ││││└└└
#         je      .LBB0_3
# # %bb.1:                                # %L14
# ; ││││ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:339 within `SamplerRangeNDL` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:328
#         mov     qword ptr [rbp - 64], 1
#         mov     qword ptr [rbp - 56], rax
# ; ││└└
#         sub     rsp, 32
#         movabs  rax, offset j_rand_2338
#         lea     rcx, [rbp - 64]
#         call    rax
#         add     rsp, 32
#         mov     rcx, rax
# ; │└
# ; │┌ @ essentials.jl:13 within `getindex`
#         dec     rax
#         cmp     rax, qword ptr [rsi + 8]
#         jae     .LBB0_4
# # %bb.2:                                # %idxend
#         mov     rax, qword ptr [rsi]
#         mov     rax, qword ptr [rax + 8*rcx - 8]
#         mov     rcx, qword ptr [rbp - 40]
#         mov     qword ptr [rdi], rcx
#         lea     rsp, [rbp - 24]
#         pop     rbx
#         pop     rdi
#         pop     rsi
#         pop     rbp
#         ret
# .LBB0_3:                                # %L11
# ; │└
# ; │┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:260 within `rand` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:255
# ; ││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\Random.jl:139 within `Sampler` @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:189
# ; │││┌ @ C:\workdir\usr\share\julia\stdlib\v1.10\Random\src\generation.jl:333 within `SamplerRangeNDL`
#         sub     rsp, 32
#         movabs  rax, offset j_ArgumentError_2337
#         movabs  rcx, 140712187852976
#         call    rax
#         add     rsp, 32
#         mov     rsi, rax
#         mov     qword ptr [rbp - 32], rax
#         mov     rcx, qword ptr [rdi + 16]
#         sub     rsp, 32
#         movabs  rax, offset ijl_gc_pool_alloc
#         mov     edx, 752
#         mov     r8d, 16
#         call    rax
#         add     rsp, 32
#         mov     qword ptr [rax - 8], rbx
#         mov     qword ptr [rax], rsi
#         sub     rsp, 32
#         movabs  rdx, offset ijl_throw
#         mov     rcx, rax
#         call    rdx
# .LBB0_4:                                # %oob
# ; │└└└
# ; │┌ @ essentials.jl:13 within `getindex`
#         mov     eax, 16
#         movabs  r11, offset ___chkstk_ms
#         call    r11
#         sub     rsp, rax
#         mov     rdx, rsp
#         mov     qword ptr [rdx], rcx
#         sub     rsp, 32
#         movabs  rax, offset ijl_bounds_error_ints
#         mov     r8d, 1
#         mov     rcx, rsi
#         call    rax
# .Lfunc_end0:
#         .size   julia_choice_2335, .Lfunc_end0-julia_choice_2335
#         .cfi_endproc
# ; └└
#                                         # -- End function
#         .type   .L_j_const1,@object             # @_j_const1
#         .section        .rodata.cst8,"aM",@progbits,8
#         .p2align        3
# .L_j_const1:
#         .quad   1                               # 0x1
#         .size   .L_j_const1, 8
# 
#         .section        ".note.GNU-stack","",@progbits


# -------------------------
# InteractiveUtils.@time_imports
# Macro @time_imports
#
# A macro to execute an expression and produce a report of any time spent importing packages and their dependencies. Any
# compilation time will be reported as a percentage, and how much of which was recompilation, if any.
# 
# One line is printed per package or package extension. The duration shown is the time to import that package itself,
# not including the time to load any of its dependencies.
# 
# On Julia 1.9+ package extensions will show as Parent → Extension.
# 
# Note: During the load process a package sequentially imports all of its dependencies, not just its direct
# dependencies.

@time_imports using CSV
#     50.7 ms  Parsers 17.52% compilation time
#      0.2 ms  DataValueInterfaces
#      1.6 ms  DataAPI
#      0.1 ms  IteratorInterfaceExtensions
#      0.1 ms  TableTraits
#     17.5 ms  Tables
#     26.8 ms  PooledArrays
#    193.7 ms  SentinelArrays 75.12% compilation time
#      8.6 ms  InlineStrings
#     20.3 ms  WeakRefStrings
#      2.0 ms  TranscodingStreams
#      1.4 ms  Zlib_jll
#      1.8 ms  CodecZlib
#      0.8 ms  Compat
#     13.1 ms  FilePathsBase 28.39% compilation time
#   1681.2 ms  CSV 92.40% compilation time

# -------------------------
# InteractiveUtils.clipboard
# Function clipboard(x)
# 
# Send a printed form of x to the operating system clipboard ("copy").

# -----------
# Function clipboard() -> String
# 
# Return a string with the contents of the operating system clipboard ("paste").
