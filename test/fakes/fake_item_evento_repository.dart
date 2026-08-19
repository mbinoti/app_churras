import 'package:app_churras/data/repositories/item_evento_repository.dart';
import 'package:app_churras/domain/entities/item_evento.dart';

class FakeEventoItemRepository implements EventoItemRepository {
  FakeEventoItemRepository([List<EventoItem>? itens])
    : itens = List<EventoItem>.from(itens ?? const []);

  final List<EventoItem> itens;
  int quantidadeCriacoes = 0;
  int quantidadeAtualizacoes = 0;
  int quantidadeExclusoes = 0;

  @override
  Future<List<EventoItem>> listarItens(String eventoId) async {
    return itens.where((item) => item.eventoId == eventoId).toList();
  }

  @override
  Future<EventoItem> criarItem(EventoItem item) async {
    quantidadeCriacoes++;
    itens.add(item);
    return item;
  }

  @override
  Future<void> atualizarItem(EventoItem item) async {
    quantidadeAtualizacoes++;
    final indice = itens.indexWhere((existente) => existente.id == item.id);
    if (indice == -1) throw Exception('Item não encontrado');
    itens[indice] = item;
  }

  @override
  Future<void> excluirItem(String id) async {
    quantidadeExclusoes++;
    itens.removeWhere((item) => item.id == id);
  }
}
