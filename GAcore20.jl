#=
Core code for the implementation of GA(2,0)
Underlying representation is with complex numbers, so essentially a wrapper for Julia's internal ComplexF64 format.
=#

import Base.:*
import Base.:+
import Base.:-
import Base.:/

struct MVeven
    c1::ComplexF64
end

struct MVodd
    c1::ComplexF64
end


#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.c1)
end

function -(a::MVodd)
    MVodd(-a.c1)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.c1 + b.c1)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.c1 + b.c1)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.c1 - b.c1)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.c1 - b.c1)
end

#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.c1 + convert(ComplexF64,num))
end

function -(num::Number,a::MVeven)
    MVeven(-a.c1 + convert(ComplexF64,num))
end

#Multiplication
function *(num::Number,a::MVeven)
    num = convert(ComplexF64,num)
    MVeven(num*a.c1)
end

function *(num::Number,a::MVodd)
    num = convert(ComplexF64,num)
    MVodd(num*a.c1)
end

function *(a::MVeven,b::MVeven)
    MVeven( a.c1*b.c1)    
end

function *(a::MVeven,b::MVodd)
    MVodd( conj(a.c1)*b.c1)    
end

function *(a::MVodd, b::MVeven)
    MVodd(  a.c1*b.c1)    
end

function *(a::MVodd, b::MVodd)
    MVeven(  conj(a.c1)*b.c1)    
end

#Division by a real
function /(a::MVeven,num::Number)
    num = convert(ComplexF64,1/num)
    MVeven(num*a.c1)
end

function /(a::MVodd,num::Number)
    num = convert(ComplexF64,1/num)
    MVodd(num*a.c1)
end

function /(a::MVeven,b::MVeven)
    z = a.c1/b.c1
    MVeven(z)
end

#Reverse
function reverse(a::MVeven)
    MVeven(conj(a.c1))
end

function reverse(a::MVodd)
    return a
end

#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        return MVeven(real(a.c1))
    elseif (n==2)
        return MVeven(imag(a.c1)*im )
    else
        return MVeven(0)
    end
end

function project(a::MVodd,n::Integer)
    if (n==1)
        return a
    else
        return MVodd(0)
    end
end

function scp(a::MVeven)
    real(a.c1)
end

function scp(a::MVeven, b::MVeven)
    real(a.c1*b.c1)    
end

function scp(a::MVodd, b::MVodd)
   real(conj(a.c1)*b.c1)
end