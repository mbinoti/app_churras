import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:app_churras/features/event_planning/viewmodel/event_planning_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_evento_repository.dart';
import '../fakes/fake_item_evento_repository.dart';
import '../fakes/fake_catalogo_repository.dart';
import '../fakes/catalogo_test_data.dart';

void main() {
  group('EventPlanningViewModel — Sprint 2', () {
    late FakeEventoRepository eventoRepository;
    late FakeCatalogoRepository catalogoRepository;
    late FakeEventoItemRepository itemRepository;
    late EventPlanningViewModel viewModel;

    setUp(() async {
      eventoRepository = FakeEventoRepository();
      catalogoRepository = FakeCatalogoRepository(catalogoItensTeste);
      itemRepository = FakeEventoItemRepository();
      viewModel = EventPlanningViewModel(
        eventoRepository: eventoRepository,
        catalogoRepository: catalogoRepository,
        itemRepository: itemRepository,
      );
      viewModel.alterarDataEvento(DateTime(2026, 9, 5));
      viewModel.alterarNome('Churrasco de testes');
      viewModel.alterarQuantidadeAdultos(5);
      viewModel.alterarQuantidadeCriancas(2);
      await viewModel.carregarCatalogo();
    });

    test('adiciona item do catálogo com quantidade automática', () {
      final picanha = itemCatalogoPicanha;

      viewModel.adicionarItemDoCatalogo(picanha);

      expect(viewModel.itens.single.nome, 'Picanha');
      expect(
        viewModel.itens.single.origemQuantidade,
        OrigemQuantidade.automatica,
      );
      expect(viewModel.itens.single.quantidade, 0.72);
    });

    test('recalcula item automático, mas preserva ajuste manual', () {
      final picanha = itemCatalogoPicanha;
      viewModel.adicionarItemDoCatalogo(picanha);
      final id = viewModel.itens.single.id;

      viewModel.alterarQuantidadeAdultos(10);
      expect(viewModel.itens.single.quantidade, 1.32);

      viewModel.alterarQuantidadeItem(id, 2.5);
      viewModel.alterarQuantidadeAdultos(2);
      expect(viewModel.itens.single.quantidade, 2.5);
      expect(viewModel.itens.single.origemQuantidade, OrigemQuantidade.manual);
    });

    test('salva evento e itens do planejamento', () async {
      viewModel.adicionarItemDoCatalogo(itemCatalogoCarvao);
      viewModel.adicionarItemPersonalizado(
        EventoItem.novo(
          eventoId: '',
          nome: 'Arroz',
          categoria: CategoriaItem.personalizado,
          unidade: UnidadeItem.pacote,
          quantidade: 2,
          precoUnitarioCentavos: 900,
        ),
      );

      final salvou = await viewModel.salvarEvento();

      expect(salvou, isTrue);
      expect(eventoRepository.quantidadeCriacoes, 1);
      expect(itemRepository.quantidadeCriacoes, 2);
      expect(itemRepository.itens, hasLength(2));
      expect(
        itemRepository.itens.every(
          (item) => item.eventoId == eventoRepository.eventos.single.id,
        ),
        isTrue,
      );
      expect(viewModel.custoEstimadoCentavos, 4300);
    });

    test(
      'carrega itens existentes e remove o item excluído ao salvar',
      () async {
        final evento = Evento.novo(
          id: 'evento-editado',
          nome: 'Churrasco',
          dataEvento: DateTime(2026, 9, 5),
          tipo: TipoEvento.churrasco,
          quantidadeAdultos: 4,
          agora: DateTime(2026, 8, 18),
        );
        final item = EventoItem.novo(
          id: 'item-remover',
          eventoId: evento.id,
          nome: 'Gelo',
          categoria: CategoriaItem.materiais,
          unidade: UnidadeItem.saco,
          quantidade: 1,
          precoUnitarioCentavos: 1200,
        );
        eventoRepository.eventos.add(evento);
        itemRepository.itens.add(item);
        viewModel = EventPlanningViewModel(
          eventoRepository: eventoRepository,
          catalogoRepository: catalogoRepository,
          itemRepository: itemRepository,
          evento: evento,
        );

        await viewModel.carregarItens();
        viewModel.removerItem(item.id);
        final salvou = await viewModel.salvarEvento();

        expect(salvou, isTrue);
        expect(itemRepository.quantidadeExclusoes, 1);
        expect(itemRepository.itens, isEmpty);
      },
    );
  });
}
