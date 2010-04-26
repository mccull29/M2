-- Test of basic Hilbert series

R = ZZ/101[a..d]
I = monomialIdeal"a2,ac3,b4d,d8"
hf = poincare I
T = (ring hf)_0
assert(hf == poly"1-T2-T4+T7-T8+T9+2T12-T13-T14-T16+T17")
assert(poincare res I == poincare I)

R = ZZ/32003[{x1, x2, x3, x4, x5, x6, x7, x8, x9, x10}];

I1 = monomialIdeal(
 x1^4*x2^4*x3^3*x4^6*x5^2*x6*x7^6*x8^3*x9^4*x10^3,
 x1^7*x2^5*x3^8*x4^5*x5^5*x6^2*x7^7*x8^8*x9^6*x10^8,
 x1^5*x2^8*x3^2*x4^2*x5^8*x6^4*x7^8*x8^4*x9^2*x10^4,
 x1^6*x2^2*x3^5*x4^8*x5^4*x6^8*x7*x8^7*x9^3*x10^5,
 x1^2*x2^3*x3*x4^4*x5^7*x6^5*x7^5*x8^6*x9^7*x10,
 x1^3*x2^7*x3^7*x4^7*x5^3*x6^3*x7^3*x8^5*x9*x10^2,
 x1^8*x2^6*x3^6*x4^3*x5*x6^6*x7^2*x8^2*x9^8*x10^7,
 x1*x2*x3^4*x4*x5^6*x6^7*x7^4*x8*x9^5*x10^6
);
time assert(poincare res I1 == poincare I1)

I2 = monomialIdeal(
 x1^453*x2^174*x3^631*x4^265*x5^151*x6^967*x7^281*x8^409*x9^72*x10^178,
 x1^947*x2^748*x3^482*x4^819*x5^217*x6^986*x7^875*x8^605*x9^828*x10^329,
 x1^777*x2^128*x3^83*x4^890*x5^441*x6^986*x7^328*x8^270*x9^85*x10^952,
 x1^788*x2^216*x3^987*x4^785*x5^981*x6^308*x7^748*x8^289*x9^164*x10^124,
 x1^254*x2^85*x3^473*x4^861*x5^479*x6^736*x7^473*x8^715*x9^33*x10^171,
 x1^289*x2^274*x3^914*x4^433*x5^302*x6^461*x7^337*x8^220*x9^42*x10^376,
 x1^969*x2^258*x3^244*x4^21*x5^561*x6^404*x7^200*x8^821*x9^820*x10^365,
 x1^245*x2^200*x3^59*x4^844*x5^674*x6^643*x7^80*x8^468*x9^477*x10^105
);
assert(time poincare res I2 == time poincare I2)