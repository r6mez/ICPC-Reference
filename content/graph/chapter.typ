#import "@preview/mitex:0.2.7": mi, mitex
= Graph

== Fundamentals
	#include "../build/dfs.cpp.typ"
	#include "../build/bfs.cpp.typ"

== Paths
	#include "../build/dijkstra.cpp.typ"
	#include "../build/dijkstraK.cpp.typ"
	#include "../build/BellmanFord.h.typ"
	#include "../build/floyedWarshall.cpp.typ"
	#include "../build/TopologicalSort.cpp.typ"
	#include "../build/DAGLongestPathDP.cpp.typ"

== Cycles
	#include "../build/CountCyclesDFS.cpp.typ"
	#include "../build/findingACycleInGraph.cpp.typ"
	
== Componenets
	#include "../build/ConnectedComponenetsBFS.cpp.typ"
	#include "../build/BiconnectedComponents.h.typ"

// == Network flow
// #include "../build/PushRelabel.h.typ"
// #include "../build/MinCostMaxFlow.h.typ"
// #include "../build/EdmondsKarp.h.typ"
// #include "../build/Dinic.h.typ"
// #include "../build/MinCut.h.typ"
// #include "../build/GlobalMinCut.h.typ"
// #include "../build/GomoryHu.h.typ"

// == Matching
// #include "../build/hopcroftKarp.h.typ"
// #include "../build/DFSMatching.h.typ"
// #include "../build/MinimumVertexCover.h.typ"
// #include "../build/WeightedMatching.h.typ"
// #include "../build/GeneralMatching.h.typ"

== DFS algorithms
	#include "../build/SCC.h.typ"
	#include "../build/EulerWalk.h.typ"
// #include "../build/2sat.h.typ"

// == Coloring
// #include "../build/EdgeColoring.h.typ"

// == Heuristics
// #include "../build/MaximalCliques.h.typ"
// #include "../build/MaximumClique.h.typ"
// #include "../build/MaximumIndependentSet.h.typ"

== Trees
	#include "../build/TreeDiameter.cpp.typ"
	#include "../build/LCAAndKthAncestor.h.typ"
	#include "../build/KruskalMST.cpp.typ"
// #include "../build/CompressTree.h.typ"
// #include "../build/HLD.h.typ"
// #include "../build/LinkCutTree.h.typ"
// #include "../build/DirectedMST.h.typ"

== Math
	=== Number of Spanning Trees
// I.e. matrix-tree theorem.
// Source: https://en.wikipedia.org/wiki/Kirchhoff%27s_theorem
// Test: stress-tests/graph/matrix-tree.cpp
		Create an #mi(`N\times N`) matrix `mat`, and for each edge #mi(`a \rightarrow b \in G`), do
		`mat[a][b]--, mat[b][b]++` (and `mat[b][a]--, mat[a][a]++` if #mi(`G`) is undirected).
		Remove the #mi(`i`)th row and column and take the determinant; this yields the number of directed spanning trees rooted at #mi(`i`)
		(if #mi(`G`) is undirected, remove any row/column).

	=== Erdős–Gallai theorem
// Source: https://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93Gallai_theorem
// Test: stress-tests/graph/erdos-gallai.cpp
		A simple graph with node degrees #mi(`d_1 \ge \dots \ge d_n`) exists iff #mi(`d_1 + \dots + d_n`) is even and for every #mi(`k = 1\dots n`),
		#mitex(`\sum _{i=1}^{k}d_{i}\leq k(k-1)+\sum _{i=k+1}^{n}\min(d_{i},k).`)
