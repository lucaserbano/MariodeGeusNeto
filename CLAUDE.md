# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> O conteúdo do site e o briefing são em português. Escreva copy, comentários e commits em português.

## O que é

Site institucional de **página única** do Dr. Mario de Geus Neto — otorrinolaringologista e
cirurgião de cabeça e pescoço. Tem dois objetivos, nessa ordem de importância: **acolher o
paciente** e **converter em agendamento pelo WhatsApp**. Toda decisão de design ou copy
deve responder a um dos dois.

Stack: **HTML + CSS + JS estático, sem build step**, sem framework, sem bundler,
sem `package.json`. Isso é uma decisão do dono do projeto, não uma etapa pendente —
não introduza Vite/Astro/React/Tailwind sem pedir.

## Comandos

```bash
python3 -m http.server 8000     # servidor local, a partir da raiz
./tools/build-assets.sh          # regenera public/ a partir de assets/ (idempotente)
FORCE=1 ./tools/build-assets.sh  # refaz tudo do zero
```

Não há testes, linter nem CI. Não invente um.

## Estrutura

```
index.html      a página inteira (uma só)
css/estilo.css  toda a folha de estilo
js/site.js      navbar, menu mobile, revelações no scroll, assinatura
assets/         originais intocáveis (fotos de câmera, logos em resolução de
                impressão, fontes .ttf, e os dois .md de briefing).
                NUNCA referencie daqui no HTML.
public/         saída do pipeline — é isto que o site consome.
tools/          build-assets.sh
```

### Seções, na ordem

| Âncora | Fundo | Papel |
|---|---|---|
| `#inicio` | **escuro** | Hero: foto 79 à esquerda, texto à direita |
| `#formacao` | claro | Formação em lista + foto 9 como plano de fundo à direita |
| `#especialidades` | claro | O território anatômico + oncologia |
| `#locais` | **escuro, em gradiente** | Curitiba e Ponta Grossa; cada endereço é um link para o Google Maps |
| `#contato` | claro | CTA final do WhatsApp + Instagram, com o símbolo escrito à mão ao fundo |

A alternância claro/escuro é a espinha do ritmo da página. Formação e
especialidades são as duas únicas claras seguidas — por isso a folga entre elas
é reduzida por regra explícita, senão o corte some numa faixa clara só.

**Caixa mista** (`text-transform: none`, entrelinha 1.16, quase sem espacejamento)
vale para **todos os títulos de seção** — hero, formação, especialidades (incluindo
os nomes das regiões anatômicas), locais e contato.

**E caixa mista em SemiBold (600).** Os quatro `<h2>` de seção — formação,
especialidades, locais e contato — têm o mesmo peso de "Clareza"/"Precisão" na
hero, e o `<h3>` da oncologia junto com eles. **Os nomes das regiões anatômicas
ficam de fora, em Light 300**: lá o destaque já vem do grifo (fundo `--tinta`),
e somar peso ao grifo só engrossaria a faixa. Onde não há grifo, quem destaca
é o peso. Em corpo grande o Light 300 da Cormorant afina até o título perder a voz
para a lista que vem embaixo; o 300 ficou para o que é rótulo. A troca custa de
1% a 4% de largura (medido nas sete linhas de título), então nenhuma quebra muda —
mas se mexer no corpo dos títulos, meça de novo.

Na hero o destaque por peso continua: "Clareza"/"Precisão" em `<em>` com
`font-style: normal`, SemiBold 600 contra o Light 300 do resto da frase. O
destaque marca sempre o par de palavras que carrega o sentido, nunca uma palavra
solta. **Em locais esse jogo acabou**: com o título inteiro em 600, o `<em>` de
"Duas"/"quatro" não pesa mais que a frase e só neutraliza o itálico. Se o destaque
tiver de voltar ali, baixe o resto da frase — subir as duas palavras para 700 não
resolve, porque 700 ao lado de 600 mal se distingue na Cormorant.

As **versais espaçadas** ficaram para os rótulos, não para os títulos:
sobrancelhas, nomes de cidade (`.cidade h3`) e o nome no rodapé. A divisão é
deliberada — título é caixa mista, rótulo é caixa alta.

**Há uma camada de grão** (`body::after`, ruído SVG em `feTurbulence`,
**`opacity: .11`**, `position: fixed`, `z-index: 300`, `pointer-events: none`) por
cima da página inteira. Ela tira o aspecto chapado dos fundos e dos gradientes.
Como fica acima de tudo, qualquer elemento novo com `z-index` alto precisa de
`pointer-events` coerente — mas nada é bloqueado por ela.

**E ela comprime o contraste de tudo, porque fica acima de figura E de fundo.**
Isso nunca esteve escrito aqui e vale mais que o número: toda razão medida nos
tokens é um teto, não o valor real na tela. Medido compondo o ruído nos dois
extremos: `--tinta-suave` sobre `--papel` cai de 6.18 para **4.74**;
`--musgo-suave` sobre `--musgo` de 6.63 para **5.04**; e a sobrancelha de
`#locais` no topo do gradiente, de 5.89 para **4.55** — passa AA por 0,05, e é a
margem mais fina da página. Clarear a ponta `#343B49` ou subir o grão reprova.

