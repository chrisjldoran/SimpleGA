#=
Core code for the implementation of GA(4,0).
Work using self-dual and anti-self-dual decomposition, so just use a pair of quaternions.
Useful algebra for projective geometry.
=#

include("quaternion.jl")

import Base.:*
import Base.:+
import Base.:-
import Base.:/

struct MVeven
    qp::Quaternion
    qm::Quaternion
end

struct MVodd
    qp::Quaternion
    qm::Quaternion
end

#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.qp,-a.qm)
end

function -(a::MVodd)
    MVodd(-a.qp,-a.qm)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.qp + b.qp, a.qm + b.qm)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.qp + b.qp, a.qm + b.qm)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.qp - b.qp, a.qm - b.qm)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.qp - b.qp, a.qm - b.qm)
end

#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.qp + convert(Float64,num), a.qm + convert(Float64,num))
end

function -(num::Number,a::MVeven)
    MVeven(-a.qp + convert(Float64,num), -a.qm + convert(Float64,num))
end

#Multiplication
function *(num::Number,a::MVeven)
    num = convert(Float64,num)
    MVeven(num*a.qp,  num*a.qm)
end

function *(num::Number,a::MVodd)
    num = convert(Float64,num)
    MVodd(num*a.qp,  num*a.qm)
end

function *(a::MVeven,b::MVeven)
    MVeven( a.qp*b.qp,   a.qm*b.qm)  
end

function *(a::MVeven,b::MVodd)
    MVodd( a.qp*b.qp,   a.qm*b.qm)  
end

function *(a::MVodd,b::MVeven)
    MVodd( a.qp*b.qm, a.qm*b.qp)    
end

function *(a::MVodd,b::MVodd)
    MVeven( a.qp*b.qm, a.qm*b.qp)    
end

#Division by a real
function /(a::MVeven,num::Number)
    num = convert(Float64,1/num)
    MVeven(num*a.qp,  num*a.qm)
end

function /(a::MVodd,num::Number)
    num = convert(Float64,1/num)
    MVodd(num*a.qp,  num*a.qm)
end

#Reverse
function reverse(a::MVeven)
    MVeven(reverse(a.qp),reverse(a.qm))
end

function reverse(a::MVodd)
    MVodd(reverse(a.qm),reverse(a.qp))
end

#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        return MVeven(0.5*(project(a.qp+a.qm,0)), 0.5*(project(a.qp+a.qm,0)))
    elseif (n==2)
        return MVeven(project(a.qp,2), project(a.qm,2) )
    elseif (n==4)
        return MVeven(0.5*(project(a.qp-a.qm,0)), 0.5*(project(-a.qp+a.qm,0)))
    else
        return MVeven(qzero,qzero)
    end
end

function project(a::MVodd,n::Integer)
    if (n==1)
        return MVodd(0.5*(a.qp + reverse(a.qm)), 0.5*(a.qm + reverse(a.qp)))
    elseif (n==3)
        return MVodd(0.5*(a.qp - reverse(a.qm)), 0.5*(a.qm - reverse(a.qp)))
    else
        return MVodd(qzero, qzero)
    end
end

function scp(a::MVeven)
    0.5*(a.qp.w + a.qm.w)
end

function scp(a::MVeven, b::MVeven)
    0.5*(scp(a.qp,b.qp) + scp(a.qm,b.qm))
end

function scp(a::MVodd, b::MVodd)
    0.5*(scp(a.qp,b.qm) + scp(a.qm,b.qp))
end

