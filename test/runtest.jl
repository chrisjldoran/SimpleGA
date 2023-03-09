#Test suite for Geometric LinearAlgebra
using Test

include("../wrapper.jl")
using .GA

#bas = basis("GA20")

@testset "GA Tests" begin
    include("test20.jl")
    include("test30.jl")
end

