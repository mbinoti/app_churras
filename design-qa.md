# Design QA — Sprint 1

## Referências e capturas

- Home: `docs/images/inicio.jpg` — 645 × 1600 px.
- Planejamento: `docs/images/configurar evento.jpg` — 645 × 1600 px.
- Home populada implementada: `test/design-qa/home-implementation.png` — 645 × 1600 px.
- Planejamento implementado: `test/design-qa/planning-implementation.png` — 645 × 1600 px.
- Captura adicional da Home no simulador iPhone 17 Pro Max: `/tmp/churras-home.png` — 1320 × 2868 px, incluindo a moldura/status do simulador.

## Estado comparado

As capturas de QA usam a mesma viewport lógica de 645 × 1600 px e dados locais de exemplo para comparar a Home populada e o formulário de planejamento. A captura real do simulador também foi inspecionada para validar a Home em execução.

## Resultado da comparação

- Tipografia: hierarquia, peso visual e textos principais foram aproximados; a implementação mantém os textos em português exigidos pelo produto.
- Espaçamento e layout: margens amplas, banner principal, cards arredondados, seções e navegação inferior seguem a composição das referências.
- Cores: fundo rosado claro, vermelho escuro da marca, laranja das ações e tons terrosos foram convertidos em tokens do tema Flutter.
- Imagens: o cabeçalho usa avatar local e o planejamento usa fotografia local de churrasco em card com overlay, mantendo a direção visual das referências.
- Ícones: navegação, configurações, fogo, participantes, duração e histórico usam ícones Material consistentes e com alvos de toque adequados.
- Conteúdo: Compras, Tarefas e Custos continuam placeholders por decisão de escopo da Sprint 1; Home e Planejamento são funcionais.
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

## Resultado final

final result: passed
