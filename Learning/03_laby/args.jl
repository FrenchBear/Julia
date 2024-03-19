# Labyrinth in Julia
# Arguments processing
#
# 2024-03-15    PV      First julia app


# General options
showSolution::Bool = false
isMonochrome::Bool = false
simplePrint::Bool = false
randomShuffle::Bool = false

# Labyrinth itself
rows::Int = 10
cols::Int = 20
colStart::Int = 0
colEnd::Int = 0

# Printing options
cornersA = [' ', '|', '-', '+', '|', '|', '+', '+', '-', '+', '-', '+', '+', '+', '+', '+', '*',]
cornersS = [' ', '│', '─', '└', '│', '│', '┌', '├', '─', '┘', '─', '┴', '┐', '┤', '┬', '┼', '█',]
cornersR = [' ', '╵', '╶', '╰', '╷', '│', '╭', '├', '╴', '╯', '─', '┴', '╮', '┤', '┬', '┼', '█',]
cornersB = [' ', '╹', '╺', '┗', '╻', '┃', '┏', '┣', '╸', '┛', '━', '┻', '┓', '┫', '┳', '╋', '█',]
cornersD = [' ', '║', '═', '╚', '║', '║', '╔', '╠', '═', '╝', '═', '╩', '╗', '╣', '╦', '╬', '█',]

corners = cornersA


i = 1
while i <= length(ARGS)
    global i, rows, cols, corners
    global showSolution, isMonochrome, simplePrint, randomShuffle

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
        showSolution = true
    elseif (arg == "-m")
        isMonochrome = true
    elseif (arg == "-a")
        simplePrint = true
    elseif (arg == "-d")
        randomShuffle = true
    elseif (arg == "-b")
        o = lowercase(getopt())
        if (o == "a")
            corners = cornersA
        elseif (o == "s")
            corners = cornersS
        elseif (o == "r")
            corners = cornersR
        elseif (o == "b")
            corners = cornersB
        elseif (o == "d")
            corners = cornersD
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
