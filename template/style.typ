  
#let leftCaption(it) = {
  set text(size: 8pt)
  set align(left)
  set par(justify: true)

  // Within the context of the element, you may use the counter
  context(it, {
    text(weight: "bold")[#it.supplement #it.counter.display(it.numbering).]
  })

  h(4pt)
  set text(fill: black.lighten(20%), style: "italic")
  it.body
}


#let template(
  // FRONTPAGE.
  title: "Book Title",
  subtitle: none,
  authors: "Your name",
  cover: none,            // <— path to cover "images/cover.png"
  cover_top: none,        // texto sobreposto no topo da capa
  cover_top_y: 4,         // posição do texto do topo, em % da altura
  cover_note: none,       // 1ª linha sobreposta no pé da capa (ex.: orientador)
  cover_note2: none,      // 2ª linha sobreposta no pé da capa
  cover_note_x: 17,       // posição das linhas do pé, em % da largura
  cover_note_y: 93.8,     // posição das linhas do pé, em % da altura
  background: none,       // imagem de fundo de todas as páginas, exceto a capa
  cover_width: 12cm,    
  coverposition: 1cm,
  justification: false,

  // TOC
  ToC_depth: 2,
  show_ToC: true,
  numbering_depth: none,  // ex.: 2 numera só capítulos e seções

  // PREFACE
  preface: none,
  preface_place: none,      // ex.: "Juazeiro do Norte, CE, Brasil"
  preface_date: none,       // ex.: "30 de setembro de 2026"
  preface_signature: none,  // ex.: "Tales Sousa da Rocha"
  preface_acknowledgments: none,  // texto da subseção "Agradecimentos", dentro do prefácio

  // SPECIFICATION of output
  paper-size: "a4",       // https://typst.app/docs/reference/layout/page/#parameters-paper
  margin: (),                          
  linespacing: .65em,
  parspacing: .65em,
  indent: 1.5em,
  indent_all: false,
  show_pagenumber: false,
  margin_top: 3cm,
  margin_bottom: 2cm,
  margin_left: 3cm,
  margin_right: 2cm,
  logo: none,
  logo_width: 10%,
  
  font: "Libertinus Serif", 
  fontsize: 12pt,

  theme: red.darken(30%),
  colorheadings: black,
  
  // The book's content.
  body
) = {

  // Idioma: hifenização e textos automáticos em português
  set text(lang: "pt", region: "br")

  // O MyST grava supplement: [Figure]/[Table] fixo no .typ;
  // traduz apenas nas legendas e nas referências cruzadas
  show figure.caption: it => { show "Figure": "Figura"; show "Table": "Tabela"; it }
  show ref: it => { show "Figure": "Figura"; show "Table": "Tabela"; it }

  // O :align: center do {image} não é exportado pelo MyST; centraliza todas as imagens
  // (evite imagens no meio de uma linha de texto com este template)
  show image: it => align(center, it)

  // Mantém o título das caixas (Objetivo, Importante...) na mesma página do conteúdo
  show block.where(below: 0pt): set block(sticky: true)

  set page(
    numbering: none,
    paper-size,
    ) //numbering off until first chapter
  
  set heading(numbering: (..args) => {
    let nums = args.pos()
    let level = nums.len()
    // numbering_depth: numera só até esse nível (none = todos os níveis)
    if numbering_depth != none and level > numbering_depth { return none }
    if level == 1 {[#numbering("1.", ..nums)]} else {[#numbering("1.1.1", ..nums)]}
    },   
    
)

  // Set figure numbering to x.y where x is chapter number and y is figure number within chapter

  set figure(numbering: (..args) => {
    // get current chapter number (first level of heading)
    let chapter = counter(heading).display((..nums) => nums.pos().at(0)) // nums is array of all levels, at(0) is first level, display formats it.  
    let fig = counter(figure).display("1")    // counter counts, display formats it
    [#chapter.#fig]
  })
  

  // Configure equation numbering and spacing.
  set math.equation(numbering: (..args) => {
    let chapter = counter(heading).display((..nums) => nums.pos().at(0))
    [(#chapter.#numbering("1)", ..args.pos())]
  })
  show math.equation: set block(spacing: 1em)


  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // link behaviour
  show link: set text( fill: blue.darken(30%))

 set page(
    margin: (
      top: 0pt,
      bottom: 0pt,
      left: 0pt,
      right: 0pt 
      )
  )

// COVERPAGE
  // Title, subtitle, 
  //align(center, text(17pt, weight: "bold", fill: theme, title))
  //if subtitle != none {
  //  parbreak()
  //  box(text(14pt, fill: gray.darken(30%), subtitle))
  //}

    if cover != none {
      //v(coverposition)
      align(center, image((cover.replace("\\", "/")), width: cover_width))
      // Textos sobrepostos à capa. A página da capa não tem margem, então as
      // porcentagens valem para a folha inteira; ajuste com cover_*_x/y.
      if cover_top != none {
        place(
          top + center,
          dy: cover_top_y * 1%,
          text(13pt, weight: "bold", fill: theme, tracking: 2pt, cover_top),
        )
      }
      if cover_note != none or cover_note2 != none {
        place(
          top + left,
          dx: cover_note_x * 1%,
          dy: cover_note_y * 1%,
          text(12pt, fill: luma(20%))[
            #if cover_note != none [#cover_note]
            #if cover_note2 != none [#linebreak() #cover_note2]
          ],
        )
      }
    }

  //author
  //v(1em)

  // authors in gray
  //if authors != none {
  //place(bottom + right, 
  //  text(12pt, fill: gray.darken(50%), authors)
  //)
  //}

  // Prefácio e sumário usam as mesmas margens do corpo do livro.
  // A imagem de fundo começa aqui, então a capa fica sem ela.
  set page(
    background: if background != none {
      image(background.replace("\\", "/"), width: 100%, height: 100%, fit: "cover")
    } else { none },
    margin: (
      top: margin_top,
      bottom: margin_bottom,
      left: margin_left,
      right: margin_right
      )
  )

// PREFACE, 
    if preface != none {
    pagebreak()
    place(top + left, 
      text(18pt, fill: theme, weight: "bold", "Prefácio")
    )
    v(2cm)
    set par(
      justify: true,
      leading: linespacing,
      spacing: parspacing,
      first-line-indent: (amount: indent, all: false),
    )
    preface
    // Subseção "Agradecimentos": depois do texto do prefácio, antes da assinatura
    if preface_acknowledgments != none {
      block(
        above: 2 * fontsize,
        below: 1.75 * fontsize,
        sticky: true,
        text(1.2 * fontsize, fill: theme, weight: "bold", "Agradecimentos"),
      )
      preface_acknowledgments
    }
    if preface_place != none or preface_signature != none or preface_date != none {
      v(1em)
      par(first-line-indent: 0em)[
        #if preface_place != none { preface_place }
        #h(1fr)
        #if preface_signature != none { preface_signature }
        #if preface_date != none { linebreak(); preface_date }
      ]
    }
  }


//OUTLINE OF THE BOOK
  pagebreak()
  if show_ToC == true {
      
    show outline.entry.where(level: 1): it => {
      v(12pt, weak: true)
      
      strong(it)
    }
    // setting outline in themecolor
    outline(
    title: strong(text(fill: theme, "Sumário")),
    depth: ToC_depth,
    indent: auto,
  )

  }

//RESETING NUMBERING
  show heading.where(level: 1): it => {
    // weak: o MyST já insere #pagebreak() entre os artigos;
    // uma quebra forte aqui gerava uma página em branco antes de cada capítulo
    pagebreak(weak: true)
    // Reset all counters with a new chapter
    counter(figure).update(0)                // all figures (irrespective of kind)
    counter(figure.where(kind: table)).update(0) // specific for tables
    counter(math.equation).update(0)
    
    it
  }

  //Heading colors
  show heading: set text(colorheadings)

  // Distância entre o título e o texto que vem depois: o padrão do Typst
  // é 0.75em do texto; aqui vale 1.75em (1em a mais) em todos os níveis
  show heading: set block(below: 1.75 * fontsize)
  

// PAGE LAYOUT OF CONTENT
  set page(
    numbering: if show_pagenumber == true {"1"} else {none},         //turn on numbering
    margin: (
      top: margin_top,
      bottom: margin_bottom,
      left: margin_left,
      right: margin_right 
      ),    //set left margin
    header: if logo != none { align(center)[#image(logo.replace("\\","/"), width: logo_width)] } else { none },//include logo
  )   

  set text(
    font: font,
    size: fontsize
    )
  set par(
    leading: linespacing,
    spacing: parspacing,
    justify: justification,
    first-line-indent: (amount: indent, all: indent_all),
    )

  counter(page).update(1)   //set number to 1

  // Display the book's contents.
  [#body]
}
