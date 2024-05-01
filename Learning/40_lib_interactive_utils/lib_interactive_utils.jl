# lib_interactive_utils.jl
# Julia Std Library doc, InteractiveUtils
# 
# 2024-05-01    PV


# Interactive Utilities

# This module is intended for interactive work. It is loaded automatically in interactive mode.

Base.Docs.apropos
—
Function
apropos([io::IO=stdout], pattern::Union{AbstractString,Regex})

Search available docstrings for entries containing pattern.

When pattern is a string, case is ignored. Results are printed to io.

apropos can be called from the help mode in the REPL by wrapping the query in double quotes:

help?> "pattern"

InteractiveUtils.varinfo
—
Function
varinfo(m::Module=Main, pattern::Regex=r""; all=false, imported=false, recursive=false, sortby::Symbol=:name, minsize::Int=0)

Return a markdown table giving information about exported global variables in a module, optionally restricted to those matching pattern.

The memory consumption estimate is an approximate lower bound on the size of the internal structure of the object.

all : also list non-exported objects defined in the module, deprecated objects, and compiler-generated objects.
imported : also list objects explicitly imported from other modules.
recursive : recursively include objects in sub-modules, observing the same settings in each.
sortby : the column to sort results by. Options are :name (default), :size, and :summary.
minsize : only includes objects with size at least minsize bytes. Defaults to 0.
The output of varinfo is intended for display purposes only. See also names to get an array of symbols defined in a module, which is suitable for more general manipulations.

InteractiveUtils.versioninfo
—
Function
versioninfo(io::IO=stdout; verbose::Bool=false)

Print information about the version of Julia in use. The output is controlled with boolean keyword arguments:

verbose: print all additional information
Warning
The output of this function may contain sensitive information. Before sharing the output, please review the output and remove any data that should not be shared publicly.

See also: VERSION.

InteractiveUtils.methodswith
—
Function
methodswith(typ[, module or function]; supertypes::Bool=false])

Return an array of methods with an argument of type typ.

The optional second argument restricts the search to a particular module or function (the default is all top-level modules).

If keyword supertypes is true, also return arguments with a parent type of typ, excluding type Any.

InteractiveUtils.subtypes
—
Function
subtypes(T::DataType)

Return a list of immediate subtypes of DataType T. Note that all currently loaded subtypes are included, including those not visible in the current module.

See also supertype, supertypes, methodswith.

Examples

subtypes(Integer)
3-element Vector{Any}:
 Bool
 Signed
 Unsigned

InteractiveUtils.supertypes
—
Function
supertypes(T::Type)

Return a tuple (T, ..., Any) of T and all its supertypes, as determined by successive calls to the supertype function, listed in order of <: and terminated by Any.

See also subtypes.

Examples

supertypes(Int)
(Int64, Signed, Integer, Real, Number, Any)

InteractiveUtils.edit
—
Method
edit(path::AbstractString, line::Integer=0, column::Integer=0)

Edit a file or directory optionally providing a line number to edit the file at. Return to the julia prompt when you quit the editor. The editor can be changed by setting JULIA_EDITOR, VISUAL or EDITOR as an environment variable.

See also define_editor.

InteractiveUtils.edit
—
Method
edit(function, [types])
edit(module)

Edit the definition of a function, optionally specifying a tuple of types to indicate which method to edit. For modules, open the main source file. The module needs to be loaded with using or import first.

Julia 1.1
edit on modules requires at least Julia 1.1.

To ensure that the file can be opened at the given line, you may need to call define_editor first.

InteractiveUtils.@edit
—
Macro
@edit

Evaluates the arguments to the function or macro call, determines their types, and calls the edit function on the resulting expression.

See also: @less, @which.

InteractiveUtils.define_editor
—
Function
define_editor(fn, pattern; wait=false)

Define a new editor matching pattern that can be used to open a file (possibly at a given line number) using fn.

The fn argument is a function that determines how to open a file with the given editor. It should take four arguments, as follows:

