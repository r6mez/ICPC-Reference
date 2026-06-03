#import "@preview/mitex:0.2.7": mi, mitex
= Combinatorial

== Permutations
	=== Factorial
		#align(center)[
			#table(columns: (auto,) * 11, align: center, stroke: none,
				[$n$], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10],
				table.hline(stroke: 0.5pt),
				[$n!$], [1], [2], [6], [24], [120], [720], [5040], [40320], [362880], [3628800],
			)
			#v(0.3em)
			#table(columns: (auto,) * 8, align: center, stroke: none,
				[$n$], [11], [12], [13], [14], [15], [16], [17],
				table.hline(stroke: 0.5pt),
				[$n!$], [4.0e7], [4.8e8], [6.2e9], [8.7e10], [1.3e12], [2.1e13], [3.6e14],
			)
			#v(0.3em)
			#table(columns: (auto,) * 9, align: center, stroke: none,
				[$n$], [20], [25], [30], [40], [50], [100], [150], [171],
				table.hline(stroke: 0.5pt),
				[$n!$], [2e18], [2e25], [3e32], [8e47], [3e64], [9e157], [6e262], [$>$ DBL_MAX],
			)
		]
		#include "../build/IntPerm.h.typ"

	=== Derangements
		Permutations of a set such that none of the elements appear in their original position.
		#mitex(`\mkern-2mu D(n) = (n-1)(D(n-1)+D(n-2)) = n D(n-1)+(-1)^n = \left\lfloor\frac{n!}{e}\right\rceil`)

== Partitions and subsets
	=== Partition function
		Number of ways of writing #mi(`n`) as a sum of positive integers, disregarding the order of the summands.
		#mitex(`p(0) = 1,\ p(n) = \sum_{k \in \mathbb Z \setminus \{0\}}{(-1)^{k+1} p(n - k(3k-1) / 2)}`)
		#mitex(`p(n) \sim 0.145 / n \cdot \exp(2.56 \sqrt{n})`)

		#align(center)[
#table(
  columns: 14,
  align: center,
  stroke: none,
  [$n$], [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [20], [50], [100],
  table.vline(stroke: 0.5pt),
  [#mi(`p(n)`)], [1], [1], [2], [3], [5], [7], [11], [15], [22], [30], [627], [2e5], [2e8],
)
]
	=== Binomials
		#include "../build/multinomial.h.typ"

== General purpose numbers
	=== Bernoulli numbers
		EGF of Bernoulli numbers is #mi(`B(t)=\frac{t}{e^t-1}`) (FFT-able).
		#mi(`B[0,\ldots] = [1, -\frac{1}{2}, \frac{1}{6}, 0, -\frac{1}{30}, 0, \frac{1}{42}, \ldots]`)

		Sums of powers:
		
		#mitex(`\sum_{i=1}^n n^m = \frac{1}{m+1} \sum_{k=0}^m \binom{m+1}{k} B_k \cdot (n+1)^{m+1-k}`)
		

		Euler-Maclaurin formula for infinite sums:
		
		#mitex(`\sum_{i=m}^{\infty} f(i) = \int_m^\infty f(x) dx - \sum_{k=1}^\infty \frac{B_k}{k!}f^{(k-1)}(m)`)
		#mitex(`\approx \int_{m}^\infty f(x)dx + \frac{f(m)}{2} - \frac{f'(m)}{12} + \frac{f'''(m)}{720} + O(f^{(5)}(m))`)
		

	=== Stirling numbers of the first kind
		Number of permutations on #mi(`n`) items with #mi(`k`) cycles.
		#mitex(`\begin{aligned}
			&c(n,k) = c(n-1,k-1) + (n-1) c(n-1,k),\ c(0,0) = 1 \\
			&\textstyle \sum_{k=0}^n c(n,k)x^k = x(x+1) \dots (x+n-1)
		\end{aligned}`)
		#mi(`c(8,k) = 8, 0, 5040, 13068, 13132, 6769, 1960, 322, 28, 1`)  \
		#mi(`c(n,2) = 0, 0, 1, 3, 11, 50, 274, 1764, 13068, 109584, \dots`)

	=== Eulerian numbers
		Number of permutations #mi(`\pi \in S_n`) in which exactly #mi(`k`) elements are greater than the previous element. #mi(`k`) #mi(`j`):s s.t. #mi(`\pi(j)>\pi(j+1)`), #mi(`k+1`) #mi(`j`):s s.t. #mi(`\pi(j)\geq j`), #mi(`k`) #mi(`j`):s s.t. #mi(`\pi(j)>j`).
		#mitex(`E(n,k) = (n-k)E(n-1,k-1) + (k+1)E(n-1,k)`)
		#mitex(`E(n,0) = E(n,n-1) = 1`)
		#mitex(`E(n,k) = \sum_{j=0}^k(-1)^j\binom{n+1}{j}(k+1-j)^n`)

	=== Stirling numbers of the second kind
		Partitions of #mi(`n`) distinct elements into exactly #mi(`k`) groups.
		#mitex(`S(n,k) = S(n-1,k-1) + k S(n-1,k)`)
		#mitex(`S(n,1) = S(n,n) = 1`)
		#mitex(`S(n,k) = \frac{1}{k!}\sum_{j=0}^k (-1)^{k-j}\binom{k}{j}j^n`)

	=== Bell numbers
		Total number of partitions of #mi(`n`) distinct elements. #mi(`B(n) =`)
		#mi(`1, 1, 2, 5, 15, 52, 203, 877, 4140, 21147, \dots`). For #mi(`p`) prime,
		#mitex(`B(p^m+n)\equiv mB(n)+B(n+1) \pmod{p}`)

	=== Catalan numbers
		#mitex(`C_n=\frac{1}{n+1}\binom{2n}{n}= \binom{2n}{n}-\binom{2n}{n+1} = \frac{(2n)!}{(n+1)!n!}`)
		#mitex(`C_0=1,\ C_{n+1} = \frac{2(2n+1)}{n+2}C_n,\ C_{n+1}=\sum C_iC_{n-i}`)
		#mi(`{C_n = 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, \dots}`)
		- sub-diagonal monotone paths in an #mi(`n\times n`) grid.
		- strings with #mi(`n`) pairs of parenthesis, correctly nested.
		- binary trees with with #mi(`n+1`) leaves (0 or 2 children).
		- ordered trees with #mi(`n+1`) vertices.
		- ways a convex polygon with #mi(`n+2`) sides can be cut into triangles by connecting vertices with straight lines.
		- permutations of #mi(`[n]`) with no 3-term increasing subseq.
