import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_header.dart';
import '../../../core/formatters/data_formatters.dart';
import '../../../domain/entities/item_evento.dart';
import '../viewmodel/shopping_view_model.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ShoppingViewModel>();

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
                      child: _ShoppingHeader(viewModel: viewModel),
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
                      child: _ShoppingError(
                        mensagem: viewModel.mensagemErro!,
                        onTentarNovamente: viewModel.carregar,
                      ),
                    )
                  else if (viewModel.eventoSelecionado == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ShoppingEmptyState(),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: _ShoppingSummary(viewModel: viewModel),
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
                    if (viewModel.itens.isEmpty && !viewModel.estaCarregando)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _ItemsEmptyState(
                          onAdicionar: () => _abrirDialogoAdicionar(context),
                        ),
                      )
                    else ...[
                      for (final grupo in viewModel.itensAgrupados.entries)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                          sliver: SliverToBoxAdapter(
                            child: _CategoryCard(
                              categoria: grupo.key,
                              itens: grupo.value,
                              idAtualizando: viewModel.idAtualizando,
                              onChanged: viewModel.alterarItemComprado,
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                        sliver: SliverToBoxAdapter(
                          child: _AddItemButton(
                            estaAdicionando: viewModel.estaAdicionando,
                            onPressed: () => _abrirDialogoAdicionar(context),
                          ),
                        ),
                      ),
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
    final viewModel = context.read<ShoppingViewModel>();
    final novoItem = await showDialog<_NovoItemCompras>(
      context: context,
      builder: (_) => const _AdicionarItemDialog(),
    );
    if (novoItem == null || !context.mounted) return;

    await viewModel.adicionarItem(
      nome: novoItem.nome,
      categoria: novoItem.categoria,
      unidade: novoItem.unidade,
      quantidade: novoItem.quantidade,
      precoUnitarioCentavos: novoItem.precoUnitarioCentavos,
    );
  }
}

class _ShoppingHeader extends StatelessWidget {
  const _ShoppingHeader({required this.viewModel});

  final ShoppingViewModel viewModel;

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
                'Lista de compras',
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
            key: const Key('comprasEventoDropdown'),
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

class _ShoppingSummary extends StatelessWidget {
  const _ShoppingSummary({required this.viewModel});

  final ShoppingViewModel viewModel;

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
                    'Total estimado',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatarMoeda(viewModel.custoTotalCentavos),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Semantics(
              label: 'Itens comprados',
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
                    '${viewModel.itensComprados}/${viewModel.totalItens} itens',
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
          viewModel.itensPendentes == 0 && viewModel.totalItens > 0
              ? 'Tudo comprado!'
              : '${viewModel.itensPendentes} ${viewModel.itensPendentes == 1 ? 'item pendente' : 'itens pendentes'}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.categoria,
    required this.itens,
    required this.idAtualizando,
    required this.onChanged,
  });

  final CategoriaItem categoria;
  final List<EventoItem> itens;
  final String? idAtualizando;
  final Future<bool> Function(String id, bool foiComprado) onChanged;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _iconeDaCategoria(categoria),
                  color: esquema.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    categoria.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '${itens.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: esquema.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final item = itens[index];
                return _ShoppingItemTile(
                  item: item,
                  estaAtualizando: idAtualizando == item.id,
                  onChanged: (foiComprado) => onChanged(item.id, foiComprado),
                );
              },
              separatorBuilder: (_, index) => const Divider(height: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingItemTile extends StatelessWidget {
  const _ShoppingItemTile({
    required this.item,
    required this.estaAtualizando,
    required this.onChanged,
  });

  final EventoItem item;
  final bool estaAtualizando;
  final Future<bool> Function(bool foiComprado) onChanged;

  @override
  Widget build(BuildContext context) {
    final estilo = item.foiComprado
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;
    final custoUnitario = item.precoUnitarioCentavos == null
        ? null
        : '${formatarMoeda(item.precoUnitarioCentavos!)} / ${item.unidade.label}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            key: Key('compras_checkbox_${item.id}'),
            value: item.foiComprado,
            onChanged: estaAtualizando
                ? null
                : (valor) {
                    if (valor != null) onChanged(valor);
                  },
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nome, style: estilo),
                const SizedBox(height: 2),
                Text(
                  '${formatarQuantidade(item.quantidade)} ${item.unidade.label}${custoUnitario == null ? '' : ' • $custoUnitario'}',
                  style: estilo ?? Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.precoUnitarioCentavos == null
                ? '—'
                : formatarMoeda(item.custoEstimadoCentavos),
            style: estilo ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AddItemButton extends StatelessWidget {
  const _AddItemButton({
    required this.estaAdicionando,
    required this.onPressed,
  });

  final bool estaAdicionando;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              key: const Key('adicionarItemComprasButton'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                minimumSize: const Size.fromHeight(52),
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
              label: const Text('Adicionar item'),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filled(
            tooltip: 'Adicionar item',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(52, 52),
            ),
            onPressed: estaAdicionando ? null : onPressed,
            icon: const Icon(Icons.add, size: 28),
          ),
        ],
      ),
    );
  }
}

