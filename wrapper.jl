#Attempting to remove namespace issues for scp etc.

module GA

function scp() end

include("GA20.jl")
include("GA30.jl")


export scp


end