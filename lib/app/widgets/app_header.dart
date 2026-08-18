import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({this.onBack, super.key});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (onBack != null) ...[
          IconButton(
            tooltip: 'Voltar',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 2),
        ] else
          const SizedBox(width: 4),
        CircleAvatar(
          radius: 23,
          backgroundColor: esquema.surfaceContainerHighest,
          backgroundImage: const AssetImage('assets/images/profile_avatar.png'),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Churras Fácil',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: esquema.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Configurações',
          onPressed: () {},
          icon: Icon(
            Icons.settings_outlined,
            size: 30,
            color: esquema.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
