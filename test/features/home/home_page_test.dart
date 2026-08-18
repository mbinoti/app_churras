import 'package:app_churras/app/app.dart';
import 'package:app_churras/domain/entities/evento.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_evento_repository.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, {List<Evento>? eventos}) async {
    await tester.pumpWidget(
      ChurrasFacilApp(eventoRepository: FakeEventoRepository(eventos)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('exibe estado vazio e navega pelos placeholders', (tester) async {
    await pumpApp(tester);

    expect(find.text('Você ainda não tem eventos'), findsOneWidget);
    expect(find.text('Planejar novo evento'), findsOneWidget);

    await tester.tap(find.text('Compras'));
    await tester.pumpAndSettle();

    expect(
      find.text('Esta área estará disponível em uma próxima sprint.'),
      findsOneWidget,
    );
  });

  testWidgets('valida nome e data no formulário de evento', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Planejar novo evento'));
    await tester.pumpAndSettle();
    final salvar = find.byKey(const Key('salvarEventoButton'));
    await tester.ensureVisible(salvar);
    await tester.pumpAndSettle();
    await tester.tap(salvar);
    await tester.pump();

    expect(find.text('Informe o nome do evento.'), findsOneWidget);
    expect(find.text('Selecione a data do evento.'), findsOneWidget);
  });

  testWidgets('conclui o fluxo de criação e exibe o evento na Home', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Planejar novo evento'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('nomeEventoField')),
      'Churrasco de inauguração',
    );
    await tester.tap(find.byKey(const Key('selecionarDataButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    final salvar = find.byKey(const Key('salvarEventoButton'));
    await tester.ensureVisible(salvar);
    await tester.pumpAndSettle();
    await tester.tap(salvar);
    await tester.pumpAndSettle();

    expect(find.text('Churrasco de inauguração'), findsOneWidget);
    expect(find.text('Próximos eventos'), findsOneWidget);
  });

  testWidgets('edita um evento existente pela Home', (tester) async {
    final evento = Evento.novo(
      id: 'evento-home',
      nome: 'Evento antigo',
      dataEvento: DateTime.now().add(const Duration(days: 2)),
      tipo: TipoEvento.churrasco,
      agora: DateTime.now(),
    );
    await pumpApp(tester, eventos: [evento]);

    await tester.tap(find.byTooltip('Mais opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('nomeEventoField')),
      'Evento atualizado',
    );
    final salvar = find.byKey(const Key('salvarEventoButton'));
    await tester.ensureVisible(salvar);
    await tester.pumpAndSettle();
    await tester.tap(salvar);
    await tester.pumpAndSettle();

    expect(find.text('Evento atualizado'), findsOneWidget);
    expect(find.text('Evento antigo'), findsNothing);
  });

  testWidgets('confirma exclusão de um evento', (tester) async {
    final evento = Evento.novo(
      id: 'evento-excluir',
      nome: 'Evento para excluir',
      dataEvento: DateTime.now().add(const Duration(days: 2)),
      tipo: TipoEvento.churrasco,
      agora: DateTime.now(),
    );
    await pumpApp(tester, eventos: [evento]);

    await tester.tap(find.byTooltip('Mais opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Excluir evento?'), findsOneWidget);
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Evento para excluir'), findsNothing);
    expect(find.text('Você ainda não tem eventos'), findsOneWidget);
  });
}