class _ShoppingEmptyState extends StatelessWidget {
  const _ShoppingEmptyState();

  @override
  Widget build(BuildContext context) {
    return _CenteredState(
      icon: Icons.event_note_outlined,
      title: 'Crie um evento para começar',
      message: 'Sua lista de compras aparecerá aqui depois do planejamento.',
    );
  }
}

class _ItemsEmptyState extends StatelessWidget {
  const _ItemsEmptyState({required this.onAdicionar});

  final VoidCallback onAdicionar;

  @override
  Widget build(BuildContext context) {
    return _CenteredState(
      icon: Icons.shopping_basket_outlined,
      title: 'Sua lista está vazia',
      message: 'Adicione um item para começar a acompanhar as compras.',
      action: OutlinedButton.icon(
        key: const Key('adicionarItemComprasButton'),
        onPressed: onAdicionar,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar item'),
      ),
    );
  }
}

class _ShoppingError extends StatelessWidget {
  const _ShoppingError({
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

class _NovoItemCompras {
  const _NovoItemCompras({
    required this.nome,
    required this.categoria,
    required this.unidade,
    required this.quantidade,
    required this.precoUnitarioCentavos,
  });

  final String nome;
  final CategoriaItem categoria;
  final UnidadeItem unidade;
  final double quantidade;
  final int? precoUnitarioCentavos;
}

class _AdicionarItemDialog extends StatefulWidget {
  const _AdicionarItemDialog();

  @override
  State<_AdicionarItemDialog> createState() => _AdicionarItemDialogState();
}

class _AdicionarItemDialogState extends State<_AdicionarItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '1');
  final _precoController = TextEditingController();
  CategoriaItem _categoria = CategoriaItem.acompanhamentos;
  UnidadeItem _unidade = UnidadeItem.unidade;

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
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('comprasItemNomeField'),
                controller: _nomeController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (valor) => valor == null || valor.trim().isEmpty
                    ? 'Informe o nome.'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<CategoriaItem>(
                      key: const Key('comprasItemCategoriaField'),
                      initialValue: _categoria,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: [
                        for (final categoria in CategoriaItem.values.where(
                          (item) => item != CategoriaItem.personalizado,
                        ))
                          DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.label),
                          ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) setState(() => _categoria = valor);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<UnidadeItem>(
                      key: const Key('comprasItemUnidadeField'),
                      initialValue: _unidade,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Unidade'),
                      items: [
                        for (final unidade in UnidadeItem.values)
                          DropdownMenuItem(
                            value: unidade,
                            child: Text(unidade.label),
                          ),
                      ],
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
                    child: TextFormField(
                      key: const Key('comprasItemQuantidadeField'),
                      controller: _quantidadeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                      validator: (valor) {
                        final quantidade = _parseNumero(valor);
                        return quantidade == null || quantidade <= 0
                            ? 'Use um valor maior que zero.'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      key: const Key('comprasItemPrecoField'),
                      controller: _precoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Preço unitário',
                        prefixText: 'R\$ ',
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) return null;
                        final preco = _parseNumero(valor);
                        return preco == null || preco < 0
                            ? 'Informe um preço válido.'
                            : null;
                      },
                    ),
                  ),
                ],
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
          key: const Key('confirmarItemComprasButton'),
          onPressed: _confirmar,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }

  void _confirmar() {
    if (!_formKey.currentState!.validate()) return;
    final quantidade = _parseNumero(_quantidadeController.text)!;
    final preco = _precoController.text.trim().isEmpty
        ? null
        : ((_parseNumero(_precoController.text)! * 100).round());
    Navigator.pop(
      context,
      _NovoItemCompras(
        nome: _nomeController.text.trim(),
        categoria: _categoria,
        unidade: _unidade,
        quantidade: quantidade,
        precoUnitarioCentavos: preco,
      ),
    );
  }

  double? _parseNumero(String? texto) {
    if (texto == null || texto.trim().isEmpty) return null;
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }
}

IconData _iconeDaCategoria(CategoriaItem categoria) {
  return switch (categoria) {
    CategoriaItem.carnes => Icons.local_fire_department_outlined,
    CategoriaItem.bebidas => Icons.local_bar_outlined,
    CategoriaItem.acompanhamentos => Icons.restaurant_outlined,
    CategoriaItem.materiais => Icons.inventory_2_outlined,
    CategoriaItem.sobremesas => Icons.cake_outlined,
    CategoriaItem.personalizado => Icons.add_box_outlined,
  };
}
