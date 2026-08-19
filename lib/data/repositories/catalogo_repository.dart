import '../../domain/entities/item_catalogo.dart';

abstract interface class CatalogoRepository {
  Future<List<ItemCatalogo>> listarItens();

  Future<void> inicializarComPadrao(List<ItemCatalogo> itens);

  Future<void> atualizarItem(ItemCatalogo item);
}
