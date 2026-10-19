// Plugin MyST: adapta o conteúdo do site para a exportação em PDF (Typst).
//
// O conversor Typst do MyST não sabe renderizar o nó "grid", e o conteúdo dos
// cards se perde no PDF. Este plugin só atua em `myst build --pdf` (ou --typst);
// o site (`myst build --html`) não é afetado.
//
// - Grids de navegação (cards que apontam para páginas .md) são removidos.
// - Cards de materiais viram uma grade de miniaturas, duas por linha, cada uma
//   com link para o arquivo no GitHub (no PDF entram as miniaturas reduzidas
//   de previas/, geradas por template/gerar_previas.py).
// - O selo "Download ZIP" vira um link em texto para o ZIP no GitHub.
//
// Os links apontam para o repositório (e não para o site) porque o PDF é gerado
// localmente e versionado: os arquivos do site têm nomes com hash, que mudam a
// cada deploy, e o PDF ficaria com links quebrados.

import fs from 'node:fs';
import path from 'node:path';

const REPO_FILES = 'https://github.com/OnMat/SPAECE-Games/raw/main/';

const isPdfBuild = process.argv.some((a) => a === '--typst' || a === '--pdf');

const text = (value) => ({ type: 'text', value });
const raw = (typst) => ({ type: 'raw', typst });

// "./jogo/anexo1.pdf" na página "geometria/jogo.md" -> URL do arquivo no GitHub
function repoUrl(url, file) {
  if (!url || /^[a-z]+:/i.test(url)) return url;
  const abs = path.resolve(path.dirname(file), url);
  const rel = path.relative(process.cwd(), abs).split(path.sep).join('/');
  return REPO_FILES + rel.split('/').map(encodeURIComponent).join('/');
}

// Usa a miniatura reduzida de previas/ (gerada por template/gerar_previas.py),
// quando existe, no lugar da imagem em resolução de impressão.
function previewUrl(url, file) {
  if (!url || /^[a-z]+:/i.test(url)) return url;
  const rel = path.relative(process.cwd(), path.resolve(path.dirname(file), url));
  const previa = path.join(process.cwd(), 'previas', rel.replace(/\.png$/i, '.jpg'));
  if (!fs.existsSync(previa)) return url;
  return path.relative(path.dirname(file), previa).split(path.sep).join('/');
}

function cardImages(card, file) {
  const images = [];
  const walk = (n) => {
    if (n.type === 'image') images.push({ ...n, url: previewUrl(n.url, file), width: '100%', align: undefined });
    (n.children || []).forEach(walk);
  };
  walk(card);
  if (!card.url) return images;
  const url = repoUrl(card.url, file);
  return images.map((img) => ({ type: 'link', url, children: [img] }));
}

function isZipBadge(node) {
  return (
    node.type === 'link' &&
    (node.children || []).some((c) => c.type === 'image' && /download-zip/.test(c.url || ''))
  );
}

function transform(node, file) {
  if (!node.children) return;
  const out = [];
  for (const child of node.children) {
    if (child.type === 'grid') {
      const cards = (child.children || []).filter((c) => c.type === 'card');
      const navigation = cards.length > 0 && cards.every((c) => /\.md$/.test(c.url || ''));
      if (navigation) continue;
      const items = cards.flatMap((c) => cardImages(c, file));
      if (!items.length) continue;
      out.push({
        type: 'paragraph',
        children: [{ type: 'emphasis', children: [text('Clique em uma miniatura para baixar o arquivo para impressão.')] }],
      });
      // #grid(columns: 2, ..., [miniatura], [miniatura], ...)
      const cells = [raw('#grid(columns: (1fr, 1fr), column-gutter: 1em, row-gutter: 1em, ')];
      items.forEach((item) => cells.push(raw('['), item, raw('], ')));
      cells.push(raw(')'));
      out.push({ type: 'paragraph', children: cells });
    } else if (isZipBadge(child)) {
      out.push({ ...child, url: repoUrl(child.url, file), children: [text('Baixar todos os materiais deste jogo (ZIP)')] });
    } else {
      transform(child, file);
      out.push(child);
    }
  }
  node.children = out;
}

const plugin = {
  name: 'Ajustes do PDF',
  transforms: [
    {
      name: 'pdf-cards',
      stage: 'document',
      plugin: () => (tree, vfile) => {
        if (isPdfBuild) transform(tree, vfile.path);
      },
    },
  ],
};

export default plugin;
