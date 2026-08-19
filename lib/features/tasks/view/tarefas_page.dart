import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_header.dart';
import '../../../core/formatters/data_formatters.dart';
import '../../../domain/entities/tarefa.dart';
import '../viewmodel/tarefas_view_model.dart';

class TarefasPage extends StatelessWidget {
  const TarefasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TarefasViewModel>();

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SizedBox.expand(
            child: RefreshIndicator(
              onRefresh: viewModel.carregar,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: _TarefasHeader(
                        viewModel: viewModel,
                        onAdicionar: () => _abrirDialogoAdicionar(context),
                      ),
                    ),
                  ),
                  if (viewModel.estaCarregando &&
                      viewModel.eventoSelecionado == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (viewModel.mensagemErro != null &&
                      viewModel.eventoSelecionado == null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _TarefasError(
                        mensagem: viewModel.mensagemErro!,
                        onTentarNovamente: viewModel.carregar,
                      ),
                    )
                  else if (viewModel.eventoSelecionado == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _TarefasEmptyEventState(),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: _TarefasSummary(viewModel: viewModel),
                      ),
                    ),
                    if (viewModel.mensagemErro != null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: _InlineError(
                            mensagem: viewModel.mensagemErro!,
                          ),
                        ),
                      ),
                    if (viewModel.tarefas.isEmpty && !viewModel.estaCarregando)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _TarefasEmptyState(
                          onAdicionar: () => _abrirDialogoAdicionar(context),
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: _ListaTarefas(
                            tarefas: viewModel.tarefas,
                            idAtualizando: viewModel.idAtualizando,
                            onStatusChanged: viewModel.alterarStatus,
                            onAtribuirResponsavel: (tarefa) =>
                                _abrirDialogoResponsavel(context, tarefa),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _abrirDialogoAdicionar(BuildContext context) async {
    final viewModel = context.read<TarefasViewModel>();
    final novaTarefa = await showDialog<_NovaTarefa>(
      context: context,
      builder: (_) => const _AdicionarTarefaDialog(),
    );
    if (novaTarefa == null || !context.mounted) return;

    await viewModel.criarTarefa(
      titulo: novaTarefa.titulo,
      descricao: novaTarefa.descricao,
      responsavelNome: novaTarefa.responsavelNome,
      dataLimite: novaTarefa.dataLimite,
    );
  }

  Future<void> _abrirDialogoResponsavel(
    BuildContext context,
    Tarefa tarefa,
  ) async {
    final viewModel = context.read<TarefasViewModel>();
    final resultado = await showDialog<_ResponsavelResult>(
      context: context,
      builder: (_) =>
          _ResponsavelDialog(responsavelAtual: tarefa.responsavelNome),
    );
    if (resultado == null || !context.mounted) return;

    await viewModel.atribuirResponsavel(tarefa.id, resultado.nome);
  }
}

class _TarefasHeader extends StatelessWidget {
  const _TarefasHeader({required this.viewModel, required this.onAdicionar});

  final TarefasViewModel viewModel;
  final VoidCallback onAdicionar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Tarefas',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (viewModel.estaCarregando && viewModel.eventoSelecionado != null)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        if (viewModel.eventos.length > 1) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: const Key('tarefasEventoDropdown'),
            initialValue: viewModel.eventoSelecionado?.id,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Evento',
              prefixIcon: Icon(Icons.event_outlined),
            ),
            items: [
              for (final evento in viewModel.eventos)
                DropdownMenuItem(value: evento.id, child: Text(evento.nome)),
            ],
            onChanged: (eventoId) {
              if (eventoId != null) viewModel.selecionarEvento(eventoId);
            },
          ),
        ] else if (viewModel.eventoSelecionado != null) ...[
          const SizedBox(height: 6),
          Text(
            viewModel.eventoSelecionado!.nome,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 18),
        _AddTaskButton(
          estaAdicionando: viewModel.estaSalvando,
          onPressed: onAdicionar,
        ),
      ],
    );
  }
}

class _TarefasSummary extends StatelessWidget {
  const _TarefasSummary({required this.viewModel});

