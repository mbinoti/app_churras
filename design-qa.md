# Design QA — Referências visuais do app

## Referências e capturas

- Home: `docs/images/inicio.jpg` — 645 × 1600 px.
- Planejamento: `docs/images/configurar evento.jpg` — 645 × 1600 px.
- Home populada implementada: `test/design-qa/home-implementation.png` — 645 × 1600 px.
- Planejamento implementado: `test/design-qa/planning-implementation.png` — 645 × 1600 px.
- Captura atual da Home no simulador iPhone 17 Pro Max: `/tmp/churras-home-current.png` — captura real com status bar e navegação do simulador.

## Estado comparado

As capturas de referência foram usadas para alinhar Home, Planejamento, Compras, Tarefas e Custos. A captura real do simulador foi inspecionada para validar a Home em execução; os fluxos das outras abas foram cobertos pelos testes de widgets com dados locais.

## Resultado da comparação

- Tipografia: hierarquia, peso visual e textos principais foram aproximados; a implementação mantém os textos em português exigidos pelo produto.
- Espaçamento e layout: margens amplas, banner principal, cards arredondados, seções e navegação inferior seguem a composição das referências.
- Cores: fundo rosado claro, vermelho escuro da marca, laranja das ações e tons terrosos foram convertidos em tokens do tema Flutter.
- Imagens: o cabeçalho usa avatar local e o planejamento usa fotografia local de churrasco em card com overlay, mantendo a direção visual das referências.
- Ícones: navegação, configurações, fogo, participantes, duração e histórico usam ícones Material consistentes e com alvos de toque adequados.
- Conteúdo: Compras, Tarefas e Custos agora possuem telas funcionais com dados locais, controles de seleção e ações principais.
- Responsividade: o dropdown de tipo foi configurado como expandido após a captura encontrar overflow em viewport móvel.

## Diferenças aceitáveis

- A referência da Home contém eventos, custos e participantes confirmados; a aplicação não inventa custos e mostra estado vazio quando a base local ainda não possui eventos.
- Avatar e fotografia são assets locais gerados para aproximar a direção visual, não reproduções das pessoas presentes nas referências.
- A referência usa rótulos em inglês na navegação, mas o produto exige interface em português; os rótulos foram mantidos em português.

## Histórico de correções

1. A primeira captura do novo layout encontrou pequenos overflows no banner da Home e no card de evento; as alturas foram ajustadas.
2. O formulário inicialmente não era totalmente materializado no teste por ser uma lista lazy; foi trocado por uma rolagem simples, adequada ao tamanho do formulário.
3. O campo de tipo apresentou overflow em duas colunas; `isExpanded: true` eliminou o clipping.
4. A captura posterior não apresentou novos problemas P0, P1 ou P2.
5. O tema global foi alinhado ao fundo rosado, vermelho da marca, laranja de ação, cards arredondados e navegação inferior das referências.
6. Os cards e banners foram redimensionados em pixels lógicos para preservar a navegação em viewport móvel sem overflow.
7. A captura real do simulador confirmou a composição da Home com cabeçalho, saudação, CTA, evento e navegação inferior.

## Resultado final

final result: passed
