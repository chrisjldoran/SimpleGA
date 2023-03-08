#=
Code for GA(4,1). 
=#

module CGA

include("CGAcore.jl")
include("GAcommon.jl")
import Base.show

#Sets tolerance for not displaying results. 
function approxzero(x::Float64)
    isapprox(x,0.0; atol = 1e-14)
end

#Basis
const e1 = MVodd(Quaternion(0,1,0,0),qzero,qzero,Quaternion(0,-1,0,0))
const e2 = MVodd(Quaternion(0,0,1,0),qzero,qzero,Quaternion(0,0,-1,0))
const e3 = MVodd(Quaternion(0,0,0,1),qzero,qzero,Quaternion(0,0,0,-1))
const e4 = MVodd(qzero,Quaternion(1,0,0,0),Quaternion(1,0,0,0),qzero)
const f4 = MVodd(qzero,Quaternion(-1,0,0,0),Quaternion(1,0,0,0),qzero)
const I5 = e1*e2*e3*e4*f4

basCGA = [e1,e2,e3,e4,f4]
export basCGA

function mvtype(a::MVeven)
    res=""
    scl = tr(a)
    tp = approxzero(scl) ? "" : " + " * string(scl)
    res *= tp
    scl = dot(a,-e1*e2)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e2"
    res *= tp
    scl = dot(a,-e2*e3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2e3"
    res *= tp
    scl = dot(a,-e3*e1)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e3e1"
    res *= tp
    scl = dot(a,-e1*e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e4"
    res *= tp
    scl = dot(a,-e2*e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2e4"
    res *= tp
    scl = dot(a,-e3*e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e3e4"
    res *= tp
    scl = dot(a,e1*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1f4"
    res *= tp
    scl = dot(a,e2*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2f4"
    res *= tp
    scl = dot(a,e3*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e3f4"
    res *= tp
    scl = dot(a,e4*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e4f4"
    res *= tp
    scl = dot(a,-e1*I5)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I5e1"
    res *= tp
    scl = dot(a,-e2*I5)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I5e2"
    res *= tp
    scl = dot(a,-e3*I5)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I5e3"
    res *= tp
    scl = dot(a,-e4*I5)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I5e4"
    res *= tp
    scl = dot(a,f4*I5)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I5f4"
    res *= tp
    if (length(res) == 0)
        res = "0.0"
    else
        res = chop(res,head=3,tail=0)
    end
    return res
end


function mvtype(a::MVodd)
    res=""
    scl = dot(a,e1)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1"
    res *= tp
    scl = dot(a,e2)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2"
    res *= tp
    scl = dot(a,e3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e3"
    res *= tp
    scl = dot(a,e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e4"
    res *= tp
    scl = dot(a,-f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "f4"
    res *= tp
    scl = dot(a,-e1*e2*e3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e2e3"
    res *= tp
    scl = dot(a,-e1*e2*e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e2e4"
    res *= tp
    scl = dot(a,-e1*e3*e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e3e4"
    res *= tp
    scl = dot(a,-e2*e3*e4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2e3e4"
    res *= tp
    scl = dot(a,e1*e2*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e2f4"
    res *= tp
    scl = dot(a,e1*e3*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e3f4"
    res *= tp
    scl = dot(a,e2*e3*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2e3f4"
    res *= tp
    scl = dot(a,e1*e4*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e1e4f4"
    res *= tp
    scl = dot(a,e2*e4*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e2e4f4"
    res *= tp
    scl = dot(a,e3*e4*f4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "e3e4f4"
    res *= tp
    scl = dot(a,-I5)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I5"
    res *= tp
    if (length(res) == 0)
        res = "0.0"
    else
        res = chop(res,head=3,tail=0)
    end
    return res
end

include("GAshow.jl")

end #Module