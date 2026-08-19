# Churras Fácil — Pacote de Requisitos

Versão: 0.1  
Status: base para desenvolvimento do MVP  
Método: RE@Agile com práticas de Engenharia de Requisitos

## 1. Visão do produto

O Churras Fácil é um aplicativo mobile para planejar churrascos, aniversários e encontros. O produto ajuda o organizador a definir convidados e cardápio, estimar quantidades e custos, gerar uma lista de compras, distribuir tarefas e acompanhar despesas.

## 2. Problema

Quem organiza um churrasco costuma ter dificuldade para:

- estimar a quantidade correta de comida e bebida;
- lembrar itens complementares, como gelo, carvão e descartáveis;
- dividir compras e tarefas entre os convidados;
- controlar quem pagou e quem ainda deve;
- revisar o planejamento antes do evento.

## 3. Objetivo do MVP

Permitir que um organizador crie um evento, informe os participantes, selecione ou cadastre itens, obtenha uma estimativa, revise um resumo, acompanhe as compras, organize tarefas e registre custos.

## 4. Público e atores

### 4.1 Organizador

Pessoa responsável por criar e administrar o evento. Pode editar o planejamento, atribuir tarefas e registrar despesas.

### 4.2 Convidado

Participante do evento. No MVP pode ser apenas contabilizado; em versão posterior poderá confirmar presença, assumir tarefas e visualizar o rateio.

### 4.3 Sistema

Calcula estimativas, atualiza totais, mantém status e apresenta pendências.

## 5. Escopo do MVP

### Incluído

- Início com próximos e eventos recentes;
- criação, edição, salvamento e exclusão de evento;
- cadastro separado de adultos e crianças;
- data, duração e tipo do evento;
- seleção de itens do catálogo;
- inclusão de itens personalizados;
- cálculo estimado de quantidade e custo;
- resumo por categoria;
- lista de compras com progresso;
- tarefas com responsável e status;
- registro de despesas;
- visão de total, pago e pendente;
- navegação por Início, Compras, Tarefas e Custos;
- persistência local dos dados.

### Fora do MVP

- login e autenticação;
- sincronização em nuvem;
- convite por link ou WhatsApp;
- confirmação online dos convidados;
- pagamentos dentro do app;
- integração com supermercados;
- notificações push;
- recomendação baseada em histórico ou IA.

## 6. Fluxo principal

1. Usuário abre a tela inicial.
2. Seleciona “Planejar novo evento”.
3. Informa nome, data, tipo, adultos, crianças e duração.
4. Seleciona carnes, bebidas e acompanhamentos.
5. Solicita o cálculo da estimativa.
6. Revisa o resumo por categoria.
7. Edita o planejamento, se necessário.
8. Finaliza e salva o evento.
9. Acompanha a lista de compras.
10. Cria e distribui tarefas.
11. Registra despesas.
12. Consulta o custo total e as pendências.

## 7. Backlog do produto

Prioridades: **Must** = obrigatório no MVP; **Should** = importante, mas pode seguir após o núcleo; **Could** = desejável; **Won’t** = fora da versão atual.

### Épico E01 — Eventos

#### US-001 — Criar evento

Como organizador, quero criar um evento informando nome, data, tipo e duração, para iniciar o planejamento.

Prioridade: Must  
Dependências: nenhuma

Critérios de aceitação:

- Deve permitir informar o nome do evento.
- Deve permitir selecionar a data.
- Deve permitir escolher o tipo do evento.
- Deve permitir definir duração entre 1 e 12 horas.
- Nome e data são obrigatórios.
- Ao salvar, o evento recebe um identificador único.

#### US-002 — Editar evento

Como organizador, quero editar os dados do evento, para corrigir ou atualizar o planejamento.

Prioridade: Must  
Dependências: US-001

Critérios de aceitação:

- Alterar os dados deve preservar os itens e tarefas existentes.
- Alterar convidados ou duração deve recalcular as estimativas.
- O usuário deve poder cancelar a edição sem salvar.

#### US-003 — Visualizar eventos

Como usuário, quero ver eventos próximos e recentes, para acessar rapidamente meus planejamentos.

Prioridade: Must  
Dependências: US-001

Critérios de aceitação:

- A tela inicial deve mostrar eventos futuros.
- Deve indicar a data e a quantidade de dias restantes.
- Deve mostrar convidados e custo total quando disponíveis.
- Deve mostrar eventos recentes.

#### US-004 — Excluir evento

Como organizador, quero excluir um evento, para remover planejamentos que não serão realizados.

Prioridade: Should  
Dependências: US-001

Critérios de aceitação:

- O app deve pedir confirmação antes da exclusão.
- A exclusão deve remover dados vinculados ao evento.

### Épico E02 — Convidados

#### US-005 — Informar adultos e crianças

