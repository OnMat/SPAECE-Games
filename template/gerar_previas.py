"""Gera as miniaturas dos anexos usadas no PDF (pasta previas/).

As imagens anexoN.png dos jogos têm resolução de impressão e, juntas, deixariam o
PDF com cerca de 80 MB. O plugin template/pdf-cards.mjs usa, no PDF, a versão
reduzida em previas/ quando ela existe.

Uso, na raiz do projeto (requer Pillow: pip install pillow):

    python template/gerar_previas.py

Rode de novo sempre que um anexo for incluído ou alterado.
"""
from pathlib import Path

from PIL import Image

LARGURA = 700   # pixels; suficiente para meia página A4
QUALIDADE = 78  # JPEG

raiz = Path(__file__).resolve().parent.parent
saida = raiz / "previas"
total = 0
for png in sorted(raiz.glob("*/*/anexo*.png")):
    destino = saida / png.relative_to(raiz).with_suffix(".jpg")
    if destino.exists() and destino.stat().st_mtime >= png.stat().st_mtime:
        continue
    destino.parent.mkdir(parents=True, exist_ok=True)
    im = Image.open(png)
    if im.mode in ("RGBA", "LA", "P"):
        im = im.convert("RGBA")
        fundo = Image.new("RGB", im.size, "white")
        fundo.paste(im, mask=im.split()[-1])
        im = fundo
    else:
        im = im.convert("RGB")
    if im.width > LARGURA:
        im = im.resize((LARGURA, round(im.height * LARGURA / im.width)), Image.LANCZOS)
    im.save(destino, quality=QUALIDADE, optimize=True)
    total += 1
print(f"{total} miniatura(s) gerada(s) em {saida}")