**O título da hero não é o nome do médico.** É uma frase sobre postura
profissional ("Clareza nos diagnósticos. Precisão nos tratamentos"); o nome está
na logo da navbar e na assinatura. A ordem do bloco é fixa: lugar → frase →
especialidade → registros → CTA.

O `<br>` entre as duas frases do título é intencional: sem ele o `text-wrap`
orfaniza um "NOS" numa linha só. Se mudar o título, confira a contagem de linhas
antes de dar por pronto — a coluna de texto é estreita e o corpo é grande.

### O território (a régua vertical)

A seção de especialidades é organizada por **região anatômica, descendo o corpo** —
ouvido, nariz, garganta, pescoço — com um fio vertical ligando as quatro e as
palavras "crânio" e "tórax" nas pontas. Isso não é ornamento: é a frase do próprio
médico ("praticamente todas as afecções entre o crânio e o tórax") desenhada.

Por isso a lista é `<ol>` e **não leva numeração visível** — a ordem é anatômica,
não uma sequência de passos. Não troque por cards nem por números.

No desktop a lista de cada região fica numa **coluna só, à esquerda**
(`max-width: min(30rem, 44%)`, no bloco `min-width: 1001px`). A segunda coluna caía
justamente sobre a ressonância e obrigava a mantê-la quase apagada; sem ela, a
metade direita da régua é inteira da imagem.

**Os nomes das regiões são grifados**: fundo `--tinta`, texto `--papel`, num
`<span class="grifo">` dentro do `<h3>` — em linha, para o fundo abraçar as
palavras em vez de tomar a coluna toda. `box-decoration-break: clone` reconstrói o
grifo em cada linha quando o título quebra, e a entrelinha do `h3` sobe para 1.32
(contra os 1.16 dos outros títulos) para as duas faixas não se encostarem.

**A bolinha é um alvo, não um ponto**: núcleo de 11px em `--musgo`, 6px de papel
que abre o fio e um anel de 1px do mesmo verde a 34%. O `margin-left: -1px` centra
o disco no fio, que tem 1px e mora em `left: 4px` do `.territorio` — **se mudar o
diâmetro, refaça essa conta** (metade do diâmetro à esquerda de 4,5px).

**Cada região entra sozinha no scroll, e por partes**: bolinha (cresce de
`scale(.2)`), depois o título (+0,22s), depois a lista (+0,44s). Quem leva a classe
`revela` é cada `<li class="regiao">`; o contêiner é neutralizado
(`.js .regiao.revela { opacity: 1; transform: none; transition: none }`) porque, se
ele também animasse, as opacidades se multiplicariam e os dois deslocamentos
somariam. O bloco de `prefers-reduced-motion` precisa alcançar as três partes —
a regra genérica de `.revela` não basta.

**`.territorio__extremo` usa `:first-of-type` / `:last-of-type`, não `:first-child`.**
O primeiro filho do `.territorio` é o `<img>` da ressonância, então o `:first-child`
nunca casava e o "crânio" ficou tempos sem margem inferior, encostado no primeiro
título.

A oncologia fica **fora** da régua, num bloco próprio: ela atravessa todas as
regiões em vez de ocupar uma.

**O bloco de oncologia tem quatro partes, nesta ordem, e cada uma existe por um
motivo.** (1) O título leva **grifo invertido**: nas regiões o fundo é claro e a
caixinha é de `--tinta`; aqui o fundo é o verde, então a caixinha é de `--papel`
e a palavra fica `--musgo` (7.1:1). Sem ele, título e corpo eram a mesma cor e
só o peso separava. (2) Os dois parágrafos ficam em **duas colunas**
(`auto-fit`, `minmax(min(28rem, 100%), 1fr)`): a caixa tem ~1100px e uma coluna
só de 58ch deixava a metade direita vazia. O acolhimento (`--papel` cheio) pesa
mais que o lead (`--musgo-suave`) de propósito. (3) A lista abre com uma **frase
de entrada** em peso 600 e corpo 1,08rem, porque ela não pode começar do nada.
(4) O convite fecha **centralizado, em coluna**: frase e botão um sobre o outro,
no eixo da caixa.

**A caixa verde é uma superfície só.** Já tentei destacar a lista com uma faixa
mais escura sangrada até as bordas, e o dono do projeto vetou: alternar tom
dentro da caixa suja o bloco. O que separa a lista do texto acima é **folga**
(2,6rem) e a frase de entrada, não cor. Não devolva o fundo.

**E o convite é centralizado por causa da marca d'água.** Ele já foi uma linha
com `justify-content: space-between`, que encostava o botão na borda direita —
bem em cima do símbolo do canto inferior direito. Centralizado, o botão cai na
faixa vazia do meio e a marca continua onde sempre esteve. Se voltar a alinhar
o botão à direita, a marca precisa sair, e aí o bloco perde a assinatura.

Medidos na caixa: grifo 7.1:1, frase de entrada 7.1:1 (5.9:1 sob a marca),
lista 6.6:1 (5.6:1 sob a marca), acolhimento e convite 7.1:1. Mexeu no
`--musgo-suave` ou na opacidade da marca, remede.

