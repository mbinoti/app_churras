# Documento de requisitos — app_churras

Versão 1.1 — fluxo centrado no planejamento

## 1. Objetivo do produto

Ajudar pessoas a planejar churrascos, aniversários e encontros informando a quantidade de adultos e crianças e recebendo uma estimativa de carnes, bebidas, acompanhamentos e materiais. O app também organiza compras, tarefas, responsáveis e custos.

O usuário deve conseguir começar pela Home, sem precisar criar ou nomear um evento previamente.

## 2. Problema que o app resolve

Organizadores costumam calcular compras manualmente, esquecer itens, comprar quantidades inadequadas e concentrar tarefas e custos em uma única pessoa. O app transforma essas decisões em um planejamento visual, ajustável e compartilhável.

## 3. Público-alvo

- Pessoas organizando churrascos domésticos.
- Organizadores de aniversários e encontros informais.
- Famílias e grupos de amigos.
- Pessoas que preferem uma alternativa simples a planilhas.

Premissa do MVP: encontros de pequeno e médio porte, de 2 a 100 participantes.

## 4. Stakeholders

| Stakeholder | Interesse |
|---|---|
| Organizador | Calcular, revisar e coordenar o planejamento |
| Convidado adulto | Participar, assumir tarefas e contribuir com custos |
| Convidado criança | Ser considerado nos cálculos de consumo |
| Responsável por compras | Usar a lista consolidada |
| Responsável por item ou tarefa | Saber o que deve levar ou fazer |
| Grupo de convidados | Ter transparência sobre responsabilidades e valores |
| Equipe de produto | Construir, testar e evoluir o app |

## 5. Conceito central e fluxo principal

O objeto principal do produto é o **Planejamento**. “Evento” pode existir futuramente como um nome, data ou registro salvo, mas não é obrigatório para iniciar o uso.

Fluxo principal:

`Home → informar participantes → escolher categorias → calcular → revisar quantidades → organizar compras, tarefas e custos`

### Home

A Home deve permitir:

- informar quantidade de adultos;
- informar quantidade de crianças;
- selecionar o tipo de encontro, opcionalmente;
- selecionar o que será calculado;
- iniciar o cálculo;
- continuar um planejamento salvo, quando existir.

## 6. Escopo do MVP

### Incluído

- Planejamento iniciado diretamente pela Home.
- Cadastro rápido de adultos e crianças, inicialmente por quantidade e, quando necessário, por nome.
- Cálculo de carnes, bebidas e acompanhamentos.
- Inclusão de itens personalizados, como pão francês, vinagrete e farofa.
- Ajuste manual das quantidades.
- Lista de compras agrupada por categoria.
- Registro de quem levará cada item.
- Divisão e acompanhamento de tarefas.
- Registro de preços e rateio igualitário dos custos.
- Resumo de pendências.
- Salvamento local do planejamento, sem cadastro obrigatório.

### Fora do MVP

- Pagamentos dentro do app.
- Compra direta em supermercados.
- Integração obrigatória com WhatsApp.
- Preços em tempo real.
- Recomendações baseadas em histórico ou inteligência artificial.
- Gestão de fornecedores.
- Eventos recorrentes.

## 7. Funcionalidades principais

1. **Calculadora inicial:** recebe adultos, crianças e categorias desejadas.
2. **Resultado do planejamento:** mostra quantidades sugeridas e permite ajustes.
3. **Itens personalizados:** permite adicionar produtos que não estão no catálogo.
4. **Lista de compras:** consolida itens, quantidades, unidades e status.
5. **Responsáveis:** informa quem levará cada item.
6. **Tarefas:** distribui atividades e controla sua conclusão.
7. **Custos:** registra preços e calcula o rateio.
8. **Resumo:** mostra participantes, compras, tarefas, itens sem responsável e valores pendentes.

## 8. Requisitos funcionais

### Entrada e planejamento

- **RF-01** O sistema deve permitir informar a quantidade de adultos na Home.
- **RF-02** O sistema deve permitir informar a quantidade de crianças na Home.
- **RF-03** O sistema deve permitir selecionar categorias de cálculo.
- **RF-04** O sistema deve permitir iniciar um planejamento sem cadastro de usuário ou evento.
- **RF-05** O sistema deve permitir informar opcionalmente o tipo, nome ou data do encontro.
- **RF-06** O sistema deve permitir continuar um planejamento salvo localmente.

### Cálculos e itens

