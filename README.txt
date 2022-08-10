This folder contains files for implementations of small geometric algebras. Currently implemented are

GA(2,0): GA20.jl
GA(3,0): GA30.jl
GA(4,0): GA40.jl
GA(1,3) (STA): STA.jl
GA(4,1) (CGA): CGA.jl
GA(3,3): GA33.jl
GA(3,0,1) (PGA): PGA.jl

For efficiency we separate out even and odd entries, and only implement products between these. It is not possible to mix even and odd entries in a single multivector. If this is required, you should work in an algebra 1 dimension higher. So to mix even and odd in GA(3,0), work instead in STA. (There are good reasons for working like this anyway).

Common code is placed in GAcommon.jl. This is mostly code to catch the various cases of multiple dispatch for addition and scalar multiplication. Quaternions are used in STA and CGA implementaions are pulled out into a separate file. (They are also used in GA(3,0) but it makes more sense to keep all this code in 1 file).

All algebras are implemented over Float64. This is fixed to allow for compiler optimisations. All multivectors are immutable structs, so write your code using FP style.

The core structures and multiplication rules, specific to each algebra, are placed in GAcore files, where the name matches the algebra. 

The final code to include is contained in the file names listed above. This includes the basis definitions and pretty-typing rules.

In most cases we expose a set of basis vectors e_i and f_i.

For CGA the basis vectors are e_1 .. e_4 and f_4. 

The STA uses a different naming convention of g0, g1, g2, g3, s1, s2, s3 for usual gamma vectors and sigma bivectors.

In PGA we follow the 'Dutch' convention and use e0 for the null vector. PGA also includes an additional 'dual' operation.

The product in every case is *, and combiations with scalars work as expected. Addition, subtraction, multiplication and division by scalars all work. If necessary scalars are converted to Float64. No multivector division is defined (it is not a division algebra.)

The other rules exposed are:

- reverse. Takes a multivector argument and returns its reverse. This is NOT an in-place operation. Following FP rules it returns are new object.
- project(A,n). Returns the grade-n part of A, in the form of a multivector.
- scp(A). Returns the scalar part of A as a scalar. 
- scp(A,B). Returns the scalar part of the product AB. Note that this form is more efficient that scp(A*B) as only the terms contributing to the scalar part are calculated.

The scp operator is the main workhorse for extracting real values back out from multivectors. Any other product you want to define can be built from * and projection onto grade.