`assets/instrucoes/instrucoes.md` (identidade visual) e `assets/instrucoes/informacoes.md`
(conteúdo médico) são a fonte de verdade original. Este arquivo resume os dois, mas em caso
de conflito o briefing manda.

## Sistema de design

### Cores

| Hex | Papel |
|---|---|
| `#272D3B` | azul-ardósia. Fundo de seção escura; **é também a cor da logo "Azul"** |
| `#E5EAE3` | verde-claro acinzentado. Fundo de seção clara |
| `#88857C` | cinza-quente. Fundo intermediário, **uso comedido** |
| `#3F512B` | verde. **Só adorno e detalhe** — nunca área de destaque nem fundo de seção |

Duas cores derivadas existem por acessibilidade, não por gosto: `#88857C` só alcança
**3.0:1** sobre o fundo claro e **3.7:1** sobre o escuro, o que reprova para texto
corrido. Então o `--pedra` ficou restrito a fios, réguas e campos lavados, e o texto
secundário usa `--tinta-suave` `#5C6274` (5.0:1 no claro) e `--papel-suave` `#B8BDB6`
(7.2:1 no escuro). Não devolva o `#88857C` para texto pequeno.

**O anel de foco é um token, não uma cor fixa.** `--foco` nasce `--musgo` no
`:root` e é redefinido para `--papel` em `.hero`, `.secao--tinta`, `.rodape`,
`.oncologia`, `.navbar` (e de volta para `--musgo` em `.navbar--assentada`), no
`.pular` e no painel `.menu` do mobile. Antes era `outline: 2px solid
var(--musgo)` global, e o verde só contrasta com o claro: dava **1.59:1** sobre
`--tinta`, **1.30:1** no topo do gradiente de `#locais` e **1.00:1** sobre o
próprio botão verde, contra os 3:1 que a WCAG 1.4.11 pede. Na prática a
navegação por teclado não tinha indicador visível em nenhuma seção escura —
inclusive nos quatro links de endereço. Hoje o pior caso é 7.10:1. **Superfície
escura nova precisa redefinir `--foco`.**

**Regra de pareamento da logo** (do manual, não negociável):
fundo `#E5EAE3` → logo `#272D3B`; **qualquer outro fundo** → logo `#E5EAE3`.

Transições entre seções devem ser suaves, com gradientes dentro da paleta.

### Tipografia

```css
/* Rótulos — CAIXA ALTA, peso light. Auto-hospedada (OFL), pesos 300/400/500/600. */
font-family: "Cormorant", serif;  font-weight: 300;  text-transform: uppercase;

/* Títulos de seção — caixa mista, SemiBold. */
font-family: "Cormorant", serif;  font-weight: 600;  text-transform: none;

/* Corpo — kit do Adobe Fonts. */
font-family: "seravek-web", system-ui, sans-serif;  font-weight: 400;
```

O kit entra no `<head>`: `<link rel="stylesheet" href="https://use.typekit.net/czr1bwa.css">`.
Pesos disponíveis da `seravek-web`: 200, 300, 400, 600, 700 — cada um com itálico.

### Logo — qual arquivo onde

- **horizontal** → navbar, em duas versões que se alternam: **branca** enquanto a
  barra está transparente sobre a hero escura, **azul** depois do scroll, quando a
  barra fica clara. No mobile a barra é sempre clara, então vale sempre a azul.
- **símbolo** → marcas d'água e a linha de preceptoria na formação
- **principal / circular / pattern** → só quando pedido explicitamente

### Marcas d'água

Três, todas decorativas (`alt=""`, `aria-hidden`), todas por baixo do texto:

| Onde | Imagem | Tratamento |
|---|---|---|
| Hero | o **símbolo animado**, em claro (`color: var(--papel)`) | altura total da seção, à direita; máscara linear faz a opacidade cair da direita para a esquerda, acompanhando o gradiente azul. No mobile: centralizado, com máscara radial. `logo/simbolo-branco.png` não é usado aqui (mas é, sim, no canto da oncologia) |
| Especialidades | `rm-isolada.webp` | vive **dentro do `.territorio`**: a altura é exatamente a da régua, de "crânio" a "tórax". No desktop começa em `left: 46%`, depois da coluna de texto, e sangra pela direita; no mobile toma a largura da tela em `cover`, como o painel do menu |
| Menu mobile | `rm-pescoco.webp` | o painel inteiro, com o azul em `mix-blend-mode: color` |
| Contato | o próprio símbolo animado | centralizado atrás do texto, `opacity: .085` |

**A ressonância é um duotone gravado no arquivo, não um `filter`.** O `build-assets.sh`
remapeia a luminância para a rampa `#272D3B` → branco com `ImageOps.colorize`, o que
põe a `--tinta` no lugar do preto e tira o cinza neutro da paleta. Aproximar isso com
`filter` no CSS (`sepia` + `hue-rotate`) não acerta um hex. Esse passo precisa de
**Pillow**, como os brasões.

Opacidade: **`.9` no desktop**, **`.22` no mobile**. A do mobile está acima do que o
contraste aguenta — o teto para 4.5:1 ali era `.11`, porque a lista passa por cima da
imagem em toda a largura; a `.22` esse texto fica em ~3.5:1. É uma escolha do dono do
projeto, não um descuido.

