// No Windows, o MyST grava os caminhos das opções do tipo "file" com "\";
// o Typst 0.14+ só aceita "/", por isso os filtros replace abaixo.
#import "style.typ": template
#import "aside_style.typ": aside
#show: template.with(
  title: "[-doc.title-]",
[# if doc.subtitle #]
  subtitle: "[-doc.subtitle-]",
[# endif #]
[# if doc.authors #]
  authors: "[# for author in doc.authors #][- author.name -][# if not loop.last #], [# endif #][# endfor #]",
[# endif #]
[# if options.advisor #]
  advisor: "[-options.advisor-]",
[# endif #]
[# if options.institution #]
  institution: "[-options.institution-]",
[# endif #]
[# if options.program #]
  program: "[-options.program-]",
[# endif #]
[# if options.place #]
  place: "[-options.place-]",
[# endif #]
[# if options.year #]
  year: "[-options.year-]",
[# endif #]
[# if options.logo #]
  logo: "[-options.logo | replace("\\", "/")-]",
[# endif #]
[# if options.cover #]
  cover: "[-options.cover | replace("\\", "/")-]",
[# endif #]
[# if options.cover_width #]
  cover_width: [-options.cover_width-]cm,
[# endif #]
[# if options.ToC_depth #]
  ToC_depth: [-options.ToC_depth-],
[# endif #]
[# if options.site_url #]
  site_url: "[-options.site_url-]",
[# endif #]
[# if options.papersize #]
  paper-size: "[-options.papersize-]",
[# endif #]
[# if options.fontsize #]
  fontsize: [-options.fontsize-]pt,
[# endif #]
)

[-IMPORTS-]

[-CONTENT-]

[# if doc.bibtex #]
#{
  show bibliography: set text(9pt)
  bibliography("[-doc.bibtex-]", title: "Referências", style: "associacao-brasileira-de-normas-tecnicas")
}
[# endif #]
