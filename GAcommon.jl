#=
All common code shared between the specific implementations is place here.
Mostly this is code to control multiple dispatch for the various ways of combining with scalars.
=#

#Addition. Can only add a scalar to even multivectors.

function +(a::MVeven,num::Number)
    num + a
end

function -(a::MVeven,num::Number)
    (-num) + a
end

#Multiplication
function *(a::MVeven,num::Number)
    num * a
end

function *(a::MVodd,num::Number)
    num * a
end

function scp(a::MVodd)
    0
end

function scp(a::MVeven,b::MVodd)
    0.0
end

function scp(a::MVodd,b::MVeven)
    0.0
end