**A ressonância da régua usa `rm-isolada.webp`, já recortada do fundo preto.**
Antes era a mesma `rm-pescoco.webp` do menu, com fundo chapado: numa seção clara as
estruturas (que são claras) sumiam e o preto ao redor virava uma mancha cinza — era
a mancha, não a anatomia, o que se via. Com alfa, a imagem entra direto: sem
máscara radial, sem `invert`, sem `mix-blend-mode`. **Não volte a apontar essa marca
d'água para `rm-pescoco.webp`** — o menu continua usando essa, porque lá o painel é
escuro e o fundo preto é justamente o que se quer.

**O fade das bordas são dois gradientes lineares cruzados, não um radial.** O
arquivo corta a anatomia reta em cima, embaixo e à direita, e à esquerda ela
chegaria na coluna de texto: são quatro arestas para apagar. Um `radial-gradient`
que desse conta das quatro comeria o perfil pelo meio. Dois `linear-gradient`
(um horizontal, um vertical) combinados com `mask-composite: intersect` apagam as
quatro bordas sem tocar no centro.

**O bloco de oncologia é verde opaco.** Já foi `color-mix(var(--musgo) 95%,
transparent)`, para o papel subir por baixo e tirar o aspecto chapado — papel que a
elevação (`box-shadow` em três profundidades mais o fio claro na aresta de cima)
agora faz melhor. O verde translúcido clareava: o par com `--musgo-suave` `#DDE3D9`
ficava em 4.77:1, sem folga nenhuma para a marca d'água do canto. Opaco, a mesma
linha dá 4.9:1. Mexer no verde ou no `--musgo-suave` exige remedir.

**A marca do canto da oncologia é `.065`, não os `.085` das outras.** Ancorada a
20px do canto inferior direito, ela cruza a última linha da lista e clareia o
verde; a `.085` esse texto cai para 4.40:1. Os 20px são de tinta, não de caixa: o
PNG tem 12,33% de margem transparente na lateral e 16,46% embaixo, descontados no
`right`/`bottom`.

**Marca d'água atrás de texto muda o contraste, sempre.** Duas vezes isso derrubou
texto abaixo de 4.5:1 e as duas correções estão nos tokens: o texto secundário da
hero usa `--papel-hero` `#D3D8D1` (mais claro, porque o símbolo escurece pontos do
fundo azul) e o `--tinta-suave` foi de `#5C6274` para `#4E5466` (mais escuro, porque
a ressonância escurece o fundo claro das especialidades). Se mexer na opacidade, no
tamanho ou na posição de qualquer marca d'água, **meça o contraste de novo**
amostrando os pixels do fundo renderizado — não confie no valor nominal do token.

### Formas

Botões e pílulas são **totalmente arredondados** (`border-radius: 999px`), em
conversa com o avatar circular do WhatsApp e com os brasões das instituições.
Não volte para cantos retos.

**Todo botão cheio esvazia no hover** — fundo transparente, e o texto e a borda
assumem a cor que era o fundo. Isso só funciona se essa cor contrastar com a
seção: veja a pegadinha do botão verde.

### Movimento

Lento e elegante: as aparições levam **1,6 s** com `--curva-lenta` e sobem 28 px.
Nada de bounce, nada rápido, nada chamativo. É um site médico — a sensação alvo é
seriedade, confiança e respeito. Sempre respeite `prefers-reduced-motion`.

## Conteúdo canônico

Copie daqui literalmente. São registros profissionais: um dígito errado é um problema real.

**Dr. Mario de Geus Neto** — CRM-PR 44.604 · RQE ORL 38.131 · RQE CCP 38.979

Formação:
- Médico pela Pontifícia Universidade Católica do Paraná (PUCPR)
- Otorrinolaringologista pelo Instituto de Assistência Médica ao Servidor Público Estadual de São Paulo (IAMSPE)
- Cirurgião de Cabeça e Pescoço pelo Hospital de Clínicas da Faculdade de Medicina da Universidade de São Paulo (HCFMUSP)
- Doutorando pela Faculdade de Medicina da Universidade de São Paulo (FMUSP)
- Médico assistente e preceptor de ORL e CCP nos Hospitais Cajuru (HUC) e Evangélico Mackenzie (HUEM), em Curitiba-PR

Locais de atendimento:
- **Curitiba-PR**: Hospital Santa Cruz (CEMED) · Hospital Evangélico Mackenzie (convênios e particular)
- **Ponta Grossa-PR**: O1 Saúde · Hospital São Camilo

Contatos: WhatsApp **+55 42 99973-4488** (principal) · Instagram **@drmariodegeus** (secundário,
só na seção de contato).

Em `#contato` são **três botões em duas linhas**: WhatsApp e Instagram
preenchidos lado a lado, e o telefone (`tel:`) embaixo, em `.botao--contorno`
e em corpo normal. A hierarquia é essa mesma: preenchido escuro > preenchido
verde > contorno. O telefone existe porque o público é adulto e idoso e nem
todo mundo escreve; antes o número só existia codificado dentro da URL do
`wa.me` e não havia o que discar. O rótulo "Prefere ligar? …" foge do imperativo
dos outros CTAs por pedido do dono do projeto.

### Link do WhatsApp

