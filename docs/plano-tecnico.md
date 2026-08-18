# Churras Fácil — Plano Técnico

Documento de origem: [documento-requisitos.md](documento-requisitos.md)

## 1. Objetivo

Implementar o MVP do Churras Fácil começando pelo fluxo de criação e salvamento de eventos.

## 2. Decisões técnicas

- O gerenciamento de estado usará `Provider`.
- As telas seguirão o padrão MVVM.
- As operações de dados serão acessadas por repositories.
- A persistência será local usando SQLite no MVP.
- As tabelas e colunas do SQLite usarão nomes em português e snake_case; o campo `id` permanece por convenção técnica.
- O SQLite será acessado somente pela camada `data`, por meio de um datasource local.
- As tabelas usarão migrations para controlar alterações no esquema.
- Datas serão armazenadas como texto em formato ISO-8601.
- Valores monetários serão armazenados como inteiros em centavos para evitar erros de arredondamento.
- Chaves estrangeiras e exclusão em cascata serão usadas para os dados vinculados a um evento.
- As regras de cálculo ficarão fora dos widgets de interface.
- Os modelos devem ser preferencialmente imutáveis e oferecer `copyWith` quando necessário.
- O ViewModel usará `ChangeNotifier` e exporá estados suficientes para a interface representar carregamento, sucesso, vazio e erro.
- Não serão criados casos de uso separados neste primeiro momento; eles poderão ser adicionados se a complexidade do domínio aumentar.

### 2.1 Diretrizes de interface multiplataforma

- Usar Material 3 como base visual do aplicativo.
- No Android, priorizar componentes Material 3.
- No iOS, usar componentes Cupertino ou construtores adaptativos quando o comportamento for específico da plataforma.
- Manter cores, tipografia e identidade visual consistentes nas duas plataformas.
- Usar componentes adaptativos para controles como diálogos, switches, sliders, checkboxes e indicadores de carregamento.
- Não duplicar toda a interface em duas versões; adaptar apenas componentes cuja interação siga convenções específicas do sistema.

## 3. Arquitetura

O fluxo principal de dependências será:

```text
View
  ↓
ViewModel (ChangeNotifier)
  ↓
Repository
  ↓
LocalDataSource
  ↓
Armazenamento local
```

### 3.1 View

Responsável por:

- construir a interface;
- exibir o estado fornecido pelo ViewModel;
- encaminhar ações do usuário ao ViewModel;
- não acessar diretamente o armazenamento ou o repository.

Exemplo de responsabilidade da View:

```dart
await viewModel.salvarEvento();
```

### 3.2 ViewModel

Responsável por:

- manter o estado da tela;
- validar dados de entrada;
- chamar o repository;
- informar à View quando o estado mudou;
- tratar estados de carregamento e erro.

Os ViewModels devem estender `ChangeNotifier`.

### 3.3 Repository

Responsável por:

- definir operações como criar, listar, editar e excluir eventos;
- esconder da aplicação a tecnologia de persistência utilizada;
- converter erros de armazenamento em erros compreensíveis para o ViewModel.

### 3.4 LocalDataSource

Responsável exclusivamente por ler e gravar dados no armazenamento local. A View e o ViewModel não devem conhecer detalhes desse armazenamento.

### 3.5 Services

Responsáveis por regras reutilizáveis e independentes da interface, como:

- cálculo de quantidades;
- cálculo de custos;
- formatação de moeda;
- regras relacionadas à duração do evento.

## 4. Estrutura de pastas

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── app_routes.dart
│   └── app_theme.dart
│
├── core/
│   ├── errors/
│   ├── formatters/
│   └── storage/
│
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── app_database.dart
│   │       ├── database_migrations.dart
│   │       └── event_local_datasource.dart
│   ├── models/
│   │   ├── event_model.dart
│   │   ├── event_item_model.dart
│   │   ├── task_model.dart
│   │   └── expense_model.dart
│   └── repositories/
│       ├── event_repository.dart
│       ├── event_repository_impl.dart
│       ├── item_repository.dart
│       └── item_repository_impl.dart
│
├── services/
│   └── estimation_service.dart
│
└── features/
    ├── home/
    │   ├── view/
    │   │   └── home_page.dart
    │   ├── viewmodel/
    │   │   └── home_view_model.dart
    │   └── widgets/
    │       └── event_card.dart
    │
    ├── event_planning/
    │   ├── view/
    │   │   └── event_planning_page.dart
    │   ├── viewmodel/
    │   │   └── event_planning_view_model.dart
    │   └── widgets/
    │
    ├── shopping/
    │   ├── view/
    │   ├── viewmodel/
    │   └── widgets/
    │
    ├── tasks/
    │   ├── view/
    │   ├── viewmodel/
    │   └── widgets/
    │
    └── costs/
        ├── view/
        ├── viewmodel/
        └── widgets/
