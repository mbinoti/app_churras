import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_header.dart';
import '../../../core/formatters/data_formatters.dart';
import '../../../data/repositories/catalogo_repository.dart';
import '../../../data/repositories/evento_repository.dart';
import '../../../data/repositories/item_evento_repository.dart';
import '../../../domain/entities/evento.dart';
import '../../../domain/entities/item_catalogo.dart';
import '../../../domain/entities/item_evento.dart';
import '../viewmodel/event_planning_view_model.dart';

class EventPlanningPage extends StatelessWidget {
  const EventPlanningPage({this.evento, super.key});

  final Evento? evento;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          EventPlanningViewModel(
              eventoRepository: context.read<EventoRepository>(),
              catalogoRepository: context.read<CatalogoRepository?>(),
              itemRepository: context.read<EventoItemRepository?>(),
              evento: evento,
            )
            ..carregarCatalogo()
            ..carregarItens(),
      child: const _EventPlanningView(),
    );
  }
}

class _EventPlanningView extends StatefulWidget {
  const _EventPlanningView();

  @override
  State<_EventPlanningView> createState() => _EventPlanningViewState();
}

class _EventPlanningViewState extends State<_EventPlanningView> {
  Future<void> _selecionarData(
    BuildContext context,
    EventPlanningViewModel viewModel,
  ) async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: viewModel.dataEvento ?? hoje,
      firstDate: DateTime(2000),
      lastDate: DateTime(hoje.year + 10),
      helpText: 'Selecione a data do evento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (data != null && context.mounted) {
      viewModel.alterarDataEvento(data);
    }
  }

  Future<void> _salvar(
    BuildContext context,
    EventPlanningViewModel viewModel,
  ) async {
    final salvou = await viewModel.salvarEvento();
    if (salvou && context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EventPlanningViewModel>();
    final tema = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
              child: Column(
                children: [
                  AppHeader(onBack: () => Navigator.of(context).pop()),
                  const SizedBox(height: 20),
                  const _PlanningHero(),
                  const SizedBox(height: 24),
                  _PlanningSection(
                    child: Column(
                      children: [
                        TextFormField(
                          key: const Key('nomeEventoField'),
                          initialValue: viewModel.nome,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Nome do evento *',
                            hintText: 'Ex.: Churrasco da família',
                            prefixIcon: Icon(Icons.celebration_outlined),
                          ).copyWith(errorText: viewModel.erroNome),
                          onChanged: viewModel.alterarNome,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _DateField(
                                data: viewModel.dataEvento,
                                erro: viewModel.erroData,
                                onPressed: () =>
                                    _selecionarData(context, viewModel),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<TipoEvento>(
                                key: const Key('tipoEventoField'),
                                isExpanded: true,
                                initialValue: viewModel.tipo,
                                decoration: const InputDecoration(
                                  labelText: 'Tipo',
                                  prefixIcon: Icon(Icons.category_outlined),
                                ),
                                items: TipoEvento.values
                                    .map(
                                      (tipo) => DropdownMenuItem(
                                        value: tipo,
                                        child: Text(tipo.label),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (tipo) {
                                  if (tipo != null) viewModel.alterarTipo(tipo);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PlanningSection(
                    title: 'CONVIDADOS',
                    icon: Icons.people_outline,
                    child: Column(
                      children: [
                        _CounterRow(
                          label: 'Adultos',
                          value: viewModel.quantidadeAdultos,
                          onChanged: viewModel.alterarQuantidadeAdultos,
                        ),
                        _CounterRow(
                          label: 'Crianças',
                          value: viewModel.quantidadeCriancas,
                          onChanged: viewModel.alterarQuantidadeCriancas,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total planejado: ${viewModel.totalParticipantes}',
                            style: tema.textTheme.bodyMedium?.copyWith(
                              color: tema.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PlanningSection(
                    title: 'DURAÇÃO',
                    icon: Icons.schedule_outlined,
                    trailing: Text(
                      '${viewModel.duracaoHoras} h',
                      style: tema.textTheme.titleMedium?.copyWith(
                        color: tema.colorScheme.primary,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Slider(
                          key: const Key('duracaoEventoSlider'),
                          value: viewModel.duracaoHoras.toDouble(),
                          min: 1,
                          max: 12,
                          divisions: 11,
                          label: '${viewModel.duracaoHoras} h',
                          onChanged: (valor) =>
                              viewModel.alterarDuracao(valor.round()),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('1 h'), Text('12 h')],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PlanningSection(
                    title: 'O QUE VAI TER?',
                    icon: Icons.restaurant_menu_outlined,
                    child: _MenuPlanning(
                      viewModel: viewModel,
                      onAdicionarPersonalizado: () =>
                          _adicionarItemPersonalizado(context, viewModel),
                      onConfigurarSugestoes: () =>
                          _configurarSugestoes(context, viewModel),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PlanningSection(
                    title: 'RESUMO',
                    icon: Icons.receipt_long_outlined,
                    child: _PlanningSummary(viewModel: viewModel),
                  ),
                  if (viewModel.mensagemErro != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      viewModel.mensagemErro!,
                      style: TextStyle(color: tema.colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const Key('salvarEventoButton'),
                    style: FilledButton.styleFrom(
                      backgroundColor: tema.colorScheme.primary,
                      minimumSize: const Size.fromHeight(58),
                      shape: const StadiumBorder(),
                    ),
                    onPressed:
                        viewModel.estaSalvando ||
                            viewModel.estaCarregandoCatalogo ||
                            viewModel.estaCarregandoItens
                        ? null
                        : () => _salvar(context, viewModel),
                    icon: viewModel.estaSalvando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      viewModel.estaEditando
                          ? 'Salvar alterações'
                          : 'Calcular estimativa',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _adicionarItemPersonalizado(
    BuildContext context,
    EventPlanningViewModel viewModel,
  ) async {
    final item = await showDialog<EventoItem>(
      context: context,
      builder: (_) => const _CustomItemDialog(),
    );
    if (item != null && context.mounted) {
      viewModel.adicionarItemPersonalizado(item);
    }
  }

  Future<void> _configurarSugestoes(
    BuildContext context,
    EventPlanningViewModel viewModel,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _CatalogSettingsDialog(
        catalogo: viewModel.catalogo,
        onSave: viewModel.atualizarItemCatalogo,
      ),
    );
  }
}

class _PlanningHero extends StatelessWidget {
  const _PlanningHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 136,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/barbecue_hero.png', fit: BoxFit.cover),
            ColoredBox(color: Colors.white.withValues(alpha: 0.24)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Text(
                  'Planeje seu evento',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanningSection extends StatelessWidget {
  const _PlanningSection({
    required this.child,
    this.title,
    this.icon,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
      decoration: BoxDecoration(
        color: tema.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB88986).withValues(alpha: 0.38),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: 19,
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  title!,
                  style: tema.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.4,
                    color: tema.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.data,
    required this.erro,
    required this.onPressed,
  });

  final DateTime? data;
  final String? erro;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('selecionarDataButton'),
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data do evento *',
          prefixIcon: Icon(Icons.calendar_month_outlined),
        ).copyWith(errorText: erro),
        child: Text(
          data == null ? 'Selecionar data' : formatarData(data!),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: data == null
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
          ),
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: esquema.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFD9BFBE)),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Diminuir $label',
                onPressed: value == 0 ? null : () => onChanged(value - 1),
                style: IconButton.styleFrom(
                  backgroundColor: esquema.surfaceContainerHighest,
                  foregroundColor: esquema.onSurfaceVariant,
                  disabledForegroundColor: esquema.outline,
                  minimumSize: const Size(38, 38),
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.remove, size: 21),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Aumentar $label',
                onPressed: () => onChanged(value + 1),
                style: IconButton.styleFrom(
                  backgroundColor: esquema.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(38, 38),
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.add, size: 21),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuPlanning extends StatelessWidget {
  const _MenuPlanning({
    required this.viewModel,
    required this.onAdicionarPersonalizado,
    required this.onConfigurarSugestoes,
  });

  final EventPlanningViewModel viewModel;
  final VoidCallback onAdicionarPersonalizado;
  final VoidCallback onConfigurarSugestoes;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sugestões rápidas',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        if (viewModel.estaCarregandoCatalogo)
          const Center(child: CircularProgressIndicator())
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in viewModel.catalogo)
                _CatalogChip(item: item, viewModel: viewModel),
            ],
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const Key('adicionarItemPersonalizadoButton'),
          onPressed: onAdicionarPersonalizado,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar item personalizado'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('configurarSugestoesButton'),
          onPressed: viewModel.catalogo.isEmpty ? null : onConfigurarSugestoes,
          icon: const Icon(Icons.tune_outlined),
          label: const Text('Configurar sugestões'),
        ),
        const SizedBox(height: 14),
        if (viewModel.estaCarregandoItens)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.itens.isEmpty)
          Text(
            'Selecione itens para montar o cardápio.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
          )
        else
          Column(
            children: [
              for (final item in viewModel.itens) ...[
                _SelectedItemTile(
                  item: item,
                  onDiminuir: () => viewModel.alterarQuantidadeItem(
                    item.id,
                    _ajustarQuantidade(item.quantidade, item.unidade, -1),
                  ),
                  onAumentar: () => viewModel.alterarQuantidadeItem(
                    item.id,
                    _ajustarQuantidade(item.quantidade, item.unidade, 1),
                  ),
                  onRemover: () => viewModel.removerItem(item.id),
                ),
                if (item != viewModel.itens.last) const Divider(height: 18),
              ],
            ],
          ),
      ],
    );
  }

  double _ajustarQuantidade(
    double quantidade,
    UnidadeItem unidade,
    int direcao,
  ) {
    final passo = switch (unidade) {
      UnidadeItem.quilograma || UnidadeItem.litro => 0.05,
      _ => 1.0,
    };
    final novaQuantidade = quantidade + passo * direcao;
    return double.parse(novaQuantidade.toStringAsFixed(2));
  }
}

class _CatalogChip extends StatelessWidget {
  const _CatalogChip({required this.item, required this.viewModel});

  final ItemCatalogo item;
  final EventPlanningViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final selecionado = viewModel.itemCatalogoSelecionado(item);
    return FilterChip(
      key: Key('catalogo_${item.id}'),
      selected: selecionado,
      showCheckmark: true,
      checkmarkColor: esquema.onPrimaryContainer,
      backgroundColor: Colors.white,
      selectedColor: esquema.primaryContainer,
      side: BorderSide(
        color: selecionado ? esquema.primary : esquema.outline,
        width: selecionado ? 1.4 : 1,
      ),
      labelStyle: TextStyle(
        color: selecionado ? esquema.onPrimaryContainer : esquema.onSurface,
        fontWeight: selecionado ? FontWeight.w700 : FontWeight.w500,
      ),
      avatar: Icon(
        _iconeCategoria(item.categoria),
        size: 17,
        color: selecionado ? esquema.onPrimaryContainer : esquema.primary,
      ),
      label: Text(item.nome),
      onSelected: (value) => viewModel.alternarItemDoCatalogo(item, value),
    );
  }

  IconData _iconeCategoria(CategoriaItem categoria) => switch (categoria) {
    CategoriaItem.carnes => Icons.outdoor_grill_outlined,
    CategoriaItem.bebidas => Icons.local_drink_outlined,
    CategoriaItem.acompanhamentos => Icons.restaurant_outlined,
    CategoriaItem.materiais => Icons.inventory_2_outlined,
    CategoriaItem.sobremesas => Icons.cake_outlined,
    CategoriaItem.personalizado => Icons.add_box_outlined,
  };
}

class _SelectedItemTile extends StatelessWidget {
  const _SelectedItemTile({
    required this.item,
    required this.onDiminuir,
    required this.onAumentar,
    required this.onRemover,
  });

  final EventoItem item;
  final VoidCallback onDiminuir;
  final VoidCallback onAumentar;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final quantidade =
        '${formatarQuantidade(item.quantidade)} ${item.unidade.label}';
    return Row(
      key: Key('itemEvento_${item.id}'),
      children: [
        Icon(_iconeItem(item.categoria), color: esquema.primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.nome,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
              Text(
                quantidade,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: esquema.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          key: Key('diminuirItem_${item.id}'),
          tooltip: 'Diminuir ${item.nome}',
          onPressed: item.quantidade > 0 ? onDiminuir : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        IconButton(
          key: Key('aumentarItem_${item.id}'),
          tooltip: 'Aumentar ${item.nome}',
          onPressed: onAumentar,
          icon: const Icon(Icons.add_circle_outline),
        ),
        IconButton(
          key: Key('removerItem_${item.id}'),
          tooltip: 'Remover ${item.nome}',
          onPressed: onRemover,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  IconData _iconeItem(CategoriaItem categoria) => switch (categoria) {
    CategoriaItem.carnes => Icons.outdoor_grill_outlined,
    CategoriaItem.bebidas => Icons.local_drink_outlined,
    CategoriaItem.acompanhamentos => Icons.restaurant_outlined,
    CategoriaItem.materiais => Icons.inventory_2_outlined,
    CategoriaItem.sobremesas => Icons.cake_outlined,
    CategoriaItem.personalizado => Icons.add_box_outlined,
  };
}

class _PlanningSummary extends StatelessWidget {
  const _PlanningSummary({required this.viewModel});

  final EventPlanningViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final grupos = viewModel.itensAgrupados;
    return Column(
      children: [
        _SummaryLine(
          label: 'Participantes',
          value: '${viewModel.totalParticipantes}',
        ),
        const SizedBox(height: 8),
        if (grupos.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nenhum item selecionado',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
            ),
          )
        else
          for (final grupo in grupos.entries) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                grupo.key.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: esquema.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                grupo.value
                    .map(
                      (item) =>
                          '${item.nome}: ${formatarQuantidade(item.quantidade)} ${item.unidade.label}',
                    )
                    .join(' • '),
              ),
            ),
            const SizedBox(height: 9),
          ],
        const Divider(height: 18),
        _SummaryLine(
          label: 'Custo estimado',
          value: formatarMoeda(viewModel.custoEstimadoCentavos),
          destaque: true,
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.destaque = false,
  });

  final String label;
  final String value;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    final estilo = destaque
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: estilo),
        Text(
          value,
          style: estilo?.copyWith(
            color: destaque ? Theme.of(context).colorScheme.primary : null,
            fontWeight: destaque ? FontWeight.w800 : null,
          ),
        ),
      ],
    );
  }
}

class _CustomItemDialog extends StatefulWidget {
  const _CustomItemDialog();

  @override
  State<_CustomItemDialog> createState() => _CustomItemDialogState();
}

class _CustomItemDialogState extends State<_CustomItemDialog> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '1');
  final _precoController = TextEditingController();
  CategoriaItem _categoria = CategoriaItem.personalizado;
  UnidadeItem _unidade = UnidadeItem.unidade;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('customItemNomeField'),
              controller: _nomeController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome *',
                hintText: 'Ex.: Arroz',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CategoriaItem>(
                    key: const Key('customItemCategoriaField'),
                    initialValue: _categoria,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: CategoriaItem.values
                        .map(
                          (categoria) => DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.label),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) setState(() => _categoria = valor);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<UnidadeItem>(
                    key: const Key('customItemUnidadeField'),
                    initialValue: _unidade,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Unidade'),
                    items: UnidadeItem.values
                        .map(
                          (unidade) => DropdownMenuItem(
                            value: unidade,
                            child: Text(unidade.label),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) setState(() => _unidade = valor);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('customItemQuantidadeField'),
                    controller: _quantidadeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    key: const Key('customItemPrecoField'),
                    controller: _precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Preço unitário',
                      prefixText: 'R\$ ',
                    ),
                  ),
                ),
              ],
            ),
            if (_erro != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _erro!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirmarItemPersonalizadoButton'),
          onPressed: _confirmar,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }

  void _confirmar() {
    final nome = _nomeController.text.trim();
    final quantidade = double.tryParse(
      _quantidadeController.text.trim().replaceAll(',', '.'),
    );
    final preco = _parseCentavos(_precoController.text);
    if (nome.isEmpty) {
      setState(() => _erro = 'Informe o nome do item.');
      return;
    }
    if (quantidade == null || quantidade <= 0) {
      setState(() => _erro = 'Informe uma quantidade válida.');
      return;
    }
    if (preco == null || preco < 0) {
      setState(() => _erro = 'Informe um preço válido.');
      return;
    }

    Navigator.of(context).pop(
      EventoItem.novo(
        eventoId: '',
        nome: nome,
        categoria: _categoria,
        unidade: _unidade,
        quantidade: quantidade,
        precoUnitarioCentavos: preco,
      ),
    );
  }

  int? _parseCentavos(String texto) {
    final normalizado = texto.trim().replaceAll('.', '').replaceAll(',', '.');
    final valor = double.tryParse(normalizado);
    return valor == null ? null : (valor * 100).round();
  }
}

class _CatalogSettingsDialog extends StatelessWidget {
  const _CatalogSettingsDialog({required this.catalogo, required this.onSave});

  final List<ItemCatalogo> catalogo;
  final Future<bool> Function(ItemCatalogo item) onSave;

  @override
  Widget build(BuildContext context) {
    final altura = (MediaQuery.sizeOf(context).height * 0.68)
        .clamp(320.0, 540.0)
        .toDouble();
    return AlertDialog(
      title: const Text('Configurar sugestões'),
      content: SizedBox(
        width: 520,
        height: altura,
        child: ListView.separated(
          itemCount: catalogo.length,
          itemBuilder: (context, index) => _CatalogSettingsTile(
            key: Key('configCatalogo_${catalogo[index].id}'),
            item: catalogo[index],
            onSave: onSave,
          ),
          separatorBuilder: (_, index) => const SizedBox(height: 10),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Concluir'),
        ),
      ],
    );
  }
}

class _CatalogSettingsTile extends StatefulWidget {
  const _CatalogSettingsTile({
    required this.item,
    required this.onSave,
    super.key,
  });

  final ItemCatalogo item;
  final Future<bool> Function(ItemCatalogo item) onSave;

  @override
  State<_CatalogSettingsTile> createState() => _CatalogSettingsTileState();
}

class _CatalogSettingsTileState extends State<_CatalogSettingsTile> {
  late final TextEditingController _adultosController;
  late final TextEditingController _criancasController;
  late final TextEditingController _precoController;
  late bool _aumentaComDuracao;
  bool _salvando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _adultosController = TextEditingController(
      text: _formatarDecimal(widget.item.quantidadePorAdulto),
    );
    _criancasController = TextEditingController(
      text: _formatarDecimal(widget.item.quantidadePorCrianca),
    );
    _precoController = TextEditingController(
      text: _formatarPreco(widget.item.precoUnitarioCentavos),
    );
    _aumentaComDuracao = widget.item.aumentaComDuracao;
  }

  @override
  void dispose() {
    _adultosController.dispose();
    _criancasController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.nome,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  widget.item.unidade.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: Key('configAdultos_${widget.item.id}'),
                    controller: _adultosController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Por adulto'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: Key('configCriancas_${widget.item.id}'),
                    controller: _criancasController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Por criança'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: Key('configPreco_${widget.item.id}'),
                    controller: _precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      prefixText: 'R\$ ',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Quantidade sugerida para o planejamento',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Switch(
                  key: Key('configDuracao_${widget.item.id}'),
                  value: _aumentaComDuracao,
                  onChanged: (value) =>
                      setState(() => _aumentaComDuracao = value),
                ),
              ],
            ),
            if (_erro != null)
              Text(
                _erro!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: Key('salvarConfigCatalogo_${widget.item.id}'),
                onPressed: _salvando ? null : _salvar,
                icon: _salvando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Salvar sugestão'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    final quantidadePorAdulto = _parseDecimal(_adultosController.text);
    final quantidadePorCrianca = _parseDecimal(_criancasController.text);
    final preco = _parseCentavos(_precoController.text);
    if (quantidadePorAdulto == null || quantidadePorAdulto < 0) {
      setState(() => _erro = 'Informe uma quantidade válida por adulto.');
      return;
    }
    if (quantidadePorCrianca == null || quantidadePorCrianca < 0) {
      setState(() => _erro = 'Informe uma quantidade válida por criança.');
      return;
    }
    if (preco == null || preco < 0) {
      setState(() => _erro = 'Informe um preço válido.');
      return;
    }

    setState(() {
      _salvando = true;
      _erro = null;
    });
    final salvou = await widget.onSave(
      widget.item.copyWith(
        precoUnitarioCentavos: preco,
        quantidadePorAdulto: quantidadePorAdulto,
        quantidadePorCrianca: quantidadePorCrianca,
        aumentaComDuracao: _aumentaComDuracao,
      ),
    );
    if (!mounted) return;
    setState(() {
      _salvando = false;
      if (!salvou) _erro = 'Não foi possível salvar a sugestão.';
    });
  }

  double? _parseDecimal(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  int? _parseCentavos(String value) {
    final normalizado = value.trim().replaceAll('.', '').replaceAll(',', '.');
    final numero = double.tryParse(normalizado);
    return numero == null ? null : (numero * 100).round();
  }

  String _formatarDecimal(double value) {
    return value
        .toStringAsFixed(3)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '')
        .replaceAll('.', ',');
  }

  String _formatarPreco(int centavos) {
    final reais = centavos ~/ 100;
    final centavosFormatados = (centavos % 100).toString().padLeft(2, '0');
    return '$reais,$centavosFormatados';
  }
}
