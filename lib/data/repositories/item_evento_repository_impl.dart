import '../../domain/entities/item_evento.dart';
import '../datasources/local/item_evento_local_datasource.dart';
import '../models/item_evento_model.dart';
import 'item_evento_repository.dart';

class EventoItemRepositoryException implements Exception {
  const EventoItemRepositoryException(this.message, {this.causa});

  final String message;
  final Object? causa;

  @override
  String toString() => message;
}

class EventoItemRepositoryImpl implements EventoItemRepository {
  const EventoItemRepositoryImpl(this._dataSource);

  final EventoItemLocalDataSource _dataSource;

  @override
  Future<List<EventoItem>> listarItens(String eventoId) async {
    try {
      final registros = await _dataSource.listarItens(eventoId);
      return registros
          .map(EventoItemModel.fromMap)
          .map((model) => model.toEntity())
          .toList();
    } catch (error) {
      throw EventoItemRepositoryException(
        'Não foi possível carregar os itens do evento.',
        causa: error,
      );
    }
  }

  @override
  Future<EventoItem> criarItem(EventoItem item) async {
    try {
      await _dataSource.inserirItem(EventoItemModel.fromEntity(item).toMap());
      return item;
    } catch (error) {
      throw EventoItemRepositoryException(
        'Não foi possível salvar o item.',
        causa: error,
      );
    }
  }

  @override
  Future<void> atualizarItem(EventoItem item) async {
    try {
      await _dataSource.atualizarItem(
        item.id,
        EventoItemModel.fromEntity(item).toMap(),
      );
    } catch (error) {
      throw EventoItemRepositoryException(
        'Não foi possível atualizar o item.',
        causa: error,
      );
    }
  }

  @override
  Future<void> excluirItem(String id) async {
    try {
      await _dataSource.excluirItem(id);
    } catch (error) {
      throw EventoItemRepositoryException(
        'Não foi possível excluir o item.',
        causa: error,
      );
    }
  }
}
