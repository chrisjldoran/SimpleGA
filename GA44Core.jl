#= 
Core code for the implementation of GA(4,4).
Uses a Uint8 representation of basis blades and bitwise operations. 
Used for checking other algebras.
=#

import Base.:*
import Base.:+
import Base.:-
import Base.:/
import Base.exp

struct Multivector
    bas::Vector{UInt8}
    val::Vector{Float64}
    function Multivector(bs,vs)
        if length(bs) != length(unique(bs))
            error("List of blades must be unique")
        end
        if issorted(bs)
            new(bs,vs)
        else
            p = sortperm(bs)
            new(sort(bs),vs[p])
        end
    end
end


#Addition / subtraction
function -(mv::Multivector)
    Multivector(mv.bas,-rsval)
end

function +(mv1::Multivector, mv2::Multivector)
    rsbas=sort(union(mv1.bas,mv2.bas))
    ln=length(rsbas)
    rsval=zeros(Float64,ln)
    for i in 1:length(mv1.bas)
        j=findfirst(isequal(mv1.bas[i]),rsbas)
        rsval[j]+=mv1.val[i]
    end
    for i in 1:length(mv2.bas)
        j=findfirst(isequal(mv2.bas[i]),rsbas)
        rsval[j]+=mv2.val[i]
    end
    return Multivector(rsbas,rsval)
end

function +(nm::Number,mv::Multivector)
    mv2 = Multivector([0x00],[convert(Float64,nm)])
    return (mv+mv2)
end

function +(mv::Multivector,nm::Number,)
    return nm+mv
end

function -(nm::Number,mv::Multivector)
    return nm+(-mv)
end

function -(mv::Multivector,nm::Number,)
    return (-nm)+mv
end

function -(mv1::Multivector,mv2::Multivector)
    return mv1+(-(mv2))
end

#Multiplication
function gaprodsign(bld1, bld2)
    #Expects UInt8s for now
    tp1 = xor( bld2, bld2 << 1 )
    cntones = count_ones((bld1 & 0xaa) & tp1)
    return convert(Int8, 1 - 2* (cntones % 2))
end


function *(mv1::Multivector,mv2::Multivector)
    blds = [xor(x,y) for x in mv1.bas for y in mv2.bas]
    resbas = sort(unique(blds))
    return mvprod1(mv1,mv2,resbas)
end 

#Does full product
#TODO Could implement a version of this projecting onto a subset.
function mvprod1(mv1::Multivector,mv2::Multivector,bas::Vector{UInt8})
    res = zeros(Float64,length(bas))
    for i in 1:length(mv1.bas)
        for j in 1:length(mv2.bas)
            k = findfirst(isequal(xor(mv1.bas[i],mv2.bas[j])),bas)
            res[k]+=gaprodsign(mv1.bas[i],mv2.bas[j])*mv1.val[i]*mv2.val[j]
        end
    end
    return Multivector(bas,res)
end

function *(num::Number,mv::Multivector)
    num = convert(Float64,num)
    return Multivector(mv.bas,num*mv.val)
end

function *(mv::Multivector,num::Number)
    return num*mv
end

#Division by a real
function /(mv::Multivector,num::Number)
    num = convert(Float64,1/num)
    return num*mv
end


#Reverse

function grd(xin::UInt8)
    if count_ones(xin & 0xc0) == 1
        xin = xor(xin,0x3f)
    end
    if count_ones(xin & 0x30) == 1
        xin = xor(xin,0x0f)
    end
    if count_ones(xin & 0x0c) == 1
        xin = xor(xin, 0x03)
    end
    return count_ones(xin)
end

function reverse(mv::Multivector)
    rsval = similar(mv.val)
    for i in 1:length(mv.bas)
        if isodd(div(grd(mv.bas[i]),2))
            rsval[i]=-mv.val[i]
        else
            rsval[i]= mv.val[i]
        end
    end
    return Multivector(mv.bas,rsval)
end

function reverse(n::Number)
    return n
end

#Grade and projection
function project(mv::Multivector,n::Int64)
    rsbas = filter(x->grd(x)==n,mv.bas)
    ln = length(rsbas)
    rsval = zeros(Float64,ln)
    for i in 1:ln
        j=findfirst(isequal(rsbas[i]),mv.bas)
        rsval[i]=mv.val[j]
    end
    return Multivector(rsbas, rsval)
end

function scp(mv::Multivector)
    if mv.bas[1]==0x00
        return mv.val[1]
    else
        return 0.0
    end
end

function scp(mv1::Multivector,mv2::Multivector)
    rsbas=intersect(mv1.bas,mv2.bas)
    ln=length(rsbas)
    res=0.0
    for i in 1:ln
        sn=gaprodsign(rsbas[i], rsbas[i])
        j=findfirst(isequal(rsbas[i]),mv1.bas)
        tp = mv1.val[j]*sn
        j=findfirst(isequal(rsbas[i]),mv2.bas)
        res += tp*mv2.val[j]
    end
    return res
end


#Exponentiation
function exp(a::Multivector)
    s = ceil(Int,log(2,dot(a.val,a.val)))
    a = 1/2^s*a
    res = 1+a
    powa = a
    for i in 2:13
        powa *= a/i
        res += powa
    end
    for i in 1:s
        res = res*res
    end
    return res
end

function expb(a::Multivector)
    return exp(project(a,2))
end