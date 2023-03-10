#Routines for converting from small algebras to G(4,4)

function embed(a::GA20.MVodd)
    bas44 = basis("GA44")
    return real(a.c1)*bas44[1]+imag(a.c1)*bas44[2]
end

function embed(a::GA20.MVeven)
    bas44 = basis("GA44")
    return real(a.c1)+imag(a.c1)*bas44[1]*bas44[2]
end

function embed(a::GA30.MVeven)
    bas44 = basis("GA44")
    return a.w - a.x*bas44[2]*bas44[3] - a.y*bas44[3]*bas44[1] - a.z*bas44[1]*bas44[2]
end

function embed(a::GA30.MVodd)
    return a.x*bas44[1] + a.y*bas44[2] + a.z*bas44[3] + a.w*bas[1]*bas[2]*bas[3]
end

function embed(a::GA40.MVeven)
    (e1,e2,e3,e4) = (GA.GA40.e1, GA.GA40.e2, GA.GA40.e3, GA.GA40.e4)
    (E1,E2,E3,E4) = (GA.GA44.e1, GA.GA44.e2, GA.GA44.e3, GA.GA44.e4)
    b40 = [-e1*e2, -e1*e3, -e1*e4, -e2*e3, -e2*e4, -e3*e4, e1*e2*e3*e4]
    b44 = [E1*E2, E1*E3, E1*E4, E2*E3, E2*E4, E3*E4, E1*E2*E3*E4]
    res = tr(a)
    for i in 1:7
        res+= dot(a,b40[i])*b44[i]
    end
    return res
end

function embed(a::GA40.MVodd)
    (e1,e2,e3,e4) = (GA.GA40.e1, GA.GA40.e2, GA.GA40.e3, GA.GA40.e4)
    (E1,E2,E3,E4) = (GA.GA44.e1, GA.GA44.e2, GA.GA44.e3, GA.GA44.e4)
    b40 = [e1, e2, e3, e4, -e2*e3*e4, -e1*e3*e4, -e1*e2*e4, -e1*e2*e3]
    b44 = [E1, E2, E3, E4, E2*E3*E4, E1*E3*E4, E1*E2*E4, E1*E2*E3 ]
    res = 0.0*E1
    for i in 1:8
        res+= dot(a,b40[i])*b44[i]
    end
    return res
end

   
function embed(a::PGA.MVeven)
    (E1,E2,E3,E0) = (GA.GA44.e1, GA.GA44.e2, GA.GA44.e3, GA.GA44.e4+GA.GA44.f4)
    I3 = E1*E2*E3
    evenlist = [a.q.w, -a.q.z, - a.q.x, -a.q.y, -a.n.x, -a.n.y, -a.n.z, -a.n.w]
    bas = [1, E1*E2, E2*E3, E3*E1, E0*E1, E0*E2, E0*E3, E0*I3 ]
    return inject(evenlist,bas)
end

function embed(a::PGA.MVodd)
    (E1,E2,E3,E0) = (GA.GA44.e1, GA.GA44.e2, GA.GA44.e3, GA.GA44.e4+GA.GA44.f4)
    I3 = E1*E2*E3
    oddlist = [a.n.w,-a.q.x,-a.q.y,-a.q.z,a.n.z,a.n.y,a.n.x,-a.q.w]
    bas = [E0, E1, E2, E3, E0*E2*E1, E0*E1*E3, E0*E3*E2, I3]
    return inject(oddlist,bas)
end

function embed(a::STA.MVeven)
    (g0,g1,g2,g3) = (GA.STA.g0,GA.STA.g1,GA.STA.g2,GA.STA.g3 )
    (G0, G1,G2,G3) = (GA.GA44.e1, GA.GA44.f1, GA.GA44.f2, GA.GA44.f3)
    i4 = g0*g1*g2*g3
    I4 = G0*G1*G2*G3
    evenlist = [tr(a), dot(a,g0*g1), dot(a,g0*g2), dot(a,g0*g3), -dot(a,i4*g0*g1), -dot(a,i4*g0*g2), -dot(a,i4*g0*g3), -dot(a,i4)]
    bas = [1, G0*G1, G0*G2, G0*G3, I4*G0*G1, I4*G0*G2, I4*G0*G3, I4  ]
    return inject(evenlist,bas)
end

function embed(a::STA.MVodd)
    (g0,g1,g2,g3) = (GA.STA.g0,GA.STA.g1,GA.STA.g2,GA.STA.g3 )
    (G0, G1,G2,G3) = (GA.GA44.e1, GA.GA44.f1, GA.GA44.f2, GA.GA44.f3)
    i4 = g0*g1*g2*g3
    I4 = G0*G1*G2*G3
    oddlist = [dot(a,g0), -dot(a,g1), -dot(a,g2), -dot(a,g3), dot(a,i4*g0), -dot(a,i4*g1), -dot(a,i4*g2), -dot(a,i4*g3)]
    bas = [G0,G1, G2, G3, I4*G0, I4*G1, I4*G2, I4*G3 ]
    return inject(oddlist,bas)
end

function embed(a::CGA.MVeven)
    (e1,e2,e3,e4,f4) = (GA.CGA.e1, GA.CGA.e2, GA.CGA.e3, GA.CGA.e4, GA.CGA.f4 )
    (E1,E2,E3,E4,F4) = (GA.GA44.e1, GA.GA44.e2, GA.GA44.e3, GA.GA44.e4, GA.GA44.f4)
    i5 = e1*e2*e3*e4*f4
    I5 = E1*E2*E3*E4*F4
    evenbas = [-e1*e2, -e1*e3, -e1*e4, -e2*e3, -e2*e4, -e3*e4, e1*f4, e2*f4, e3*f4, e4*f4, -i5*e1, -i5*e2, -i5*e3, -i5*e4, i5*f4] 
    vals = map(bs->dot(a,bs),evenbas)
    resbas = [E1*E2, E1*E3, E1*E4, E2*E3, E2*E4, E3*E4, E1*F4, E2*F4, E3*F4, E4*F4, I5*E1, I5*E2, I5*E3, I5*E4, I5*F4] 
    return tr(a)+inject(vals,resbas)
