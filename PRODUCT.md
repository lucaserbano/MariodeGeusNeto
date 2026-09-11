# Product

## Register

brand

## Users

Pacientes e potenciais pacientes do Dr. Mario de Geus Neto, otorrinolaringologista
e cirurgião de cabeça e pescoço em Curitiba e Ponta Grossa (PR).

Chegam por três caminhos, com estados emocionais muito diferentes:

- **Encaminhados com uma suspeita.** Saíram de outra consulta com a palavra
  "nódulo", "massa" ou "tumor" escrita num pedido de exame. Estão assustados e
  procurando saber se este médico entende do assunto. É o visitante de maior
  valor e o mais frágil.
- **Buscando alívio de algo crônico e chato.** Ronco, obstrução nasal, zumbido,
  rouquidão, tontura, otite de repetição. Já tentaram outras coisas. Querem
  reconhecer o próprio sintoma numa lista.
- **Conferindo credenciais.** Viram o nome no Instagram, num convênio ou numa
  indicação. Vão direto para formação e locais de atendimento.

Contexto de uso: majoritariamente celular, muitas vezes à noite, às vezes na sala
de espera de outro médico. Raramente num desktop com tempo.

O trabalho a ser feito: **decidir se vale a pena marcar com este médico, e marcar
sem fricção**. O site não diagnostica nem informa: ele qualifica e encaminha.

## Product Purpose

Página única institucional com dois objetivos, nessa ordem:

1. **Acolher.** Quem chega pode estar com medo. A página precisa devolver
   competência e calma antes de pedir qualquer coisa.
2. **Converter em agendamento pelo WhatsApp.** Todo CTA leva ao mesmo número,
   com mensagem pré-escrita. O Instagram é secundário.

Sucesso é uma conversa iniciada no WhatsApp. Não há formulário, cadastro, login
ou funil: o site é uma ponte curta entre a dúvida e a mensagem enviada.

O diferencial a comunicar: ORL e CCP na mesma pessoa cobrem praticamente tudo
entre o crânio e o tórax, e no Brasil é raro o mesmo médico ter as duas
residências. Isso não é dito como vantagem competitiva; é desenhado (a régua
anatômica das especialidades).

## Brand Personality

**Direta, competente, próxima.**

Voz: séria, respeitosa, gentil. Explica primeiro *para que serve* cada
especialidade, depois lista as condições. Nunca promete resultado nem cura. Fala
com um leigo adulto sem infantilizar e sem despejar nomenclatura clínica crua.

Emoção alvo, na ordem em que a página entrega: segurança → reconhecimento ("é
disso que eu tenho") → confiança para escrever.

Todo CTA no imperativo ("Agende sua consulta", "Fale comigo"), nunca "Saiba mais".

## Anti-references

Três coisas que este site não pode parecer:

- **Clínica popular / plantão.** Selos, banners coloridos, urgência fabricada,
  preço em destaque. Barateia a percepção de um especialista com doutorado e
  duas residências.
- **Healthtech / startup de saúde.** Azul-ciano, ilustração vetorial de gente
  sorrindo, grade de cards idênticos, linguagem de produto. Tira a pessoa do
  centro e põe a plataforma.
- **Template de consultório.** Stock photo de estetoscópio, ícones genéricos,
  "Sobre nós / Nossos serviços / Contato". Indistinguível de mil outros sites e
  não comunica nada específico deste médico.

Também fora: tipografia gigante e scroll experimental de portfólio de designer.
O efeito não pode chamar atenção para si.

## Design Principles

1. **Acolher antes de vender.** A lista inclui câncer. Quem lê pode estar no pior
   dia do ano. Nenhum elemento pode soar como venda antes de ter oferecido calma.
2. **O território é o argumento.** "Praticamente todas as afecções entre o crânio
   e o tórax" é a frase do próprio médico. A seção de especialidades é essa frase
   desenhada: uma régua vertical descendo o corpo, não uma grade de cards.
3. **Um dígito errado é um problema real.** CRM, RQE, nomes de instituição e
   número de WhatsApp são registros profissionais. Conteúdo canônico se copia,
   não se reescreve.
4. **O ritmo é claro/escuro.** A alternância de fundo entre seções é a espinha da
   página. Qualquer seção nova entra nesse ritmo ou o quebra.
5. **Movimento lento ou nenhum.** 1,6s, sem bounce, sem nada rápido. A sensação
   alvo é seriedade. `prefers-reduced-motion` sempre respeitado.

## Accessibility & Inclusion

**WCAG 2.1 AA.** 4.5:1 em texto corrido, 3:1 em texto grande. É o alvo que o CSS
já persegue: existem tokens derivados (`--tinta-suave`, `--papel-suave`,
`--papel-hero`, `--musgo-suave`) que existem só por causa de medições de
contraste, e cada um está documentado com o número que o gerou.

Regras que vêm disso e não se negociam:

- `--pedra` (`#88857C`) nunca volta para texto pequeno: dá 3.0:1 no claro.
- Marca d'água atrás de texto muda o contraste. Mexeu em opacidade, tamanho ou
  posição de qualquer uma, mede de novo amostrando o pixel renderizado.
- Hierarquia não se faz baixando `opacity` de texto.
- `prefers-reduced-motion: reduce` tem alternativa em toda animação, incluindo as
  três partes da revelação por região nas especialidades.

Exceção conhecida e deliberada do dono do projeto: a ressonância de fundo das
especialidades fica a `.22` no mobile, acima do teto de `.11` que 4.5:1 pediria.
O texto por cima fica em ~3.5:1. Está registrado como escolha, não como descuido.

Público majoritariamente adulto e idoso: corpo de texto generoso, alvos de toque
grandes, nada que dependa de hover para funcionar.
