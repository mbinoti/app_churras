import 'package:app_churras/data/repositories/catalogo_repository.dart';
import 'package:app_churras/domain/entities/item_catalogo.dart';

class FakeCatalogoRepository implements CatalogoRepository {
  FakeCatalogoRepository([List<ItemCatalogo>? itens])
    : itens = List<ItemCatalogo>.from(itens ?? const []);

  final List<ItemCatalogo> itens;
  int quantidadeAtualizacoes = 0;

  @override
  Future<List<ItemCatalogo>> listarItens() async {
    return List<ItemCatalogo>.from(itens);
  }

  @override
  Future<void> inicializarComPadrao(List<ItemCatalogo> itens) async {
    if (this.itens.isEmpty) this.itens.addAll(itens);
  }

  @override
  Future<void> atualizarItem(ItemCatalogo item) async {
    quantidadeAtualizacoes++;
    final indice = itens.indexWhere((existente) => existente.id == item.id);
    if (indice == -1) throw Exception('Item não encontrado');
    itens[indice] = item;
  }
}