Como organizador, quero informar adultos e crianças, para obter uma estimativa adequada.

Prioridade: Must  
Dependências: US-001

Critérios de aceitação:

- Deve existir contador separado para adultos e crianças.
- Os valores não podem ser negativos.
- A alteração deve atualizar o total de participantes.

#### US-006 — Definir convidados confirmados

Como organizador, quero informar quantos convidados estão confirmados, para calcular o custo por participante.

Prioridade: Should  
Dependências: US-005

Critérios de aceitação:

- O número confirmado não pode ser maior que o número planejado sem confirmação do usuário.
- O resumo deve exibir o total confirmado.

### Épico E03 — Cardápio e itens

#### US-007 — Selecionar itens do catálogo

Como organizador, quero selecionar carnes, bebidas e acompanhamentos, para montar o cardápio.

Prioridade: Must  
Dependências: US-001

Itens iniciais sugeridos:

- Picanha;
- linguiça;
- costela;
- frango;
- coração;
- cerveja;
- refrigerante;
- água;
- suco;
- pão de alho;
- farofa;
- vinagrete;
- queijo coalho;
- carvão;
- gelo;
- descartáveis.

#### US-008 — Adicionar item personalizado

Como organizador, quero cadastrar qualquer item manualmente, para incluir produtos que não estão no catálogo.

Prioridade: Must  
Dependências: US-007

Campos:

- nome;
- categoria;
- unidade;
- quantidade;
- preço unitário estimado;
- observação opcional.

Exemplos: pão francês, arroz, salada, bolo e sobremesa.

#### US-009 — Editar ou remover item

Como organizador, quero editar ou remover itens, para manter o planejamento correto.

Prioridade: Must  
Dependências: US-007

### Épico E04 — Estimativa e resumo

#### US-010 — Calcular quantidades

Como organizador, quero calcular quantidades sugeridas, para reduzir o risco de falta ou desperdício.

Prioridade: Must  
Dependências: US-005, US-007

Critérios de aceitação:

- O cálculo deve considerar adultos, crianças, duração e itens selecionados.
- Cada item deve possuir uma regra de consumo ou quantidade manual.
- O resultado deve informar quantidade e unidade.
- O usuário deve poder alterar a sugestão.

#### US-011 — Calcular custo estimado

Como organizador, quero ver o custo estimado, para avaliar o orçamento.

Prioridade: Must  
Dependências: US-010

Regra inicial: custo estimado do item = quantidade × preço unitário. O custo total é a soma dos itens.

#### US-012 — Visualizar resumo do evento

Como organizador, quero revisar o resumo por categoria, para confirmar o planejamento.

Prioridade: Must  
Dependências: US-010, US-011

O resumo deve mostrar:

- custo total estimado;
- convidados;
- carnes;
- bebidas;
- acompanhamentos;
- materiais;
- quantidade total por unidade;
- ação para editar;
- ação para finalizar e salvar.

#### US-013 — Finalizar planejamento

Como organizador, quero finalizar e salvar o planejamento, para começar a execução do evento.

Prioridade: Must  
Dependências: US-012

### Épico E05 — Lista de compras

#### US-014 — Gerar lista de compras

Como organizador, quero uma lista agrupada por categoria, para facilitar a compra.

Prioridade: Must  
Dependências: US-013

Critérios de aceitação:

- A lista deve agrupar itens por categoria.
- Deve exibir nome, quantidade, unidade e valor estimado.
- Deve exibir total estimado.
- Não deve duplicar itens iguais.

#### US-015 — Marcar item como comprado

Como usuário, quero marcar um item como comprado, para acompanhar o progresso.

Prioridade: Must  
Dependências: US-014

Critérios de aceitação:

- O item deve mudar para o estado comprado.
- O item comprado deve aparecer visualmente concluído.
- O contador de itens deve ser atualizado.
- O progresso deve ser recalculado.

#### US-016 — Adicionar item pela lista

Como usuário, quero adicionar um item diretamente na lista, para não esquecer compras extras.

Prioridade: Must  
Dependências: US-014

### Épico E06 — Tarefas

#### US-017 — Criar tarefa

Como organizador, quero criar uma tarefa, para organizar a preparação.

Prioridade: Must  
Dependências: US-013

Campos:

- título;
- descrição;
- categoria ou itens relacionados;
- responsável opcional;
- prazo opcional;
- status.

Exemplos: comprar carne, comprar gelo, preparar vinagrete e limpar churrasqueira.

#### US-018 — Atribuir tarefa

Como organizador, quero atribuir uma tarefa a uma pessoa, para deixar a responsabilidade clara.

Prioridade: Should  
Dependências: US-017

#### US-019 — Concluir tarefa

Como responsável, quero marcar uma tarefa como concluída, para informar o andamento.

Prioridade: Must  
Dependências: US-017

### Épico E07 — Custos

