#=
Code for GA(2,0). Even and odd elements are stored as complex numbers.
=#
module GA20

include("GAcore20.jl")
include("GAcommon.jl")
import Base.show
import Base.log
import Base.real
import Base.imag


#Basis
const e1 = MVodd(1)
const e2 = MVodd(im)
const I2 = MVeven(im)

bas20 = [e1,e2]
export bas20


#Sets tolerance for not displaying results. 
function approxzero(x::Float64)
    isapprox(x,0.0; atol = 1e-14)
end

#Extra functions on even elements
function log(a::MVeven)
    MVeven(log(a.c1))
end

function real(a::MVeven)
    real(a.c1)
end

function imag(a::MVeven)
    imag(a.c1)
end



function mvtype(a::MVeven)
    res=""
    tp = approxzero(real(a.c1)) ? "" : " + " * string(real(a.c1))
    res *= tp
    tp = approxzero(imag(a.c1)) ? "" : " + " * string(imag(a.c1)) * "I2"
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
    tp = approxzero(real(a.c1)) ? "" : " + " * string(real(a.c1)) * "e1"
    res *= tp
    tp = approxzero(imag(a.c1)) ? "" : " + " * string(imag(a.c1)) * "e2"
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

function Base.show(io::IO, mv::MVodd)
    print(mvtype(mv))
end


end