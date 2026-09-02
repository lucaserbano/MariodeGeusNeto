#!/usr/bin/env bash
#
# Gera os assets web a partir dos originais em assets/.
# Idempotente: pula o que já existe. Use FORCE=1 para refazer tudo.
#
# Requer: cwebp, dwebp, sips, ffmpeg (todos já presentes no macOS + Homebrew),
#         npx (para ttf2woff2).
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_FOTOS="$ROOT/assets/fotos-originais"
SRC_LOGO="$ROOT/assets/logo-sem-fundo"
SRC_FONTES="$ROOT/assets/instrucoes/fontes"
OUT_IMG="$ROOT/public/img"
OUT_LOGO="$OUT_IMG/logo"
OUT_INST="$OUT_IMG/inst"
OUT_FONT="$ROOT/public/fonts"

QUALITY=82

mkdir -p "$OUT_IMG" "$OUT_LOGO" "$OUT_INST" "$OUT_FONT"

# Pula se o destino já existe e FORCE não está setado.
skip() {
  [ -z "${FORCE:-}" ] && [ -f "$1" ]
}

log() { printf '  %s\n' "$*"; }

# ---------------------------------------------------------------- fotos ----
# Mapa de nomes: as fotos citadas no briefing ganham slug semântico,
# as demais viram foto-NN. Os originais têm acento e parênteses no nome,
# que não servem para URL.
slug_para() {
  case "$1" in
    79)  echo "hero" ;;
    9)   echo "formacao" ;;
    100) echo "whatsapp" ;;
    *)   printf 'foto-%02d\n' "$1" ;;
  esac
}

echo "==> Fotos -> WebP"
for src in "$SRC_FOTOS"/*.jpg; do
  base="$(basename "$src")"
  # "Mario_estúdio (79 de 100).jpg" -> 79
  num="$(echo "$base" | sed -n 's/.*(\([0-9]\{1,3\}\) de 100).*/\1/p')"
  [ -n "$num" ] || { log "ignorado (nome inesperado): $base"; continue; }
  slug="$(slug_para "$num")"

  for w in 1600 800; do
    dst="$OUT_IMG/$slug-$w.webp"
    if skip "$dst"; then log "= $slug-$w.webp"; continue; fi
    cwebp -quiet -q "$QUALITY" -resize "$w" 0 "$src" -o "$dst"
    log "+ $slug-$w.webp ($(du -h "$dst" | cut -f1 | tr -d ' '))"
  done
done

# A foto do botão flutuante de WhatsApp aparece recortada em círculo:
# precisa de um quadrado enquadrado no rosto, não do retrato inteiro.
# Recorte medido sobre o original 4000x6000 da foto 100.
dst="$OUT_IMG/whatsapp-320.webp"
if skip "$dst"; then
  log "= whatsapp-320.webp"
else
  tmp="$(mktemp -t wa).png"
  ffmpeg -y -loglevel error -i "$SRC_FOTOS/Mario_estúdio (100 de 100).jpg" \
    -vf "crop=2600:2600:600:200,scale=320:320" "$tmp"
  cwebp -quiet -q 88 "$tmp" -o "$dst"
  rm -f "$tmp"
  log "+ whatsapp-320.webp ($(du -h "$dst" | cut -f1 | tr -d ' '))"
fi

# ------------------------------------------------- ressonância (RM) ----
# Usada como marca d'água no painel do menu mobile. É um corte sagital do
# pescoço: mostra exatamente o território entre o crânio e o tórax.
dst="$OUT_IMG/rm-pescoco.webp"
if skip "$dst"; then
  log "= rm-pescoco.webp"
else
  cwebp -quiet -q 80 "$SRC_FOTOS/RM-pescoco" -o "$dst"
  log "+ rm-pescoco.webp ($(du -h "$dst" | cut -f1 | tr -d ' '))"
fi

