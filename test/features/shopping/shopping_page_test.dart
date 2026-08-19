import 'package:app_churras/app/app.dart';
import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_evento_repository.dart';
import '../../fakes/fake_item_evento_repository.dart';

void main() {
  testWidgets('exibe progresso, marca compras e adiciona item manual', (
    tester,
  ) async {
    final evento = Evento.novo(
      id: 'evento-compras-page',
      nome: 'Churrasco da família',
      dataEvento: DateTime(2026, 9, 5),
      tipo: TipoEvento.churrasco,
      agora: DateTime(2026, 8, 19),
    );
    final eventoRepository = FakeEventoRepository([evento]);
    final itemRepository = FakeEventoItemRepository([
      EventoItem.novo(
        id: 'item-page-picanha',
        eventoId: evento.id,
        nome: 'Picanha',
        categoria: CategoriaItem.carnes,
        unidade: UnidadeItem.quilograma,
        quantidade: 2,
        precoUnitarioCentavos: 6500,
      ),
      EventoItem.novo(
        id: 'item-page-carvao',
        eventoId: evento.id,
        nome: 'Carvão',
        categoria: CategoriaItem.materiais,
        unidade: UnidadeItem.saco,
        quantidade: 1,
        precoUnitarioCentavos: 2500,
        foiComprado: true,
      ),
    ]);

    await tester.pumpWidget(
      ChurrasFacilApp(
        eventoRepository: eventoRepository,
        eventoItemRepository: itemRepository,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compras'));
    await tester.pumpAndSettle();

    expect(find.text('Lista de compras'), findsOneWidget);
    expect(find.text('Churrasco da família'), findsOneWidget);
    expect(find.text('1/2 itens'), findsOneWidget);
    expect(find.text('R\$ 155,00'), findsOneWidget);
    expect(find.text('R\$ 130,00'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('compras_checkbox_item-page-picanha')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tudo comprado!'), findsOneWidget);
    expect(
      itemRepository.itens
          .firstWhere((item) => item.id == 'item-page-picanha')
          .foiComprado,
      isTrue,
    );

    final adicionar = find.byKey(const Key('adicionarItemComprasButton'));
    await tester.scrollUntilVisible(
      adicionar,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(adicionar);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('comprasItemNomeField')),
      'Farofa',
    );
    await tester.enterText(
      find.byKey(const Key('comprasItemQuantidadeField')),
      '2',
    );
    await tester.enterText(
      find.byKey(const Key('comprasItemPrecoField')),
      '12,00',
    );
    await tester.tap(find.byKey(const Key('confirmarItemComprasButton')));
    await tester.pumpAndSettle();

    expect(find.text('Farofa'), findsOneWidget);
    expect(itemRepository.itens.map((item) => item.nome), contains('Farofa'));
  });
}