Use exatamente este href em todos os CTAs — não remonte a mão:

```
https://wa.me/5542999734488?text=Ol%C3%A1%21%20Gostaria%20de%20agendar%20uma%20consulta%20com%20o%20Dr.%20Mario%20de%20Geus%21
```

**Todo CTA no imperativo** ("Agende sua consulta", "Fale comigo") — nunca "Saiba mais".

## Diretriz editorial

Linguagem séria, respeitosa e gentil. O paciente que chega aqui pode estar assustado
(a lista inclui câncer e tumores) — acolha antes de vender.

O briefing entrega a lista de condições como um despejo clínico. Ela **deve** ser
reorganizada em grupos legíveis para leigo — Ouvido e Audição · Nariz e Seios da Face ·
Garganta, Voz e Vias Aéreas · Cabeça e Pescoço (nódulos, tireoide, glândulas salivares,
oncologia) — explicando primeiro *para que serve* cada especialidade. Um diferencial que
vale destacar: ORL e CCP juntas cobrem praticamente tudo entre o crânio e o tórax, e no
Brasil é raro o mesmo médico ter as duas.

Nunca prometa resultado de tratamento nem cura.

## Assets

`./tools/build-assets.sh` gera, a partir de `assets/`:

- `public/img/<slug>-1600.webp` e `-800.webp` — use em `srcset`. Slugs das fotos citadas
  no briefing: **`hero`** (hero section), **`formacao`** (seção de formação médica),
  **`whatsapp`**. As demais viram `foto-NN`.
- `public/img/hero-mobile-{1400,700}.webp` — a foto da hero **já recortada em
  quadrado**, que é a caixa dela no mobile. A 3:2 inteira só chegava em 800px de
  largura ali e o `cover` jogava fora um terço: sobravam ~533px de foto esticados
  para os ~1200 de um celular retina, e dava para ver. O recorte sai do build
  (`crop=4000:4000:380:0` sobre o original 6000×4000), que é exatamente o que o
  `object-position: 19% 50%` mostrava — por isso o CSS do mobile agora usa
  `object-position: 50% 50%`. Se mudar o enquadramento, mude o `crop`, não o CSS.
- `public/img/whatsapp-320.webp` — quadrada, já enquadrada no rosto, para o botão
  flutuante recortado em círculo, ao lado da frase "Como posso ajudar?".
- `public/img/logo/{horizontal,principal,simbolo,circular}-{azul,branco}.png` e os patterns.
- `public/fonts/Cormorant-{Light,Regular,Medium,SemiBold}.woff2` — quatro pesos.
  O CSS hoje casa 300, 400 e 600; o 500 fica declarado sem uso desde que os
  títulos de seção subiram para SemiBold. Custo zero na rede (nunca é baixado).
- `public/img/inst/{pucpr,iamspe,hcfmusp,fmusp}.png` — brasões das instituições,
  exibidos como ícone circular de fundo branco ao lado de cada formação. O círculo
  e o fundo são feitos em CSS, não estão gravados na imagem.
- `public/img/inst/hosp-{santa-cruz,huem,o1saude,sao-camilo}.png` — as marcas dos
  quatro locais de atendimento, no mesmo disco. Os originais vêm em duas famílias
  e o build trata cada uma de um jeito:
  - **Santa Cruz e São Camilo** são lockups (símbolo + palavra) sobre um branco
    impuro. O quase-branco de baixa saturação é normalizado para branco puro
    (senão vira um quadrado cinza dentro do disco) e o recorte fica **só no
    símbolo** — a 52px a palavra é ilegível e ainda encolhe o símbolo até ele
    sumir ao lado das outras marcas. As caixas foram medidas varrendo as linhas
    com tinta do original até achar a folga que separa símbolo e palavra.
  - **HUEM e O1** são quadrados de cor sangrada. Num disco branco virariam um
    quadrado colorido flutuando; o CSS recorta em círculo
    (`.local__marca--sangra`, sem padding) e a própria cor da marca vira o disco.
  Esse passo precisa de **Pillow** (`pip3 install Pillow`) — é a única parte do
  pipeline que não roda só com as ferramentas do sistema.
- `public/img/rm-isolada.webp` — a mesma ressonância, já recortada do fundo preto
  (com alfa). É a marca d'água da régua nas especialidades.
- `public/img/rm-pescoco.webp` — corte sagital de ressonância do pescoço, com o fundo
  preto original. É a marca d'água do painel do menu mobile, cobrindo a altura toda: o território do próprio
  médico, do crânio ao tórax. O painel **é** a imagem; o azul entra por cima num
  `::before` com `mix-blend-mode: color`, que toma a luminância da ressonância e a
  cor da tinta. O `brightness` no filtro e o `opacity: .8` existem só para o texto
  manter contraste — medido em **6,2:1 no pior pixel** sob os links.

**O botão flutuante some quando o convite final entra na tela.** `#contato`
oferece o mesmo WhatsApp; com ele visível o flutuante é repetição — e, como o
rodapé virou uma faixa estreita, ele passava por cima do nome e dos registros no
celular. A regra está em `marcarFlutuante()`, junto com a da primeira dobra.

