// Standalone test-session document (not part of main kactl.pdf)
// Ported from test-session.tex

#set page(paper: "a4", margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm))
#set text(font: ("New Computer Modern", "TeX Gyre Cursor"), size: 9pt)
#set heading(numbering: "1.1.1")

// Page 1: single-column chapter content
#page[
  #include "chapter.typ"
]

// Page 2+: empty problem-tracking table (to fill in during contest)
#page[
  #table(
    columns: (auto, 1fr, auto, auto, 2fr),
    fill: none,
    stroke: 0.5pt,
    rows: (1.5em,) * 20,
    table.hline(stroke: 1pt),
    table.header(
      table.hline(stroke: 1pt),
      [*Problem*], [*Topics*], [*Difficulty*], [*Solver*], [*Notes*],
      table.hline(stroke: 1pt),
    ),
    [A], [], [], [], [], table.hline(),
    [B], [], [], [], [], table.hline(),
    [C], [], [], [], [], table.hline(),
    [D], [], [], [], [], table.hline(),
    [E], [], [], [], [], table.hline(),
    [F], [], [], [], [], table.hline(),
    [G], [], [], [], [], table.hline(),
    [H], [], [], [], [], table.hline(),
    [I], [], [], [], [], table.hline(),
    [J], [], [], [], [], table.hline(),
    [K], [], [], [], [], table.hline(),
    [L], [], [], [], [], table.hline(),
    [M], [], [], [], [], table.hline(),
    [N], [], [], [], [], table.hline(),
    [O], [], [], [], [], table.hline(),
    [P], [], [], [], [], table.hline(),
    [Q], [], [], [], [], table.hline(),
    table.hline(stroke: 1pt),
  )
]
