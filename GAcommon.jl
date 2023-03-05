#=
All common code shared between the specific implementations is place here.
Mostly this is code to control multiple dispatch for the various ways of combining with scalars.
=#

#Addition. Can only add a scalar to even multivectors.

import LinearAlgebra.tr
import LinearAlgebra.dot

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

function tr(a::MVodd)
    0
end

function dot(a::MVeven,b::MVodd)
    0.0
end

function dot(a::MVodd,b::MVeven)
    0.0
end