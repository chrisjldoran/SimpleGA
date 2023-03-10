#Test shared across all algebras.

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
