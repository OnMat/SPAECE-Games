#import "@preview/marge:0.1.0"
#import "style.typ": template
#import "aside_style.typ": aside
#show: template.with(

// title
  title: "[-doc.title-]",

// subtitle
[# if doc.subtitle #]
  subtitle: "[-doc.subtitle-]",
[# endif #]

// authors
[# if doc.authors #]
  authors: "[# for author in doc.authors #][- author.name -][# if not loop.last #], [# endif #][# endfor #]",
[# endif #]


// logo for top page
// Caminhos de arquivo entram como texto bruto (`...`.text), não como string "...":
// no Windows o MyST usa barra invertida, e numa string Typst "files\referencias.bib"
// o \r vira quebra de linha. O .replace("\\", "/") no style.typ troca as barras.
[# if options.logo #]
  logo: `[-options.logo-]`.text,
[# endif #]

// specify the with of the logo
[# if options.logo_width #]
  logo_width: [-options.logo_width-]%,
[# endif #]


// cover picture
[# if options.cover #]
  cover: `[-options.cover-]`.text,
[# endif #]

[# if options.background #]
  background: `[-options.background-]`.text,
[# endif #]

[# if options.cover_top #]
  cover_top: "[-options.cover_top-]",
[# endif #]

[# if options.cover_top_y #]
  cover_top_y: [-options.cover_top_y-],
[# endif #]

[# if options.cover_note2 #]
  cover_note2: "[-options.cover_note2-]",
[# endif #]

[# if options.cover_note #]
  cover_note: "[-options.cover_note-]",
[# endif #]

[# if options.cover_note_x #]
  cover_note_x: [-options.cover_note_x-],
[# endif #]

[# if options.cover_note_y #]
  cover_note_y: [-options.cover_note_y-],
[# endif #]

[# if options.cover_width #]
  cover_width: [-options.cover_width-]cm,
[# endif #]

[# if options.coverposition #]
  coverposition: [-options.coverposition-]cm,
[# endif #]



//specify depth of table of contents

[# if options.show_ToC is defined#]
  show_ToC: [-options.show_ToC-],
[# endif #]

[# if options.numbering_depth #]
  numbering_depth: [-options.numbering_depth-],
[# endif #]

[# if options.ToC_depth #]
  ToC_depth: [-options.ToC_depth-],
[# endif #]



//Page settings
[# if options.papersize #]
  paper-size: "[-options.papersize-]",
[# endif #]

[# if options.show_pagenumber is defined #]
  show_pagenumber: [-options.show_pagenumber-],
[# endif #]

[# if options.margin_top #]
  margin_top: [-options.margin_top-]cm,
[# endif #]

[# if options.margin_bottom #]
  margin_bottom: [-options.margin_bottom-]cm,
[# endif #]

[# if options.margin_left #]
  margin_left: [-options.margin_left-]cm,
[# endif #]

[# if options.margin_right #]
  margin_right: [-options.margin_right-]cm,
[# endif #]

[# if options.colortheme #]
  theme: [-options.colortheme-],
[# endif #]

[# if options.colorheadings #]
  colorheadings: [-options.colorheadings-],
[# endif #]

[# if options.fontstyle #]
  font: "[-options.fontstyle-]",
[# endif #]

[# if options.fontsize #]
  fontsize: [-options.fontsize-]pt,
[# endif #]

[# if options.linespacing #]
  linespacing: [-options.linespacing-]em,
[# endif #]

[# if options.justification is defined #]
  justification: [-options.justification-],
[# endif #]

[# if options.preface is defined #]
  preface: "[-options.preface-]",
[# endif #]

[# if options.preface_place #]
  preface_place: "[-options.preface_place-]",
[# endif #]

[# if options.preface_date #]
  preface_date: "[-options.preface_date-]",
[# endif #]

[# if options.preface_acknowledgments #]
  preface_acknowledgments: "[-options.preface_acknowledgments-]",
[# endif #]

[# if options.preface_signature #]
  preface_signature: "[-options.preface_signature-]",
[# endif #]

)



[-IMPORTS-]

[-CONTENT-]

[# if doc.bibtex #]
#{
  // Usa o .bib original (opção bibliography_file) quando informado: o main.bib que o
  // MyST gera converte @mastersthesis em @misc e descarta o urldate ("Acesso em").
  // Citações por DOI, que não estão no .bib, exigem voltar para o main.bib.
  let bibfile = `[# if options.bibliography_file #][-options.bibliography_file-][# else #][-doc.bibtex-][# endif #]`.text
  // Mesma fonte e tamanho do texto; ABNT: referências alinhadas à esquerda
  // e separadas por uma linha em branco
  show bibliography: set par(justify: false, first-line-indent: 0em, spacing: 1.2em)
  bibliography(bibfile.replace("\\", "/"), title: "Referências", style: "associacao-brasileira-de-normas-tecnicas")
}
[# endif #]