cmd - a base command object for the editor
path - the path to the source file to open
line - the line number to open the editor at
column - the column number to open the editor at
Editors which cannot open to a specific line with a command or a specific column may ignore the line and/or column argument. The fn callback must return either an appropriate Cmd object to open a file or nothing to indicate that they cannot edit this file. Use nothing to indicate that this editor is not appropriate for the current environment and another editor should be attempted. It is possible to add more general editing hooks that need not spawn external commands by pushing a callback directly to the vector EDITOR_CALLBACKS.

The pattern argument is a string, regular expression, or an array of strings and regular expressions. For the fn to be called, one of the patterns must match the value of EDITOR, VISUAL or JULIA_EDITOR. For strings, the string must equal the basename of the first word of the editor command, with its extension, if any, removed. E.g. "vi" doesn't match "vim -g" but matches "/usr/bin/vi -m"; it also matches vi.exe. If pattern is a regex it is matched against all of the editor command as a shell-escaped string. An array pattern matches if any of its items match. If multiple editors match, the one added most recently is used.

By default julia does not wait for the editor to close, running it in the background. However, if the editor is terminal based, you will probably want to set wait=true and julia will wait for the editor to close before resuming.

If one of the editor environment variables is set, but no editor entry matches it, the default editor entry is invoked:

(cmd, path, line, column) -> `$cmd $path`

Note that many editors are already defined. All of the following commands should already work:

emacs
emacsclient
vim
nvim
nano
micro
kak
helix
textmate
mate
kate
subl
atom
notepad++
Visual Studio Code
open
pycharm
bbedit
Example:

The following defines the usage of terminal-based emacs:

define_editor(
    r"\bemacs\b.*\s(-nw|--no-window-system)\b", wait=true) do cmd, path, line
    `$cmd +$line $path`
end

Julia 1.4
define_editor was introduced in Julia 1.4.

InteractiveUtils.less
—
Method
less(file::AbstractString, [line::Integer])

Show a file using the default pager, optionally providing a starting line number. Returns to the julia prompt when you quit the pager.

InteractiveUtils.less
—
Method
less(function, [types])

Show the definition of a function using the default pager, optionally specifying a tuple of types to indicate which method to see.

InteractiveUtils.@less
—
Macro
@less

Evaluates the arguments to the function or macro call, determines their types, and calls the less function on the resulting expression.

See also: @edit, @which, @code_lowered.

InteractiveUtils.@which
—
Macro
@which

Applied to a function or macro call, it evaluates the arguments to the specified call, and returns the Method object for the method that would be called for those arguments. Applied to a variable, it returns the module in which the variable was bound. It calls out to the which function.

See also: @less, @edit.

InteractiveUtils.@functionloc
—
Macro
@functionloc

Applied to a function or macro call, it evaluates the arguments to the specified call, and returns a tuple (filename,line) giving the location for the method that would be called for those arguments. It calls out to the functionloc function.

InteractiveUtils.@code_lowered
—
Macro
@code_lowered

Evaluates the arguments to the function or macro call, determines their types, and calls code_lowered on the resulting expression.

InteractiveUtils.@code_typed
—
Macro
@code_typed

Evaluates the arguments to the function or macro call, determines their types, and calls code_typed on the resulting expression. Use the optional argument optimize with

@code_typed optimize=true foo(x)

to control whether additional optimizations, such as inlining, are also applied.

InteractiveUtils.code_warntype
—
Function
code_warntype([io::IO], f, types; debuginfo=:default)

Prints lowered and type-inferred ASTs for the methods matching the given generic function and type signature to io which defaults to stdout. The ASTs are annotated in such a way as to cause "non-leaf" types which may be problematic for performance to be emphasized (if color is available, displayed in red). This serves as a warning of potential type instability.

Not all non-leaf types are particularly problematic for performance, and the performance characteristics of a particular type is an implementation detail of the compiler. code_warntype will err on the side of coloring types red if they might be a performance concern, so some types may be colored red even if they do not impact performance. Small unions of concrete types are usually not a concern, so these are highlighted in yellow.

Keyword argument debuginfo may be one of :source or :none (default), to specify the verbosity of code comments.

See the @code_warntype section in the Performance Tips page of the manual for more information.

InteractiveUtils.@code_warntype
—
Macro
@code_warntype

Evaluates the arguments to the function or macro call, determines their types, and calls code_warntype on the resulting expression.

