// Elementos comuns à capa e ao fundo das páginas do PDF.
// Cores tiradas das miniaturas dos jogos.
#let creme = rgb("#FBF3E2")
#let laranja = rgb("#E3872D")
#let verde = rgb("#1F6F66")
#let marrom = rgb("#3B2A1A")

// Peças de jogo em contorno: um dado, um triângulo e uma carta.
#let dado(x, y, s: 14mm, cor: luma(215)) = place(top + left, dx: x, dy: y, {
  rect(width: s, height: s, radius: 2mm, stroke: 1.2pt + cor)
  for (cx, cy) in ((0.25, 0.25), (0.75, 0.75), (0.5, 0.5), (0.75, 0.25), (0.25, 0.75)) {
    place(top + left, dx: cx * s - 1.2mm, dy: cy * s - 1.2mm, circle(radius: 1.2mm, fill: cor))
  }
})
#let triangulo(x, y, s: 16mm, cor: luma(215)) = place(top + left, dx: x, dy: y,
  polygon(stroke: 1.2pt + cor, (0pt, s), (s, s), (s / 2, 0pt)))
#let carta(x, y, cor: luma(215)) = place(top + left, dx: x, dy: y,
  rotate(12deg, rect(width: 11mm, height: 16mm, radius: 1.5mm, stroke: 1.2pt + cor)))
#let pecas(cor) = {
  dado(12mm, 10mm, cor: cor)
  triangulo(180mm, 10mm, cor: cor)
  carta(12mm, 276mm, cor: cor)
  dado(186mm, 282mm, s: 10mm, cor: cor)
}