```

## 5. Dependência entre as partes

O `main.dart` deve montar as dependências compartilhadas, como o armazenamento local e os repositories. Cada tela pode receber seu ViewModel por meio de `ChangeNotifierProvider`.

Exemplo conceitual:

```dart
MultiProvider(
  providers: [
    Provider<EventRepository>(
      create: (_) => EventRepositoryImpl(
        localDataSource: eventLocalDataSource,
      ),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        context.read<EventRepository>(),
      ),
    ),
  ],
  child: const App(),
)
```

O ViewModel deve receber suas dependências pelo construtor. A View pode usar `context.watch`, `context.read`, `Consumer` ou `Selector`, preferindo rebuilds pequenos e específicos.

## 6. Primeiro fluxo implementado

```text
Home
  → Planejar novo evento
  → Preencher nome, data, tipo, duração e participantes
  → Validar formulário
  → Salvar evento pelo ViewModel
  → Repository persiste o evento
  → Voltar para a Home
  → Exibir o evento salvo
```

## 7. Plano de implementação

### Sprint 1 — Eventos

- adicionar o pacote `provider`;
- criar o modelo `Event`;
- criar o repository de eventos;
- criar a persistência local;
- criar a Home;
- criar a tela de novo evento;
- validar nome e data obrigatórios;
- salvar e recuperar eventos;
- exibir eventos salvos na Home.

### Sprint 2 — Planejamento

- adicionar adultos e crianças;
- criar catálogo de itens;
- permitir itens personalizados;
- implementar o `EstimationService`;
- exibir o resumo do evento.

### Sprint 3 — Compras

- listar itens por categoria;
- marcar item como comprado;
- exibir progresso;
- adicionar item pela lista.

### Sprint 4 — Tarefas

- criar tarefa;
- atribuir responsável;
- concluir tarefa.

### Sprint 5 — Custos

- registrar despesa;
- exibir total pago e pendente;
- implementar rateio após as regras serem confirmadas.

## 8. Testes

### Testes unitários

- criar evento válido;
- rejeitar nome vazio;
- rejeitar data inválida;
- impedir adultos ou crianças negativos;
- salvar e recuperar evento;
- editar evento sem perder seus dados;
- calcular quantidade e custo corretamente.

### Testes de ViewModel

- carregar estado inicial;
- representar carregamento;
- representar lista vazia;
- representar erro do repository;
- atualizar a lista depois de salvar ou excluir um evento.

### Testes de widget

- exibir estado vazio na Home;
- exibir um evento salvo;
- validar o formulário;
- concluir o fluxo de criação de evento.

## 9. Definição de pronto da Sprint 1

A Sprint 1 estará pronta quando o usuário conseguir:

1. abrir a Home;
2. iniciar um novo evento;
3. preencher nome, data, tipo, duração e participantes;
4. receber mensagens para dados inválidos;
5. salvar o evento;
6. fechar e reabrir o aplicativo;
7. visualizar o evento salvo na Home.

## 10. Entidades do domínio

A análise das telas em docs/images confirma as entidades principais abaixo. As informações que ainda não estão definidas no documento de requisitos permanecem marcadas como decisões abertas.

### 10.1 Evento

Representa o churrasco ou encontro planejado.

Tabela SQLite: eventos.

Campos: id, nome, data_evento, horario_inicio opcional, tipo, duracao_horas, quantidade_adultos, quantidade_criancas, convidados_confirmados opcional, status, criado_em e atualizado_em.

A tela inicial mostra horário, mas o formulário atual não informa horário de início. horario_inicio só deve ser implementado depois que essa decisão for confirmada.

### 10.2 Item do evento

Representa um item do cardápio e também o item correspondente da lista de compras. Não é necessário criar uma entidade ItemCompra separada no MVP.

Tabela SQLite: itens_evento.

Campos: id, evento_id, nome, categoria, unidade, quantidade, preco_unitario_centavos opcional, origem_quantidade, foi_comprado e observacoes opcional.

O custo do item é calculado por quantidade multiplicada por preco_unitario_centavos. O progresso da lista de compras é derivado de foi_comprado.

### 10.3 Tarefa

Representa uma tarefa de preparação do evento.

Tabela SQLite: tarefas.

Campos: id, evento_id, titulo, descricao opcional, responsavel_nome opcional, responsavel_id opcional, data_limite opcional e status.

Se uma tarefa puder estar relacionada a vários itens, adicionar a tabela de associação itens_tarefa com tarefa_id e item_evento_id.

### 10.4 Despesa

Representa uma despesa real registrada pelo usuário. O custo estimado dos itens não deve ser gravado automaticamente como despesa.

Tabela SQLite: despesas.

Campos: id, evento_id, descricao, valor_centavos, categoria, pagador_nome, pagador_id opcional, data_despesa e observacoes opcional.

### 10.5 Acerto de rateio

Representa uma dívida calculada pelo rateio e exibida na tela de custos.

Tabela SQLite: acertos.

Campos: id, evento_id, devedor_id, credor_id, valor_centavos e status.

### 10.6 Participante — decisão necessária para o rateio

As telas de tarefas e custos mostram pessoas identificadas por nome, como responsáveis, pagadores, devedores e credores. Para implementar o rateio de forma consistente, recomenda-se criar a entidade Participante.

Tabela SQLite: participantes.

Campos: id, evento_id, nome, tipo, esta_confirmado e fator_consumo.

Essa entidade depende da decisão sobre o cadastro nominal dos convidados. Enquanto ela não for adotada, responsavel_nome e pagador_nome poderão permanecer como texto, mas o rateio ficará limitado.

## 11. Entidades derivadas e opcionais

Não é necessário criar tabelas próprias para:

- Resumo do evento: ViewModel ou DTO calculado a partir do evento e dos itens;
- total estimado: soma dos custos de itens_evento;
- total pago: soma de despesas;
- progresso de compras: itens comprados dividido pelo total;
- resumo por categoria: agrupamento de itens_evento por categoria.

O catálogo inicial pode ser uma lista estática no código. Só será necessário criar itens_catalogo e regras de consumo persistidas se o usuário puder editar o catálogo ou suas regras.

O avatar, a saudação e as configurações visuais não exigem uma entidade de usuário enquanto login e sincronização estiverem fora do MVP.

## 12. Relacionamentos SQLite

Um evento possui muitos itens_evento, tarefas, despesas e acertos.

Se Participante for adotado, um evento também possuirá muitos participantes. Despesas e acertos poderão referenciar participantes.

Se tarefas puderem relacionar vários itens, tarefas e itens_evento terão relação muitos-para-muitos por meio de itens_tarefa.

Todas as tabelas dependentes devem possuir evento_id e ser removidas quando o evento for excluído. O banco deve habilitar foreign keys e usar exclusão em cascata.

## 13. Esquema inicial do banco

Tabela eventos: id TEXT PRIMARY KEY, nome TEXT NOT NULL, data_evento TEXT NOT NULL, horario_inicio TEXT, tipo TEXT NOT NULL, duracao_horas INTEGER NOT NULL, quantidade_adultos INTEGER NOT NULL DEFAULT 0, quantidade_criancas INTEGER NOT NULL DEFAULT 0, convidados_confirmados INTEGER, status TEXT NOT NULL, criado_em TEXT NOT NULL e atualizado_em TEXT NOT NULL.

Tabela itens_evento: id TEXT PRIMARY KEY, evento_id TEXT NOT NULL, nome TEXT NOT NULL, categoria TEXT NOT NULL, unidade TEXT NOT NULL, quantidade REAL NOT NULL, preco_unitario_centavos INTEGER, origem_quantidade TEXT NOT NULL, foi_comprado INTEGER NOT NULL DEFAULT 0 e observacoes TEXT.

Tabela tarefas: id TEXT PRIMARY KEY, evento_id TEXT NOT NULL, titulo TEXT NOT NULL, descricao TEXT, responsavel_nome TEXT, responsavel_id TEXT, data_limite TEXT e status TEXT NOT NULL.

Tabela despesas: id TEXT PRIMARY KEY, evento_id TEXT NOT NULL, descricao TEXT NOT NULL, valor_centavos INTEGER NOT NULL, categoria TEXT NOT NULL, pagador_nome TEXT NOT NULL, pagador_id TEXT, data_despesa TEXT NOT NULL e observacoes TEXT.

Tabela acertos: id TEXT PRIMARY KEY, evento_id TEXT NOT NULL, devedor_id TEXT NOT NULL, credor_id TEXT NOT NULL, valor_centavos INTEGER NOT NULL e status TEXT NOT NULL.

Tabela participantes: id TEXT PRIMARY KEY, evento_id TEXT NOT NULL, nome TEXT NOT NULL, tipo TEXT NOT NULL, esta_confirmado INTEGER NOT NULL DEFAULT 0 e fator_consumo REAL NOT NULL DEFAULT 1.0.

Tabela itens_tarefa: tarefa_id TEXT NOT NULL, item_evento_id TEXT NOT NULL, PRIMARY KEY (tarefa_id, item_evento_id).

As tabelas participantes e itens_tarefa devem ser adicionadas quando suas decisões correspondentes forem confirmadas.

## 14. Lacunas reveladas pelas telas

As imagens devem ser tratadas como evidência visual, não como requisitos definitivos. Elas revelam estas perguntas abertas:

1. O evento terá horário de início? A Home mostra 13:00, mas o formulário atual não possui esse campo.
2. O usuário cadastrará os nomes dos convidados? A tela de custos exige nomes para calcular e exibir o rateio.
3. O número de convidados confirmados será digitado manualmente ou calculado a partir de participantes?
4. Responsáveis por tarefas serão convidados cadastrados ou apenas nomes livres?
5. O catálogo e as regras de consumo serão fixos no código ou editáveis pelo usuário?
6. Os textos exibidos nas imagens serão traduzidos integralmente para português no aplicativo?
