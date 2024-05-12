# base_introspection.jl
# Julia Base doc, Reflection and instrospection
# 
# 2024-05-11    PV


# Reflection and introspection

# Julia provides a variety of runtime reflection capabilities.

# Module bindings

# The exported names for a Module are available using names(m::Module), which will return an array of Symbol elements
# representing the exported bindings. names(m::Module, all = true) returns symbols for all bindings in m, regardless of
# export status.

# DataType fields

# The names of DataType fields may be interrogated using fieldnames. For example, given the following type,
# fieldnames(Point) returns a tuple of Symbols representing the field names:
struct Point
    x::Int
    y
end

fieldnames(Point)
# (:x, :y)

# The type of each field in a Point object is stored in the types field of the Point variable itself:
Point.types
# svec(Int64, Any)          # svec = SimpleVector, whatever it is...

# While x is annotated as an Int, y was unannotated in the type definition, therefore y defaults to the Any type.

# Types are themselves represented as a structure called DataType:
typeof(Point)
# DataType

# Note that fieldnames(DataType) gives the names for each field of DataType itself, and one of these fields is the types
# field observed in the example above.


# Subtypes

# The direct subtypes of any DataType may be listed using subtypes. For example, the abstract DataType AbstractFloat has
# four (concrete) subtypes:

subtypes(AbstractFloat)
# 4-element Vector{Any}:
#  BigFloat
#  Float16
#  Float32
#  Float64

# Any abstract subtype will also be included in this list, but further subtypes thereof will not; recursive application
# of subtypes may be used to inspect the full type tree.


# DataType layout

# The internal representation of a DataType is critically important when interfacing with C code and several functions
# are available to inspect these details. isbitstype(T::DataType) returns true if T is stored with C-compatible
# alignment. fieldoffset(T::DataType, i::Integer) returns the (byte) offset for field i relative to the start of the
# type.


# Function methods

# The methods of any generic function may be listed using methods. The method dispatch table may be searched for methods
# accepting a given type using methodswith.

methodswith(BitVector)
# [1] adjoint(B::Union{BitMatrix, BitVector}) @ LinearAlgebra C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\LinearAlgebra\src\bitarray.jl:237
# [2] /(A::Union{BitMatrix, BitVector}, B::Union{BitMatrix, BitVector}) @ Base bitarray.jl:1201
# [3] <<(B::BitVector, i::Int64) @ Base bitarray.jl:1413
# [4] <<(B::BitVector, i::UInt64) @ Base bitarray.jl:1324
# [5] >>(B::BitVector, i::Union{Int64, UInt64}) @ Base bitarray.jl:1375
# ⋮
# [40] dot(x::BitVector, y::BitVector) @ LinearAlgebra C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\LinearAlgebra\src\bitarray.jl:3
# [41] ordschur(gschur::LinearAlgebra.GeneralizedSchur, select::Union{BitVector, Vector{Bool}}) @ LinearAlgebra C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\LinearAlgebra\src\schur.jl:404
# [42] ordschur(schur::LinearAlgebra.Schur, select::Union{BitVector, Vector{Bool}}) @ LinearAlgebra C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\LinearAlgebra\src\schur.jl:290
# [43] ordschur!(gschur::LinearAlgebra.GeneralizedSchur, select::Union{BitVector, Vector{Bool}}) @ LinearAlgebra C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\LinearAlgebra\src\schur.jl:379
# [44] ordschur!(schur::LinearAlgebra.Schur, select::Union{BitVector, Vector{Bool}}) @ LinearAlgebra C:\Users\Pierr\.julia\juliaup\julia-1.10.3+0.x64.w64.mingw32\share\julia\stdlib\v1.10\LinearAlgebra\src\schur.jl:268


# Expansion and lowering

# As discussed in the Metaprogramming section, the macroexpand function gives the unquoted and interpolated expression
# (Expr) form for a given macro. To use macroexpand, quote the expression block itself (otherwise, the macro will be
# evaluated and the result will be passed instead!). For example:

macroexpand(@__MODULE__, :(@edit println("")) )
# :(InteractiveUtils.edit(println, (Base.typesof)("")))

