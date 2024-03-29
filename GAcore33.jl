#=
Core code for the implementation of GA(3,3).
Work using self-dual and anti-self-dual decomposition. Base element is a 4x4 matrix built on Static Arrays library.
Useful algebra for line geometry.
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
    p::SArray{Tuple{4,4},Float64,2,16}
    m::SArray{Tuple{4,4},Float64,2,16}
end

struct MVodd
    p::SArray{Tuple{4,4},Float64,2,16}
    m::SArray{Tuple{4,4},Float64,2,16}
end

const id4 = SA_F64[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
const J4 = SA_F64[0 -1 0 0; 1 0 0 0; 0 0 0 1; 0 0 -1 0]
const mzero = SA_F64[0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]

#Addition / subtraction
function -(a::MVeven)
    MVeven(-a.p,-a.m)
end

function -(a::MVodd)
    MVodd(-a.p,-a.m)
end

function +(a::MVeven,b::MVeven)
    MVeven(a.p + b.p, a.m + b.m)
end

function +(a::MVodd,b::MVodd)
    MVodd(a.p + b.p, a.m + b.m)
end

function -(a::MVeven,b::MVeven)
    MVeven(a.p - b.p, a.m - b.m)
end

function -(a::MVodd,b::MVodd)
    MVodd(a.p - b.p, a.m - b.m)
end

#Scalar addition / subtraction. Other cases are in GAcommon
function +(num::Number,a::MVeven)
    MVeven(a.p + convert(Float64,num)*id4, a.m + convert(Float64,num)*id4)
end

function -(num::Number,a::MVeven)
    MVeven(-a.p + convert(Float64,num)*id4, -a.m + convert(Float64,num)*id4)
end

function *(num::Number,a::MVeven)
    num = convert(Float64,num)
    MVeven(num*a.p,  num*a.m)
end

function *(num::Number,a::MVodd)
    num = convert(Float64,num)
    MVodd(num*a.p,  num*a.m)
end

function *(a::MVeven,b::MVeven)
    MVeven( a.p*b.p,   a.m*b.m)  
end

function *(a::MVeven,b::MVodd)
    MVodd( a.p*b.p,   a.m*b.m)  
end

function *(a::MVodd,b::MVeven)
    MVodd( a.p*b.m, a.m*b.p)    
end

function *(a::MVodd,b::MVodd)
    MVeven( a.p*b.m, a.m*b.p)    
end

#Division by a real
function /(a::MVeven,num::Number)
    num = convert(Float64,1/num)
    MVeven(num*a.p,  num*a.m)
end

function /(a::MVodd,num::Number)
    num = convert(Float64,1/num)
    MVodd(num*a.p,  num*a.m)
end

#Reverse
function adjoint(a::MVeven)
    MVeven(-J4*transpose(a.m)*J4, -J4*transpose(a.p)*J4 )
end

function adjoint(a::MVodd)
    MVodd(-J4*transpose(a.p)*J4, -J4*transpose(a.m)*J4 )
end

#Grade and projection
function project(a::MVeven,n::Integer)
    if (n==0)
        scl = (tr(a.p)+tr(a.m))/8
        return MVeven(scl*id4,scl*id4)
    elseif (n==2)
        scl = (tr(a.p)-tr(a.m))/8
        return 0.5*(a - a') - MVeven(scl*id4,-scl*id4)
    elseif (n==4)
        scl = (tr(a.p)+tr(a.m))/8
        return 0.5*(a+a') - MVeven(scl*id4,scl*id4)
    elseif (n == 6)
        scl = (tr(a.p)-tr(a.m))/8
        return MVeven(scl*id4,-scl*id4)
    else
        return MVeven(mzero,mzero)
    end
end

function project(a::MVodd,n::Integer)
    if (n==3)
        return 0.5*(a - a')
    elseif (n==1)
        tmp = (a+a')*e3/2
        return (project(tmp,0)+project(tmp,2))*e3
    elseif (n==5)
        tmp = (a+a')*e3/2
        return (project(tmp,4)+project(tmp,6))*e3
    else
        return MVodd(mzero,mzero)
    end
end   

function tr(a::MVeven)
    (tr(a.p)+tr(a.m))/8
end

#StaticArrays seems to have optimised the trace of a product operation already.
function dot(a::MVeven, b::MVeven)
    (tr(a.p*b.p)+tr(a.m*b.m))/8   
end

function dot(a::MVodd, b::MVodd)
    (tr(a.p*b.m)+tr(a.m*b.p))/8   
end


#Exponentiation
function exp(a::MVeven)
    return MVeven(exp(a.p),exp(a.m))
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
Base.isapprox(a::MVeven, b::MVeven) = isapprox(a.p,b.p) && isapprox(a.m,b.m)
Base.isapprox(a::MVodd, b::MVodd) = isapprox(a.p,b.p) && isapprox(a.m,b.m)
