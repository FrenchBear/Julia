# julab.jl
# My first real Julia program
# Labyrinth generation and solving
# 
# 2024-03-14    PV      First version, full new code

using Random

include("args.jl")


const TopWall = 1       # Also index in Cell.walls
const LeftWall = 2      # Also index in Cell.walls
const BottomWall = 3
const RightWall = 4

# Indices in corners array
const CellEmpty = 1
const CellSolution = 17
const VerticalWall = 6
const HorizontalWall = 11


mutable struct Cell
    walls::Array{Bool}
    visited::Bool
    dir_sol::Int8
end


lab = Array{Cell}(undef, rows + 1, cols + 1)
for row in 1:rows+1
    for col in 1:cols+1
        lab[row, col] = Cell(ones(Bool, 2), false, 0)
    end
end

# ----------------------------------------------------------------------------------
# Walls accessors

function ClearWall(row::Int, col::Int, wall::Int)
    global lab
    @assert 1 <= row <= rows
    @assert 1 <= col <= cols
    if (wall == TopWall || wall == LeftWall)
        lab[row, col].walls[wall] = false
    elseif (wall == RightWall)
        lab[row, col+1].walls[LeftWall] = false
    else
        lab[row+1, col].walls[TopWall] = false
    end
end

function GetWall(row::Int, col::Int, wall::Int)::Bool
    global lab
    @assert 1 <= row <= rows + 1
    @assert 1 <= col <= cols + 1
    @assert 1 <= wall <= 2
    if (wall == TopWall || wall == LeftWall)
        return lab[row, col].walls[wall]
    elseif (wall == RightWall)
        return lab[row, col+1].walls[LeftWall]
    else
        return lab[row+1, col].walls[TopWall]
    end
end

# ----------------------------------------------------------------------------------
# Printing

function IsSolution(row::Int, col::Int)
    if (row == 0)
        col == colStart
    elseif (row == rows + 1)
        col == colEnd
    else
        1 <= row <= rows + 1 && 1 <= col <= cols + 1 ? lab[row, col].dir_sol == 6 : false
    end
end

CoulOn()::String = isMonochrome ? "" : "\x1b[32m"
CoulOff()::String = isMonochrome ? "" : "\x1b[37m"
CoulSolutionOn()::String = isMonochrome ? "" : "\033[33m"
CoulSolutionOff()::String = isMonochrome ? "" : "\033[30m"

function GetCorner(up::Bool, right::Bool, down::Bool, left::Bool)::Char
    global corners
    ix = (up ? 1 : 0) + (right ? 2 : 0) + (down ? 4 : 0) + (left ? 8 : 0)
    return corners[ix+1]
end

function PrintCorner(row::Int, col::Int)
    @assert 1 <= row <= rows + 1
    @assert 1 <= col <= cols + 1

    up = row == 1 ? false : GetWall(row - 1, col, LeftWall)
    left = col == 1 ? false : GetWall(row, col - 1, TopWall)
    right = col == cols + 1 ? false : GetWall(row, col, TopWall)
    down = row == rows + 1 ? false : GetWall(row, col, LeftWall)
    print(CoulOn(), GetCorner(up, right, down, left), CoulOff())
end

function PrintTopWall(row::Int, col::Int)
    @assert 1 <= row <= rows + 1
    @assert 1 <= col <= cols + 1

    if (GetWall(row, col, TopWall))
        print(CoulOn(), corners[HorizontalWall]^2, CoulOff())
    elseif (IsSolution(row, col) && IsSolution(row - 1, col))
        print(CoulSolutionOn(), corners[CellSolution]^2, CoulSolutionOff())
    else
        print(corners[CellEmpty]^2)
    end
end

function PrintLeftWall(row::Int, col::Int)
    @assert 1 <= row <= rows + 1
    @assert 1 <= col <= cols + 1

    if (GetWall(row, col, LeftWall))
        print(CoulOn(), corners[VerticalWall], CoulOff())
    elseif (IsSolution(row, col) && IsSolution(row, col - 1))
        print(CoulSolutionOn(), corners[CellSolution], CoulSolutionOff())
    else
        print(corners[CellEmpty])
    end
end

function PrintCell(row::Int, col::Int)
    @assert 1 <= row <= rows + 1
    @assert 1 <= col <= cols + 1

    if (IsSolution(row, col))
        print(CoulSolutionOn(), corners[CellSolution]^2, CoulSolutionOff())
    else
        print(corners[CellEmpty]^2)
    end
end

# Enhanced printing using corners
function PrintEnhanced()
    for r in 1:rows
        for c in 1:cols
            PrintCorner(r, c)
            PrintTopWall(r, c)
        end
        PrintCorner(r, cols + 1)
        println()

        for c in 1:cols
            PrintLeftWall(r, c)
            PrintCell(r, c)
        end
        PrintLeftWall(r, cols + 1)
        println()
    end

    for c in 1:cols
        PrintCorner(rows + 1, c)
        PrintTopWall(rows + 1, c)
    end
    PrintCorner(rows + 1, cols + 1)
    println()
end


