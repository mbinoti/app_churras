import 'package:app_churras/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_evento_repository.dart';
import '../fakes/fake_item_evento_repository.dart';
import '../fakes/fake_catalogo_repository.dart';
import '../fakes/catalogo_test_data.dart';

void main() {
  testWidgets('monta cardápio, adiciona item personalizado e salva resumo', (
    tester,
  ) async {
    final eventoRepository = FakeEventoRepository();
    final catalogoRepository = FakeCatalogoRepository(catalogoItensTeste);
    final itemRepository = FakeEventoItemRepository();
    await tester.pumpWidget(
      ChurrasFacilApp(
        eventoRepository: eventoRepository,
        catalogoRepository: catalogoRepository,
        eventoItemRepository: itemRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Planejar novo evento'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('nomeEventoField')),
      'Churrasco da sprint 2',
    );
    await tester.tap(find.byKey(const Key('selecionarDataButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    final aumentarAdultos = find.byTooltip('Aumentar Adultos');
    await tester.ensureVisible(aumentarAdultos);
    for (var i = 0; i < 4; i++) {
      await tester.tap(aumentarAdultos);
      await tester.pump();
    }

    final picanha = find.byKey(const Key('catalogo_picanha'));
    await tester.scrollUntilVisible(
      picanha,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(picanha);
    await tester.pump();
    expect(tester.widget<FilterChip>(picanha).selected, isTrue);
    expect(find.text('Picanha'), findsWidgets);
    expect(find.text('R\$ 31,20'), findsOneWidget);

    final adicionarPersonalizado = find.byKey(
      const Key('adicionarItemPersonalizadoButton'),
    );
    await tester.ensureVisible(adicionarPersonalizado);
    await tester.tap(adicionarPersonalizado);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('customItemNomeField')),
      'Arroz',
    );
    await tester.enterText(
      find.byKey(const Key('customItemPrecoField')),
      '9,00',
    );
    await tester.tap(find.byKey(const Key('confirmarItemPersonalizadoButton')));
    await tester.pumpAndSettle();

    expect(find.text('Arroz'), findsWidgets);
    expect(find.text('R\$ 40,20'), findsOneWidget);

    final salvar = find.byKey(const Key('salvarEventoButton'));
    await tester.ensureVisible(salvar);
    await tester.tap(salvar);
    await tester.pumpAndSettle();

    expect(find.text('Churrasco da sprint 2'), findsOneWidget);
    expect(itemRepository.itens, hasLength(2));
    expect(itemRepository.itens.map((item) => item.nome), contains('Arroz'));
  });

  testWidgets('edita a regra de consumo do catálogo pelo app', (tester) async {
    final catalogoRepository = FakeCatalogoRepository(catalogoItensTeste);
    await tester.pumpWidget(
      ChurrasFacilApp(
        eventoRepository: FakeEventoRepository(),
        catalogoRepository: catalogoRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Planejar novo evento'));
    await tester.pumpAndSettle();
    final configurar = find.byKey(const Key('configurarSugestoesButton'));
    await tester.ensureVisible(configurar);
    await tester.tap(configurar);
    await tester.pumpAndSettle();

    expect(find.text('Configurar sugestões'), findsNWidgets(2));
    await tester.enterText(
      find.byKey(const Key('configAdultos_picanha')),
      '0,18',
    );
    await tester.tap(find.byKey(const Key('salvarConfigCatalogo_picanha')));
    await tester.pumpAndSettle();

    expect(catalogoRepository.itens.first.quantidadePorAdulto, 0.18);
    expect(catalogoRepository.quantidadeAtualizacoes, 1);
  });
}
