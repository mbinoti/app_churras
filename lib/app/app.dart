import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/catalogo_repository.dart';
import '../data/repositories/despesa_repository.dart';
import '../data/repositories/item_evento_repository.dart';
import '../data/repositories/evento_repository.dart';
import '../data/repositories/tarefa_repository.dart';
import '../features/costs/view/custos_page.dart';
import '../features/costs/viewmodel/custos_view_model.dart';
import '../features/home/view/home_page.dart';
import '../features/home/viewmodel/home_view_model.dart';
import '../features/shopping/view/shopping_page.dart';
import '../features/shopping/viewmodel/shopping_view_model.dart';
import '../features/tasks/viewmodel/tarefas_view_model.dart';
import 'app_theme.dart';

class ChurrasFacilApp extends StatelessWidget {
  const ChurrasFacilApp({
    required this.eventoRepository,
    this.catalogoRepository,
    this.eventoItemRepository,
    this.tarefaRepository,
    this.despesaRepository,
    super.key,
  });

  final EventoRepository eventoRepository;
  final CatalogoRepository? catalogoRepository;
  final EventoItemRepository? eventoItemRepository;
  final TarefaRepository? tarefaRepository;
  final DespesaRepository? despesaRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventoRepository>.value(value: eventoRepository),
        Provider<CatalogoRepository?>.value(value: catalogoRepository),
        Provider<EventoItemRepository?>.value(value: eventoItemRepository),
        Provider<DespesaRepository?>.value(value: despesaRepository),
        ChangeNotifierProvider(
          create: (_) =>
              HomeViewModel(eventoRepository: eventoRepository)
                ..carregarEventos(),
        ),
        ChangeNotifierProvider(
          create: (_) => ShoppingViewModel(
            eventoRepository: eventoRepository,
            itemRepository: eventoItemRepository,
          )..carregar(),
        ),
        ChangeNotifierProvider(
          create: (_) => TarefasViewModel(
            eventoRepository: eventoRepository,
            tarefaRepository: tarefaRepository,
          )..carregar(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustosViewModel(
            eventoRepository: eventoRepository,
            itemRepository: eventoItemRepository,
          )..carregar(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Churras Fácil',
        theme: criarTema(),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _indiceSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSelecionado,
        children: const [HomePage(), ShoppingPage(), CustosPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSelecionado,
        onDestinationSelected: (indice) {
          final eventoIdAtual = switch (_indiceSelecionado) {
            1 => context.read<ShoppingViewModel>().eventoSelecionado?.id,
            2 => context.read<CustosViewModel>().eventoSelecionado?.id,
            _ => null,
          };
          setState(() => _indiceSelecionado = indice);
          if (indice == 1) {
            context.read<ShoppingViewModel>().carregar(eventoId: eventoIdAtual);
          } else if (indice == 2) {
            context.read<CustosViewModel>().carregar(eventoId: eventoIdAtual);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Custos',
          ),
        ],
      ),
    );
  }
}
