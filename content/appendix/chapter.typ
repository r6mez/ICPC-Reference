// Appendix: reset numbering to A, B, C...
#context state("_appendix-mode", false).update(true)
#counter(heading).update(0)
#set heading(numbering: "A.1.1")
#colbreak()

= Techniques

#context { let p = counter(page).get().first(); state("kactl-files", ()).update(regs => regs + (("techniques.txt", p),)) }
#text(size: 12pt, weight: "bold")[techniques.txt]\
#block(width: 100%, above: 3pt, stroke: (top: 0.5pt), inset: (top: 3pt, bottom: 2pt, left: 4pt, right: 4pt))[
  #text(size: 8pt, raw(read("techniques.txt"), lang: "raw"))
]
#v(0.5em)