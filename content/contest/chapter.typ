= Contest

#include "../build/template.cpp.typ"
#context { let p = counter(page).get().first(); state("kactl-files", ()).update(regs => regs + ((".vimrc", p),)) }
#text(size: 12pt, weight: "bold")[.vimrc]\
#block(width: 100%, above: 3pt, stroke: (top: 0.5pt), inset: (top: 3pt, bottom: 2pt, left: 4pt, right: 4pt))[
  #text(size: 8pt, raw(read(".vimrc"), lang: "vim"))
]
#v(0.5em)
#context { let p = counter(page).get().first(); state("kactl-files", ()).update(regs => regs + (("stress.sh", p),)) }
#text(size: 12pt, weight: "bold")[stress.sh]\
#block(width: 100%, above: 3pt, stroke: (top: 0.5pt), inset: (top: 3pt, bottom: 2pt, left: 4pt, right: 4pt))[
  #text(size: 8pt, raw(read("stress.sh"), lang: "sh"))
]
#v(0.5em)
#context { let p = counter(page).get().first(); state("kactl-files", ()).update(regs => regs + (("troubleshoot.txt", p),)) }
#text(size: 12pt, weight: "bold")[troubleshoot.txt]\
#block(width: 100%, above: 3pt, stroke: (top: 0.5pt), inset: (top: 3pt, bottom: 2pt, left: 4pt, right: 4pt))[
  #text(size: 8pt, raw(read("troubleshoot.txt"), lang: "raw"))
]
#v(0.5em)