import 'package:app_churras/app/app.dart';
import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/tarefa.dart';
import 'package:app_churras/features/tasks/view/tarefas_page.dart';
import 'package:app_churras/features/tasks/viewmodel/tarefas_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../fakes/fake_evento_repository.dart';
import '../../fakes/fake_tarefa_repository.dart';

void main() {
  testWidgets('cria, atribui e conclui uma tarefa', (tester) async {
    final evento = Evento.novo(
      id: 'evento-tarefas-page',
      nome: 'Churrasco da família',
      dataEvento: DateTime(2026, 9, 5),
      tipo: TipoEvento.churrasco,
      agora: DateTime(2026, 8, 19),
    );
    final eventoRepository = FakeEventoRepository([evento]);
    final tarefaRepository = FakeTarefaRepository([
      Tarefa.novo(
        id: 'tarefa-page-gelo',
        eventoId: evento.id,
        titulo: 'Comprar gelo',
      ),
    ]);

    final viewModel = TarefasViewModel(
      eventoRepository: eventoRepository,
      tarefaRepository: tarefaRepository,
    );
    await viewModel.carregar();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: const MaterialApp(home: TarefasPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Preparação do evento'), findsOneWidget);
    expect(find.text('Comprar gelo'), findsOneWidget);
    expect(find.text('Sem responsável'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('tarefas_atribuir_tarefa-page-gelo')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('editarResponsavelField')),
      'Ana',
    );
    await tester.tap(find.byKey(const Key('confirmarResponsavelButton')));
    await tester.pumpAndSettle();

    expect(find.text('Ana'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('tarefas_checkbox_tarefa-page-gelo')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Concluída'), findsOneWidget);
    expect(tarefaRepository.tarefas.single.estaConcluida, isTrue);

    final adicionar = find.byKey(const Key('adicionarTarefaButton'));
    await tester.ensureVisible(adicionar);
    await tester.tap(adicionar);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('tarefaTituloField')),
      'Preparar vinagrete',
    );
    await tester.enterText(
      find.byKey(const Key('tarefaResponsavelField')),
      'João',
    );
    await tester.tap(find.byKey(const Key('confirmarTarefaButton')));
    await tester.pumpAndSettle();

    expect(find.text('Preparar vinagrete'), findsOneWidget);
    expect(
      tarefaRepository.tarefas.map((tarefa) => tarefa.titulo),
      contains('Preparar vinagrete'),
    );
  });

  testWidgets('não exibe Tarefas na navegação principal', (tester) async {
    await tester.pumpWidget(
      ChurrasFacilApp(eventoRepository: FakeEventoRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tarefas'), findsNothing);
    expect(find.text('Compras'), findsOneWidget);
    expect(find.text('Custos'), findsOneWidget);
  });
}
