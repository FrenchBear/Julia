# asm.jl
# Look as Julia generated code
# https://stackoverflow.com/questions/66860149/in-julia-can-you-specify-the-parameters-and-return-value-of-a-callable-function
#
# 2024-04-26    PV

# See 39_base_introspection
# See 40_lib_InteractiveUtils

using InteractiveUtils

bar(x::Int)::Int = 2x

println(@code_lowered(bar(42)))
# CodeInfo(
# 1 ─ %1 = Main.Int
# │   %2 = 2 * x
# │        @_3 = %2
# │   %4 = @_3 isa %1
# └──      goto #3 if not %4
# 2 ─      goto #4
# 3 ─ %7 = Base.convert(%1, @_3)
# └──      @_3 = Core.typeassert(%7, %1)
# 4 ┄      return @_3
# )


# In this case the compiler is smart enough to figure out that when the input is an integer the output will be an
# integer and does not need to be converted.
# In fact, we see that bar has been reduced to the left bit shift operation.

@code_llvm bar(42)
# ;  @ C:\Development\GitHub\Julia\Learning\20_asm\asm.jl:9 within `bar`
# ; Function Attrs: uwtable
# define i64 @julia_bar_902(i64 signext %0) #0 {
# top:
# ; ┌ @ int.jl:88 within `*`
#    %1 = shl i64 %0, 1
# ; └
#   ret i64 %1
# }