macroexpand(@__MODULE__, :(@show 2*sin(π/3)))
# quote
#     Base.println("2 * sin(π / 3) = ", Base.repr(begin
#                 #= show.jl:1181 =#
#                 local var"#5#value" = 2 * sin(π / 3)
#             end))
#     var"#5#value"
# end

# The functions Base.Meta.show_sexpr and dump are used to display S-expr style views and depth-nested detail views for
# any expression.

# Finally, the Meta.lower function gives the lowered form of any expression and is of particular interest for
# understanding how language constructs map to primitive operations such as assignments, branches, and calls:

Meta.lower(@__MODULE__, :( [1+2, sin(0.5)] ))
# :($(Expr(:thunk, CodeInfo(
#     @ none within `top-level scope`
# 1 ─ %1 = 1 + 2
# │   %2 = sin(0.5)
# │   %3 = Base.vect(%1, %2)
# └──      return %3
# ))))

Meta.lower(@__MODULE__, :( f(x) = x<=1 ? x : x*f(x-1) ))
# :($(Expr(:thunk, CodeInfo(
#     @ none within `top-level scope`
# 1 ─      $(Expr(:thunk, CodeInfo(
#     @ none within `top-level scope`
# 1 ─     return $(Expr(:method, :f))
# )))
# │        $(Expr(:method, :f))
# │   %3 = Core.Typeof(f)
# │   %4 = Core.svec(%3, Core.Any)
# │   %5 = Core.svec()
# │   %6 = Core.svec(%4, %5, $(QuoteNode(:(#= REPL[90]:1 =#))))
# │        $(Expr(:method, :f, :(%6), CodeInfo(
#     @ REPL[90]:1 within `none`
# 1 ─ %1 = x <= 1
# └──      goto #3 if not %1
# 2 ─      return x
# 3 ─ %4 = x - 1
# │   %5 = f(%4)
# │   %6 = x * %5
# └──      return %6
# )))
# └──      return f
# ))))


# Intermediate and compiled representations

# Inspecting the lowered form for functions requires selection of the specific method to display, because generic
# functions may have many methods with different type signatures. For this purpose, method-specific code-lowering is
# available using code_lowered, and the type-inferred form is available using code_typed. code_warntype adds
# highlighting to the output of code_typed.

# Closer to the machine, the LLVM intermediate representation of a function may be printed using by code_llvm, and
# finally the compiled machine code is available using code_native (this will trigger JIT compilation/code generation
# for any function which has not previously been called).

# For convenience, there are macro versions of the above functions which take standard function calls and expand
# argument types automatically:

@code_llvm +(1,1)
# ;  @ int.jl:87 within `+`
# ; Function Attrs: sspstrong uwtable
# define i64 @"julia_+_476"(i64 signext %0, i64 signext %1) #0 {
# top:
#   %2 = add i64 %1, %0
#   ret i64 %2
# }



@code_lowered (fact(x::Int) = x<=1 ? x : x*fact(x-1))(10)
# CodeInfo(
# 1 ─ %1 = x <= 1
# └──      goto #3 if not %1
# 2 ─      return x
# 3 ─ %4 = x - 1
# │   %5 = Main.fact(%4)
# │   %6 = x * %5
# └──      return %6
# )

@code_typed (fact(x::Int) = x<=1 ? x : x*fact(x-1))(10)
# CodeInfo(
# 1 ─ %1 = Base.sle_int(x, 1)::Bool
# └──      goto #3 if not %1
# 2 ─      return x
# 3 ─ %4 = Base.sub_int(x, 1)::Int64
# │   %5 = invoke Main.fact(%4::Int64)::Int64
# │   %6 = Base.mul_int(x, %5)::Int64
# └──      return %6
# ) => Int64

@code_warntype (fact(x::Int) = x<=1 ? x : x*fact(x-1))(10)
# MethodInstance for fact(::Int64)
#   from fact(x::Int64) @ Main REPL[97]:1
# Arguments
#   #self#::Core.Const(fact)
#   x::Int64
# Body::Int64
# 1 ─ %1 = (x <= 1)::Bool
# └──      goto #3 if not %1
# 2 ─      return x
# 3 ─ %4 = (x - 1)::Int64
# │   %5 = Main.fact(%4)::Int64
# │   %6 = (x * %5)::Int64
# └──      return %6

