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

