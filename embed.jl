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