**Não há logo dos Hospitais Cajuru (HUC) e Evangélico Mackenzie (HUEM).** Essa
linha da formação usa o símbolo do próprio médico no lugar do brasão — o que
também faz sentido, já que é sobre a prática dele hoje e não sobre um diploma. Se
os brasões aparecerem, troque por eles.

`hero` é a única foto em paisagem — todas as outras são retrato. Só 13 das 100 fotos
foram selecionadas; é uma curadoria, não um acervo incompleto.

## Animação do símbolo

`public/img/simbolo-m.svg` e `simbolo-g.svg` desenham as letras M e G (as iniciais de
Mario de Geus, que formam o símbolo) como se estivessem sendo escritas à mão.

São **assets de origem, não saída de build** — o `build-assets.sh` não os gera. O contorno
veio de vetorização das letras em `assets/instrucoes/animacao-simbolo/`, mas os caminhos de
eixo dentro do `<mask>` foram desenhados à mão sobre a geometria da letra. Para ajustar,
edite o SVG direto.

**As duas letras ocupam a mesma caixa e o mesmo viewBox** (`106 175 787 649`).
Sobrepostas, elas remontam exatamente o símbolo oficial — conferi compondo os dois
arquivos de origem contra `Símbolo Azul.png`. Não as coloque lado a lado, e não
recorte os viewBox individualmente: é a sobreposição que forma o logo.

Como usar:

**Onde ela vive: duas vezes na página.** Na hero, como marca d'água em claro
(`.hero__marca`, `color: var(--papel)`, `opacity: .11`), escrita 0,9s depois do
carregamento para não competir com a entrada do texto; e centralizada em
`#contato`, atrás do convite (`.contato__monograma`, `opacity: .085`), disparada
quando a seção chega. Nenhuma das duas tem seção própria — a assinatura teve, e
foi absorvida. As duas são decorativas: `aria-hidden`, sem `role="img"`.

**As SVGs estão inline no `index.html`, e os arquivos em `public/img/` são só a
fonte.** Editar o `.svg` não muda a página: é preciso recopiar o conteúdo para as
duas ocorrências do HTML. E na cópia da hero os ids de máscara levam sufixo
(`tracado-m-hero`, `tracado-g-hero`), tanto no `id=` quanto no `mask="url(#…)"` —
id de SVG é global no documento e, sem isso, a segunda cópia aponta para a máscara
da primeira.

- **Inline o SVG no HTML** (não `<img>`) — a animação é CSS e precisa do DOM.
- As duas SVGs ficam em `position: absolute; inset: 0` dentro de um container com
  `aspect-ratio: 787 / 649`. Nada de flex nem gap.
- Adicione a classe `escrevendo` ao `<svg>` para disparar. Dispare por
  `IntersectionObserver` quando a seção entrar na tela, não no load.
- A cor vem de `currentColor`. As letras são escuras → **use sobre fundo claro** (`#E5EAE3`).
- **Altura de 90% da seção só no desktop.** Abaixo de 820px a seção fica alta e
  estreita: 90% da altura joga o símbolo para fora dos dois lados e ele deixa de
  ser reconhecível. No mobile quem manda é a largura (`height: auto; width: 88%`),
  e a altura vem do `aspect-ratio`.
- **`opacity: .085` é o teto.** A marca d'água passa por baixo da chamada, que já
  cai de 5.6:1 para 5.0:1 aí. Mexeu na opacidade, remeça.
- Duração no atributo `data-duracao` (M: 2,3 s; G: 2,0 s) — é o JS que lê esse valor
  para encadear as letras. Para a sequência do briefing — M primeiro, depois G — o
  `escrevendo` do G entra quando o M termina. As durações não são gosto: mantêm a
  mesma velocidade de escrita nas duas letras (o M tem ~1970 unidades de traço, o G
  ~1740). Se mudar o `d`, refaça a proporção, senão uma letra sai correndo.
- `prefers-reduced-motion` já está tratado: a letra aparece inteira, sem animação.

**O G é um traço só, e é assim que ele tem de ficar.** Já foram quatro `<path>`
com atrasos encadeados (arco de cima, arco de baixo, perninha, haste) e aquilo
nunca fechou: sobrava um vão de ~31° entre os dois arcos que a máscara não
alcançava, a perninha precisava ser desenhada de trás para frente para não acender
um pedaço órfão da haste, e cada traço a mais era mais um ponto onde a ponta
redonda aparecia antes da hora. Hoje é um `d` contínuo:

```
M 650 250 A 286 286 0 1 0 676 783 L 686 358 L 548 512
```

Começa na ponta de cima do G, desce em sentido anti-horário pela esquerda, dá a
volta por baixo, sobe pela haste da direita e termina na ponta da perninha, no
miolo da letra — a mão nunca levanta do papel. O arco é o círculo de centro
(560, 521) e raio 286; com o pincel de 110 isso dá uma faixa de [231, 341] contra
os [239, 331] que o glifo ocupa. **Rasterizei para conferir: 0 pixel do glifo
fica sem revelar** (o arranjo antigo deixava 15, no vão do canto superior
esquerdo). Se mexer no raio ou no centro, refaça essa medição — a folga é de
menos de 10 unidades de cada lado.

