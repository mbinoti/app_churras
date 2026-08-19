import 'package:app_churras/data/repositories/catalogo_repository_impl.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/catalogo_test_data.dart';
import '../fakes/fake_catalogo_local_datasource.dart';

void main() {
  test('inicializa catálogo padrão somente quando a base está vazia', () async {
    final dataSource = FakeCatalogoLocalDataSource();
    final repository = CatalogoRepositoryImpl(dataSource);

    await repository.inicializarComPadrao([itemCatalogoPicanha]);
    await repository.inicializarComPadrao([itemCatalogoCerveja]);

    expect(await repository.listarItens(), [itemCatalogoPicanha]);
  });

  test('atualiza regra de consumo do item', () async {
    final dataSource = FakeCatalogoLocalDataSource();
    final repository = CatalogoRepositoryImpl(dataSource);
    await repository.inicializarComPadrao([itemCatalogoPicanha]);

    final atualizado = itemCatalogoPicanha.copyWith(quantidadePorAdulto: 0.18);
    await repository.atualizarItem(atualizado);

    final salvo = (await repository.listarItens()).single;
    expect(salvo.quantidadePorAdulto, 0.18);
    expect(salvo.unidade, UnidadeItem.quilograma);
  });
}
