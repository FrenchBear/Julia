# Labyrinth in Julia
# Arguments processing
#
# 2024-03-15    PV      First julia app


# General options
show_solution::Bool = false
is_monochrome::Bool = false
simple_print::Bool = false
random_shuffle::Bool = false

# Labyrinth itself
rows::Int = 10
cols::Int = 20
col_start::Int = 0
col_end::Int = 0

# Printing options
CornersA = [' ', '|', '-', '+', '|', '|', '+', '+', '-', '+', '-', '+', '+', '+', '+', '+', '*',]
CornersS = [' ', '│', '─', '└', '│', '│', '┌', '├', '─', '┘', '─', '┴', '┐', '┤', '┬', '┼', '█',]
CornersR = [' ', '╵', '╶', '╰', '╷', '│', '╭', '├', '╴', '╯', '─', '┴', '╮', '┤', '┬', '┼', '█',]
CornersB = [' ', '╹', '╺', '┗', '╻', '┃', '┏', '┣', '╸', '┛', '━', '┻', '┓', '┫', '┳', '╋', '█',]
CornersD = [' ', '║', '═', '╚', '║', '║', '╔', '╠', '═', '╝', '═', '╩', '╗', '╣', '╦', '╬', '█',]

Corners = CornersA


i = 1
while i <= length(ARGS)
    global i, rows, cols, Corners
    global show_solution, is_monochrome, simple_print, random_shuffle

    arg = ARGS[i]
    if (arg[1] == '/')
        arg = "-" * arg[2:end]
    end
    #opt = ""

    getopt() = begin
        i += 1
        if (i > length(ARGS))
            println("julab: option $(arg) requires an argument")
            exit(1)
        end
        ARGS[i]
    end

    if (arg in ["?", "-?", "-h", "help", "-help", "--help"])
        println("Generation of a random labyrinth, and optionally show solution path (Julia version)")
        println("Usage: jullab [-h] [-a] [-b a|s|b|d|r] [-s [-m]] [-d] [-r rows] [-c cols]")
        println("-h           Shows this message")
        println("-a           Simple print (ASCII only)")
        println("-b a|s|b|d|r Border style, a=ASCII, s=Simple, b=Bold, d=Double, r=Rounded (use chcp 65001 for styles s/b/d/r on Windows)")
        println("-s           Shows solution")
        println("-m           Monochrome (no color) solution output")
        println("-d           Shuffle random generator")
        println("-r rows      Number of rows in [5..100], default $(rows)")
        println("-c cols      Number of columns in [5..100], default $(cols)")
        exit(0)
    end

    if (arg == "-s")
        show_solution = true
    elseif (arg == "-m")
        is_monochrome = true
    elseif (arg == "-a")
        simple_print = true
    elseif (arg == "-d")
        random_shuffle = true
    elseif (arg == "-b")
        o = lowercase(getopt())
        if (o == "a")
            Corners = CornersA
        elseif (o == "s")
            Corners = CornersS
        elseif (o == "r")
            Corners = CornersR
        elseif (o == "b")
            Corners = CornersB
        elseif (o == "d")
            Corners = CornersD
        else
            println("julab: invalid argument for option -b")
            exit(1)
        end
    elseif (arg == "-r")
        rtemp::Int = 0
        try
            rtemp = parse(Int, getopt())
        catch
            println("julab: Invalid argument for option -r")
            exit(1)
        end
        if (!(rtemp in 5:200))
            print("jullab: rows argument must be in the range 5..200")
            sys.exit()
        end
        rows = rtemp
    elseif (arg == "-c")
        ctemp::Int = 0
        try
            ctemp = parse(Int, getopt())
        catch
            println("julab: Invalid argument for option -c")
            exit(1)
        end
        if (!(ctemp in 5:200))
            print("jullab: rows argument must be in the range 5..200")
            sys.exit()
        end
        cols = ctemp
    else
        print("jullab: unknown/unsupported option $(arg)")
        exit(1)
    end

    i += 1
end
