#Attempting to remove namespace issues for scp etc.

using LinearAlgebra

module Quaternions
include("quaternion.jl")
export quat, real_part, imag_part, expb, qzero, Quaternion

end #module


module GA

using ..Quaternions
export project, expb, inject, basis

function project() end

function inject(xs,ys) 
    reduce(+,map((x,y)->x*y,xs,ys))
end

include("GA20.jl")
using .GA20

include("GA30.jl")
using .GA30

#include("GA40.jl")
#using .GA40

function basis(alg)
    if alg == "GA20" 
        return bas20
    elseif alg =="GA30"
        return bas30
    elseif alg =="GA40"
        return bas40
    end
end




end #module