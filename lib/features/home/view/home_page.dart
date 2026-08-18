import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_header.dart';
import '../../../domain/entities/evento.dart';
import '../../event_planning/view/event_planning_page.dart';
import '../viewmodel/home_view_model.dart';
import '../widgets/event_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _abrirPlanejamento(
    BuildContext context, {
    Evento? evento,
  }) async {
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EventPlanningPage(evento: evento)),
    );
    if (resultado == true && context.mounted) {
      await context.read<HomeViewModel>().carregarEventos();
    }
  }

  Future<void> _confirmarExclusao(BuildContext context, Evento evento) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir evento?'),
        content: Text(
          'O evento “${evento.nome}” será removido permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou == true && context.mounted) {
      await context.read<HomeViewModel>().excluirEvento(evento);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: viewModel.carregarEventos,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _HomeHeader(
                  onNovoEvento: () => _abrirPlanejamento(context),
                ),
              ),
            ),
            if (viewModel.estaCarregando)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (viewModel.mensagemErro != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ErrorState(
                  mensagem: viewModel.mensagemErro!,
                  onTentarNovamente: viewModel.carregarEventos,
                ),
              )
            else
              ..._conteudo(context, viewModel),
          ],
        ),
      ),
    );
  }

  List<Widget> _conteudo(BuildContext context, HomeViewModel viewModel) {
    final proximos = viewModel.proximosEventos;
    final recentes = viewModel.eventosRecentes;
    final temEventos = proximos.isNotEmpty || recentes.isNotEmpty;

    if (!temEventos) {
      return [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Próximos eventos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyHomeState(),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
        sliver: SliverToBoxAdapter(
          child: Text(
            'Próximos eventos',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      if (proximos.isEmpty)
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Text('Nenhum evento futuro por enquanto.'),
          ),
        )
      else
        _listaProximos(context, proximos),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        sliver: SliverToBoxAdapter(
          child: Text(
            'Eventos recentes',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      if (recentes.isEmpty)
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 32),
          sliver: SliverToBoxAdapter(
            child: Text('Seus eventos anteriores aparecerão aqui.'),
          ),
        )
      else
        _listaRecentes(context, recentes, paddingBottom: 32),
    ];
  }

  Widget _listaProximos(BuildContext context, List<Evento> eventos) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 14, 0, 0),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 192,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return EventCard(
                evento: evento,
                compacto: true,
                onEditar: () => _abrirPlanejamento(context, evento: evento),
                onExcluir: () => _confirmarExclusao(context, evento),
              );
            },
            separatorBuilder: (_, index) => const SizedBox(width: 14),
          ),
        ),
      ),
    );
  }

  Widget _listaRecentes(
    BuildContext context,
    List<Evento> eventos, {
    double paddingBottom = 0,
  }) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 14, 20, paddingBottom),
      sliver: SliverList.separated(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final evento = eventos[index];
          return RecentEventCard(
            evento: evento,
            onEditar: () => _abrirPlanejamento(context, evento: evento),
            onExcluir: () => _confirmarExclusao(context, evento),
          );
        },
        separatorBuilder: (_, index) => const SizedBox(height: 12),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onNovoEvento});

  final VoidCallback onNovoEvento;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(),
        const SizedBox(height: 28),
        Text('Olá, João!', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'Pronto para acender a churrasqueira?',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: esquema.onSurfaceVariant),
        ),
        const SizedBox(height: 22),
        _PlanEventBanner(onPressed: onNovoEvento),
      ],
    );
  }
}

class _PlanEventBanner extends StatelessWidget {
  const _PlanEventBanner({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Material(
      color: esquema.primary,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 166,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 22, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Text(
                  'Planejar novo evento',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      'Comece a organizar agora',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHomeState extends StatelessWidget {
  const _EmptyHomeState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.outdoor_grill_outlined,
              size: 68,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Você ainda não tem eventos',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crie seu primeiro planejamento e deixe o Churras Fácil cuidar do resto.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.mensagem, required this.onTentarNovamente});

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(mensagem, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onTentarNovamente,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