@code_llvm (fact(x::Int) = x<=1 ? x : x*fact(x-1))(10)
# ;  @ REPL[98]:1 within `fact`
# ; Function Attrs: uwtable
# define i64 @julia_fact_1496(i64 signext %0) #0 {
# top:
# ; ┌ @ int.jl:514 within `<=`
#    %1 = icmp sgt i64 %0, 1
# ; └
#   br i1 %1, label %L4, label %common.ret
# 
# common.ret:                                       ; preds = %L4, %top
#   %common.ret.op = phi i64 [ %4, %L4 ], [ %0, %top ]
# ;  @ REPL[98] within `fact`
#   ret i64 %common.ret.op
# 
# L4:                                               ; preds = %top
# ;  @ REPL[98]:1 within `fact`
# ; ┌ @ int.jl:86 within `-`
#    %2 = add nsw i64 %0, -1
# ; └
#   %3 = call i64 @julia_fact_1496(i64 signext %2)
# ; ┌ @ int.jl:88 within `*`
#    %4 = mul i64 %3, %0
#    br label %common.ret
# ; └
# }

@code_native (fact(x::Int) = x<=1 ? x : x*fact(x-1))(10)
#         .text
#         .file   "fact"
#         .globl  julia_fact_1520                 # -- Begin function julia_fact_1520
#         .p2align        4, 0x90
#         .type   julia_fact_1520,@function
# julia_fact_1520:                        # @julia_fact_1520
# ; ┌ @ REPL[99]:1 within `fact`
#         .cfi_startproc
# # %bb.0:                                # %top
#         push    rbp
#         .cfi_def_cfa_offset 16
#         .cfi_offset rbp, -16
#         mov     rbp, rsp
#         .cfi_def_cfa_register rbp
#         push    rsi
#         sub     rsp, 40
#         .cfi_offset rsi, -24
#         mov     rsi, rcx
# ; │┌ @ int.jl:514 within `<=`
#         cmp     rcx, 1
# ; │└
#         jle     .LBB0_2
# # %bb.1:                                # %L4
# ; │┌ @ int.jl:86 within `-`
#         lea     rcx, [rsi - 1]
# ; │└
#         movabs  rax, offset julia_fact_1520
#         call    rax
# ; │┌ @ int.jl:88 within `*`
#         imul    rsi, rax
# .LBB0_2:                                # %common.ret
# ; │└
# ; │ @ REPL[99] within `fact`
#         mov     rax, rsi
#         add     rsp, 40
#         pop     rsi
#         pop     rbp
#         ret
# .Lfunc_end0:
#         .size   julia_fact_1520, .Lfunc_end0-julia_fact_1520
#         .cfi_endproc
# ; └
#                                         # -- End function
#         .section        ".note.GNU-stack","",@progbits


# For more information see @code_lowered, @code_typed, @code_warntype, @code_llvm, and @code_native.


# Printing of debug information

# The aforementioned functions and macros take the keyword argument debuginfo that controls the level debug information
# printed.

@code_typed debuginfo=:source +(1,1)
# CodeInfo(
#     @ int.jl:53 within `+'
# 1 ─ %1 = Base.add_int(x, y)::Int64
# └──      return %1
# ) => Int64

# Possible values for debuginfo are: :none, :source, and :default. Per default debug information is not printed, but
# that can be changed by setting Base.IRShow.default_debuginfo[] = :source.

Base.IRShow.default_debuginfo[] = :source;

@code_typed (fact(x::Int) = x<=1 ? x : x*fact(x-1))(10)
# CodeInfo(
#     @ REPL[102]:1 within `fact`
#    ┌ @ int.jl:514 within `<=`
# 1 ─│ %1 = Base.sle_int(x, 1)::Bool
# │  └
# └──      goto #3 if not %1
# 2 ─      return x
#    ┌ @ int.jl:86 within `-`
# 3 ─│ %4 = Base.sub_int(x, 1)::Int64
# │  └
# │   %5 = invoke Main.fact(%4::Int64)::Int64
# │  ┌ @ int.jl:88 within `*`
# │  │ %6 = Base.mul_int(x, %5)::Int64
# └──│      return %6
#    └
# ) => Int64
