-- -*- coding: utf-8 -*-
--- status: DRAFT
--- author(s): DE, then MES
--- notes: 

document {
     Key => quotient,
     Headline => "quotient or division"
     }

document { 
     Key => {
	  (quotient, Ideal, Ideal),
	  (quotient, MonomialIdeal, MonomialIdeal),
	  (quotient, Module, Ideal),
	  (quotient, Ideal, RingElement),
	  (quotient, Module, Module),
	  (quotient, Module, RingElement),
	  (symbol:, Module, Module),
	  (symbol:, Ideal, RingElement),
	  (symbol:, Ideal, Ideal),
	  (symbol:, Module, RingElement),
	  (symbol:, Module, Ideal),
	  (symbol:, MonomialIdeal, MonomialIdeal)
	  },
     Headline => "ideal or submodule quotient",
     Usage => "quotient(I,J)\nI:J",
     Inputs => {
	  "I" => {ofClass Ideal, ", or ", ofClass Module, ", a submodule"},
	  "J" => {ofClass Ideal, ", ", ofClass RingElement, ", or ", ofClass Module, ", a submodule"},
	  },
     Outputs => {
	  {TEX ///the ideal or submodule $I:J = \{f | fJ\subset I\}$///}
	  },
     "If ", TT "I", " and ", TT "J", " are both ", TO2(MonomialIdeal,"monomial ideals"), ", then the result will be as well.
     If ", TT "I", " and ", TT "J", " are both submodules of the same module, then the result will be an ideal, otherwise
     if ", TT "J", " is an ideal or ring element, then the result is a submodule containing ", TT "I", ".",
     PARA{},
     "Gröbner bases will be computed as needed.",
     PARA{},
     "The colon operator ", TO (symbol :), " may be used as an abbreviation 
     of ", TT "quotient", " if no options need to be supplied.",
     PARA{},
     "If the second input ", TT "J", " is a ring element ", TT "f", 
     ", then the principal ideal generated by ", TT "f", " is used.",
     PARA{},
     "The computation is not stored anywhere yet, BUT, it will soon be stored
     under ", TT "I.cache.QuotientComputation{J}", ", or ", TT "I.QuotientComputation{J}", ",
     so that the computation can be restarted after an interrupt.",
     EXAMPLE lines ///
	  R = ZZ[a,b,c];
	  F = a^3-b^2*c-11*c^2
	  I = ideal(F,diff(a,F),diff(b,F),diff(c,F))
	  I : (ideal(a,b,c))^3
	  ///,
     "If both arguments are submodules, the annihilator of ", TT "J/I", " (or ", TT "(J+I)/I", ") is returned.",
     EXAMPLE lines ///
          S = QQ[x,y,z];
	  J = image vars S
	  I = image symmetricPower(2,vars S)
	  (I++I) : (J++J)
	  (I++I) : x+y+z
	  quotient(I,J)
	  quotient(gens I, gens J)	  
          ///,
     "Ideal quotients and saturations are useful for manipulating components of ideals.
     For example, ",
     EXAMPLE lines ///
          I = ideal(x^2-y^2, y^3)
	  J = ideal((x+y+z)^3, z^2)
          L = intersect(I,J)
	  L : z^2
	  L : I == J
          ///,
     SeeAlso => {saturate, symbol:},
     }
document { 
     Key => [quotient, Strategy],
     Headline => "Possible strategies are: Iterate, Linear, and Quotient",
     Usage => "quotient(I,J,Strategy=>b)",
     Inputs => {"b"=>Symbol =>{"one of", TT " Iterate, Linear, Quotient"}
	  },
     "Suppose that ", TT "I", " is the image of a free module ", TT "FI", " in a quotient module ", TT "G", ",
     and ", TT "J", " is the image of the free module ", TT "FJ", " in ", TT "G", ".",
     PARA{},PARA{},
     "The default is ", TT "Strategy=>Quotient", ", which works as follows:",
     PARA{},
     "compute the first
     components of the syzygies of ",
     PRE "map R++((dual FJ)**FI --> (dual FJ) ** G.",
     PARA{},
     "If ", TT "Strategy=>Iterate", 
     " then quotient first computes the quotient ", TT "I1", " by the first generator of ", TT "J", ".
     It then checks whether this quotient already annihilates the second generator of ", TT "J", " mod ", TT "I", ".
     If so, it goes on to the third generator; else
     it intersects ", TT "I1", " with the quotient of ", TT "I", " by the second generator to produce a new ", TT "I1", ".
     It then iterates this process, working through the generators one at a time.",
     PARA{},
     "To use ", TT "Strategy=>Linear", 
     " the argument ", TT "J", " must be a principal ideal, generated by a linear form. A change of variables is made
     so that this linear form becomes the last variable. Then a reverse lex Gröbner basis is used,
     and the quotient of the initial ideal by the last variable is computed combinatorially. This
     set of monomial is then lifted back to a set of generators for the quotient.",
     PARA{},
     "For further information see for example Exercise 15.41 in Eisenbud's Commutative Algebra with a View Towards Algebraic Geometry.",
      PARA{},
     "The following examples show timings for the different strategies.",
     PARA{},
     TT "Strategy=>Iterate", " is sometimes faster for ideals with a small number of generators:",
     EXAMPLE {      
         "n = 6",  
         "S = ZZ/101[vars(0..n-1)];",
         "i1 = monomialCurveIdeal(S, 1..n-1)",
         "i2 = monomialCurveIdeal(S, 1..n-1)",
         "j1 = ideal(map(S^1,S^n, (p,q)->S_q^5))",
         "j2 = ideal(map(S^1,S^n, (p,q)->S_q^5))",
         "time quotient(i1^3,j1^2,Strategy=>Iterate);",
         "time quotient(i2^3,j2^2,Strategy=>Quotient);"
        },
      TT "Strategy=>Quotient", " is faster in other cases:",
      EXAMPLE {
             "S =ZZ/101[vars(0..4)];",
             "i =ideal vars S;",
             "j =ideal vars S;",
             "i3 = i^3; i5 = i^5;",
             "j3 = j^3; j5 = j^5;",
             "time quotient(i5,i3,Strategy=>Iterate);",
             "time quotient(j5,j3,Strategy=>Quotient);"
      }
}



document { 
     Key => [quotient, MinimalGenerators],
     Headline => "Decides whether quotient computes and outputs a trimmed set of generators; default is true",
     Usage => "quotient(I,J,MinimalGenerators => b)",
     Inputs => {"b" => Boolean => {TT "true", " forces trimmed output."}
	  },
     EXAMPLE {
	  "S=ZZ/101[a,b]",
     	  "i=ideal(a^4,b^4)"},
	  "The following returns 2 minimal generators ",
	  "(Serre's Theorem: a codim 2 Gorenstein ideal is a complete intersection.)",
	EXAMPLE  "quotient(i, a^3+b^3)",
	  "Without trimming we'd get 4 generators instead.",
  	  EXAMPLE "quotient(i, a^3+b^3, MinimalGenerators=>false)",
     }

end

///
-- old, replaced documentation
document {
     Key => quotient,
     Headline => "ideal or submodule quotient",
     TT "quotient(I,J)", " -- computes the ideal or submodule quotient ", TT "(I:J)", ".", 
     PARA{},
     "The arguments should be ideals in the same ring, or submodules of the same
     module.  If ", TT "J", " is a ring element, then the principal ideal 
     generated by ", TT "J", " is used.",
     PARA{},
     "The operator ", TO ":", " can be used as an abbreviation, but without optional
     arguments; see ", TO (symbol :, Module, Module), ".",
     PARA{},
     "For ideals, the quotient is the set of ring elements r such that rJ is
     contained in I.  If I is a submodule of a module M, and J is an ideal,
     the quotient is the set of elements m of M such that Jm is contained in
     I.  Finally, if I and J are submodules of the same module M, then the
     result is the set of ring elements r such that rJ is contained in I.",
     EXAMPLE {
	  "R = ZZ/32003[a..d];",
      	  "J = monomialCurveIdeal(R,{1,4,7})",
      	  "I = ideal(J_1-a^2*J_0,J_2-d*c*J_0)",
      	  "I : J",
	  },
     PARA{},
     "The computation is currently not stored anywhere: this means
     that the computation cannot be continued after an interrupt.
     This will be changed in a later version."
     }
///

TEST "
  -- quotient(Ideal,Ideal)
  -- quotient(Ideal,RingElement)
  -- options to test: DegreeLimit, BasisElementLimit, PairLimit, 
  --    MinimalGenerators,
  --    Strategy=>Iterate, Strategy=>Linear
  R = ZZ/101[a..d]
  I1 = monomialCurveIdeal(R, {1,3,7})
  I2 = ideal((gens I1)_{0,1})
  I3 = quotient(I2,I1)
  I4 = quotient(I2,I3)
  I5 = quotient(I2, c)

  assert(I2 == 
       intersect(I3,I4)
       )
  
  assert(ideal(c,d) ==
       quotient(I2, I5)
       )

  assert(I3 ==
       I2 : I1
       )

--  assert(ideal(d) + I2 ==
--       quotient(I2,I1,DegreeLimit=>1)
--       )

  assert(I3 ==
       quotient(I2,I1,Strategy=>Iterate)
       )
  
  quotient(I2,I1,MinimalGenerators=>false)
--  stderr << \"  -- this fails currently\" << endl
--  assert(I5 ==
--       quotient(I2, c,Strategy=>Linear)
--       )
  
"

TEST "
  -- quotient(Ideal,Ideal)
  -- quotient(Ideal,RingElement)
  -- options to test: DegreeLimit, BasisElementLimit, PairLimit, 
  --    MinimalGenerators,
  --    Strategy=>Iterate, Strategy=>Linear
  R = ZZ/101[vars(0..3)]/(a*d)
  I1 = ideal(a^3, b*d)
  I2 = ideal(I1_0)

  I3 = quotient(I2,I1)
  assert(I3 == ideal(a))
  I4 = quotient(I2,I3)
  assert(I4 == ideal(a^2,d))
  I5 = quotient(I2, d)
  assert(I5 == ideal(a))
"

TEST "
  --    quotient(Module,RingElement)
  --    quotient(Module,Ideal)
  
  -- This tests 'quotmod0' (default)
  R = ZZ/101[vars(0..4)]/e
  m = matrix{{a,c},{b,d}}
  M = subquotient(m_{0}, a^2**m_{0} | a*b**m_{1})
  J = ideal(a)
  Q1 = quotient(M,J)
  
  -- Now try the iterative version
  Q2 = quotient(M,J,Strategy=>Iterate)
  assert(Q1 == Q2)

  m = gens M  
  F = target m
  mm = generators M | relations M
  j = transpose gens J
  g = (j ** F) | (target j ** mm)
  h = syz gb(g, 
	  Strategy=>LongPolynomial,
	  SyzygyRows=>numgens F,
	  Syzygies=>true)
  trim subquotient(h % M.relations, 
             M.relations)
  
"

TEST "
  --    quotient(Module,Module)
  R = ZZ/101[a..d]
  M = image matrix{{a,b},{c,d}}
  N = super M
  I = quotient(M,N)
  assert(I ==
            quotient(M,N,Strategy=>Iterative)
	)
   
  assert(I == 
            M : N
	)
  assert(I ==
            ann(N/M)
	)
"

TEST "
  --    quotient(Module,Module)
  R = ZZ/101[vars(0..14)]
  N = coker genericMatrix(R,a,3,5)
  M = image N_{}
  I = quotient(M,N)
  assert(I ==
            quotient(M,N,Strategy=>Iterative)
	)
   
  assert(I == 
            M : N
	)
  assert(I ==
            ann(N/M)
	)
"

TEST "
  R = ZZ/101[a..d]
  M = coker matrix{{a,b},{c,d}}
  m1 = basis(2,M)
  image m1
  M1 = subquotient(matrix m1, relations M)
  Q1 = M1 : a  
  Q2 = quotient(M1,ideal(a,b,c,d),Strategy=>Iterate)
  assert(Q1 == Q2)
"

TEST "
  R = ZZ/101[a..d]
  mrels = matrix{{a,b},{c,d}}
  mgens = matrix(R,{{1,0},{0,0}})
  M = trim subquotient(mgens, mrels)
  Q1 = quotient(image M_{},a*d-b*c)
  assert(Q1 == super M)  -- fails: bug in == ...
"

TEST ///
-- Test of stopping conditions
R = QQ[a..d]
I = ideal(a^5,b^5,c^5,d^5)
I : (a+b+c+d)
quotient(I, a^2+b^2+c^2+d^2, DegreeLimit=>20)
gbTrace=3
quotient(I, a+b+c+d, BasisElementLimit=>5, MinimalGenerators=>false)
///