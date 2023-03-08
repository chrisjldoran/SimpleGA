#Test suite for Geometric LinearAlgebra
using Test

include("../wrapper.jl")
using .GA

#bas = basis("GA20")

@testset "GA Tests" begin
    include("test20.jl")
    @test 1==1
end