- **RF-07** O sistema deve calcular quantidades sugeridas com base nos participantes confirmados.
- **RF-08** O sistema deve exibir carnes, bebidas e acompanhamentos em categorias separadas.
- **RF-09** O sistema deve permitir adicionar itens personalizados.
- **RF-10** O sistema deve permitir editar quantidade e unidade de um item.
- **RF-11** O sistema deve preservar ajustes manuais durante novos cálculos, solicitando confirmação quando houver conflito.
- **RF-12** O sistema deve permitir remover itens do planejamento.

### Lista de compras

- **RF-13** O sistema deve gerar uma lista agrupada por categoria.
- **RF-14** O sistema deve permitir marcar itens como planejados, comprados ou entregues.
- **RF-15** O sistema deve permitir registrar preço estimado e preço real.
- **RF-16** O sistema deve calcular o total dos preços informados.

### Pessoas, itens e tarefas

- **RF-17** O sistema deve permitir cadastrar nomes de convidados quando for necessário dividir tarefas ou custos.
- **RF-18** O sistema deve permitir associar um convidado a um item que ele levará.
- **RF-19** O sistema deve exibir itens sem responsável.
- **RF-20** O sistema deve permitir criar, atribuir e concluir tarefas.
- **RF-21** O sistema deve exibir tarefas agrupadas por responsável e status.

### Custos

- **RF-22** O sistema deve permitir selecionar os participantes elegíveis para o rateio.
- **RF-23** O sistema deve calcular o valor individual no rateio igualitário.
- **RF-24** O sistema deve permitir ajustar manualmente a contribuição de uma pessoa.
- **RF-25** O sistema deve indicar valores pagos, pendentes e diferenças entre contribuições e custo total.

## 9. Requisitos não funcionais

- **RNF-01 — Usabilidade:** o usuário deve conseguir informar participantes e obter uma primeira estimativa em até 2 minutos.
- **RNF-02 — Desempenho:** o resultado do cálculo deve ser exibido em até 2 segundos após a confirmação dos dados.
- **RNF-03 — Persistência:** alterações confirmadas devem permanecer após fechar e reabrir o app.
- **RNF-04 — Offline:** o cálculo e a consulta de um planejamento salvo devem funcionar sem conexão no MVP.
- **RNF-05 — Integridade:** o sistema não deve aceitar quantidades negativas ou valores financeiros inválidos.
- **RNF-06 — Privacidade:** o cadastro de nomes deve ser opcional e limitado ao necessário para o planejamento.
- **RNF-07 — Acessibilidade:** controles devem ter rótulos claros e suportar o tamanho de texto definido pelo sistema operacional.
- **RNF-08 — Testabilidade:** as regras de cálculo e rateio devem ser separadas da interface e cobertas por testes automatizados.

## 10. Regras de negócio

### Participantes

- **RB-01:** somente participantes confirmados entram no cálculo.
- **RB-02:** adulto equivale a peso de consumo 1,0.
- **RB-03:** criança equivale a peso de consumo 0,5.
- **RB-04:** o usuário pode alterar manualmente a categoria de consumo de uma criança.

### Carnes

- **RB-05:** quantidade-base de carne: 400 g por adulto.
- **RB-06:** quantidade-base de carne: 200 g por criança.
- **RB-07:** fórmula: `adultos × 400 g + crianças × 200 g`.
- **RB-08:** o total deve ser arredondado conforme a unidade de compra configurada.
- **RB-09:** o total pode ser distribuído entre tipos de carne por percentuais definidos pelo usuário.

### Bebidas e acompanhamentos

- **RB-10:** bebida não alcoólica: 600 ml por adulto e 500 ml por criança.
- **RB-11:** água deve ser calculada separadamente, inicialmente a 500 ml por participante.
- **RB-12:** bebida alcoólica só deve ser calculada para pessoas marcadas como consumidoras.
- **RB-13:** pão, farofa, vinagrete e demais acompanhamentos devem ter parâmetros configuráveis.
- **RB-14:** itens sem regra automática devem aceitar quantidade manual.

### Custos

- **RB-15:** custo total é a soma dos preços registrados.
- **RB-16:** rateio igualitário divide o custo entre participantes elegíveis.
- **RB-17:** crianças ficam fora do rateio por padrão.
- **RB-18:** o organizador pode incluir ou excluir participantes do rateio.
- **RB-19:** itens levados por convidados podem ser registrados como contribuição.
- **RB-20:** diferenças de arredondamento devem ser exibidas e atribuídas conforme configuração.

## 11. Histórias de usuário

