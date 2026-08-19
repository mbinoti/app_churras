import 'package:app_churras/data/repositories/item_evento_repository_impl.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_item_evento_local_datasource.dart';

void main() {
  test(
    'EventoItemRepository salva, atualiza e lista itens do evento',
    () async {
      final dataSource = FakeEventoItemLocalDataSource();
      final repository = EventoItemRepositoryImpl(dataSource);
      final item = EventoItem.novo(
        id: 'item-1',
        eventoId: 'evento-1',
        nome: 'Picanha',
        categoria: CategoriaItem.carnes,
        unidade: UnidadeItem.quilograma,
        quantidade: 1.2,
        precoUnitarioCentavos: 6500,
        origemQuantidade: OrigemQuantidade.automatica,
      );

      await repository.criarItem(item);
      expect(await repository.listarItens('evento-1'), [item]);

      final atualizado = item.copyWith(quantidade: 1.5);
      await repository.atualizarItem(atualizado);
      expect((await repository.listarItens('evento-1')).single.quantidade, 1.5);

      await repository.excluirItem(item.id);
      expect(await repository.listarItens('evento-1'), isEmpty);
    },
  );
}
