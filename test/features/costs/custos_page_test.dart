import 'package:app_churras/app/app.dart';
import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_evento_repository.dart';
import '../../fakes/fake_item_evento_repository.dart';

void main() {
  testWidgets('exibe apenas o total e os itens do evento', (tester) async {
    final evento = Evento.novo(
      id: 'evento-custos-page',
      nome: 'Churrasco da família',
      dataEvento: DateTime(2026, 9, 5),
      tipo: TipoEvento.churrasco,
      agora: DateTime(2026, 8, 19),
    );
    final itens = FakeEventoItemRepository([
      EventoItem.novo(
        id: 'item-page-carne',
        eventoId: evento.id,
        nome: 'Carnes',
        categoria: CategoriaItem.carnes,
        unidade: UnidadeItem.quilograma,
        quantidade: 2,
        precoUnitarioCentavos: 15000,
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
        eventoRepository: FakeEventoRepository([evento]),
        eventoItemRepository: itens,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custos'));
    await tester.pumpAndSettle();

    expect(find.text('Total do evento'), findsOneWidget);
    expect(find.text('R\$ 325,00'), findsOneWidget);
    expect(find.text('1/2 comprados'), findsOneWidget);

    final itensEvento = find.text('Itens do evento');
    await tester.scrollUntilVisible(
      itensEvento,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(itensEvento, findsOneWidget);
    expect(find.text('Carnes'), findsOneWidget);
    expect(find.text('Carvão'), findsOneWidget);
    expect(find.text('Pendente'), findsOneWidget);
    expect(find.text('Comprado'), findsOneWidget);

    expect(find.text('Total das despesas'), findsNothing);
    expect(find.text('Quem deve a quem?'), findsNothing);
    expect(find.text('Despesa'), findsNothing);
  });
}
