#Test suite for GA 40.
#Test stand-alone results and compares with GA(4,4)

bas40 = basis("GA40")
e1 = bas40[1]
e2 = bas40[2]
e3 = bas40[3]
e4 = bas40[4]
E4 = e1*e2*e3*e4

me1 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + rand()*e3*e4 + rand()*E4
me2 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + rand()*e3*e4 + rand()*E4
me3 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + rand()*e3*e4 + E4/rand()
mo1 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand() + E4*(rand()*e1 + rand()*e2 + e3*rand() + e4*rand())
mo2 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand() + E4*(rand()*e1 + rand()*e2 + e3*rand() + e4*rand())
mo3 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand() + E4*(rand()*e1 + rand()*e2 + e3*rand() + e4*rand())

#Distributivity
@test isapprox(me1*(me2+me3), me1*me2 + me1*me3)
@test isapprox(mo1*(me2+me3), mo1*me2 + mo1*me3)
@test isapprox(me1*(mo2+mo3), me1*mo2 + me1*mo3)
@test isapprox(mo1*(mo2+mo3), mo1*mo2 + mo1*mo3)

#Associativity
@test isapprox(me1*(me2*me3) , (me1*me2)*me3)
@test isapprox(mo1*(me2*me3) , (mo1*me2)*me3)
@test isapprox(me1*(mo2*me3) , (me1*mo2)*me3)
@test isapprox(me1*(me2*mo3) , (me1*me2)*mo3)
@test isapprox(mo1*(mo2*me3) , (mo1*mo2)*me3)
@test isapprox(mo1*(me2*mo3) , (mo1*me2)*mo3)
@test isapprox(me1*(mo2*mo3) , (me1*mo2)*mo3)
@test isapprox(mo1*(mo2*mo3) , (mo1*mo2)*mo3)

#Rotation
f1 = me1*e1*me1'
f2 = me1*e2*me1'
@test isapprox(dot(f1,f2),0.0; atol=16*eps(Float64))


#Projection
@test isapprox(me1  , project(me1,0) + project(me1,2) + project(me1,4) + project(me1,6))
@test isapprox(mo1  , project(mo1,1) + project(mo1,3) + project(mo1,5))


#Comparison with GA(4,4)
bas44 = basis("GA44")
E1 = bas44[1]
E2 = bas44[2]
E3 = bas44[3]
E4 = bas44[4]
arr1 = rand(4)
v1 = inject(arr1,bas40)
V1 = inject(arr1,[E1,E2,E3,E4])
arr2 = rand(4)
v2 = inject(arr2,bas40)
V2 = inject(arr2,[E1,E2,E3,E4])
arr3 = rand(4)
v3 = inject(arr3,bas40)
V3 = inject(arr3,[E1,E2,E3,E4])
arr4 = rand(4)
v4 = inject(arr4,bas40)
V4 = inject(arr4,[E1,E2,E3,E4])
@test isapprox(dot(v1,v1),dot(V1,V1); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,e1), dot(V1*V2*V3,E1); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,e2), dot(V1*V2*V3,E2); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,e3), dot(V1*V2*V3,E3); atol=eps(Float64))
@test isapprox(embed(v1*v2*v3), V1*V2*V3)
@test isapprox(embed(v1*v2*v3*v4), V1*V2*V3*V4)
@test isapprox(embed(exp(v1*v2)),exp(V1*V2),1e-8)
@test isapprox(embed(expb(v1*v2)),expb(V1*V2),1e-8)
