#=
Quaternion code. This is called by some of the later GA implementations. 
The core mirrors much of the GA code structure.
For completeness we have defined a division operation for quaternions as they are a division algebra.
Pretty-typing has not been implented here.
=#


import Base.:*
import Base.:+
import Base.:-
import Base.:/
import Base.exp

struct Quaternion
    w::Float64
    x::Float64
    y::Float64
    z::Float64
end

const qzero = Quaternion(0,0,0,0)

#Maths operations
function -(a::Quaternion)
    Quaternion(-a.w,-a.x,-a.y,-a.z)
end

function +(a::Quaternion, b::Quaternion)
    Quaternion(a.w + b.w, a.x + b.x, a.y + b.y, a.z + b.z)
end

function -(a::Quaternion,b::Quaternion)
    Quaternion(a.w - b.w, a.x - b.x, a.y - b.y, a.z - b.z)
end

function +(num::Number,a::Quaternion)
    Quaternion(a.w+convert(Float64,num), a.x, a.y, a.z)
end

function -(num::Number,a::Quaternion)
    Quaternion(-a.w+convert(Float64,num), -a.x, -a.y, -a.z)
end

function +(a::Quaternion,num::Number)
    Quaternion(a.w+convert(Float64,num), a.x, a.y, a.z)
end

function -(a::Quaternion,num::Number)
    Quaternion(a.w-convert(Float64,num), a.x, a.y, a.z)
end

function *(num::Number,a::Quaternion)
    num = convert(Float64,num)
    Quaternion(num*a.w, num*a.x, num*a.y, num*a.z)
end

function *(a::Quaternion,num::Number)
    num = convert(Float64,num)
    Quaternion(num*a.w, num*a.x, num*a.y, num*a.z)
end

function *(a::Quaternion, b::Quaternion)
    Quaternion(a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z,
             a.w*b.x + a.x*b.w + a.y*b.z - a.z*b.y,
             a.w*b.y + a.y*b.w + a.z*b.x - a.x*b.z,
             a.w*b.z + a.z*b.w + a.x*b.y - a.y*b.x )
end

function /(a::Quaternion,num::Number)
    num = convert(Float64,1/num)
    Quaternion(num*a.w, num*a.x, num*a.y, num*a.z)
end

function /(a::Quaternion,b::Quaternion)
    a*reverse(b) / scp(b,reverse(b))
end

#Reverse
function reverse(a::Quaternion)
    Quaternion(a.w,-a.x, -a.y, -a.z)
end

#Projection operations
function scp(a::Quaternion)
    a.w
end

function scp(a::Quaternion, b::Quaternion)
    a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z
end

function project(a::Quaternion, n::Integer)
    if (n==0)
        return Quaternion(a.w,0,0,0)
    elseif (n==2)
        return Quaternion(0,a.x,a.y,a.z)
    else
        return qzero
    end
end

#Exponentiation
function expb(a::Quaternion)
    a = project(a,2)
    nrm = sqrt(scp(a,-a))
    if iszero(nrm)
        return Quaternion(one(nrm),0,0,0)
    else
        return cos(nrm) + sin(nrm)*a/nrm
    end
end

function exp(a::Quaternion)
    R = expb(a)
    if iszero(a.w)
        return R
    else 
        return exp(a.w)*R
    end
end

