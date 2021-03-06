cyclicRoots = (n,kk) -> (
           R := kk[vars(0..n-1)];
           ideal apply(1..n-1, d-> sum(0..n-1, i -> product(d, k -> R_((i+k)%n)))) 
             + ideal(product gens R - 1))
I = cyclicRoots(7,CC)	 
end
load "cyclic7.m2"
needsPackage "PHCpack"
mixedVolume I_* -- fails
