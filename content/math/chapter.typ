#import "@preview/mitex:0.2.7": mi, mitex
// Written by Anders Sjoqvist and Ulf Lundstrom, 2009
// The main sources are: tinyKACTL, Beta and Wikipedia

= Mathematics

== Equations
#mitex(`ax^2+bx+c=0 \Rightarrow x = \frac{-b\pm\sqrt{b^2-4ac}}{2a}`)

The extremum is given by #mi(`x = -b/2a`).

#mitex(`\begin{aligned}ax+by=e\\cx+dy=f\end{aligned}
\Rightarrow
\begin{aligned}x=\dfrac{ed-bf}{ad-bc}\\y=\dfrac{af-ec}{ad-bc}\end{aligned}`)

In general, given an equation #mi(`Ax = b`), the solution to a variable #mi(`x_i`) is given by
#mitex(`x_i = \frac{\det A_i'}{\det A}`)
where #mi(`A_i'`) is #mi(`A`) with the #mi(`i`)'th column replaced by #mi(`b`).

== Recurrences
If #mi(`a_n = c_1 a_{n-1} + \dots + c_k a_{n-k}`), and #mi(`r_1, \dots, r_k`) are distinct roots of #mi(`x^k - c_1 x^{k-1} - \dots - c_k`), there are #mi(`d_1, \dots, d_k`) s.t.
#mitex(`a_n = d_1r_1^n + \dots + d_kr_k^n.`)
Non-distinct roots #mi(`r`) become polynomial factors, e.g. #mi(`a_n = (d_1n + d_2)r^n`).

== Trigonometry
#mitex(`\begin{aligned}
\sin(v+w)&{}=\sin v\cos w+\cos v\sin w\\
\cos(v+w)&{}=\cos v\cos w-\sin v\sin w\\
\end{aligned}`)
#mitex(`\begin{aligned}
\tan(v+w)&{}=\dfrac{\tan v+\tan w}{1-\tan v\tan w}\\
\sin v+\sin w&{}=2\sin\dfrac{v+w}{2}\cos\dfrac{v-w}{2}\\
\cos v+\cos w&{}=2\cos\dfrac{v+w}{2}\cos\dfrac{v-w}{2}
\end{aligned}`)
#mitex(`(V+W)\tan(v-w)/2{}=(V-W)\tan(v+w)/2`)
where #mi(`V, W`) are lengths of sides opposite angles #mi(`v, w`).
#mitex(`\begin{aligned}
	a\cos x+b\sin x&=r\cos(x-\phi)\\
	a\sin x+b\cos x&=r\sin(x+\phi)
\end{aligned}`)
where #mi(`r=\sqrt{a^2+b^2}, \phi=\operatorname{atan2}(b,a)`).

== Geometry

// Tiny figure helpers: coordinates in mm, y grows downward.
#let seg(p, q, ..args) = place(line(start: (p.at(0) * 1mm, p.at(1) * 1mm), end: (q.at(0) * 1mm, q.at(1) * 1mm), stroke: 0.4pt, ..args))
#let dseg(p, q) = seg(p, q, stroke: (thickness: 0.4pt, dash: "dashed"))
#let pt(p) = place(dx: p.at(0) * 1mm - 0.4mm, dy: p.at(1) * 1mm - 0.4mm, circle(radius: 0.4mm, fill: black))
#let lbl(p, body) = place(dx: p.at(0) * 1mm, dy: p.at(1) * 1mm, text(size: 7pt, body))
#let ring(c, r) = place(dx: (c.at(0) - r) * 1mm, dy: (c.at(1) - r) * 1mm, circle(radius: r * 1mm, stroke: 0.4pt))
#let fig(w, h, body) = align(center, box(width: w * 1mm, height: h * 1mm, body))
// Shared triangle: A=(2,15), B=(26,15), C=(9,2)
#let triangle = seg((2, 15), (26, 15)) + seg((26, 15), (9, 2)) + seg((9, 2), (2, 15))

=== Triangles
Side lengths: #mi(`a,b,c`) \
Semiperimeter: #mi(`p=\dfrac{a+b+c}{2}`) \
Area: #mi(`A=\sqrt{p(p-a)(p-b)(p-c)}`) \
Circumradius: #mi(`R=\dfrac{abc}{4A}`) \
#fig(28, 26, triangle + ring((14, 13.08), 12.15) + pt((14, 13.08)) + seg((14, 13.08), (26, 15)) + lbl((13, 13.8), [$O$]) + lbl((19, 10.9), [$R$]))
Inradius: #mi(`r=\dfrac{A}{p}`) \
#fig(28, 16, triangle + ring((10.68, 9.81), 5.19) + pt((10.68, 9.81)) + seg((10.68, 9.81), (10.68, 15)) + lbl((11.4, 10.6), [$r$]))
Length of median (divides triangle into two equal-area triangles): #mi(`m_a=\tfrac{1}{2}\sqrt{2b^2+2c^2-a^2}`) \
Length of bisector (halves the angle, *not* side #mi(`a`), which it splits in ratio #mi(`c:b`)): #mi(`s_a=\sqrt{bc\left[1-\left(\dfrac{a}{b+c}\right)^2\right]}`) \
// Wide angle at A=(11,2); bisector foot D=(12.9,13.09) splits a in ratio c:b
#fig(28, 17, seg((11, 2), (2, 14)) + seg((2, 14), (26, 12)) + seg((26, 12), (11, 2)) + dseg((11, 2), (12.9, 13.09)) + pt((12.9, 13.09)) + lbl((13.8, 10.8), [$s_a$]) + lbl((7, 7.6), [$alpha \/ 2$]) + lbl((13.2, 7), [$alpha \/ 2$]) + lbl((16.5, 13.1), [$a$]) + lbl((19.8, 4.6), [$b$]) + lbl((3.8, 7.4), [$c$]) + lbl((9, 0.4), [$A$]))
Law of sines: #mi(`\dfrac{\sin\alpha}{a}=\dfrac{\sin\beta}{b}=\dfrac{\sin\gamma}{c}=\dfrac{1}{2R}`) \
Law of cosines: #mi(`a^2=b^2+c^2-2bc\cos\alpha`) \
Law of tangents: #mi(`\dfrac{a+b}{a-b}=\dfrac{\tan\dfrac{\alpha+\beta}{2}}{\tan\dfrac{\alpha-\beta}{2}}`) \
=== Quadrilaterals
With side lengths #mi(`a,b,c,d`), diagonals #mi(`e, f`), diagonals angle #mi(`\theta`), area #mi(`A`) and
magic flux #mi(`F=b^2+d^2-a^2-c^2`):

#mitex(`4A = 2ef \cdot \sin\theta = F\tan\theta = \sqrt{4e^2f^2-F^2}`)

#fig(26, 16, seg((1, 13), (21, 15)) + seg((21, 15), (25, 2)) + seg((25, 2), (6, 1)) + seg((6, 1), (1, 13)) + dseg((1, 13), (25, 2)) + dseg((21, 15), (6, 1)) + lbl((10.5, 14.6), [$a$]) + lbl((23.8, 8.2), [$b$]) + lbl((15, 2.1), [$c$]) + lbl((0.6, 6), [$d$]) + lbl((5.6, 9.6), [$e$]) + lbl((17, 10.6), [$f$]) + lbl((12.5, 4.6), [$theta$]))

 For cyclic quadrilaterals the sum of opposite angles is #mi(`180^\circ`),
#mi(`ef = ac + bd`), and #mi(`A = \sqrt{(p-a)(p-b)(p-c)(p-d)}`).

=== Spherical coordinates
#align(center)[
#image("sphericalCoordinates.pdf", width: 25mm)
]
#mitex(`\begin{array}{cc}
x = r\sin\theta\cos\phi & r = \sqrt{x^2+y^2+z^2}\\
y = r\sin\theta\sin\phi & \theta = \textrm{acos}(z/\sqrt{x^2+y^2+z^2})\\
z = r\cos\theta & \phi = \textrm{atan2}(y,x)
\end{array}`)
// 
// == Derivatives/Integrals
// #mitex(`\begin{aligned}
// \dfrac{d}{dx}\arcsin x = \dfrac{1}{\sqrt{1-x^2}} &&& \dfrac{d}{dx}\arccos x = -\dfrac{1}{\sqrt{1-x^2}} \\
// \dfrac{d}{dx}\tan x = 1+\tan^2 x &&& \dfrac{d}{dx}\arctan x = \dfrac{1}{1+x^2} \\
// \int\tan ax = -\dfrac{\ln|\cos ax|}{a} &&& \int x\sin ax = \dfrac{\sin ax-ax \cos ax}{a^2} \\
// \int e^{-x^2} = \frac{\sqrt \pi}{2} \text{erf}(x) &&& \int xe^{ax}dx = \frac{e^{ax}}{a^2}(ax-1)
// \end{aligned}`)
// 
// Integration by parts:
// #mitex(`\int_a^bf(x)g(x)dx = [F(x)g(x)]_a^b-\int_a^bF(x)g'(x)dx`)
// 
== Sums
#mitex(`c^a + c^{a+1} + \dots + c^{b} = \frac{c^{b+1} - c^a}{c-1}, c \neq 1`)
#mitex(`\begin{aligned}
	1 + 2 + 3 + \dots + n &= \frac{n(n+1)}{2} \\
	1^2 + 2^2 + 3^2 + \dots + n^2 &= \frac{n(2n+1)(n+1)}{6} \\
	1^3 + 2^3 + 3^3 + \dots + n^3 &= \frac{n^2(n+1)^2}{4} \\
	1^4 + 2^4 + 3^4 + \dots + n^4 &= \frac{n(n+1)(2n+1)(3n^2 + 3n - 1)}{30} \\
\end{aligned}`)

== Series
#mitex(`e^x = 1+x+\frac{x^2}{2!}+\frac{x^3}{3!}+\dots,\,(-\infty<x<\infty)`)
#mitex(`\ln(1+x) = x-\frac{x^2}{2}+\frac{x^3}{3}-\frac{x^4}{4}+\dots,\,(-1<x\leq1)`)
#mitex(`\sqrt{1+x} = 1+\frac{x}{2}-\frac{x^2}{8}+\frac{2x^3}{32}-\frac{5x^4}{128}+\dots,\,(-1\leq x\leq1)`)
#mitex(`\sin x = x-\frac{x^3}{3!}+\frac{x^5}{5!}-\frac{x^7}{7!}+\dots,\,(-\infty<x<\infty)`)
#mitex(`\cos x = 1-\frac{x^2}{2!}+\frac{x^4}{4!}-\frac{x^6}{6!}+\dots,\,(-\infty<x<\infty)`)

== Probability theory
Let #mi(`X`) be a discrete random variable with probability #mi(`p_X(x)`) of assuming the value #mi(`x`). It will then have an expected value (mean) #mi(`\mu=\mathbb{E}(X)=\sum_xxp_X(x)`) and variance #mi(`\sigma^2=V(X)=\mathbb{E}(X^2)-(\mathbb{E}(X))^2=\sum_x(x-\mathbb{E}(X))^2p_X(x)`) where #mi(`\sigma`) is the standard deviation. If #mi(`X`) is instead continuous it will have a probability density function #mi(`f_X(x)`) and the sums above will instead be integrals with #mi(`p_X(x)`) replaced by #mi(`f_X(x)`).

Expectation is linear:
#mitex(`\mathbb{E}(aX+bY) = a\mathbb{E}(X)+b\mathbb{E}(Y)`)
For independent #mi(`X`) and #mi(`Y`), #mitex(`V(aX+bY) = a^2V(X)+b^2V(Y).`)

=== Discrete distributions

==== Binomial distribution
The number of successes in #mi(`n`) independent yes/no experiments, each which yields success with probability #mi(`p`) is #mi(`\textrm{Bin}(n,p),\,n=1,2,\dots,\, 0\leq p\leq1`).
#mitex(`p(k)=\binom{n}{k}p^k(1-p)^{n-k}`)
#mitex(`\mu = np,\,\sigma^2=np(1-p)`)
#mi(`\textrm{Bin}(n,p)`) is approximately #mi(`\textrm{Po}(np)`) for small #mi(`p`).

==== First success distribution
The number of trials needed to get the first success in independent yes/no experiments, each which yields success with probability #mi(`p`) is #mi(`\textrm{Fs}(p),\,0\leq p\leq1`).
#mitex(`p(k)=p(1-p)^{k-1},\,k=1,2,\dots`)
#mitex(`\mu = \frac1p,\,\sigma^2=\frac{1-p}{p^2}`)

==== Poisson distribution
The number of events occurring in a fixed period of time #mi(`t`) if these events occur with a known average rate #mi(`\kappa`) and independently of the time since the last event is #mi(`\textrm{Po}(\lambda),\,\lambda=t\kappa`).
#mitex(`p(k)=e^{-\lambda}\frac{\lambda^k}{k!}, k=0,1,2,\dots`)
#mitex(`\mu=\lambda,\,\sigma^2=\lambda`)

=== Continuous distributions

==== Uniform distribution
If the probability density function is constant between #mi(`a`) and #mi(`b`) and 0 elsewhere it is #mi(`\textrm{U}(a,b),\,a<b`).
#mitex(`f(x) = \left\{
\begin{array}{cl}
\frac{1}{b-a} & a<x<b\\
0 & \textrm{otherwise}
\end{array}\right.`)
#mitex(`\mu=\frac{a+b}{2},\,\sigma^2=\frac{(b-a)^2}{12}`)

==== Exponential distribution
The time between events in a Poisson process is #mi(`\textrm{Exp}(\lambda),\,\lambda>0`).
#mitex(`f(x) = \left\{
\begin{array}{cl}
\lambda e^{-\lambda x} & x\geq0\\
0 & x<0
\end{array}\right.`)
#mitex(`\mu=\frac{1}{\lambda},\,\sigma^2=\frac{1}{\lambda^2}`)

==== Normal distribution
Most real random values with mean #mi(`\mu`) and variance #mi(`\sigma^2`) are well described by #mi(`\mathcal{N}(\mu,\sigma^2),\,\sigma>0`).
#mitex(`f(x) = \frac{1}{\sqrt{2\pi\sigma^2}}e^{-\frac{(x-\mu)^2}{2\sigma^2}}`)
If #mi(`X_1 \sim \mathcal{N}(\mu_1,\sigma_1^2)`) and #mi(`X_2 \sim \mathcal{N}(\mu_2,\sigma_2^2)`) then
#mitex(`aX_1 + bX_2 + c \sim \mathcal{N}(\mu_1+\mu_2+c,a^2\sigma_1^2+b^2\sigma_2^2)`)

// == Markov chains
// A _Markov chain_ is a discrete random process with the property that the next state depends only on the current state.
// Let #mi(`X_1,X_2,\ldots`) be a sequence of random variables generated by the Markov process.
// Then there is a transition matrix #mi(`\mathbf{P} = (p_{ij})`), with #mi(`p_{ij} = \Pr(X_n = i | X_{n-1} = j)`),
// and #mi(`\mathbf{p}^{(n)} = \mathbf P^n \mathbf p^{(0)}`) is the probability distribution for #mi(`X_n`) (i.e., #mi(`p^{(n)}_i = \Pr(X_n = i)`)),
// where #mi(`\mathbf{p}^{(0)}`) is the initial distribution.
// 
// ==== Stationary distribution
// #mi(`\mathbf{\pi}`) is a stationary distribution if #mi(`\mathbf{\pi} = \mathbf{\pi P}`).
// If the Markov chain is _irreducible_ (it is possible to get to any state from any state),
// then #mi(`\pi_i = \frac{1}{\mathbb{E}(T_i)}`) where #mi(`\mathbb{E}(T_i)`)  is the expected time between two visits in state #mi(`i`).
// #mi(`\pi_j/\pi_i`) is the expected number of visits in state #mi(`j`) between two visits in state #mi(`i`).
// 
// For a connected, undirected and non-bipartite graph, where the transition probability is uniform among all neighbors, #mi(`\pi_i`) is proportional to node #mi(`i`)'s degree.
// 
// ==== Ergodicity
// A Markov chain is _ergodic_ if the asymptotic distribution is independent of the initial distribution.
// A finite Markov chain is ergodic iff it is irreducible and _aperiodic_ (i.e., the gcd of cycle lengths is 1).
// #mi(`\lim_{k\rightarrow\infty}\mathbf{P}^k = \mathbf{1}\pi`).
// 
// ==== Absorption
// A Markov chain is an A-chain if the states can be partitioned into two sets #mi(`\mathbf{A}`) and #mi(`\mathbf{G}`), such that all states in #mi(`\mathbf{A}`) are absorbing (#mi(`p_{ii}=1`)), and all states in #mi(`\mathbf{G}`) leads to an absorbing state in #mi(`\mathbf{A}`).
// The probability for absorption in state #mi(`i\in\mathbf{A}`), when the initial state is #mi(`j`), is #mi(`a_{ij} = p_{ij}+\sum_{k\in\mathbf{G}} a_{ik}p_{kj}`).
// The expected time until absorption, when the initial state is #mi(`i`), is #mi(`t_i = 1+\sum_{k\in\mathbf{G}}p_{ki}t_k`).
