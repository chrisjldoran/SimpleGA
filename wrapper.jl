#Attempting to remove namespace issues for scp etc.

using LinearAlgebra

module Quaternions
include("quaternion.jl")
export quat, real_part, imag_part, expb, qzero
end #module


module GA

using ..Quaternions
export project, expb

function project() end

include("GA20.jl")
#include("GA30.jl")
#include("GA40.jl")

end #module