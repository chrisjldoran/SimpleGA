#Common text for display multivectors.

function Base.show(io::IO, mv::MVeven)
    print(mvtype(mv))
end


function Base.show(io::IO, ::MIME"text/plain", mvs::Vector{MVeven})
    n= length(mvs)
    println(io,n,"-element Vector{MVeven}")
    for i in eachindex(mvs)
    println(io, " ", mvtype(mvs[i]))
    end
end


function Base.show(io::IO, mv::MVodd)
    print(mvtype(mv))
end

function Base.show(io::IO, ::MIME"text/plain", mvs::Vector{MVodd})
    n= length(mvs)
    println(io,n,"-element Vector{MVodd}")
    for i in eachindex(mvs)
    println(io, " ", mvtype(mvs[i]))
    end
end