# A mesma ressonância, recortada do fundo preto. É a marca d'água da régua nas
# especialidades: como já vem com alfa, entra direto, sem máscara nem mistura.
# O cinza da RM é neutro e destoava da paleta, então aqui ela vira um duotone: a
# luminância é remapeada para a rampa azul-ardósia -> branco, o que põe a --tinta
# no lugar do preto. Fica gravado no arquivo em vez de aproximado por `filter` no
# CSS, que não acerta um hex. Precisa de Pillow, como os brasões.
dst="$OUT_IMG/rm-isolada.webp"
if skip "$dst"; then
  log "= rm-isolada.webp"
else
  tmp="$(mktemp -t rm).png"
  python3 - "$SRC_FOTOS/MRI isolada.png" "$tmp" <<'TINTA'
import sys
from PIL import Image, ImageOps
src = Image.open(sys.argv[1]).convert('RGBA')
alfa = src.getchannel('A')
img = ImageOps.colorize(src.convert('L'), black='#272D3B', white='#FFFFFF')
img.putalpha(alfa)
img.save(sys.argv[2])
TINTA
  cwebp -quiet -q 88 -alpha_q 100 "$tmp" -o "$dst"
  rm -f "$tmp"
  log "+ rm-isolada.webp ($(du -h "$dst" | cut -f1 | tr -d ' '))"
fi

# ------------------------------------------- logos das instituições ----
# Entram como ícone circular de fundo branco ao lado de cada formação.
# O círculo é feito em CSS; aqui só normalizamos tamanho e nome.
echo "==> Logos das instituições"
mkdir -p "$OUT_INST"
inst() {
  local src="$1" dst="$OUT_INST/$2.png"
  if skip "$dst"; then log "= $2.png"; return; fi
  sips -Z 260 "$src" --out "$dst" >/dev/null 2>&1
  log "+ $2.png ($(du -h "$dst" | cut -f1 | tr -d ' '))"
}
inst "$SRC_FOTOS/logo_pucpr_horizontal_rgb.png" pucpr
inst "$SRC_FOTOS/logo-iamspe.png"               iamspe
inst "$SRC_FOTOS/logohc.png"                    hcfmusp
inst "$SRC_FOTOS/logo-oficial-fmusp.png"        fmusp

