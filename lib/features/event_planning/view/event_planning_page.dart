import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_header.dart';
import '../../../core/formatters/data_formatters.dart';
import '../../../data/repositories/evento_repository.dart';
import '../../../domain/entities/evento.dart';
import '../viewmodel/event_planning_view_model.dart';

class EventPlanningPage extends StatelessWidget {
  const EventPlanningPage({this.evento, super.key});

  final Evento? evento;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventPlanningViewModel(
        eventoRepository: context.read<EventoRepository>(),
        evento: evento,
      ),
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
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
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
                    onPressed: viewModel.estaSalvando
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
                          : 'Salvar evento',
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
}

class _PlanningHero extends StatelessWidget {
  const _PlanningHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 138,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/barbecue_hero.png', fit: BoxFit.cover),
            ColoredBox(color: Colors.black.withValues(alpha: 0.28)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Text(
                  'Planeje seu evento',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: tema.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
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
