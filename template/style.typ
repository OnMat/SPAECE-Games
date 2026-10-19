// Estilo do PDF do SPAECE Games.
// Derivado do plain_typst_book (https://github.com/myst-templates/plain_typst_book, MIT),
// traduzido para o português e com capa institucional (UFCA/PROFMAT).

#let template(
  // CAPA
  title: "Título",
  subtitle: none,
  authors: none,
  advisor: none,
  institution: none,
  program: none,
  place: none,
  year: none,
  logo: none,
  cover: none,
  cover_width: 14cm,

  // SUMÁRIO
  ToC_depth: 2,
  show_ToC: true,

  // LINKS: arquivos locais (anexos, ZIPs) apontam para o site publicado
  site_url: none,

  // PÁGINA
  paper-size: "a4",
  margin_top: 2.5cm,
  margin_bottom: 2.5cm,
  margin_left: 12%,
  margin_right: 12%,
  show_pagenumber: true,
  font: "Libertinus Serif",
  fontsize: 11pt,
  linespacing: 0.65em,
  justification: true,
  theme: rgb("#1f6f66"),
  colorheadings: rgb("#1f6f66"),

  body,
) = {
  set document(title: title)
  set text(lang: "pt", region: "br", font: font, size: fontsize)
  set par(leading: linespacing, justify: justification)
  set page(
    paper: paper-size,
    numbering: none,
    margin: (top: margin_top, bottom: margin_bottom, left: margin_left, right: margin_right),
  )

  // Numeração só para seções (nível 1) e jogos (nível 2).
  set heading(numbering: (..nums) => {
    let n = nums.pos()
    if n.len() <= 2 { numbering("1.1", ..n) }
  })
  show heading: set text(fill: colorheadings)
  show heading.where(level: 1): set text(size: 1.6em)
  show heading.where(level: 2): set text(size: 1.35em)
  show heading.where(level: 3): set text(size: 1.1em)
  show heading.where(level: 4): set text(size: 1em, fill: black)

  set figure(numbering: (..args) => {
    let chapter = counter(heading).display((..nums) => nums.pos().at(0))
    [#chapter.#counter(figure).display("1")]
  })
  set math.equation(numbering: (..args) => {
    let chapter = counter(heading).display((..nums) => nums.pos().at(0))
    [(#chapter.#numbering("1)", ..args.pos())]
  })
  show math.equation: set block(spacing: 1em)

  // Imagens dentro de parágrafos (miniaturas dos anexos) ficam lado a lado.
  // (no Typst, imagem é bloco por padrão; dentro de uma caixa ela flui na linha)
  show image: box

  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Links para arquivos estáticos (ex.: "/anexo1-<hash>.pdf") apontam para o site,
  // onde o MyST publica esses arquivos na pasta build/.
  show link: it => {
    if site_url != none and type(it.dest) == str and it.dest.starts-with("/") {
      link(site_url + "build" + it.dest, it.body)
    } else { it }
  }
  show link: set text(fill: theme.darken(10%))

  // ---------------------------------------------------------------- CAPA
  page(margin: (top: 2cm, bottom: 2cm, left: 2.2cm, right: 2.2cm))[
    #set par(justify: false)
    #if logo != none { align(center, image(logo, width: 5.5cm)) }
    #v(0.3cm)
    #align(center, text(10.5pt, fill: gray.darken(40%))[
      #if institution != none [#institution \ ]
      #if program != none [#program]
    ])
    #v(1fr)
    #align(center, text(32pt, weight: "bold", fill: theme, title))
    #if subtitle != none {
      v(0.2cm)
      align(center, box(width: 85%, text(14pt, fill: gray.darken(45%), subtitle)))
    }
    #v(0.8cm)
    #if cover != none { align(center, image(cover, width: cover_width)) }
    #v(1fr)
    #align(center)[
      #if authors != none { text(13pt, weight: "bold", authors) }
      #if advisor != none [ \ #text(11pt, fill: gray.darken(40%))[Orientador: #advisor] ]
    ]
    #v(0.8cm)
    #align(center, text(11pt, fill: gray.darken(40%))[
      #if place != none [#place]#if place != none and year != none [, ]#if year != none [#year]
    ])
  ]

  // ------------------------------------------------------------ SUMÁRIO
  if show_ToC {
    show outline.entry.where(level: 1): it => { v(10pt, weak: true); strong(it) }
    outline(title: text(fill: theme, "Sumário"), depth: ToC_depth, indent: auto)
  }

  // Cada seção começa em nova página.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    counter(figure).update(0)
    counter(math.equation).update(0)
    it
  }

  set page(
    numbering: if show_pagenumber { "1" } else { none },
    header: context {
      if counter(page).get().first() > 1 {
        align(right, text(8.5pt, fill: gray.darken(20%), title))
        v(-0.6em)
        line(length: 100%, stroke: 0.4pt + gray.lighten(30%))
      }
    },
  )
  pagebreak(weak: true)
  counter(page).update(1)

  body
}