#### US-020 — Registrar despesa

Como usuário, quero registrar uma despesa, para controlar os gastos reais.

Prioridade: Must  
Dependências: US-013

Campos:

- descrição;
- valor;
- categoria;
- pagador;
- data;
- observação opcional.

#### US-021 — Visualizar custos

Como organizador, quero ver o total, o valor pago e o pendente, para acompanhar o orçamento.

Prioridade: Must  
Dependências: US-020

#### US-022 — Calcular rateio

Como organizador, quero saber quem deve para quem, para acertar as despesas.

Prioridade: Should  
Dependências: US-006, US-020

#### US-023 — Marcar dívida como paga

Como usuário, quero marcar uma dívida como paga, para manter o controle atualizado.

Prioridade: Should  
Dependências: US-022

## 8. Regras de negócio

### RN-001 — Participantes

Adultos e crianças devem ser armazenados separadamente. O total de participantes é a soma dos dois grupos.

### RN-002 — Fator de criança

O MVP deve usar um fator configurável para crianças. Valor inicial sugerido: 0,5 participante adulto. Esse valor precisa ser validado com usuários reais.

### RN-003 — Duração

Eventos mais longos podem aumentar a estimativa de bebidas e acompanhamentos. A regra deve ser configurável, não fixa no código da tela.

### RN-004 — Quantidade por pessoa

Cada item pode possuir uma regra de consumo por pessoa ou uma quantidade informada manualmente.

### RN-005 — Itens personalizados

Itens personalizados devem usar a categoria e a unidade escolhidas pelo usuário.

### RN-006 — Estimado e realizado

O custo estimado não deve ser confundido com o custo real. O custo real só entra após o registro de uma despesa.

### RN-007 — Compras e despesas

Marcar uma compra como concluída não registra automaticamente seu pagamento. São estados independentes.

### RN-008 — Rateio

O rateio do MVP deve dividir o custo real entre os participantes confirmados. Crianças podem possuir fator diferente, conforme decisão do produto.

### RN-009 — Status

Status de item: pendente, comprado.  
Status de tarefa: pendente, concluída.  
Status financeiro: pendente, pago.

### RN-010 — Moeda

Todos os valores devem usar BRL e ser exibidos no formato brasileiro: `R$ 0,00`.

## 9. Modelo de dados inicial

Os nomes abaixo representam o modelo lógico persistido no SQLite. As tabelas e colunas usam português em snake_case. O campo `id` permanece por convenção técnica.

### Evento

Tabela SQLite: eventos.

~~~text
id: String
nome: String
data_evento: DateTime
horario_inicio: String?
tipo: TipoEvento
duracao_horas: int
quantidade_adultos: int
quantidade_criancas: int
convidados_confirmados: int?
status: StatusEvento
criado_em: DateTime
atualizado_em: DateTime
~~~

A tela inicial mostra horário, mas o formulário atual não informa horário de início. horario_inicio só deve ser implementado depois que essa decisão for confirmada.

### Item do evento

Tabela SQLite: itens_evento.

~~~text
id: String
evento_id: String
nome: String
categoria: CategoriaItem
unidade: UnidadeItem
quantidade: double
preco_unitario_centavos: int?
origem_quantidade: automatica | manual
foi_comprado: bool
observacoes: String?
~~~

O item do evento também representa o item da lista de compras. Não é necessário criar uma tabela separada para compras no MVP.

### Tarefa

Tabela SQLite: tarefas.

~~~text
id: String
evento_id: String
titulo: String
descricao: String?
responsavel_nome: String?
responsavel_id: String?
data_limite: DateTime?
status: pendente | concluida
~~~

Quando uma tarefa estiver relacionada a vários itens, usar a tabela de associação itens_tarefa com tarefa_id e item_evento_id.

### Despesa

Tabela SQLite: despesas.

~~~text
id: String
evento_id: String
descricao: String
valor_centavos: int
categoria: CategoriaItem
pagador_nome: String
pagador_id: String?
data_despesa: DateTime
status: pendente | pago
observacoes: String?
~~~

O custo estimado dos itens não deve ser gravado automaticamente como despesa real.

### Acerto de rateio

Tabela SQLite: acertos.

~~~text
id: String
evento_id: String
devedor_id: String
credor_id: String
valor_centavos: int
status: pendente | pago
~~~

### Participante — entidade opcional

As telas de tarefas e custos mostram pessoas identificadas por nome. Para implementar o rateio de forma consistente, recomenda-se criar esta entidade caso o cadastro nominal dos convidados seja adotado.

Tabela SQLite: participantes.

~~~text
id: String
evento_id: String
nome: String
tipo: adulto | crianca
esta_confirmado: bool
fator_consumo: double
~~~

Se Participante for adotado, convidados_confirmados deve ser calculado a partir dos participantes confirmados, evitando duplicação de informação.

