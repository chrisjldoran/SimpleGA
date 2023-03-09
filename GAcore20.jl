#=
Core code for the implementation of GA(2,0)
Underlying representation is with complex numbers, so essentially a wrapper for Julia's internal ComplexF64 format.
=#

import Base.:*
import Base.:+
import Base.:-
import Base.:/
import Base.exp
import LinearAlgebra.tr
import LinearAlgebra.dot
import LinearAlgebra.adjoint
import ..project
import ..expb

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
function adjoint(a::MVeven)
    MVeven(conj(a.c1))
end

function adjoint(a::MVodd)
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

function tr(a::MVeven)
    real(a.c1)
end

function dot(a::MVeven, b::MVeven)
    real(a.c1*b.c1)    
end

function dot(a::MVodd, b::MVodd)
   real(conj(a.c1)*b.c1)
end

#Exponentiation
function exp(a::MVeven)
    MVeven(exp(a.c1))
end

function expb(a::MVeven)
    MVeven(exp(im*a.c1.im))
end

#Comparison
#Not very elegant, but multiple dispatch does not work with kwargs.
Base.isapprox(a::MVeven, b::MVeven, tol) = isapprox(a.c1,b.c1; atol=tol) 
Base.isapprox(a::MVeven, b::MVeven) = isapprox(a.c1,b.c1; atol=10*eps(Float64)) 
Base.isapprox(a::MVodd, b::MVodd, tol) = isapprox(a.c1,b.c1; atol=tol) 
Base.isapprox(a::MVodd, b::MVodd) = isapprox(a.c1,b.c1; atol=10*eps(Float64)) 

