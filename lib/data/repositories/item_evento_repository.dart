import '../../domain/entities/item_evento.dart';

abstract interface class EventoItemRepository {
  Future<List<EventoItem>> listarItens(String eventoId);

  Future<EventoItem> criarItem(EventoItem item);

  Future<void> atualizarItem(EventoItem item);

  Future<void> excluirItem(String id);
}
