#Attempting to remove namespace issues for scp etc.

using LinearAlgebra

module Quaternions
include("quaternion.jl")
export quat, real_part, imag_part, expb, qzero

end #module


module GA

using ..Quaternions
export project, expb, inject

function project() end

function inject(xs,ys) 
    reduce(+,map((x,y)->x*y,xs,ys))
end

include("GA20.jl")
using .GA20
export bas20

include("GA30.jl")
using .GA30
export bas30


#include("GA40.jl")

end #module