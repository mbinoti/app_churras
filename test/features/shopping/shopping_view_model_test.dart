import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:app_churras/features/shopping/viewmodel/shopping_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_evento_repository.dart';
import '../../fakes/fake_item_evento_repository.dart';

void main() {
  group('ShoppingViewModel — Sprint 3', () {
    late Evento evento;
    late FakeEventoRepository eventoRepository;
    late FakeEventoItemRepository itemRepository;
    late ShoppingViewModel viewModel;

    setUp(() async {
      evento = Evento.novo(
        id: 'evento-compras',
        nome: 'Churrasco de domingo',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.churrasco,
        agora: DateTime(2026, 8, 19),
      );
      eventoRepository = FakeEventoRepository([evento]);
      itemRepository = FakeEventoItemRepository([
        EventoItem.novo(
          id: 'item-picanha',
          eventoId: evento.id,
          nome: 'Picanha',
          categoria: CategoriaItem.carnes,
          unidade: UnidadeItem.quilograma,
          quantidade: 2,
          precoUnitarioCentavos: 6500,
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
      viewModel = ShoppingViewModel(
        eventoRepository: eventoRepository,
        itemRepository: itemRepository,
      );
      await viewModel.carregar();
    });

    test('carrega itens por categoria e calcula o progresso', () {
      expect(viewModel.eventoSelecionado, evento);
      expect(viewModel.itensAgrupados.keys, [
        CategoriaItem.carnes,
        CategoriaItem.materiais,
      ]);
      expect(viewModel.totalItens, 2);
      expect(viewModel.itensComprados, 1);
      expect(viewModel.itensPendentes, 1);
      expect(viewModel.progresso, 0.5);
      expect(viewModel.custoTotalCentavos, 15_500);
    });

    test('marca o item como comprado e persiste a alteração', () async {
      final alterado = await viewModel.alterarItemComprado(
        'item-picanha',
        true,
      );

      expect(alterado, isTrue);
      expect(viewModel.itensComprados, 2);
      expect(viewModel.progresso, 1);
      expect(
        itemRepository.itens
            .firstWhere((item) => item.id == 'item-picanha')
            .foiComprado,
        isTrue,
      );
    });

    test('adiciona item manual à lista do evento', () async {
      final adicionado = await viewModel.adicionarItem(
        nome: 'Farofa',
        categoria: CategoriaItem.acompanhamentos,
        unidade: UnidadeItem.pacote,
        quantidade: 2,
        precoUnitarioCentavos: 1200,
      );

      expect(adicionado, isTrue);
      expect(viewModel.itens.map((item) => item.nome), contains('Farofa'));
      expect(itemRepository.quantidadeCriacoes, 1);
      expect(
        itemRepository.itens.last,
        isA<EventoItem>().having(
          (item) => item.eventoId,
          'eventoId',
          evento.id,
        ),
      );
    });
  });
}
