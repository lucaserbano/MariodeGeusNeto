/* Dr. Mario de Geus Neto — comportamento da página.
   Tudo aqui é progressivo: sem JS a página continua legível e navegável. */

(function () {
  'use strict';

  /* Primeira linha de todas: avisa ao temporizador do <head> que o script
     chegou vivo. Qualquer exceção daqui para baixo ainda deixa a página
     escondida, então os blocos independentes abaixo vão em try/catch. */
  document.documentElement.setAttribute('data-animado', '');

  /* Cada bloco é independente: uma falha no menu não pode impedir a revelação
     do conteúdo. */
  function protegido(nome, fn) {
    try { fn(); } catch (e) {
      if (window.console) console.error('site.js: falha em ' + nome, e);
    }
  }

  var paradoNaquieta = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ── navbar: ganha fundo depois que a hero sai ───────────── */
  var navbar = document.getElementById('navbar');
  var ultimoY = -1;

  function marcarNavbar() {
    var y = window.scrollY;
    if (y === ultimoY) return;
    ultimoY = y;
    navbar.classList.toggle('navbar--assentada', y > 40);
  }

  /* ── whatsapp flutuante: entra depois da primeira dobra ──── */
  var flutuante = document.getElementById('flutuante');
  var secaoContato = document.getElementById('contato');

  function marcarFlutuante() {
    var passouDobra = window.scrollY > window.innerHeight * 0.6;
    /* O convite final oferece o mesmo botão. Com ele na tela o flutuante vira
       ruído — e, como o rodapé agora é uma faixa estreita, ele passaria por
       cima do nome e dos registros no celular. */
    var r = secaoContato.getBoundingClientRect();
    var conviteNaTela = r.top < window.innerHeight * 0.75 && r.bottom > 0;
    flutuante.classList.toggle('flutuante--visivel', passouDobra && !conviteNaTela);
  }

  var pendente = false;
  protegido('scroll', function () {
    window.addEventListener('scroll', function () {
      if (pendente) return;
      pendente = true;
      requestAnimationFrame(function () {
        marcarNavbar();
        marcarFlutuante();
        pendente = false;
      });
    }, { passive: true });
    marcarNavbar();
    marcarFlutuante();
  });

  /* ── menu mobile ─────────────────────────────────────────── */
  var botaoMenu = document.getElementById('menu-botao');
  var menu = document.getElementById('menu');

  function fecharMenu() {
    botaoMenu.setAttribute('aria-expanded', 'false');
    menu.classList.remove('menu--aberto');
    navbar.classList.remove('navbar--menu-aberto');
    document.body.style.overflow = '';
  }

  protegido('menu', function () {
    botaoMenu.addEventListener('click', function () {
      var aberto = botaoMenu.getAttribute('aria-expanded') === 'true';
      if (aberto) { fecharMenu(); return; }
      botaoMenu.setAttribute('aria-expanded', 'true');
      menu.classList.add('menu--aberto');
      navbar.classList.add('navbar--menu-aberto');
      document.body.style.overflow = 'hidden';
    });

    menu.addEventListener('click', function (e) {
      if (e.target.closest('a')) fecharMenu();
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && botaoMenu.getAttribute('aria-expanded') === 'true') {
        fecharMenu();
        botaoMenu.focus();
      }
    });
  });

  /* ── entrada da hero: encadeada, lenta ───────────────────── */
  var entradas = document.querySelectorAll('.entra');
  Array.prototype.forEach.call(entradas, function (el) {
    var passo = parseInt(el.getAttribute('data-atraso') || '0', 10);
    el.style.transitionDelay = (passo * 0.11) + 's';
  });

  requestAnimationFrame(function () {
    requestAnimationFrame(function () {
      Array.prototype.forEach.call(entradas, function (el) {
        el.classList.add('entra--dentro');
      });
    });
  });

  /* ── revelação no scroll ─────────────────────────────────── */
  var alvos = document.querySelectorAll('.revela');

  if (!('IntersectionObserver' in window)) {
    Array.prototype.forEach.call(alvos, function (el) { el.classList.add('revela--visivel'); });
  } else {
    var observador = new IntersectionObserver(function (registros) {
      registros.forEach(function (r) {
        if (!r.isIntersecting) return;
        r.target.classList.add('revela--visivel');
        observador.unobserve(r.target);
      });
    }, { rootMargin: '0px 0px -12% 0px', threshold: 0.05 });

    Array.prototype.forEach.call(alvos, function (el) { observador.observe(el); });
  }

  /* ── o símbolo: o M é escrito, depois o G ────────────────── */
  /* Duas ocorrências na página: a marca d'água da hero e o convite final.
     A da hero já nasce na tela e é escrita com um respiro, depois do texto
     entrar; a do contato espera a seção chegar. */
  function escreverSimbolo(container, atrasoInicial) {
    var letras = container.querySelectorAll('svg.simbolo-letra');
    var acumulado = atrasoInicial || 0;
    Array.prototype.forEach.call(letras, function (svg) {
      var dur = parseFloat(svg.getAttribute('data-duracao') || '1.7');
      window.setTimeout(function () { svg.classList.add('escrevendo'); }, acumulado * 1000);
      acumulado += dur * 0.98; /* o G só começa quando o M termina */
    });
  }

  function prepararSimbolo(container, atrasoInicial, limiar) {
    if (!container) return;
    if (paradoNaquieta || !('IntersectionObserver' in window)) {
      var letras = container.querySelectorAll('svg.simbolo-letra');
      Array.prototype.forEach.call(letras, function (svg) { svg.classList.add('escrevendo'); });
      return;
    }
    var olho = new IntersectionObserver(function (registros) {
      registros.forEach(function (r) {
        if (!r.isIntersecting) return;
        escreverSimbolo(container, atrasoInicial);
        olho.unobserve(r.target);
      });
    }, { threshold: limiar });
    olho.observe(container);
  }

  /* a marca da hero é alta e larga: exigir 55% dela na tela nunca fecharia
     em telas baixas, então o limiar aqui é menor */
  protegido('símbolo', function () {
    prepararSimbolo(document.getElementById('monograma-hero'), 0.9, 0.2);
    prepararSimbolo(document.getElementById('monograma'), 0, 0.45);
  });
})();
