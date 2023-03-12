#=
Code for G(2,4)
=#

module GA24


using LinearAlgebra
using StaticArrays

include("GAcore24.jl")
include("GAcommon.jl")
import Base.show

#Sets tolerance for not displaying results. Note tolerance is lower than elsewhere. Maybe accuracy loss due to StaticArrays?
function approxzero(x::Float64)
    isapprox(x,0.0; atol = 1e-12)
end

const g0 = MVodd(id4)
const g1 = MVodd(
    complexSA([0 1 0 0 ; 1 0 0 0; 0 0 0 -1; 0 0 -1 0])
)
const g2 = MVodd(
    complexSA([0 -im 0 0; im 0 0 0; 0 0 0 im; 0 0 -im 0])
)
const g3 = MVodd(
    complexSA([1 0 0 0; 0 -1 0 0 ; 0 0 -1 0; 0 0 0 1])
)
const g4 = MVodd(
    complexSA([0 0 1 0; 0 0 0 1; 1 0 0 0; 0 1 0 0])
)
const g5 = MVodd(adj)

const I6 = g0*g1*g2*g3*g4*g5
bas24 = [g0, g1, g2, g3, g4, g5]
export bas24


function mvtype(a::MVeven)
    scl = tr(a)
    res = approxzero(scl) ? "" : " + " * string(scl)
    tpevenbas = [g1*g0, g2*g0, g3*g0, g4*g0, -g5*g0, -g1*g2, -g1*g3, -g1*g4, g1*g5, -g2*g3, -g2*g4, g2*g5, -g3*g4, g3*g5, g4*g5,
        -g1*g0*I6, -g2*g0*I6, -g3*g0*I6, -g4*g0*I6, g5*g0*I6, g1*g2*I6, g1*g3*I6, g1*g4*I6, -g1*g5*I6, g2*g3*I6, g2*g4*I6, -g2*g5*I6, g3*g4*I6, -g3*g5*I6, -g4*g5*I6, -I6]
    tpevenstr = ["g1g0", "g2g0", "g3g0", "g4g0", "g5g0", "g1g2", "g1g3", "g1g4", "g1g5", "g2g3", "g2g4", "g2g5", "g3g4", "g3g5", "g4g5",
        "g1g0I6", "g2g0I6", "g3g0I6", "g4g0I6", "g5g0I6", "g1g2I6", "g1g3I6", "g1g4I6", "g1g5I6", "g2g3I6", "g2g4I6", "g2g5I6", "g3g4I6", "g3g5I6", "g4*g5*I6", "I6"]
    for i in 1:31
        scl = dot(a,tpevenbas[i])
        tp = approxzero(scl) ? "" : " + " * string(scl) * tpevenstr[i]
        res *= tp
    end
    if (length(res) == 0)
        res = "0.0"
    else
        res = chop(res,head=3,tail=0)
    end
    return res
end



function mvtype(a::MVodd)
    tpoddbas = [g0, -g1, -g2, -g3, -g4, g5, 
        -g0*g1*g2, -g0*g1*g3, -g0*g1*g4, g0*g1*g5, -g0*g2*g3, -g0*g2*g4, g0*g2*g5, -g0*g3*g4, g0*g3*g5, g0*g4*g5,
        -g0*g1*g2*I6, -g0*g1*g3*I6, -g0*g1*g4*I6, g0*g1*g5*I6, -g0*g2*g3*I6, -g0*g2*g4*I6, g0*g2*g5*I6, -g0*g3*g4*I6, g0*g3*g5*I6, g0*g4*g5*I6,
        g0*I6, -g1*I6, -g2*I6, -g3*I6, -g4*I6, g5*I6 ]
    tpoddstr = ["g0", "g1", "g2", "g3", "g4", "g5", 
    "g0g1g2", "g0g1g3", "g0g1g4", "g0g1g5", "g0g2g3", "g0g2g4", "g0g2g5", "g0g3g4", "g0g3g5", "g0g4g5",
    "g0g1g2I6", "g0g1g3I6", "g0g1g4I6", "g0g1g5I6", "g0g2g3I6", "g0g2g4*I6", "g0g2g5I6", "g0g3g4I6", "g0g3g5I6", "g0g4g5I6",
    "g0I6", "g1I6", "g2I6", "g3I6", "g4I6", "g5I6"]
    res=""
    for i in 1:32
        scl = dot(a,tpoddbas[i])
        tp = approxzero(scl) ? "" : " + " * string(scl) * tpoddstr[i]
        res *= tp
    end
    if (length(res) == 0)
        res = "0.0"
    else
        res = chop(res,head=3,tail=0)
    end
    return res
end

include("GAshow.jl")

end #Module


