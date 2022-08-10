#=
Core code for the implementation of GA(4,1).
Representation is as a 2x2 matrix of quaternions.
=#

include("quaternion.jl")

import Base.:*
import Base.:+
import Base.:-
import Base.:/

struct MVeven
    q1::Quaternion
    q2::Quaternion
    q3::Quaternion
    q4::Quaternion
end

struct MVodd
    q1::Quaternion
    q2::Quaternion
    q3::Quaternion
    q4::Quaternion
end

const qone = Quaternion(1,0,0,0)

#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.q1,-a.q2,-a.q3,-a.q4)
end

function -(a::MVodd)
    MVodd(-a.q1,-a.q2,-a.q3,-a.q4)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.q1 + b.q1, a.q2 + b.q2, a.q3 + b.q3, a.q4 + b.q4)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.q1 + b.q1, a.q2 + b.q2, a.q3 + b.q3, a.q4 + b.q4)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.q1 - b.q1, a.q2 - b.q2, a.q3 - b.q3, a.q4 - b.q4)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.q1 - b.q1, a.q2 - b.q2, a.q3 - b.q3, a.q4 - b.q4)
end

#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.q1 + convert(Float64,num), a.q2, a.q3, a.q4 + convert(Float64,num))
end

function -(num::Number,a::MVeven)
    MVeven(-a.q1 + convert(Float64,num), -a.q2, -a.q3, -a.q4 + convert(Float64,num))
end

#Multiplication
function *(num::Number,a::MVeven)
    num = convert(Float64,num)
    MVeven(num*a.q1, num*a.q2, num*a.q3, num*a.q4)
end

function *(num::Number,a::MVodd)
    num = convert(Float64,num)
    MVodd(num*a.q1, num*a.q2, num*a.q3, num*a.q4)
end

function *(a::MVeven,b::MVeven)
    MVeven( a.q1*b.q1 - a.q2*b.q3,
            a.q1*b.q2 + a.q2*b.q4,
            a.q3*b.q1 + a.q4*b.q3,
            a.q4*b.q4 - a.q3*b.q2)    
end

function *(a::MVeven,b::MVodd)
    MVodd( a.q1*b.q1 - a.q2*b.q3,
            a.q1*b.q2 + a.q2*b.q4,
            a.q3*b.q1 + a.q4*b.q3,
            a.q4*b.q4 - a.q3*b.q2)    
end

function *(a::MVodd,b::MVeven)
    MVodd( a.q1*b.q1 - a.q2*b.q3,
            a.q1*b.q2 + a.q2*b.q4,
            a.q3*b.q1 + a.q4*b.q3,
            a.q4*b.q4 - a.q3*b.q2)    
end

function *(a::MVodd,b::MVodd)
    MVeven( -a.q1*b.q1 + a.q2*b.q3,
            -a.q1*b.q2 - a.q2*b.q4,
            -a.q3*b.q1 - a.q4*b.q3,
            -a.q4*b.q4 + a.q3*b.q2)    
end

#Division by a real
function /(a::MVeven,num::Number)
    num = convert(Float64,1/num)
    MVeven(num*a.q1, num*a.q2, num*a.q3, num*a.q4)
end

function /(a::MVodd,num::Number)
    num = convert(Float64,1/num)
    MVodd(num*a.q1, num*a.q2, num*a.q3, num*a.q4)
end

#Reverse
function reverse(a::MVeven)
    MVeven(reverse(a.q4),reverse(a.q2), reverse(a.q3), reverse(a.q1))
end

function reverse(a::MVodd)
    MVodd(reverse(a.q4),reverse(a.q2), reverse(a.q3), reverse(a.q1))
end

#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        return MVeven(0.5*(a.q1.w+a.q4.w)*qone, qzero, qzero, 0.5*(a.q1.w+a.q4.w)*qone)
    elseif (n==2)
        qtmp = project(0.5*(a.q1+a.q4),2)
        stmp = 0.5*(a.q1.w - a.q4.w)
        return MVeven(stmp+qtmp, project(a.q2,2), project(a.q3,2), -stmp+ qtmp )
    elseif (n==4)
        qtmp = project(0.5*(a.q1-a.q4),2)
        return MVeven(qtmp, project(a.q2,0), project(a.q3,0), -qtmp )
    else
        return MVeven(qzero,qzero,qzero,qzero)
    end
end

function project(a::MVodd,n::Integer)
    if (n==5)
        return MVodd(0.5*(a.q1.w+a.q4.w)*qone, qzero, qzero, 0.5*(a.q1.w+a.q4.w)*qone)
    elseif (n==3)
        qtmp = project(0.5*(a.q1+a.q4),2)
        stmp = 0.5*(a.q1.w - a.q4.w)
        return MVodd(stmp+qtmp, project(a.q2,2), project(a.q3,2), -stmp+ qtmp )
    elseif (n==1)
        qtmp = project(0.5*(a.q1-a.q4),2)
        return MVodd(qtmp, project(a.q2,0), project(a.q3,0), -qtmp )
    else
        return MVodd(qzero,qzero,qzero,qzero)
    end
end

function scp(a::MVeven)
    0.5*(a.q1.w + a.q4.w)
end

function scp(a::MVeven, b::MVeven)
    0.5*(scp(a.q1,b.q1) - scp(a.q2,b.q3) + scp(a.q4,b.q4) - scp(a.q3,b.q2))    
end

function scp(a::MVodd, b::MVodd)
    -0.5*(scp(a.q1,b.q1) - scp(a.q2,b.q3) + scp(a.q4,b.q4) - scp(a.q3,b.q2))    
end

