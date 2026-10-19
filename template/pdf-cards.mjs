// Plugin MyST: adapta o conteúdo do site para a exportação em PDF (Typst).
//
// O conversor Typst do MyST não sabe renderizar o nó "grid", e o conteúdo dos
// cards se perde no PDF. Este plugin só atua em `myst build --typst` ou
// `myst build --pdf`; o site (`myst build --html`) não é afetado. Por isso, no
// deploy, o PDF e o site são gerados em comandos separados.
//
// - Grids de navegação (cards que apontam para páginas .md) são removidos.
// - Cards de materiais (imagem + link para o anexo) viram miniaturas lado a lado,
//   cada uma com link para o arquivo no site.
// - O selo "Download ZIP" vira um link em texto.

const isPdfBuild = process.argv.some((a) => a === '--typst' || a === '--pdf');

const text = (value) => ({ type: 'text', value });

function cardImages(card) {
  const images = [];
  const walk = (n) => {
    if (n.type === 'image') images.push({ ...n, width: '46%', align: undefined });
    (n.children || []).forEach(walk);
  };
  walk(card);
  if (!card.url) return images;
  return images.map((img) => ({ type: 'link', url: card.url, children: [img] }));
}

function isZipBadge(node) {
  return (
    node.type === 'link' &&
    (node.children || []).some((c) => c.type === 'image' && /download-zip/.test(c.url || ''))
  );
}

function transform(node) {
  if (!node.children) return;
  const out = [];
  for (const child of node.children) {
    if (child.type === 'grid') {
      const cards = (child.children || []).filter((c) => c.type === 'card');
      const navigation = cards.length > 0 && cards.every((c) => /\.md$/.test(c.url || ''));
      if (navigation) continue;
      const items = cards.flatMap(cardImages);
      if (!items.length) continue;
      out.push({
        type: 'paragraph',
        children: [{ type: 'emphasis', children: [text('Clique em uma miniatura para baixar o arquivo para impressão.')] }],
      });
      const row = [];
      items.forEach((item, i) => {
        if (i > 0) row.push(text(' '));
        row.push(item);
      });
      out.push({ type: 'paragraph', children: row });
    } else if (isZipBadge(child)) {
      out.push({ ...child, children: [text('Baixar todos os materiais deste jogo (ZIP)')] });
    } else {
      transform(child);
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
      plugin: () => (tree) => {
        if (isPdfBuild) transform(tree);
      },
    },
  ],
};

export default plugin;