Tem de continuar sendo **um único subpath**: `stroke-dasharray` reinicia a cada
`M`, e é essa emenda que obrigava os atrasos encadeados.

## Pegadinhas

- **O kit do Adobe Fonts é restrito por domínio.** `czr1bwa` só serve a `seravek-web` em
  domínios cadastrados no web project. `localhost` já funciona (verificado), mas **o domínio
  de produção precisa ser adicionado no painel do Adobe Fonts** — senão a fonte cai para o
  fallback silenciosamente, sem erro no console. Confira no browser com
  `document.fonts.check('400 18px "seravek-web"')`.
- A família é **`seravek-web`** (grafia "Seravek"). O briefing escreve "Sevarek" — está errado.
- **Nunca aponte o HTML para `assets/fotos-originais/`**: são 141 MB de JPEG de câmera.
  Só `public/img/`.
- Os arquivos em `assets/` têm acento e parênteses no nome (`Mario_estúdio (79 de 100).jpg`,
  `Símbolo Azul.png`). O pipeline normaliza para slugs ASCII; o HTML usa só os slugs.
- **Ids de SVG colidem se você inlinar o mesmo símbolo duas vezes na página** — o `<mask>`
  do segundo passa a apontar para o do primeiro e a animação quebra. Se precisar repetir,
  torne o id único.
- **O `<style>` de um SVG inline vale para o documento inteiro.** As duas letras
  usam as mesmas classes (`.t1`, `.tracado`), então sem escopo o style do G — que
  vem depois no HTML — vencia para o M também, e o M rodava com a duração do G.
  Por isso cada regra é prefixada por `.simbolo-letra--m` / `--g`. Se acrescentar
  uma terceira letra ou símbolo animado, escope do mesmo jeito.
- `stroke-dasharray` **reinicia a cada subpath** de um `<path>`. Um traço que precisa
  atravessar em sequência tem de ser um `d` contínuo, sem um segundo `M`; se precisar
  mesmo de traços separados, cada um vira um `<path>` com seu próprio `animation-delay`.
- **Dash encostado na ponta do caminho + `stroke-linecap: round` = disco.** Era
  `stroke-dasharray: 1 1` com `stroke-dashoffset: 1`: o dash terminava exatamente no
  ponto 0 do caminho, virava um traço de comprimento zero e a ponta redonda o desenhava
  como um disco do tamanho do pincel. Resultado: pedaços da letra acesos **antes** da
  animação começar, um por traço — muito visível no G, que tinha quatro. Por isso o vão
  agora é `1 1.5` e o recuo `1.01`, que param o traço inteiro fora do caminho. Vale para
  as duas letras; se acrescentar outra, copie esses valores.
- **A navbar assentada é sólida de propósito.** Depois do scroll ela é fixa e cruza
  seções claras e escuras com texto escuro. Qualquer transparência deixa o conteúdo
  de baixo vazar por trás das palavras — foi testado e ficou ilegível.
- **A foto da hero e o gradiente cobrem a seção inteira, de propósito.** Enquanto o
  gradiente vivia dentro da coluna da foto, a borda dessa coluna aparecia como uma
  linha vertical: de um lado ele terminava em `#272D3B` chapado, do outro o fundo
  diagonal da seção estava noutro tom. Cobrindo tudo, não existe encontro possível.
  Não devolva o gradiente para dentro da coluna.
- **Emenda entre duas seções claras exige que as duas resolvam na mesma cor.** O
  fundo da formação terminava em `--papel-frio` e as especialidades são `--papel`
  chapado: os dois se encontravam numa linha horizontal. Tanto o fundo da seção
  quanto o `::after` do painel da foto agora fecham em `--papel` **antes** da borda
  (91–96%, não 100%) — fechar exatamente em 100% ainda deixa um traço na última
  faixa de pixels. Verifique amostrando pixels acima e abaixo da fronteira; a
  variação aceitável é ±1 (nível do grão).
- **Fundo em gradiente aperta o contraste na ponta clara.** O `#locais` desce de
  `#343B49` a `#202329`; a sobrancelha em `--papel-suave` fica justamente no topo,
  o ponto mais claro, e a 4.24:1 reprovava. A ponta clara da rampa é o teto do que
  o texto secundário aguenta ali — se clarear, remeça. Escurecer a ponta **escura**
  é livre: só melhora o texto que estiver embaixo.
- **`flex-basis: 100%` mais `margin` estoura a linha.** No mobile o "Ver no mapa"
  desce para baixo do nome com `flex: 1 0 100%`; a indentação tem de ser `padding`,
  que o `border-box` inclui nos 100%. Com `margin-left` a página ganhou 37px de
  rolagem horizontal.
- **Cuidado com seletores de elemento dentro de um bloco.** `.cidade span` tem
  (0,1,1) e vencia `.local__mapa` (0,1,0), impondo ao rótulo o corpo do texto de
  detalhe. Escopado como `.local__texto > span`. Mesma classe de armadilha da
  navbar assentada, mas por tag em vez de por classe extra.
- **`opacity` em texto é redução de contraste disfarçada.** O "Ver no mapa" a 75%
  de opacidade caía para 3.0:1 sobre o gradiente. Hierarquia se faz com corpo,
  espacejamento e caixa — não baixando a opacidade de texto pequeno.
