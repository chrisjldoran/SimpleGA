#=
Core code for the implementation of GA(2,4).
Base element is a 4x4 complex matrix built on Static Arrays library.
This is the conformal algebra for spacetime, also relevant to twistor geometry.
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
    m::SArray{Tuple{4,4},ComplexF64,2,16}
end

struct MVodd
    m::SArray{Tuple{4,4},ComplexF64,2,16}
end

complexSA(arr) = SMatrix{4,4,ComplexF64,16}(convert(Matrix{ComplexF64},arr))

const id4 = complexSA([1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1])
const adj = complexSA([0 0 1 0; 0 0 0 1; -1 0 0 0; 0 -1 0 0 ])
const rev = complexSA([0  0 0 -im; 0 0 im 0;  0 -im 0 0; im 0 0 0])
const mzero = complexSA([0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0])
 

#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.m)
end

function -(a::MVodd)
    MVodd(-a.m)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.m + b.m)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.m + b.m)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.m - b.m)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.m - b.m)
end


#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.m + convert(ComplexF64,num)*id4)
end

function -(num::Number,a::MVeven)
    MVeven(-a.m + convert(ComplexF64,num)*id4)
end

function *(num::Number,a::MVeven)
    num = convert(Float64,num)
    MVeven(num*a.m)
end

function *(num::Number,a::MVodd)
    num = convert(Float64,num)
    MVodd(num*a.m)
end

function *(a::MVeven,b::MVeven)
    MVeven(a.m*b.m)  
end

function *(a::MVeven,b::MVodd)
    MVodd( a.m*b.m)  
end

function *(a::MVodd,b::MVeven)
    MVodd( a.m*g2.m*conj(b.m)*g2.m)    
end

function *(a::MVodd,b::MVodd)
    MVeven(a.m*g2.m*conj(b.m)*g2.m)    
end


#Division by a real
function /(a::MVeven,num::Number)
    num = convert(Float64,1/num)
    MVeven(num*a.m)
end

function /(a::MVodd,num::Number)
    num = convert(Float64,1/num)
    MVodd(num*a.m)
end

#Reverse
function adjoint(a::MVeven)
    MVeven(-adj*(a.m)'*adj)
end

function adjoint(a::MVodd)
    MVodd(rev*transpose(a.m)*rev)
end


#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        scl = real((tr(a.m))/4)
        return MVeven(scl*id4)
    elseif (n==2)
        tmp = (a-a')/2
        return tmp - MVeven(tr(tmp.m)/4*id4)
    elseif (n==4)
        tmp = (a+a')/2
        return tmp - MVeven(tr(tmp.m)/4*id4)
    elseif (n == 6)
        scl = im*imag((tr(a.m))/4)
        return MVeven(scl*id4)
    else
        return MVeven(mzero)
    end
end


function project(a::MVodd,n::Integer)
    if (n==3)
        return 0.5*(a - a')
    elseif (n==1)
        tmp = (a+a')*g0/2
        return (project(tmp,0)+project(tmp,2))*g0
    elseif (n==5)
        tmp = (a+a')*g0/2
        return (project(tmp,4)+project(tmp,6))*g0
    else
        return MVodd(mzero)
    end
end   

function tr(a::MVeven)
    real(tr(a.m))/4
end

function dot(a::MVeven, b::MVeven)
    real(tr(a.m*b.m))/4  
end


function dot(a::MVodd, b::MVodd)
    bp = g2.m*conj(b.m)*g2.m
    real(tr(a.m*bp))/4  
end



#Exponentiation
function exp(a::MVeven)
    return MVeven(exp(a.m))
end

#TODO Any improvement here?
function expb(a::MVeven)
    a = project(a,2)
    R = exp(a)
    delt = R*R'-1
    return (1-0.5*delt + 0.375*delt*delt)*R
end


#Comparison
#StaticArrays does seem to lose some accuracy.
Base.isapprox(a::MVeven, b::MVeven) =  isapprox(a.m,b.m)
Base.isapprox(a::MVodd, b::MVodd) =  isapprox(a.m,b.m)
