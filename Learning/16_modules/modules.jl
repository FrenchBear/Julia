# modules.jl
# Play with julia modules (Julia manual §16)
#
# 2024-04-08    PV      First version

# Modules in Julia help organize code into coherent units. They are delimited syntactically inside 
# module NameOfModule ... end
# and have the following features:
# - Modules are separate namespaces, each introducing a new global scope. This is useful, because it allows the same name
#   to be used for different functions or global variables without conflict, as long as they are in separate modules.
# - Files and file names are mostly unrelated to modules; modules are associated only with module expressions. One can
#   have multiple files per module, and multiple modules per file.
#   include behaves as if the contents of the source file were evaluated in the global scope of the including module. 

# Names (referring to functions, types, global variables, and constants) can be added to the export list of a module
# with export: these are the symbols that are imported when using the module.
# However, since qualified names always make identifiers accessible, this is just an option for organizing APIs: unlike
# other languages, Julia has no facilities for truly hiding module internals.

module NiceStuff
export nice, DOG
struct Dog end      # singleton type, not exported
const DOG = Dog()   # named instance, exported
nice(x) = "nice $x" # function, exported
end


# Standalone using and import

# The most common way of loading a module is using ModuleName. This loads the code associated with ModuleName, and
# brings the module name and the elements of the export list into the surrounding global namespace.

# To load a module from a package, the statement 
# using ModuleName
# can be used. To load a module from a locally defined module, a dot needs to be added before the module name.

# In contrast,
# import .NiceStuff
# brings only the module name into scope. Users would need to use NiceStuff.DOG, NiceStuff.Dog, and NiceStuff.nice
# to access its contents. Usually, import ModuleName is used in contexts when the user wants to keep the namespace clean.
# As we will see in the next section import .NiceStuff is equivalent to using .NiceStuff: NiceStuff.


# Using and import with specific identifiers, and adding methods

# When using ModuleName: or import ModuleName: is followed by a comma-separated list of names, the module is loaded,
# but only those specific names are brought into the namespace by the statement. For example,
# using .NiceStuff: nice, DOG
# will import the names nice and DOG.

# Iportantly, the module name NiceStuff will not be in the namespace. If you want to make it accessible, you have
# to list it explicitly, as
# using .NiceStuff: nice, DOG, NiceStuff


# Renaming with as

# An identifier brought into scope by import or using can be renamed with the keyword as. This is useful for working
# around name conflicts as well as for shortening names. For example, Base exports the function name read, but the
# CSV.jl package also provides CSV.read. If we are going to invoke CSV reading many times, it would be convenient to
# drop the CSV. qualifier. But then it is ambiguous whether we are referring to Base.read or CSV.read:
# Renaming provides a solution:
# import CSV: read as rd

# Imported packages themselves can also be renamed:
# import BenchmarkTools as BT


# Mixing multiple using and import statements

# When multiple using or import statements of any of the forms above are used, their effect is combined in the order
# they appear. For example,
# using .NiceStuff         # exported names and the module name
# import .NiceStuff: nice  # allows adding methods to unqualified functions


# Default top-level definitions and bare modules

# Modules automatically contain using Core, using Base, and definitions of the eval and include functions, which
# evaluate expressions/files within the global scope of that module.
# If these default definitions are not wanted, modules can be defined using the keyword baremodule instead (note: Core
# is still imported). In terms of baremodule, a standard module looks like this:
baremodule Mod
using Base
# ...
end



# Standard modules

# There are three important standard modules:
# - Core contains all functionality "built into" the language.
# - Base contains basic functionality that is useful in almost all cases.
# - Main is the top-level module and the current module, when Julia is started.

