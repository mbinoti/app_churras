import 'package:flutter/material.dart';

import '../../../core/formatters/data_formatters.dart';
import '../../../domain/entities/evento.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.evento,
    required this.onEditar,
    required this.onExcluir,
    this.compacto = false,
    super.key,
  });

  final Evento evento;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return SizedBox(
      width: compacto ? 302 : null,
      height: compacto ? 210 : null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: esquema.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      evento.tipo == TipoEvento.aniversario
                          ? Icons.celebration_outlined
                          : Icons.local_fire_department_outlined,
                      color: esquema.tertiary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: esquema.secondaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        formatarDiasRestantes(
                          evento.dataEvento,
                          DateTime.now(),
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: esquema.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  _EventMenu(onEditar: onEditar, onExcluir: onExcluir),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                evento.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${formatarData(evento.dataEvento)} • ${evento.tipo.label}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: esquema.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 18,
                    color: esquema.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${evento.totalParticipantes} participantes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentEventCard extends StatelessWidget {
  const RecentEventCard({
    required this.evento,
    required this.onEditar,
    required this.onExcluir,
    super.key,
  });

  final Evento evento;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Card(
      color: esquema.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 10, 16),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: esquema.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history, color: esquema.onSurfaceVariant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatarData(evento.dataEvento),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _EventMenu(onEditar: onEditar, onExcluir: onExcluir),
          ],
        ),
      ),
    );
  }
}

class _EventMenu extends StatelessWidget {
  const _EventMenu({required this.onEditar, required this.onExcluir});

  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Mais opções',
      padding: EdgeInsets.zero,
      onSelected: (opcao) {
        if (opcao == 'editar') onEditar();
        if (opcao == 'excluir') onExcluir();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'editar', child: Text('Editar')),
        PopupMenuItem(value: 'excluir', child: Text('Excluir')),
      ],
    );
  }
}
