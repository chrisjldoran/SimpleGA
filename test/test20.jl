#Test suite for GA 20.
#Test stand-alone results and compares with GA(4,4)

bas20 = basis("GA20")
e1 = bas20[1]
e2 = bas20[2]
me1 = rand() + rand()*e1*e2 
me2 = rand() + rand()*e1*e2 
me3 = rand() + rand()*e1*e2 
mo1 = rand()*e1 + rand()*e2
mo2 = rand()*e1 + rand()*e2 
mo3 = rand()*e1 + rand()*e2 

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
@test isapprox(dot(f1,f2),0.0; 1e-10)


#Projection
@test isapprox(me1  , project(me1,0) + project(me1,2) + project(me1,4) + project(me1,6))
@test isapprox(mo1  , project(mo1,1) + project(mo1,3) + project(mo1,5))

#Comparison with GA(4,4)
bas44 = basis("GA44")
E1 = bas44[1]
E2 = bas44[2]
arr1 = rand(2)
v1 = inject(arr1,bas20)
V1 = inject(arr1,[E1,E2])
arr2 = rand(2)
v2 = inject(arr2,bas20)
V2 = inject(arr2,[E1,E2])
arr3 = rand(2)
v3 = inject(arr3,bas20)
V3 = inject(arr3,[E1,E2])
@test isapprox(dot(v1,v1),dot(V1,V1))
@test isapprox(dot(v1*v2*v3,e1), dot(V1*V2*V3,E1))
@test isapprox(dot(v1*v2*v3,e2), dot(V1*V2*V3,E2))
@test isapprox(embed(exp(v1*v2)),exp(V1*V2))
@test isapprox(embed(expb(v1*v2)),expb(V1*V2))