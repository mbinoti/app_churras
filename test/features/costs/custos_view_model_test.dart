import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:app_churras/features/costs/viewmodel/custos_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_evento_repository.dart';
import '../../fakes/fake_item_evento_repository.dart';

void main() {
  group('CustosViewModel', () {
    late Evento evento;
    late FakeEventoRepository eventoRepository;
    late FakeEventoItemRepository itemRepository;
    late CustosViewModel viewModel;

    setUp(() async {
      evento = Evento.novo(
        id: 'evento-custos-view-model',
        nome: 'Churrasco da família',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.churrasco,
        agora: DateTime(2026, 8, 19),
      );
      eventoRepository = FakeEventoRepository([evento]);
      itemRepository = FakeEventoItemRepository([
        EventoItem.novo(
          id: 'item-carne',
          eventoId: evento.id,
          nome: 'Carnes',
          categoria: CategoriaItem.carnes,
          unidade: UnidadeItem.quilograma,
          quantidade: 2,
          precoUnitarioCentavos: 15000,
        ),
        EventoItem.novo(
          id: 'item-carvao',
          eventoId: evento.id,
          nome: 'Carvão',
          categoria: CategoriaItem.materiais,
          unidade: UnidadeItem.saco,
          quantidade: 1,
          precoUnitarioCentavos: 2500,
          foiComprado: true,
        ),
      ]);
      viewModel = CustosViewModel(
        eventoRepository: eventoRepository,
        itemRepository: itemRepository,
      );
      await viewModel.carregar();
    });

    test('carrega os itens e calcula o total estimado', () {
      expect(viewModel.eventoSelecionado, evento);
      expect(viewModel.itens, hasLength(2));
      expect(viewModel.custoTotalCentavos, 32500);
      expect(viewModel.itensComprados, 1);
      expect(viewModel.progressoCompras, 0.5);
    });

    test('filtra os itens ao trocar de evento', () async {
      final outroEvento = Evento.novo(
        id: 'outro-evento',
        nome: 'Outro encontro',
        dataEvento: DateTime(2026, 9, 6),
        tipo: TipoEvento.familia,
        agora: DateTime(2026, 8, 19),
      );
      eventoRepository.eventos.add(outroEvento);
      itemRepository.itens.add(
        EventoItem.novo(
          id: 'item-outro-evento',
          eventoId: outroEvento.id,
          nome: 'Gelo',
          categoria: CategoriaItem.materiais,
          unidade: UnidadeItem.saco,
          quantidade: 2,
          precoUnitarioCentavos: 1000,
        ),
      );

      await viewModel.selecionarEvento(outroEvento.id);

      expect(viewModel.eventoSelecionado, outroEvento);
      expect(viewModel.itens.map((item) => item.nome), ['Gelo']);
      expect(viewModel.custoTotalCentavos, 2000);
    });
  });
}
