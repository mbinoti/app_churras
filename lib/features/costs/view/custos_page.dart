import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_header.dart';
import '../../../core/formatters/data_formatters.dart';
import '../../../domain/entities/item_evento.dart';
import '../viewmodel/custos_view_model.dart';

class CustosPage extends StatelessWidget {
  const CustosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustosViewModel>();

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
                      child: _CustosHeader(viewModel: viewModel),
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
                      child: _CustosError(
                        mensagem: viewModel.mensagemErro!,
                        onTentarNovamente: viewModel.carregar,
                      ),
                    )
                  else if (viewModel.eventoSelecionado == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _CustosEmptyEventState(),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: _TotalCard(viewModel: viewModel),
                      ),
                    ),
                    if (viewModel.mensagemErro != null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            viewModel.mensagemErro!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    if (viewModel.itens.isEmpty && !viewModel.estaCarregando)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _ItensEmptyState(),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                        sliver: SliverToBoxAdapter(
                          child: _ItensEventoCard(itens: viewModel.itens),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustosHeader extends StatelessWidget {
  const _CustosHeader({required this.viewModel});

  final CustosViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(),
        const SizedBox(height: 30),
        Text('Custos', style: Theme.of(context).textTheme.headlineMedium),
        if (viewModel.eventos.length > 1) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: const Key('custosEventoDropdown'),
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
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.viewModel});

  final CustosViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Card(
      color: esquema.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total do evento',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatarMoeda(viewModel.custoTotalCentavos),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            if (viewModel.totalItens > 0)
              Text(
                '${viewModel.itensComprados}/${viewModel.totalItens} comprados',
                style: TextStyle(
                  color: esquema.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ItensEventoCard extends StatelessWidget {
  const _ItensEventoCard({required this.itens});

  final List<EventoItem> itens;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Card(
      color: esquema.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Itens do evento',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 4),
            for (final item in itens) ...[
              _ItemCustoRow(item: item),
              if (item != itens.last) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _ItemCustoRow extends StatelessWidget {
  const _ItemCustoRow({required this.item});

  final EventoItem item;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final custo = item.precoUnitarioCentavos == null
        ? 'Sem preço'
        : formatarMoeda(item.custoEstimadoCentavos);
    final status = item.foiComprado ? 'Comprado' : 'Pendente';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: item.foiComprado
                  ? esquema.secondaryContainer
                  : esquema.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Icon(
                item.foiComprado
                    ? Icons.check_outlined
                    : _iconeDaCategoria(item.categoria),
                size: 20,
                color: item.foiComprado
                    ? esquema.onSecondaryContainer
                    : esquema.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nome, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  '${_formatarQuantidade(item.quantidade)} ${item.unidade.label}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: esquema.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: item.foiComprado
                        ? esquema.secondary
                        : esquema.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            custo,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: esquema.primary),
          ),
        ],
      ),
    );
  }
}

class _ItensEmptyState extends StatelessWidget {
  const _ItensEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          'Nenhum item foi adicionado ao planejamento deste evento.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CustosEmptyEventState extends StatelessWidget {
  const _CustosEmptyEventState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          'Crie um evento para visualizar os itens e o total.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CustosError extends StatelessWidget {
  const _CustosError({required this.mensagem, required this.onTentarNovamente});

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 52),
            const SizedBox(height: 12),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onTentarNovamente,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconeDaCategoria(CategoriaItem categoria) => switch (categoria) {
  CategoriaItem.carnes => Icons.outdoor_grill_outlined,
  CategoriaItem.bebidas => Icons.local_drink_outlined,
  CategoriaItem.acompanhamentos => Icons.restaurant_outlined,
  CategoriaItem.materiais => Icons.inventory_2_outlined,
  CategoriaItem.sobremesas => Icons.cake_outlined,
  CategoriaItem.personalizado => Icons.receipt_long_outlined,
};

String _formatarQuantidade(double quantidade) {
  if (quantidade == quantidade.roundToDouble()) {
    return quantidade.toStringAsFixed(0);
  }
  return quantidade.toStringAsFixed(2).replaceFirst('.', ',');
}
