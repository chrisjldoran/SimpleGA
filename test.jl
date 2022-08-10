#Selection of test routines for GA code.

#Quaternions

q1 = Quaternion(rand(), rand(), rand(), rand())
q2 = Quaternion(rand(), rand(), rand(), rand())
q3 = Quaternion(rand(), rand(), rand(), rand())

q1*(q2+q3) - q1*q2 - q1*q3
(q1*q2)*q3 - q1*(q2*q3)

#GA(2,0)
me1 = rand() + rand()*e1*e2 
me2 = rand() + rand()*e1*e2 
me3 = rand() + rand()*e1*e2 
mo1 = rand()*e1 + rand()*e2
mo2 = rand()*e1 + rand()*e2 
mo3 = rand()*e1 + rand()*e2 

#GA(3,0)
me1 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2
me2 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2
me3 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2
mo1 = rand()*e1 + rand()*e2 + e3*rand() + e3*rand()*e2*e1
mo2 = rand()*e1 + rand()*e2 + e3*rand() + e3*rand()*e2*e1
mo3 = rand()*e1 + rand()*e2 + e3*rand() + e3*rand()*e2*e1

vc = rand()*e1 + rand()*e2 + e3*rand()

#GA(4,0)
me1 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + rand()*e3*e4 + rand()*E4
me2 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + rand()*e3*e4 + rand()*E4
me3 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + rand()*e3*e4 + E4/rand()
mo1 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand() + E4*(rand()*e1 + rand()*e2 + e3*rand() + e4*rand())
mo2 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand() + E4*(rand()*e1 + rand()*e2 + e3*rand() + e4*rand())
mo3 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand() + E4*(rand()*e1 + rand()*e2 + e3*rand() + e4*rand())

#STA
me1 = rand() + rand()*g1*g2 + g1*g3*rand() + g3*rand()*g2 - rand()*g1*g0 + g2*g0/rand() + rand()*g3*g0 + rand()*I4
me2 = rand() + rand()*g1*g2 + g1*g3*rand() + g3*rand()*g2 - rand()*g1*g0 + g2*g0/rand() + rand()*g3*g0 + rand()*I4
me3 = rand() + rand()*g1*g2 + g1*g3*rand() + g3*rand()*g2 - rand()*g1*g0 + g2*g0/rand() + rand()*g3*g0 + rand()*I4
mo1 = rand()*g1 + rand()*g2 + g3*rand() + g0*rand() + I4*(rand()*g1 + rand()*g2 + g3*rand() + g0*rand())
mo2 = rand()*g1 + rand()*g2 + g3*rand() + g0*rand() + I4*(rand()*g1 + rand()*g2 + g3*rand() + g0*rand())
mo3 = rand()*g1 + rand()*g2 + g3*rand() + g0*rand() + I4*(rand()*g1 + rand()*g2 + g3*rand() + g0*rand())

#PGA
me1 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e0 + rand()*e2*e0 + rand()*e3*e0 + rand()*I3*e0
me2 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e0 + rand()*e2*e0 + rand()*e3*e0 + rand()*I3*e0
me3 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e0 + rand()*e2*e0 + rand()*e3*e0 + rand()*I3*e0
mo1 = rand()*e1 + rand()*e2 + e3*rand() + e0/rand() + I3*e0*(rand()*e1 + rand()*e2 + e3*rand()) + + rand()*I3
mo2 = rand()*e1 + rand()*e2 + e3*rand() + e0/rand() + I3*e0*(rand()*e1 + rand()*e2 + e3*rand()) + + rand()*I3
mo3 = rand()*e1 + rand()*e2 + e3*rand() + e0/rand() + I3*e0*(rand()*e1 + rand()*e2 + e3*rand()) + + rand()*I3


#CGA
me1 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + e3*e4/rand() + 
f4*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4) + I5*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4 + rand()*f4)
me2 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + e3*e4/rand() + 
f4*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4) + I5*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4 + rand()*f4)
me3 = rand() + rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + e3*e4/rand() + 
f4*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4) + I5*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4 + rand()*f4)
mo1 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand()+ f4/rand() + rand()*I5 +
I5*(rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + e3*e4/rand() + f4*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4))
mo2 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand()+ f4/rand() + rand()*I5 +
I5*(rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + e3*e4/rand() + f4*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4))
mo3 = rand()*e1 + rand()*e2 + e3*rand() + e4*rand()+ f4/rand() + rand()*I5 +
I5*(rand()*e1*e2 + e1*e3*rand() + e3*rand()*e2 - rand()*e1*e4 + rand()*e2*e4 + e3*e4/rand() + f4*(rand()*e1 + rand()*e2 +rand()*e3 +rand()*e4))


#GA(3,3)
me1 = rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2 +
    e3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    f3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    e3*f3*(rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2)
me2 = rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2 +
    e3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    f3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    e3*f3*(rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2)
me3 = rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2 +
    e3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    f3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    e3*f3*(rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2)
mo1 = (rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    e3*( rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2) +
    f3*( rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2) +
    e3*f3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ))
mo2 = (rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    e3*( rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2) +
    f3*( rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2) +
    e3*f3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ))
mo3 = (rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ) ) +
    e3*( rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2) +
    f3*( rand() + rand()*e1*e2 + e1*f1*rand() + e1*rand()*f2 - rand()*f1*e2 + e2*f2/rand() + rand()*f1*f2 + rand()*e1*e2*f1*f2) +
    e3*f3*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() + e1*e2*f1*f2*(rand()*e1 + rand()*e2 + f1*rand() + f2*rand() ))

vc1 = rand()*e1 + rand()*e2 + e3*rand()+ rand()*f1 + rand()*f2 + f3*rand()
vc2 = rand()*e1 + rand()*e2 + e3*rand()+ rand()*f1 + rand()*f2 + f3*rand()
vc3 = rand()*e1 + rand()*e2 + e3*rand()+ rand()*f1 + rand()*f2 + f3*rand()
vc4 = rand()*e1 + rand()*e2 + e3*rand()+ rand()*f1 + rand()*f2 + f3*rand()

#Distributivity
me1*(me2+me3) - me1*me2 - me1*me3
mo1*(me2+me3) - mo1*me2 - mo1*me3
me1*(mo2+mo3) - me1*mo2 - me1*mo3
mo1*(mo2+mo3) - mo1*mo2 - mo1*mo3

#Associativity
me1*(me2*me3) - (me1*me2)*me3
mo1*(me2*me3) - (mo1*me2)*me3
me1*(mo2*me3) - (me1*mo2)*me3
me1*(me2*mo3) - (me1*me2)*mo3
mo1*(mo2*me3) - (mo1*mo2)*me3
mo1*(me2*mo3) - (mo1*me2)*mo3
me1*(mo2*mo3) - (me1*mo2)*mo3
mo1*(mo2*mo3) - (mo1*mo2)*mo3

#Rotation
f1 = me1*e1*reverse(me1)
f2 = me1*e2*reverse(me1)
scp(f1,f2)

#Projection
me1  - project(me1,0) - project(me1,2) - project(me1,4) - project(me1,6)
mo1  - project(mo1,1) - project(mo1,3) - project(mo1,5)