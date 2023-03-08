#Each algebra in a separate sub-module.

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

include("GA40.jl")
using .GA40

include("PGA.jl")
using .PGA
export pdual

include("CGA.jl")
using .CGA

include("STA.jl")
using .STA
export bar

include("GA33.jl")
using .GA33

include("GA44.jl")
using .GA44
export construct44

function basis(alg)
    if alg == "GA20" 
        return bas20
    elseif alg =="GA30"
        return bas30
    elseif alg =="GA40"
        return bas40
    elseif alg =="PGA"
        return basPGA
    elseif alg =="CGA"
        return basCGA
    elseif alg =="STA"
        return basSTA
    elseif alg =="GA33"
        return bas33
    elseif alg =="GA44"
        return bas44
    end
end




end #module