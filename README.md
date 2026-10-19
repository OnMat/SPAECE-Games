# SPAECE-Games
Jogos concretos de baixo custo alinhados aos descritores de matemática do SPAECE

## Site

O site é publicado pelo GitHub Actions a cada push na branch `main`
(`.github/workflows/deploy.yml`).

## PDF

O PDF em `exports/SPAECE-Games.pdf` **não** é gerado pelo GitHub Actions: ele é
gerado localmente e versionado junto com o site, que o oferece no botão *Download PDF*.

Para regerar depois de alterar alguma página:

```bash
python template/gerar_previas.py   # só se algum anexo*.png foi incluído ou alterado
myst build --pdf
```

É preciso ter o [Typst](https://github.com/typst/typst) instalado. A configuração está em
`export.yml` (páginas incluídas, margens, cores, prefácio e agradecimentos) e o modelo
em `template/`.

As miniaturas dos materiais que aparecem no PDF ficam em `previas/`: são cópias
reduzidas dos `anexo*.png` dos jogos (as originais deixariam o PDF com cerca de 80 MB),
geradas por `template/gerar_previas.py` (requer `pip install pillow`). O plugin
`template/pdf-cards.mjs` usa essas miniaturas e aponta os links do PDF para os arquivos
no GitHub.

A capa e o fundo das páginas são imagens em `public/capa.png` e `public/fundo.png`,
geradas a partir dos arquivos em `capa/`:

```bash
cd capa
typst compile --format png --ppi 150 capa.typ ../public/capa.png
typst compile --format png --ppi 150 fundo.typ ../public/fundo.png
```

Também podem ser substituídas por imagens feitas em outro programa, desde que no
tamanho A4 (1240 × 1754 pixels a 150 ppi).
