#=
Core code for the implementation of GA(1,3).
Underlying representation is with 2x2 complex matrices, though no matrices are formally constructed. The multiplication rules are hard-coded for efficiency.
Makes use of Julia's internal ComplexF64 format.
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
    c2::ComplexF64
    c3::ComplexF64
    c4::ComplexF64
end

struct MVodd
    c1::ComplexF64
    c2::ComplexF64
    c3::ComplexF64
    c4::ComplexF64
end


#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.c1,-a.c2,-a.c3,-a.c4)
end

function -(a::MVodd)
    MVodd(-a.c1,-a.c2,-a.c3,-a.c4)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.c1 + b.c1, a.c2 + b.c2, a.c3 + b.c3, a.c4 + b.c4)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.c1 + b.c1, a.c2 + b.c2, a.c3 + b.c3, a.c4 + b.c4)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.c1 - b.c1, a.c2 - b.c2, a.c3 - b.c3, a.c4 - b.c4)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.c1 - b.c1, a.c2 - b.c2, a.c3 - b.c3, a.c4 - b.c4)
end

#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.c1 + convert(ComplexF64,num), a.c2, a.c3, a.c4 + convert(ComplexF64,num))
end

function -(num::Number,a::MVeven)
    MVeven(-a.c1 + convert(ComplexF64,num), -a.c2, -a.c3, -a.c4 + convert(ComplexF64,num))
end

#Multiplication
function *(num::Number,a::MVeven)
    num = convert(ComplexF64,num)
    MVeven(num*a.c1, num*a.c2, num*a.c3, num*a.c4)
end

function *(num::Number,a::MVodd)
    num = convert(ComplexF64,num)
    MVodd(num*a.c1, num*a.c2, num*a.c3, num*a.c4)
end

function *(a::MVeven,b::MVeven)
    MVeven( a.c1*b.c1 + a.c2*b.c3,
            a.c1*b.c2 + a.c2*b.c4,
            a.c3*b.c1 + a.c4*b.c3,
            a.c4*b.c4 + a.c3*b.c2)    
end

function *(a::MVeven,b::MVodd)
    MVodd( a.c1*b.c1 + a.c2*b.c3,
            a.c1*b.c2 + a.c2*b.c4,
            a.c3*b.c1 + a.c4*b.c3,
            a.c4*b.c4 + a.c3*b.c2)    
end

function *(a::MVodd, b::MVeven)
    MVodd(  a.c1*conj(b.c4) - a.c2*conj(b.c2),
            - a.c1*conj(b.c3) + a.c2*conj(b.c1),
            a.c3*conj(b.c4) - a.c4*conj(b.c2),
            a.c4*conj(b.c1) - a.c3*conj(b.c3))    
end

function *(a::MVodd, b::MVodd)
    MVeven(  a.c1*conj(b.c4) - a.c2*conj(b.c2),
            - a.c1*conj(b.c3) + a.c2*conj(b.c1),
            a.c3*conj(b.c4) - a.c4*conj(b.c2),
            a.c4*conj(b.c1) - a.c3*conj(b.c3))    
end

#Division by a real
function /(a::MVeven,num::Number)
    num = convert(ComplexF64,1/num)
    MVeven(num*a.c1, num*a.c2, num*a.c3, num*a.c4)
end

function /(a::MVodd,num::Number)
    num = convert(ComplexF64,1/num)
    MVodd(num*a.c1, num*a.c2, num*a.c3, num*a.c4)
end

#Reverse
function adjoint(a::MVeven)
    MVeven(a.c4, -a.c2, -a.c3, a.c1)
end

function adjoint(a::MVodd)
    MVodd(conj(a.c1), conj(a.c3), conj(a.c2), conj(a.c4))
end

#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        return MVeven(0.5*(real(a.c1+a.c4)), 0, 0, 0.5*(real(a.c1+a.c4)))
    elseif (n==2)
        return MVeven(0.5*(a.c1-a.c4), a.c2, a.c3, 0.5*(a.c4-a.c1) )
    elseif (n==4)
        return MVeven(0.5*(imag(a.c1+a.c4)*im), 0, 0, 0.5*imag(a.c1+a.c4)*im)
    else
        return MVeven(0,0,0,0)
    end
end

function project(a::MVodd,n::Integer)
    if (n==1)
        return MVodd(real(a.c1), 0.5*(a.c2 + conj(a.c3)), 0.5*(a.c3+ conj(a.c2)) , real(a.c4))
    elseif (n==3)
        return MVodd(imag(a.c1)*im, 0.5*(a.c2 - conj(a.c3)), 0.5*(a.c3 - conj(a.c2)) , imag(a.c4)*im)
    else
        return MVodd(0,0,0,0)
    end
end

function tr(a::MVeven)
    0.5*(real(a.c1+a.c4))
end

function dot(a::MVeven, b::MVeven)
    0.5*real(a.c1*b.c1 + a.c2*b.c3 + a.c4*b.c4 + a.c3*b.c2)    
end

function dot(a::MVodd, b::MVodd)
   0.5*real(a.c1*conj(b.c4) - a.c2*conj(b.c2) + a.c4*conj(b.c1) - a.c3*conj(b.c3))    
end

#Exponentiation
function expb(a::MVeven)
    a = project(a,2)
    aa = a*a
    fct = sqrt(0.5*(aa.c1+aa.c4))
    if iszero(fct)
        return 1+a
    else
        return cosh(fct)+sinh(fct)/fct*a
    end
end

function exp(a::MVeven)
    R = expb(a)
    fct = 0.5*(a.c1+a.c4)
    if iszero(fct)
        return R
    else
        return exp(fct)*R
    end
end

#Comparison. Uses default tolerances
Base.isapprox(a::MVeven, b::MVeven) = isapprox(a.c1,b.c1) && isapprox(a.c2,b.c2)  && isapprox(a.c3,b.c3) && isapprox(a.c4,b.c4) 
Base.isapprox(a::MVodd, b::MVodd) = isapprox(a.c1,b.c1) && isapprox(a.c2,b.c2)  && isapprox(a.c3,b.c3) && isapprox(a.c4,b.c4) 