- **HU-01:** Como usuário, quero informar adultos e crianças na Home para obter uma estimativa sem criar um evento.
- **HU-02:** Como usuário, quero escolher as categorias que desejo calcular para receber somente informações relevantes.
- **HU-03:** Como usuário, quero adicionar pão, vinagrete, farofa e itens personalizados para completar meu planejamento.
- **HU-04:** Como usuário, quero ajustar as quantidades sugeridas para adequá-las aos hábitos do meu grupo.
- **HU-05:** Como responsável por compras, quero uma lista agrupada por categoria para comprar os itens com facilidade.
- **HU-06:** Como organizador, quero cadastrar nomes somente quando necessário para dividir tarefas e custos.
- **HU-07:** Como organizador, quero registrar quem levará cada item para evitar duplicidades e faltas.
- **HU-08:** Como convidado, quero visualizar e assumir uma tarefa.
- **HU-09:** Como organizador, quero dividir os custos e visualizar valores pendentes.
- **HU-10:** Como usuário, quero salvar o planejamento para continuar depois sem refazer os cálculos.

## 12. Critérios de aceitação principais

### Entrada pela Home

- Dado que o usuário abriu o app, ele deve conseguir informar adultos e crianças sem criar um evento.
- Com 5 adultos e 3 crianças, o sistema deve calcular usando 5 adultos e 3 crianças confirmados.
- Se nenhuma pessoa for informada, o sistema deve impedir o cálculo e exibir uma mensagem orientativa.

### Cálculos

- Para 5 adultos e 3 crianças, a quantidade-base de carne deve ser 2,6 kg antes do arredondamento.
- O resultado deve apresentar categoria, item, quantidade e unidade.
- Após ajuste manual, um novo cálculo não deve sobrescrever o valor sem confirmação.

### Organização

- O usuário deve conseguir transformar o resultado em lista de compras.
- Itens sem responsável devem aparecer em uma lista de pendências.
- Uma tarefa atribuída deve aparecer para o respectivo responsável.

### Custos

- O sistema deve dividir o custo total entre os participantes selecionados.
- A soma das contribuições deve ser comparada ao custo total.
- O sistema deve informar se existe saldo pendente ou valor excedente.

### Persistência

- Ao reabrir o app, o usuário deve conseguir recuperar o planejamento salvo.
- O usuário deve poder iniciar um novo planejamento sem apagar os anteriores.

## 13. Riscos e dúvidas em aberto

| ID | Dúvida | Impacto |
|---|---|---|
| D-01 | O MVP será apenas local ou terá compartilhamento entre celulares? | Alto |
| D-02 | O planejamento será salvo automaticamente ou somente quando o usuário solicitar? | Médio |
| D-03 | O rateio inicial será somente igualitário? | Alto |
| D-04 | O usuário poderá personalizar os parâmetros de consumo por planejamento? | Alto |
| D-05 | Como outra pessoa acessará tarefas e custos sem login? | Alto |
| D-06 | O app terá Android, iOS ou ambos no primeiro lançamento? | Médio |
| D-07 | O tipo de encontro altera automaticamente as quantidades? | Médio |
| D-08 | O usuário poderá editar nomes depois de iniciar o planejamento? | Baixo |

## 14. Backlog priorizado — MoSCoW

### Must have

1. Home com quantidade de adultos e crianças.
2. Seleção de categorias de cálculo.
3. Cálculo de carnes, bebidas e acompanhamentos.
4. Inclusão de itens personalizados.
5. Ajuste manual das quantidades.
6. Lista de compras.
7. Salvamento local do planejamento.
8. Cadastro opcional de nomes.
9. Associação de responsáveis a itens.
10. Criação e conclusão de tarefas.
11. Registro de preços.
12. Rateio igualitário configurável.
13. Resumo de pendências.

### Should have

1. Compartilhamento por código ou link.
2. Mais de um organizador.
3. Parâmetros de consumo editáveis.
4. Exportação da lista de compras.
5. Lembretes de tarefas.
6. Duplicação de planejamento anterior.

### Could have

1. Integração com WhatsApp.
2. Rateio proporcional ao consumo.
3. Histórico de planejamentos.
4. Integração com preços de mercados.
5. Temas para diferentes tipos de encontro.

### Won’t have no MVP

1. Pagamentos dentro do app.
2. Compra automática de produtos.
3. Marketplace de fornecedores.
4. Recomendações por inteligência artificial.
5. Programa de fidelidade.

## Decisões recomendadas para iniciar a implementação

- Usar **Planejamento** como conceito interno, sem tela obrigatória de cadastro de evento.
- Começar com cálculo local e salvamento local.
- Usar rateio igualitário no MVP.
- Solicitar nomes somente ao entrar em tarefas, responsáveis ou custos.
- Implementar primeiro este fluxo vertical: `Home → cálculo de carnes → resultado → salvar planejamento`.