  final TarefasViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preparação do evento',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${viewModel.tarefasPendentes} ${viewModel.tarefasPendentes == 1 ? 'pendente' : 'pendentes'}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Semantics(
              label: 'Tarefas concluídas',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: esquema.tertiary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Text(
                    '${viewModel.tarefasConcluidas}/${viewModel.totalTarefas}',
                    style: TextStyle(
                      color: esquema.onTertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: viewModel.progresso,
            minHeight: 8,
            backgroundColor: esquema.outlineVariant,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          viewModel.tarefasPendentes == 0 && viewModel.totalTarefas > 0
              ? 'Tudo pronto!'
              : '${viewModel.tarefasConcluidas} ${viewModel.tarefasConcluidas == 1 ? 'tarefa concluída' : 'tarefas concluídas'}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ListaTarefas extends StatelessWidget {
  const _ListaTarefas({
    required this.tarefas,
    required this.idAtualizando,
    required this.onStatusChanged,
    required this.onAtribuirResponsavel,
  });

  final List<Tarefa> tarefas;
  final String? idAtualizando;
  final Future<bool> Function(String id, bool concluida) onStatusChanged;
  final Future<void> Function(Tarefa tarefa) onAtribuirResponsavel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final tarefa in tarefas) ...[
          _TarefaCard(
            tarefa: tarefa,
            estaAtualizando: idAtualizando == tarefa.id,
            onStatusChanged: (concluida) =>
                onStatusChanged(tarefa.id, concluida),
            onAtribuirResponsavel: () => onAtribuirResponsavel(tarefa),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TarefaCard extends StatelessWidget {
  const _TarefaCard({
    required this.tarefa,
    required this.estaAtualizando,
    required this.onStatusChanged,
    required this.onAtribuirResponsavel,
  });

  final Tarefa tarefa;
  final bool estaAtualizando;
  final Future<bool> Function(bool concluida) onStatusChanged;
  final VoidCallback onAtribuirResponsavel;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final estiloTitulo = tarefa.estaConcluida
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 10, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarefa.titulo,
                    style:
                        estiloTitulo ?? Theme.of(context).textTheme.titleLarge,
                  ),
                  if (tarefa.descricao != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      tarefa.descricao!,
                      style:
                          estiloTitulo ?? Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _TaskMeta(
                        icon: Icons.person_outline,
                        text: tarefa.responsavelNome ?? 'Sem responsável',
                      ),
                      if (tarefa.dataLimite != null)
                        _TaskMeta(
                          icon: Icons.event_outlined,
                          text: 'Prazo ${formatarData(tarefa.dataLimite!)}',
                        ),
                      _TaskMeta(
                        icon: tarefa.estaConcluida
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        text: tarefa.status.label,
                        color: tarefa.estaConcluida
                            ? esquema.secondary
                            : esquema.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Checkbox(
                  key: Key('tarefas_checkbox_${tarefa.id}'),
                  value: tarefa.estaConcluida,
                  shape: const CircleBorder(),
                  onChanged: estaAtualizando
                      ? null
                      : (valor) {
                          if (valor != null) onStatusChanged(valor);
                        },
                ),
                IconButton(
                  key: Key('tarefas_atribuir_${tarefa.id}'),
                  tooltip: 'Atribuir responsável',
                  onPressed: estaAtualizando ? null : onAtribuirResponsavel,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskMeta extends StatelessWidget {
  const _TaskMeta({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cor = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: cor),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: cor)),
      ],
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  const _AddTaskButton({
    required this.estaAdicionando,
    required this.onPressed,
  });

  final bool estaAdicionando;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        key: const Key('adicionarTarefaButton'),
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: const StadiumBorder(),
        ),
        onPressed: estaAdicionando ? null : onPressed,
        icon: estaAdicionando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
        label: const Text('Adicionar tarefa'),
      ),
    );
  }
}

class _TarefasEmptyEventState extends StatelessWidget {
  const _TarefasEmptyEventState();

  @override
  Widget build(BuildContext context) {
    return const _CenteredState(
      icon: Icons.event_note_outlined,
      title: 'Crie um evento para começar',
      message:
          'Suas tarefas de preparação aparecerão aqui depois do planejamento.',
    );
  }
}

class _TarefasEmptyState extends StatelessWidget {
  const _TarefasEmptyState({required this.onAdicionar});

