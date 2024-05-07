# playthreads.jl
# Expermentations with threads in Julia
#
# 2024-05-07    PV

function sum_single(a)
    s = 0
    for i in a
        s += i
    end
    s
end


function sum_multi_good(a)
    chunks = Iterators.partition(a, length(a) ÷ Threads.nthreads())
    tasks = map(chunks) do chunk
        Threads.@spawn sum_single(chunk)
    end
    chunk_sums = fetch.(tasks)
    return sum_single(chunk_sums)
end
# sum_multi_good (generic function with 1 method)

println(sum_multi_good(1:1_000_000))     # 500000500000