InteractiveUtils.code_llvm
—
Function
code_llvm([io=stdout,], f, types; raw=false, dump_module=false, optimize=true, debuginfo=:default)

Prints the LLVM bitcodes generated for running the method matching the given generic function and type signature to io.

If the optimize keyword is unset, the code will be shown before LLVM optimizations. All metadata and dbg.* calls are removed from the printed bitcode. For the full IR, set the raw keyword to true. To dump the entire module that encapsulates the function (with declarations), set the dump_module keyword to true. Keyword argument debuginfo may be one of source (default) or none, to specify the verbosity of code comments.

InteractiveUtils.@code_llvm
—
Macro
@code_llvm

Evaluates the arguments to the function or macro call, determines their types, and calls code_llvm on the resulting expression. Set the optional keyword arguments raw, dump_module, debuginfo, optimize by putting them and their value before the function call, like this:

@code_llvm raw=true dump_module=true debuginfo=:default f(x)
@code_llvm optimize=false f(x)

optimize controls whether additional optimizations, such as inlining, are also applied. raw makes all metadata and dbg.* calls visible. debuginfo may be one of :source (default) or :none, to specify the verbosity of code comments. dump_module prints the entire module that encapsulates the function.

InteractiveUtils.code_native
—
Function
code_native([io=stdout,], f, types; syntax=:intel, debuginfo=:default, binary=false, dump_module=true)

Prints the native assembly instructions generated for running the method matching the given generic function and type signature to io.

Set assembly syntax by setting syntax to :intel (default) for intel syntax or :att for AT&T syntax.
Specify verbosity of code comments by setting debuginfo to :source (default) or :none.
If binary is true, also print the binary machine code for each instruction precedented by an abbreviated address.
If dump_module is false, do not print metadata such as rodata or directives.
If raw is false, uninteresting instructions (like the safepoint function prologue) are elided.
See also: @code_native, code_llvm, code_typed and code_lowered

InteractiveUtils.@code_native
—
Macro
@code_native

Evaluates the arguments to the function or macro call, determines their types, and calls code_native on the resulting expression.

Set any of the optional keyword arguments syntax, debuginfo, binary or dump_module by putting it before the function call, like this:

@code_native syntax=:intel debuginfo=:default binary=true dump_module=false f(x)

Set assembly syntax by setting syntax to :intel (default) for Intel syntax or :att for AT&T syntax.
Specify verbosity of code comments by setting debuginfo to :source (default) or :none.
If binary is true, also print the binary machine code for each instruction precedented by an abbreviated address.
If dump_module is false, do not print metadata such as rodata or directives.
See also: code_native, @code_llvm, @code_typed and @code_lowered

InteractiveUtils.@time_imports
—
Macro
@time_imports

A macro to execute an expression and produce a report of any time spent importing packages and their dependencies. Any compilation time will be reported as a percentage, and how much of which was recompilation, if any.

One line is printed per package or package extension. The duration shown is the time to import that package itself, not including the time to load any of its dependencies.

On Julia 1.9+ package extensions will show as Parent → Extension.

Note
During the load process a package sequentially imports all of its dependencies, not just its direct dependencies.

@time_imports using CSV
     50.7 ms  Parsers 17.52% compilation time
      0.2 ms  DataValueInterfaces
      1.6 ms  DataAPI
      0.1 ms  IteratorInterfaceExtensions
      0.1 ms  TableTraits
     17.5 ms  Tables
     26.8 ms  PooledArrays
    193.7 ms  SentinelArrays 75.12% compilation time
      8.6 ms  InlineStrings
     20.3 ms  WeakRefStrings
      2.0 ms  TranscodingStreams
      1.4 ms  Zlib_jll
      1.8 ms  CodecZlib
      0.8 ms  Compat
     13.1 ms  FilePathsBase 28.39% compilation time
   1681.2 ms  CSV 92.40% compilation time

Julia 1.8
This macro requires at least Julia 1.8

InteractiveUtils.clipboard
—
Function
clipboard(x)

Send a printed form of x to the operating system clipboard ("copy").

clipboard() -> String

Return a string with the contents of the operating system clipboard ("paste").