  final VoidCallback onAdicionar;

  @override
  Widget build(BuildContext context) {
    return _CenteredState(
      icon: Icons.checklist_outlined,
      title: 'Nenhuma tarefa ainda',
      message:
          'Crie tarefas como comprar carne, preparar o vinagrete ou limpar a churrasqueira.',
      action: OutlinedButton.icon(
        key: const Key('adicionarTarefaButton'),
        onPressed: onAdicionar,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar tarefa'),
      ),
    );
  }
}

class _TarefasError extends StatelessWidget {
  const _TarefasError({
    required this.mensagem,
    required this.onTentarNovamente,
  });

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return _CenteredState(
      icon: Icons.error_outline,
      title: 'Não foi possível carregar',
      message: mensagem,
      action: OutlinedButton(
        onPressed: onTentarNovamente,
        child: const Text('Tentar novamente'),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Text(
      mensagem,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}

class _CenteredState extends StatelessWidget {
  const _CenteredState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: esquema.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

class _NovaTarefa {
  const _NovaTarefa({
    required this.titulo,
    this.descricao,
    this.responsavelNome,
    this.dataLimite,
  });

  final String titulo;
  final String? descricao;
  final String? responsavelNome;
  final DateTime? dataLimite;
}

class _AdicionarTarefaDialog extends StatefulWidget {
  const _AdicionarTarefaDialog();

  @override
  State<_AdicionarTarefaDialog> createState() => _AdicionarTarefaDialogState();
}

class _AdicionarTarefaDialogState extends State<_AdicionarTarefaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _responsavelController = TextEditingController();
  DateTime? _dataLimite;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _responsavelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova tarefa'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('tarefaTituloField'),
                controller: _tituloController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  hintText: 'Ex.: Comprar carne',
                  prefixIcon: Icon(Icons.task_alt_outlined),
                ),
                validator: (valor) => valor == null || valor.trim().isEmpty
                    ? 'Informe o título.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('tarefaDescricaoField'),
                controller: _descricaoController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Detalhes opcionais',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('tarefaResponsavelField'),
                controller: _responsavelController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Responsável',
                  hintText: 'Ex.: Marcos',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('tarefaPrazoButton'),
                  onPressed: _selecionarPrazo,
                  icon: const Icon(Icons.event_outlined),
                  label: Text(
                    _dataLimite == null
                        ? 'Adicionar prazo'
                        : 'Prazo: ${formatarData(_dataLimite!)}',
                  ),
                ),
              ),
              if (_dataLimite != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => _dataLimite = null),
                    child: const Text('Remover prazo'),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirmarTarefaButton'),
          onPressed: _confirmar,
          child: const Text('Criar tarefa'),
        ),
      ],
    );
  }

  Future<void> _selecionarPrazo() async {
    final hoje = DateTime.now();
    final prazo = await showDatePicker(
      context: context,
      initialDate: _dataLimite ?? hoje,
      firstDate: DateTime(2000),
      lastDate: DateTime(hoje.year + 10),
      helpText: 'Selecione o prazo',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (prazo != null && mounted) setState(() => _dataLimite = prazo);
  }

  void _confirmar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _NovaTarefa(
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        responsavelNome: _responsavelController.text.trim(),
        dataLimite: _dataLimite,
      ),
    );
  }
}

class _ResponsavelResult {
  const _ResponsavelResult(this.nome);

  final String nome;
}

class _ResponsavelDialog extends StatefulWidget {
  const _ResponsavelDialog({required this.responsavelAtual});

  final String? responsavelAtual;

  @override
  State<_ResponsavelDialog> createState() => _ResponsavelDialogState();
}

class _ResponsavelDialogState extends State<_ResponsavelDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.responsavelAtual ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Atribuir responsável'),
      content: TextField(
        key: const Key('editarResponsavelField'),
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Nome',
          hintText: 'Ex.: Marcos',
          prefixIcon: Icon(Icons.person_outline),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirmarResponsavelButton'),
          onPressed: () => Navigator.pop(
            context,
            _ResponsavelResult(_controller.text.trim()),
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
