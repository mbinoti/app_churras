import '../../domain/entities/evento.dart';
import '../datasources/local/evento_local_datasource.dart';
import '../models/evento_model.dart';
import 'evento_repository.dart';

class EventoRepositoryException implements Exception {
  const EventoRepositoryException(this.message, {this.causa});

  final String message;
  final Object? causa;

  @override
  String toString() => message;
}

class EventoRepositoryImpl implements EventoRepository {
  const EventoRepositoryImpl(this._dataSource);

  final EventoLocalDataSource _dataSource;

  @override
  Future<List<Evento>> listarEventos() async {
    try {
      final registros = await _dataSource.listarEventos();
      return registros
          .map(EventoModel.fromMap)
          .map((model) => model.toEntity())
          .toList();
    } catch (error) {
      throw EventoRepositoryException(
        'Não foi possível carregar os eventos.',
        causa: error,
      );
    }
  }

  @override
  Future<Evento?> buscarEvento(String id) async {
    try {
      final registro = await _dataSource.buscarEvento(id);
      return registro == null ? null : EventoModel.fromMap(registro).toEntity();
    } catch (error) {
      throw EventoRepositoryException(
        'Não foi possível buscar o evento.',
        causa: error,
      );
    }
  }

  @override
  Future<Evento> criarEvento(Evento evento) async {
    try {
      await _dataSource.inserirEvento(EventoModel.fromEntity(evento).toMap());
      return evento;
    } catch (error) {
      throw EventoRepositoryException(
        'Não foi possível salvar o evento.',
        causa: error,
      );
    }
  }

  @override
  Future<void> atualizarEvento(Evento evento) async {
    try {
      await _dataSource.atualizarEvento(
        evento.id,
        EventoModel.fromEntity(evento).toMap(),
      );
    } catch (error) {
      throw EventoRepositoryException(
        'Não foi possível atualizar o evento.',
        causa: error,
      );
    }
  }

  @override
  Future<void> excluirEvento(String id) async {
    try {
      await _dataSource.excluirEvento(id);
    } catch (error) {
      throw EventoRepositoryException(
        'Não foi possível excluir o evento.',
        causa: error,
      );
    }
  }
}