end


function embed(a::CGA.MVodd)
    (e1,e2,e3,e4,f4) = (GA.CGA.e1, GA.CGA.e2, GA.CGA.e3, GA.CGA.e4, GA.CGA.f4 )
    (E1,E2,E3,E4,F4) = (GA.GA44.e1, GA.GA44.e2, GA.GA44.e3, GA.GA44.e4, GA.GA44.f4)
    i5 = e1*e2*e3*e4*f4
    I5 = E1*E2*E3*E4*F4
    oddbas = [e1,e2,e3,e4,-f4, i5*e1*e2, i5*e1*e3, i5*e1*e4, i5*e2*e3, i5*e2*e4, i5*e3*e4, -i5*e1*f4, -i5*e2*f4, -i5*e3*f4, -i5*e4*f4, -i5 ]
    vals = map(bs->dot(a,bs),oddbas)
    resbas = [E1,E2,E3,E4,F4, I5*E1*E2, I5*E1*E3, I5*E1*E4, I5*E2*E3, I5*E2*E4, I5*E3*E4, I5*E1*F4, I5*E2*F4, I5*E3*F4, I5*E4*F4, I5 ]
    return inject(vals,resbas)
end

function embed(a::GA33.MVeven)
    e1 = GA.bas33[1]
    e2 = GA.bas33[2]
    e3 = GA.bas33[3]
    f1 = GA.bas33[4]
    f2 = GA.bas33[5]
    f3 = GA.bas33[6]
    i6 = e1*e2*e3*f1*f2*f3
    evenbas = [-e1*e2, -e1*e3, -e2*e3, -f1*f2, -f1*f3, -f2*f3, e1*f1, e1*f2, e1*f3, e2*f1, e2*f2, e2*f3, e3*f1, e3*f2, e3*f3,
        -e1*e2*i6, -e1*e3*i6, -e2*e3*i6, -f1*f2*i6, -f1*f3*i6, -f2*f3*i6, e1*f1*i6, e1*f2*i6, e1*f3*i6,e2*f1*i6, 
        e2*f2*i6, e2*f3*i6, e3*f1*i6, e3*f2*i6, e3*f3*i6,i6]
    vals = map(bs->dot(a,bs),evenbas)
    E1 = GA.bas44[1]
    E2 = GA.bas44[2]
    E3 = GA.bas44[3]
    F1 = GA.bas44[5]
    F2 = GA.bas44[6]
    F3 = GA.bas44[7]
    I6 = E1*E2*E3*F1*F2*F3
    resbas = [E1*E2, E1*E3, E2*E3, F1*F2, F1*F3, F2*F3, E1*F1, E1*F2, E1*F3, E2*F1, E2*F2, E2*F3, E3*F1, E3*F2, E3*F3,
    E1*E2*I6, E1*E3*I6, E2*E3*I6, F1*F2*I6, F1*F3*I6, F2*F3*I6, E1*F1*I6, E1*F2*I6, E1*F3*I6,E2*F1*I6, 
    E2*F2*I6, E2*F3*I6, E3*F1*I6, E3*F2*I6, E3*F3*I6,I6]
    return tr(a) + inject(vals,resbas)
end

function embed(a::GA33.MVodd)
    e1 = GA.bas33[1]
    e2 = GA.bas33[2]
    e3 = GA.bas33[3]
    f1 = GA.bas33[4]
    f2 = GA.bas33[5]
    f3 = GA.bas33[6]
    i6 = e1*e2*e3*f1*f2*f3
    oddbas = [e1, e2, e3, -f1, -f2, -f3, -e1*e2*e3, 
    e1*e2*f1, e1*e3*f1, e2*e3*f1, e1*e2*f2, e1*e3*f2, e2*e3*f2, e1*e2*f3, e1*e3*f3, e2*e3*f3,
    -e1*f1*f2, - e1*f1*f3, -e1*f2*f3, -e2*f1*f2, - e2*f1*f3, -e2*f2*f3, -e3*f1*f2, - e3*f1*f3, -e3*f2*f3,
    f1*f2*f3, -e1*i6, -e2*i6, -e3*i6, f1*i6, f2*i6, f3*i6]
    vals = map(bs->dot(a,bs),oddbas)
    E1 = GA.bas44[1]
    E2 = GA.bas44[2]
    E3 = GA.bas44[3]
    F1 = GA.bas44[5]
    F2 = GA.bas44[6]
    F3 = GA.bas44[7]
    I6 = E1*E2*E3*F1*F2*F3
    resbas = [E1, E2, E3, F1, F2, F3, E1*E2*E3, 
    E1*E2*F1, E1*E3*F1, E2*E3*F1, E1*E2*F2, E1*E3*F2, E2*E3*F2, E1*E2*F3, E1*E3*F3, E2*E3*F3,
    E1*F1*F2,  E1*F1*F3, E1*F2*F3, E2*F1*F2, E2*F1*F3, E2*F2*F3, E3*F1*F2,  E3*F1*F3, E3*F2*F3,
    F1*F2*F3, E1*I6, E2*I6, E3*I6, F1*I6, F2*I6, F3*I6]
    return inject(vals,resbas)
end