# ------------------------------------------------ logos dos hospitais ----
# Ícone circular ao lado de cada local de atendimento, mesmo tratamento
# dos brasões da formação. Duas famílias de original, dois tratamentos:
#
#  - Santa Cruz e São Camilo: lockup (símbolo + palavra) sobre um branco
#    impuro (#f5f5f5 e #f7f7f7). Duas correções: o quase-branco vira branco
#    puro, senão apareceria como um quadrado cinza dentro do disco; e o
#    recorte fica só no símbolo — a 52px a palavra é ilegível e encolhe o
#    símbolo até ele sumir ao lado das outras marcas.
#  - HUEM e O1: quadrados de cor sangrada, sem margem. Não cabem dentro de
#    um disco branco (virariam um quadrado colorido flutuando nele); o CSS
#    os recorta em círculo e a própria cor da marca vira o disco.
#
# As caixas do símbolo foram medidas no original varrendo as linhas com
# tinta e achando a folga que separa o símbolo da palavra.
echo "==> Logos dos hospitais"
disco() {
  local src="$1" dst="$OUT_INST/$2.png" caixa="${3:-}"
  if skip "$dst"; then log "= $2.png"; return; fi
  python3 - "$src" "$dst" $caixa <<'PYDISCO'
import sys
try:
    from PIL import Image
except ImportError:
    sys.exit('ERRO: este passo precisa de Pillow (pip3 install Pillow)')

src, dst = sys.argv[1], sys.argv[2]
im = Image.open(src).convert('RGBA')
# achata sobre branco: o Santa Cruz tem metade transparente e metade #f5f5f5
im = Image.alpha_composite(Image.new('RGBA', im.size, (255, 255, 255, 255)), im)

px = im.load()
w, h = im.size
for y in range(h):
    for x in range(w):
        r, g, b, a = px[x, y]
        # só quase-branco de baixa saturação vira branco puro; o vermelho
        # do São Camilo chega a 255 num canal e não pode ser tocado
        if min(r, g, b) >= 228 and max(r, g, b) - min(r, g, b) <= 10:
            px[x, y] = (255, 255, 255, 255)

if len(sys.argv) > 3:
    x0, y0, x1, y1 = (int(v) for v in sys.argv[3:7])
    im = im.crop((x0, y0, x1 + 1, y1 + 1))

# centraliza numa tela quadrada: o disco do CSS é redondo e um retângulo
# deixaria a marca fora do eixo
lado = max(im.size)
tela = Image.new('RGBA', (lado, lado), (255, 255, 255, 255))
tela.paste(im, ((lado - im.size[0]) // 2, (lado - im.size[1]) // 2))
tela.thumbnail((260, 260), Image.LANCZOS)
tela.save(dst)
PYDISCO
  log "+ $2.png ($(du -h "$dst" | cut -f1 | tr -d ' '))"
}
disco "$SRC_FOTOS/Logo_pb_hospital_santa_cruz.png" hosp-santa-cruz "144 36 255 153"
disco "$SRC_FOTOS/logo_h_sao_camilo.jpg"           hosp-sao-camilo "145 53 303 211"

# sangradas: só normalizar tamanho e formato, o recorte é do CSS
inst "$SRC_FOTOS/logo_HUEM.jpg"    hosp-huem
inst "$SRC_FOTOS/logo_o1saude.jpg" hosp-o1saude

# ---------------------------------------------------------------- logos ----
# Os PNGs vêm em resolução de impressão (o horizontal tem 5679px).
# Reduzir para uso web, preservando a transparência.
echo "==> Logos -> PNG web"
logo_web() {
  local src="$1" dst="$2" max="$3"
  if skip "$dst"; then log "= $(basename "$dst")"; return; fi
  sips -Z "$max" "$src" --out "$dst" >/dev/null 2>&1
  log "+ $(basename "$dst") ($(du -h "$dst" | cut -f1 | tr -d ' '))"
}

for cor in Azul Branco; do
  low="$(echo "$cor" | tr '[:upper:]' '[:lower:]')"
  logo_web "$SRC_LOGO/$cor/Horizontal $cor.png" "$OUT_LOGO/horizontal-$low.png" 900
  logo_web "$SRC_LOGO/$cor/Principal $cor.png"  "$OUT_LOGO/principal-$low.png"  700
  logo_web "$SRC_LOGO/$cor/Símbolo $cor.png"    "$OUT_LOGO/simbolo-$low.png"    600
  logo_web "$SRC_LOGO/$cor/Circular $cor.png"   "$OUT_LOGO/circular-$low.png"   600
done
logo_web "$SRC_LOGO/Azul/pattern 1.png"        "$OUT_LOGO/pattern-1-azul.png"  800
logo_web "$SRC_LOGO/Azul/pattern 2.png"        "$OUT_LOGO/pattern-2-azul.png"  800
logo_web "$SRC_LOGO/Branco/pattern claro.png"  "$OUT_LOGO/pattern-claro.png"   800

# ---------------------------------------------------------------- fontes ----
# Cormorant é OFL: pode e deve ser auto-hospedada.
# Só os pesos que o design usa (títulos em Light, eventual Regular).
echo "==> Cormorant -> WOFF2"
for peso in Light Regular Medium SemiBold; do
  src="$SRC_FONTES/Cormorant-$peso.ttf"
  dst="$OUT_FONT/Cormorant-$peso.woff2"
  if skip "$dst"; then log "= Cormorant-$peso.woff2"; continue; fi
  npx --yes ttf2woff2 < "$src" > "$dst"
  log "+ Cormorant-$peso.woff2 ($(du -h "$dst" | cut -f1 | tr -d ' '))"
done

echo
echo "Pronto. Saída em public/"
