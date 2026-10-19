#import "comum.typ": *
#set page(width: 210mm, height: 297mm, margin: 0pt, fill: creme)
#set text(font: "Libertinus Serif", lang: "pt")
#pecas(laranja.lighten(55%))

#place(top + center, dy: 30mm, block(width: 165mm, align(center)[
  #text(12pt, tracking: 2pt, fill: verde.lighten(10%), upper[Produto educacional])
  #v(6mm)
  #text(44pt, weight: "bold", fill: verde)[SPAECE Games]
  #v(4mm)
  #line(length: 60mm, stroke: 1.5pt + laranja)
  #v(4mm)
  #text(15pt, fill: marrom.lighten(25%))[Jogos concretos de baixo custo alinhados \ aos descritores de matemática do SPAECE]
]))

#place(top + center, dy: 122mm,
  box(stroke: 0.8pt + luma(205), inset: 3mm, fill: white,
    image("mosaico.jpg", width: 150mm)))

#place(bottom + center, dy: -26mm, block(width: 165mm, align(center)[
  #text(14pt, fill: marrom)[Anna Beatriz Bezerra Rodrigues Alves]
  #v(2mm)
  #text(11pt, fill: marrom.lighten(35%))[PROFMAT · Universidade Federal do Cariri · 2025]
]))
