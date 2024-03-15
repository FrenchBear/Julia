# julab.jl
# My first real Julia program
# Labyrinth generation and solving
# 
# 2024-03-14    PV      First version, full new code

using Random

include("args.jl")


const TopWall = 1       # Also index in Cell.walls
const LeftWall = 2      # Also index in Cell.walls
const RightWall = 3
const BottomWall = 4

const CellEmpty = 1
const CellSolution = 17
const VerticalWall = 6
const HorizontalWall = 11


mutable struct Cell
    walls::Array{Bool}
    visited::Bool
    dir_sol::Int8
end


lab = Array{Cell}(undef, rows+1, cols+1)
for row in 1:rows+1
    for col in 1:cols+1
        lab[row, col] = Cell(ones(Bool, 2), false, 0)
    end
end

function ClearWall(row::Int, col::Int, wall::Int)
    global lab
    @assert 1<=row<=rows
    @assert 1<=col<=cols
    if (wall==TopWall || wall==LeftWall)
        lab[row,col].walls[wall] = false
    elseif (wall==RightWall)
        lab[row,col+1].walls[LeftWall] = false
    else
        lab[row+1,col].walls[TopWall] = false
    end
end

function GetWall(row::Int, col::Int, wall::Int)::Bool
    global lab
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1
    @assert 1<=wall<=2
    if (wall==TopWall || wall==LeftWall)
        return lab[row,col].walls[wall]
    elseif (wall==RightWall)
        return lab[row,col+1].walls[LeftWall]
    else
        return lab[row+1,col].walls[TopWall]
    end
end

function GetLeftWall(row::Int, col::Int)::Bool
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1
    if col==cols+1 return true end
    GetWall(row, col, LeftWall)
end

function GetTopWall(row::Int, col::Int)::Bool
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1
    #if c==cols+1 return true end
    GetWall(row, col, TopWall)
end

function GetCorner(up::Bool, right::Bool, down::Bool, left::Bool)::Char
    global Corners
    ix = (up ? 1 : 0) + (right ? 2 : 0) + (down ? 4 : 0) + (left ? 8 : 0)
    return Corners[ix+1]
end

function PrintCorner(row::Int, col::Int)
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1

    up = row==1 ? false : GetLeftWall(row-1, col)
    left = col==1 ? false : GetTopWall(row, col-1)
    right = col==cols+1 ? false : GetTopWall(row, col)
    down = row==rows+1 ? false : GetLeftWall(row, col)
    print(GetCorner(up, right, down, left))
end

function PrintTopWall(row::Int, col::Int)
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1
    
    if GetTopWall(row, col)
        print(Corners[HorizontalWall]^2)
    else
        print(Corners[CellEmpty]^2)
    end
end

function PrintLeftWall(row::Int, col::Int)
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1
    
    if GetLeftWall(row, col)
        print(Corners[VerticalWall])
    else
        print(Corners[CellEmpty])
    end
end

function PrintCell(row::Int, col::Int)
    @assert 1<=row<=rows+1
    @assert 1<=col<=cols+1
    
    print(Corners[CellEmpty]^2)
end

function PrintLab()
    for r in 1:rows
        for c in 1:cols
            PrintCorner(r, c)
            PrintTopWall(r, c)
        end
        PrintCorner(r, cols+1)
        println()

        for c in 1:cols
            PrintLeftWall(r, c)
            PrintCell(r, c)
        end
        PrintLeftWall(r, cols+1)
        println()
    end

    for c in 1:cols
        PrintCorner(rows+1, c)
        PrintTopWall(rows+1, c)
    end
    PrintCorner(rows+1, cols+1)
    println()
end

function GenerateLab()
    global lab

    visited::Array{Bool} = zeros(Bool, rows, cols)

    remaining = rows*cols
    while remaining>0
        r::Int = 0
        c::Int = 0
        while true
            r = rand(1:rows)
            c = rand(1:cols)
            if (remaining==rows*cols || visited[r, c]) break end
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
                if (dir==1)         # TopWall
                    rt = r - 1 ; ct = c
                elseif (dir==2)     # LeftWall
                    rt = r ; ct = c - 1
                elseif (dir==3)     # RightWall
                    rt = r ; ct = c + 1
                else                # BottomWall
                    rt = r + 1 ; ct = c
                end

                if (1 <= rt <= rows && 1 <= ct <= cols)
                    if (!visited[rt, ct]) break end      # Ok, temp cell fits
                end

                # Doesn't fit, turn direction
                dir = dir%4 + 1
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

if (!random_shuffle) Random.seed!(2) end
GenerateLab()
PrintLab()
