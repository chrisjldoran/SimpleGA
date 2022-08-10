#=
Code for GA(1,3). Even and odd elements are stored as complex 'matrices'. 
Gamma and sigma used for pretty typing.
=#

#Wrapper for FastSTA code

include("STAcore.jl")
include("GAcommon.jl")
import Base.show

#Sets tolerance for not displaying results. 
function approxzero(x::Float64)
    isapprox(x,0.0; atol = 1e-14)
end

#Basis
const s1 = MVeven(0,1,1,0)
const s2 = MVeven(0,-im,im,0)
const s3 = MVeven(1,0,0,-1)
const g0 = MVodd(1,0,0,1)
const g1 = s1*g0
const g2 = s2*g0
const g3 = s3*g0
const I4 = g0*g1*g2*g3


#Additional function for Pauli operations.Pre and post multiply by g0.
function bar(a::MVeven)
    MVeven(conj(a.c4), - conj(a.c3), - conj(a.c2), conj(a.c1))
end

function bar(a::MVodd)
    MVodd(conj(a.c4), - conj(a.c3), - conj(a.c2), conj(a.c1))
end

function mvtype(a::MVeven)
    res=""
    scl = scp(a)
    tp = approxzero(scl) ? "" : " + " * string(scl)
    res *= tp
    scl = scp(a,s1)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "σ1"
    res *= tp
    scl = scp(a,s2)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "σ2"
    res *= tp
    scl = scp(a,s3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "σ3"
    res *= tp
    scl = scp(a,-I4*s1)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iσ1"
    res *= tp
    scl = scp(a,-I4*s2)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iσ2"
    res *= tp
    scl = scp(a,-I4*s3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iσ3"
    res *= tp
    scl = scp(a,-I4)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "I"
    res *= tp
    if (length(res) == 0)
        res = "0.0"
    else
        res = chop(res,head=3,tail=0)
    end
    return res
end

function Base.show(io::IO, mv::MVeven)
    print(mvtype(mv))
end

function mvtype(a::MVodd)
    res=""
    scl = scp(a,g0)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "γ0"
    res *= tp
    scl = scp(a,-g1)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "γ1"
    res *= tp
    scl = scp(a,-g2)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "γ2"
    res *= tp
    scl = scp(a,-g3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "γ3"
    res *= tp
    scl = scp(a,I4*g0)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iγ0"
    res *= tp
    scl = scp(a,-I4*g1)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iγ1"
    res *= tp
    scl = scp(a,-I4*g2)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iγ2"
    res *= tp
    scl = scp(a,-I4*g3)
    tp = approxzero(scl) ? "" : " + " * string(scl) * "Iγ3"
    res *= tp
    if (length(res) == 0)
        res = "0.0"
    else
        res = chop(res,head=3,tail=0)
    end
    return res
end

function Base.show(io::IO, mv::MVodd)
    print(mvtype(mv))
end