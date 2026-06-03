= Various
// 
// == Intervals
// #include "../build/IntervalContainer.h.typ"
// #include "../build/IntervalCover.h.typ"
// #include "../build/ConstantIntervals.h.typ"

== Misc. algorithms
	#include "../build/TernarySearch.h.typ"
	#include "../build/LIS.h.typ"
	#include "../build/FastKnapsack.h.typ"

== Dynamic programming
// #include "../build/KnuthDP.h.typ"
	#include "../build/DivideAndConquerDP.h.typ"

== Debugging tricks
	- `signal(SIGSEGV, [](int) { _Exit(0); });` converts segfaults into Wrong Answers.
Similarly one can catch SIGABRT (assertion failures) and SIGFPE (zero divisions).
`_GLIBCXX_DEBUG` failures generate SIGABRT (or SIGSEGV on gcc 5.4.0 apparently).
- `feenableexcept(29);` kills the program on NaNs (`1`), 0-divs (`4`), infinities (`8`) and denormals (`16`).

== Optimization tricks
	`__builtin_ia32_ldmxcsr(40896);` disables denormals (which make floats 20x slower near their minimum value).
	=== Bit hacks
		- `x & -x` is the least bit in `x`.
- `for (int x = m; x; ) { --x &= m; ... }` loops over all subset masks of `m` (except `m` itself).
- `c = x&-x, r = x+c; (((r^x) >> 2)/c) | r` is the next number after `x` with the same number of bits set.
- `rep(b,0,K) rep(i,0,(1 << K))`  \
 `  if (i & 1 << b) D[i] += D[i^(1 << b)];` computes all sums of subsets.
	=== Pragmas
		- `\#pragma GCC optimize ("Ofast")` will make GCC auto-vectorize loops and optimizes floating points better.
- `\#pragma GCC target ("avx2")` can double performance of vectorized code, but causes crashes on old machines.
- `\#pragma GCC optimize ("trapv")` kills the program on integer overflows (but is really slow).
	#include "../build/FastMod.h.typ"
// #include "../build/FastInput.h.typ"
// #include "../build/BumpAllocator.h.typ"
// #include "../build/SmallPtr.h.typ"
// #include "../build/BumpAllocatorSTL.h.typ"
// #include "../build/Unrolling.h.typ"
// #include "../build/SIMD.h.typ"