## 10. Categorias e enumerações

~~~text
CategoriaItem:
- carnes
- bebidas
- acompanhamentos
- materiais
- sobremesas
- personalizado

TipoEvento:
- churrasco
- aniversario
- empresa
- familia
- outro

StatusEvento:
- rascunho
- planejado
- concluido
- cancelado

UnidadeItem:
- kg
- g
- litro
- ml
- unidade
- pacote
- garrafa
- lata
- caixa
- personalizado
~~~

## 11. Arquitetura funcional sugerida

Organizar o app por módulos:

```text
Início
 ├── Próximos eventos
 └── Eventos recentes

Planejamento do evento
 ├── Dados do evento
 ├── Convidados
 ├── Cardápio
 ├── Cálculo
 └── Resumo

Compras
 ├── Itens por categoria
 ├── Progresso
 └── Inclusão e conclusão de itens

Tarefas
 ├── Tarefas pendentes
 ├── Tarefas concluídas
 └── Responsáveis

Custos
 ├── Resumo financeiro
 ├── Despesas
 └── Rateio
```

## 12. Requisitos de qualidade

- Todas as telas devem funcionar em diferentes tamanhos de celular.
- A navegação principal deve permanecer consistente entre as telas.
- O app deve preservar dados ao trocar de aba ou fechar uma tela.
- Operações de cálculo devem atualizar a interface sem atraso perceptível.
- Exclusões devem exigir confirmação.
- Textos da interface devem ser padronizados em português.
- A interface deve respeitar as convenções de interação do Android e do iOS, preservando a identidade visual do produto.
- Valores monetários devem usar formatação brasileira.
- Estados de carregamento, vazio e erro devem ser definidos para cada lista.
- O app deve permitir uso básico sem conexão no MVP, caso os dados sejam locais.
- O código deve manter as regras de cálculo fora dos widgets de interface.

## 13. Estados de interface necessários

### Início

- sem eventos;
- eventos futuros;
- eventos recentes;
- carregando;
- erro ao carregar.

### Lista de compras

- lista vazia;
- itens pendentes;
- todos os itens comprados;
- inclusão de item;
- erro ao salvar.

### Tarefas

- sem tarefas;
- tarefas pendentes;
- todas concluídas;
- tarefa sem responsável.

### Custos

- sem despesas;
- despesas registradas;
- despesas parcialmente pagas;
- evento sem convidados confirmados.

## 14. Lacunas e decisões abertas

Estas decisões devem ser respondidas antes da implementação final:

1. O usuário cadastra nomes dos convidados ou apenas quantidades?
2. Como convidados confirmam presença?
3. O app será somente local ou terá conta e sincronização?
4. O rateio será igual para todos ou ponderado para crianças?
5. O preço dos itens será informado pelo usuário ou virá de uma tabela padrão?
6. O evento finalizado ainda poderá ser editado?
7. O usuário poderá duplicar um evento antigo?
8. A atribuição de tarefas será apenas manual no MVP?
9. A lista de compras deverá ser compartilhável?
10. Os itens e regras de consumo precisarão ser editáveis pelo usuário?

## 15. Ordem recomendada de desenvolvimento

### Sprint 1 — Base do produto

- modelo Evento;
- Início;
- criar e editar evento;
- navegação inferior;
- persistência local.

### Sprint 2 — Planejamento

- convidados;
- catálogo de itens;
- itens personalizados;
- regras iniciais de cálculo;
- resumo.

### Sprint 3 — Compras

- lista por categoria;
- marcação de comprado;
- progresso;
- inclusão manual pela lista.

### Sprint 4 — Tarefas

- criar tarefa;
- responsável;
- status pendente/concluída.

### Sprint 5 — Custos

- registrar despesa;
- resumo de custos;
- pago e pendente;
- rateio básico, se as regras estiverem definidas.

### Sprint 6 — Validação

- testes dos cálculos;
- testes de navegação;
- revisão das telas;
- teste com usuários organizando um churrasco real;
- correção de ambiguidades e ajustes do backlog.

## 16. Definição de pronto

Uma história só será considerada pronta quando:

- estiver implementada;
- tiver critérios de aceitação atendidos;
- tiver validação para dados vazios e inválidos;
- tiver sido testada em pelo menos um fluxo normal e um fluxo alternativo;
- não quebrar os fluxos já existentes;
- tiver interface em português;
- tiver persistência dos dados necessária ao MVP.

## 17. Próximo artefato técnico

A partir deste documento, o próximo artefato recomendado é um plano técnico contendo:

- estrutura de pastas;
- entidades e repositórios;
- estratégia de estado;
- rotas;
- componentes reutilizáveis;
- implementação da calculadora;
- plano de testes;
- ordem dos commits.

Documento técnico relacionado: [plano-tecnico.md](plano-tecnico.md)