- **O botão que esvazia no hover tem de vestir a própria cor, não o papel.** O
  `.botao--verde` aparece em dois fundos: a hero (escura) e `#contato` (clara).
  A regra genérica pintava texto e borda de `--papel` no hover — certo na hero,
  e em `#contato` o botão sumia contra o fundo `--papel`. Invisível, não discreto.
  Agora o genérico usa `--musgo` (7.2:1 sobre o papel, 6.1:1 sob a marca d'água
  do monograma) e a hero sobrescreve com `--papel`. Se levar um botão cheio para
  uma seção nova, confira o hover nela — é o estado que ninguém testa.
- **Elemento com fundo próprio engana a medição de contraste.** O harness esconde
  o elemento e amostra o que está atrás; num botão sólido isso remove o próprio
  fundo dele e a razão sai 1.00. Para botões preenchidos vale o valor nominal
  (`--papel` sobre `--tinta`), não a amostra.
- **A verificação por captura tem duas armadilhas, e eu caí nas duas.**
  `page.screenshot({clip})` usa coordenadas de **documento**, não do viewport: sem
  somar `window.scrollX/Y` ao `getBoundingClientRect()`, a amostra vem de outro
  ponto da página e os números parecem plausíveis mesmo estando errados. E a
  captura recortada **de um elemento** (`elemento.screenshot()`) desalinha a camada
  de grão, que é `position: fixed`: aparece um degrau horizontal fantasma perto do
  pé do recorte. Para conferir emenda ou gradiente, capture o **viewport** inteiro.
- **Ler `getComputedStyle` logo depois de acrescentar `.revela--visivel` devolve
  `opacity: 0`** — a transição leva 1,6s. Espere antes de medir, ou toda medida de
  contraste sai como 1.00.
- **A rampa da hero tem ~22 paradas.** Não é exagero: com poucas paradas o degrau
  volta a aparecer como faixa. O grão também ajuda a mascarar banding.
- **O médico é deslocado por `transform: translateX`, não por `object-position`.**
  A imagem é mais estreita em proporção que o container, então não há corte lateral
  e `object-position-x` é inerte ali. A faixa sem imagem à direita cai onde o
  gradiente já é azul opaco.
- No mobile `.hero__retrato` precisa ser `position: relative`. Com `static`, o
  `::after` de `inset: 0` se ancorava na hero inteira e a foto cortava numa linha dura.
- No desktop a foto da formação é **plano de fundo**, não retrato em destaque — vai
  sob um véu leve mais um gradiente que a dissolve na borda que encosta no texto.
  **No mobile ela não aparece**: sem largura para funcionar como plano de fundo, ela
  virava um retrato solto que não somava nada.
- `max-width` numa `.envelope` **centraliza a coluna**, porque a `.envelope` tem
  `margin-inline: auto`. Para alinhar texto à esquerda dentro dela, use um filho
  (`.formacao__corpo`), não as duas classes no mesmo elemento.
- `<picture>` não herda altura: para uma foto de `height: 100%` funcionar, o
  `<picture>` também precisa de `height: 100%`, senão o `img` resolve contra `auto`.
- **A navbar clara escurece os links do menu.** `.navbar--assentada .menu__lista a`
  tem especificidade (0,2,1); no mobile o painel aberto é escuro e precisa de um
  seletor de **mesma** especificidade para devolver o claro — `.menu__lista a`
  sozinho perde e o texto some no fundo.
- As animações só escondem conteúdo quando a classe `js` está no `<html>` (um script
  inline no `<head>` a coloca). Sem JS a página nasce inteira e visível — confira isso
  antes de mexer nas regras `.entra` / `.revela`.
- **O perigo não é o JS desligado, é o JS meio quebrado.** Com o JS desligado a
  classe `js` nunca entra e a página nasce inteira. Mas com o JS ligado e o
  `site.js` falhando (404, exceção, rede), a classe entra, os 31 blocos ficam em
  `opacity: 0` e nada nunca os revela: a página serve **em branco**. Por isso
  existem três coisas que não devem ser removidas: o `setTimeout` de 3s no
  `<head>`, que tira a classe `js` se o `data-animado` não tiver sido marcado; o
  `document.documentElement.setAttribute('data-animado', '')` como **primeira
  linha** do `site.js`; e o helper `protegido()`, que põe cada bloco
  independente em `try/catch` para que uma falha no menu não derrube a
  revelação. Se acrescentar um bloco novo ao `site.js`, embrulhe nele.
- **A foto da hero não leva `entra`, e isso é sobre métrica.** Ela é o elemento
  de LCP, e o Chrome só o contabiliza quando fica visível: com `opacity: 0` e
  transição de 1,6s, o `fetchpriority="high"` trazia o byte cedo e a própria
  animação segurava a métrica por 1,6s. O texto ao lado continua entrando
  escalonado; a foto nasce pronta. Não devolva a classe.
- **Existe `@media print`.** Sem ele, imprimir sai em branco: o que não foi
  rolado continua em `opacity: 0`, porque o observador só revela o que entrou na
  tela. O bloco força opacidade 1, esconde flutuante/navbar/marcas d'água e
  imprime o `href` de cada endereço ao lado do nome.
