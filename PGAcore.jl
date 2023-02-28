#=
Core code for the implementation of GA(3,0,1).
Work using a pair of quaternions. q is the main term and n is the null term.
Even / odd map performed by I3
Useful for performance if CGA is too slow.
=#

include("quaternion.jl")

import Base.:*
import Base.:+
import Base.:-
import Base.:/
import Base.exp

struct MVeven
    q::Quaternion
    n::Quaternion
end

struct MVodd
    q::Quaternion
    n::Quaternion
end

#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.q,-a.n)
end

function -(a::MVodd)
    MVodd(-a.q,-a.n)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.q + b.q, a.n + b.n)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.q + b.q, a.n + b.n)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.q - b.q, a.n - b.n)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.q - b.q, a.n - b.n)
end

#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.q + convert(Float64,num), a.n)
end

function -(num::Number,a::MVeven)
    MVeven(-a.q + convert(Float64,num), -a.n )
end

#Multiplication
function *(num::Number,a::MVeven)
    num = convert(Float64,num)
    MVeven(num*a.q,  num*a.n)
end

function *(num::Number,a::MVodd)
    num = convert(Float64,num)
    MVodd(num*a.q,  num*a.n)
end

function *(a::MVeven,b::MVeven)
    MVeven( a.q*b.q, a.q*b.n + a.n*b.q)  
end

function *(a::MVeven,b::MVodd)
    MVodd( a.q*b.q, a.q*b.n - a.n*b.q)  
end

function *(a::MVodd,b::MVeven)
    MVodd( a.q*b.q, a.q*b.n + a.n*b.q)    
end

function *(a::MVodd,b::MVodd)
    MVeven( -a.q*b.q, -a.q*b.n + a.n*b.q )     
end

#Division by a real
function /(a::MVeven,num::Number)
    num = convert(Float64,1/num)
    MVeven(num*a.q,  num*a.n)
end

function /(a::MVodd,num::Number)
    num = convert(Float64,1/num)
    MVodd(num*a.q,  num*a.n)
end

#Reverse
function reverse(a::MVeven)
    MVeven(reverse(a.q),reverse(a.n))
end

function reverse(a::MVodd)
    MVodd(-reverse(a.q),reverse(a.n)  )
end

#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        return MVeven(Quaternion(a.q.w,0,0,0), qzero)
    elseif (n==2)
        return MVeven(project(a.q,2), project(a.n,2))
    elseif (n==4)
        return MVeven(qzero, Quaternion(a.n.w,0,0,0))
    else
        return MVeven(qzero,qzero)
    end
end

function project(a::MVodd,n::Integer)
    if (n==1)
        return MVodd(project(a.q,2), project(a.n,0))
    elseif (n==3)
        return MVodd(project(a.q,0), project(a.n,2))
    else
        return MVodd(qzero, qzero)
    end
end

function scp(a::MVeven)
    a.q.w
end

function scp(a::MVeven, b::MVeven)
    scp(a.q,b.q)
end

function scp(a::MVodd, b::MVodd)
    -scp(a.q,b.q)
end

#Exponentiation
function expb(a::MVeven)
    a = project(a,2)
    aa = -a*a
    if iszero(scp(aa))
        return 1+a
    else
        f0 = sqrt(scp(aa))
        f1 = aa.n.w/2/f0
        cf = MVeven(Quaternion(cos(f0),0,0,0), Quaternion(-f1*sin(f0),0,0,0))
        sncf = MVeven(Quaternion(sin(f0)/f0,0,0,0),  Quaternion(f1/f0^2*(f0*cos(f0) - sin(f0)),0,0,0))
        return cf + sncf*a
    end
end

function exp(a::MVeven)
    R = expb(a)
    return exp(a.q.w)*(1+project(a,4))*R
end