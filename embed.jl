#Routines for converting from small algebras to G(4,4)

function embed(a::GA.GA20.MVodd)
    bas44 = basis("GA44")
    return real(a.c1)*bas44[1]+imag(a.c1)*bas44[2]
end

function embed(a::GA.GA20.MVeven)
    bas44 = basis("GA44")
    return real(a.c1)+imag(a.c1)*bas44[1]*bas44[2]
end

function embed(a::GA.GA30.MVeven)
    bas44 = basis("GA44")
    return a.w - a.x*bas44[2]*bas44[3] - a.y*bas44[3]*bas44[1] - a.z*bas44[1]*bas44[2]
end

function embed(a::GA.GA30.MVodd)
    return a.x*bas44[1] + a.y*bas44[2] + a.z*bas44[3] + a.w*bas[1]*bas[2]*bas[3]
end