# Simple ASCII print using + - |
function PrintSimple()
    path_dot1 = isMonochrome ? "\u2588" : "\033[43m \033[40m"
    path_dot2 = isMonochrome ? "\u2588\u2588" : "\033[43m  \033[40m"
    for r in 1:rows+1
        # 1st line, top wall
        for c in 1:cols+1
            cell = lab[r, c]
            print('+')

            if (c <= cols)
                if (cell.walls[TopWall])
                    print("--")
                else
                    if (r == 1)
                        print(c == colStart && showSolution ? path_dot2 : "  ")
                    elseif (r == rows + 1)
                        print(c == colEnd && showSolution ? path_dot2 : "  ")
                    else
                        print(cell.dir_sol == 6 && lab[r-1, c].dir_sol == 6 ? path_dot2 : "  ")
                    end
                end
            end
        end
        println()

        # 2nd line, left wall and cell interior (except on last col)
        if (r <= rows)
            for c in 1:cols+1
                cell = lab[r, c]

                # Left wall
                if (cell.walls[LeftWall])
                    print('|')
                else
                    if (c == 1)
                        print('|')
                    else
                        print(cell.dir_sol == 6 && lab[r, c-1].dir_sol == 6 ? path_dot1 : ' ')
                    end
                end

                # Cell interior
                if (c <= cols)
                    print(cell.dir_sol == 6 ? path_dot2 : "  ")
                end
            end
            println()
        end
    end
end

# ----------------------------------------------------------------------------------
# Generation

function GenerateLab()
    global lab, colStart, colEnd

    visited::Array{Bool} = zeros(Bool, rows, cols)

    remaining = rows * cols
    while remaining > 0
        r::Int = 0
        c::Int = 0
        while true
            r = rand(1:rows)
            c = rand(1:cols)
            if (remaining == rows * cols || visited[r, c])
                break
            end
        end

        dir::Int = 0
        while true
            if !visited[r, c]
                visited[r, c] = true
                remaining -= 1
            end

            dir = rand(1:4)
            rt::Int = 0
            ct::Int = 0
            ntest::Int = 1

            while true
                if (dir == 1)         # TopWall
                    rt = r - 1
                    ct = c
                elseif (dir == 2)     # LeftWall
                    rt = r
                    ct = c - 1
                elseif (dir == 3)     # BottomWall
                    rt = r + 1
                    ct = c
                else                # RightWall
                    rt = r
                    ct = c + 1
                end

                if (1 <= rt <= rows && 1 <= ct <= cols)
                    if (!visited[rt, ct])
                        break
                    end      # Ok, temp cell fits
                end

                # Doesn't fit, turn direction
                dir = dir % 4 + 1
                ntest += 1

                if (ntest == 5)
                    @goto NextGallery    # all directions blocked, gallery finished.
                end
            end

            # Erase border
            ClearWall(r, c, dir)
            r = rt
            c = ct
        end
        @label NextGallery
    end

    # Open one cell on first and last row
    colStart = rand(1:cols)
    colEnd = rand(1:cols)
    ClearWall(1, colStart, TopWall)
    ClearWall(rows, colEnd, BottomWall)
end

# ----------------------------------------------------------------------------------
# Solution

# Global variable used during recursive calls of search
finished::Bool = false

function search(r::Int, c::Int)
    global finished
    for direction in 1:4
        lab[r, c].dir_sol = direction
        # Next row/col, Update row/col, index of wall for cell update
        if (direction == 1)       # Top
            rn, cn, rt, ct, iw = r - 1, c, r, c, TopWall
        elseif (direction == 2)   # Left
            rn, cn, rt, ct, iw = r, c - 1, r, c, LeftWall
        elseif (direction == 3)   # Bottom
            rn, cn, rt, ct, iw = r + 1, c, r + 1, c, TopWall
        else                    # Right
            rn, cn, rt, ct, iw = r, c + 1, r, c + 1, LeftWall
        end

        # If next cell in the maze
        if (1 <= rn <= rows && 1 <= cn <= cols)
            # No wall?
            if (!lab[rt, ct].walls[iw])
                if (lab[rn, cn].dir_sol == 6)    # Found exit cell
                    finished = true
                    return
                end
                if (lab[rn, cn].dir_sol == 0)
                    search(rn, cn)
                    if (finished)
                        return
                    end
                end
            end
        end
    end
    lab[r, c].dir_sol = 5         # Not part of solution
end

function SolveLab(rs::Int, cs::Int, re::Int, ce::Int)
    lab[rs, cs].dir_sol = 6     # Mark start cell as part of solution
    lab[re, ce].dir_sol = 6     # Mark end cell as part of solution
    search(rs, cs)

    # Mark all lab in current path as being part of the solution (dir_sol==6)
    for r in 1:rows
        for c in 1:cols
            if (1 <= lab[r, c].dir_sol <= 4)
                lab[r, c].dir_sol = 6
            end
        end
    end
end

# ----------------------------------------------------------------------------------
# Main program (arguments have already been processed in args.jl)

if (!randomShuffle)
    Random.seed!(2)
end
GenerateLab()
if (showSolution)
    SolveLab(1, colStart, rows, colEnd)
end
simplePrint ? PrintSimple() : PrintEnhanced()
