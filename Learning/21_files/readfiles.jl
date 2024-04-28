# readfiles.jl
# Opening and reading files in Julia
#
# 2024-04-28    PV


# File handling in Julia is achieved using functions such as open(), read(), and close(). There are many ways to read
# the contents of a file like readline(), readlines() and just read().
# - open(): To open a file existing in an absolute path, provided as the parameter.  
# - read(): Read the contents of the file into a single string. 
# - close(): Close the file object or the variable holding the instance of an opened file.  

# Classic open-close
# Medod 1
f = open("test.txt", "r")
while !eof(f)
    line = readline(f)
end 
close(f)

# Method 2
f = open("test.txt", "r")
for line in readlines(f)
    #
end 
close(f)

# Read entiere file in a string
f = open("test.txt", "r")
alltext = read(f, String)       
close(f)


# readline
# Lines in the input end with '\n' or "\r\n" or the end of an input stream. When keep is false (as it is by default),
# these trailing newline characters are removed from the line before it is returned. When keep is true, they are
# returned as part of the line.
open("test.txt") do f
    while !eof(f)
        line = readline(f)
    end
end

# readlines
# Read all lines of an I/O stream or a file as a vector of strings
open("test.txt") do f
    for line in readlines(f)
        #
    end
end

# eachline
# Create an iterable EachLine object that will yield each line from an I/O stream or a file.
open("test.txt") do f
    for line in eachline(f)
        #
    end
end


open("test.txt") do file
    alltext = read(file, String)
end


# Read file content without open/close
lines = readlines("test.txt")
for line in readlines("test.txt")
    #
end
for line in eachline("test.txt")
    #
end
alltext = read("test.txt", String)


# Working with paths and filenames
# https://en.wikibooks.org/wiki/Introducing_Julia/Working_with_text_files
#
# These functions will be useful for working with filenames:
#    cd(path) changes the current directory.
#    pwd() gets the current working directory.
#    readdir(path) returns a lists of the contents of a named directory, or the current directory.
#    abspath(path) adds the current directory's path to a filename to make an absolute pathname.
#    joinpath(str, str, ...) assembles a pathname from pieces.
#    isdir(path) tells you whether the path is a directory.
#    splitdir(path) – split a path into a tuple of the directory name and file name.
#    splitdrive(path) – on Windows, split a path into the drive letter part and the path part. On Unix systems, the first component is always the empty string.
#    splitext(path) – if the last component of a path contains a dot, split the path into everything before the dot and everything including and after the dot. Otherwise, return a tuple of the argument unmodified and the empty string.
#    expanduser(path) – replaces a tilde character at the start of a path with the current user's home directory.
#    normpath(path) – normalizes a path, removing "." and ".." entries.
#    realpath(path) – canonicalizes a path by expanding symbolic links and removing "." and ".." entries.
#    homedir() – gets current user's home directory.
#    dirname(path) – gets the directory part of a path.
#    basename(path) – gets the file name part of a path.
