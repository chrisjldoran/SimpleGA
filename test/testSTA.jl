#Test suite for STA.
#Test stand-alone results and compares with GA(4,4)

bassta = basis("STA")
g0 = bassta[1]
g1 = bassta[2]
g2 = bassta[3]
g3 = bassta[4]

I4 = g0*g1*g2*g3

me1 = rand() + rand()*g1*g2 + g1*g3*rand() + g3*rand()*g2 - rand()*g1*g0 + g2*g0/rand() + rand()*g3*g0 + rand()*I4
me2 = rand() + rand()*g1*g2 + g1*g3*rand() + g3*rand()*g2 - rand()*g1*g0 + g2*g0/rand() + rand()*g3*g0 + rand()*I4
me3 = rand() + rand()*g1*g2 + g1*g3*rand() + g3*rand()*g2 - rand()*g1*g0 + g2*g0/rand() + rand()*g3*g0 + rand()*I4
mo1 = rand()*g1 + rand()*g2 + g3*rand() + g0*rand() + I4*(rand()*g1 + rand()*g2 + g3*rand() + g0*rand())
mo2 = rand()*g1 + rand()*g2 + g3*rand() + g0*rand() + I4*(rand()*g1 + rand()*g2 + g3*rand() + g0*rand())
mo3 = rand()*g1 + rand()*g2 + g3*rand() + g0*rand() + I4*(rand()*g1 + rand()*g2 + g3*rand() + g0*rand())

#include("testcommon.jl")
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
f1 = me1*g0*me1'
f2 = me1*g1*me1'
@test isapprox(dot(f1,f2),0.0; atol=128*eps(Float64))

#Projection
@test isapprox(me1  , project(me1,0) + project(me1,2) + project(me1,4) + project(me1,6))
@test isapprox(mo1  , project(mo1,1) + project(mo1,3) + project(mo1,5))

#Comparison with GA(4,4)
bas44 = basis("GA44")
G0 = bas44[1]
G1 = bas44[5]
G2 = bas44[6]
G3 = bas44[7]
arr1 = rand(4)
v1 = inject(arr1,bassta)
V1 = inject(arr1,[G0,G1,G2,G3])
arr2 = rand(4)
v2 = inject(arr2,bassta)
V2 = inject(arr2,[G0,G1,G2,G3])
arr3 = rand(4)
v3 = inject(arr3,bassta)
V3 = inject(arr3,[G0,G1,G2,G3])
arr4 = rand(4)
v4 = inject(arr4,bassta)
V4 = inject(arr4,[G0,G1,G2,G3])
@test isapprox(dot(v1,v1),dot(V1,V1); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,g1), dot(V1*V2*V3,G1); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,g2), dot(V1*V2*V3,G2); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,g3), dot(V1*V2*V3,G3); atol=eps(Float64))
@test isapprox(dot(v1*v2*v3,g0), dot(V1*V2*V3,G0); atol=eps(Float64))
@test isapprox(embed(v1*v2*v3), V1*V2*V3)
@test isapprox(embed(v1*v2*v3*v4), V1*V2*V3*V4)
@test isapprox(embed(exp(v1*v2)),exp(V1*V2),1e-8)
@test isapprox(embed(expb(v1*v2)),expb(V1*V2),1e-8)