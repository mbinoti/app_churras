import '../../domain/entities/tarefa.dart';
import '../datasources/local/tarefa_local_datasource.dart';
import '../models/tarefa_model.dart';
import 'tarefa_repository.dart';

class TarefaRepositoryException implements Exception {
  const TarefaRepositoryException(this.message, {this.causa});

  final String message;
  final Object? causa;

  @override
  String toString() => message;
}

class TarefaRepositoryImpl implements TarefaRepository {
  const TarefaRepositoryImpl(this._dataSource);

  final TarefaLocalDataSource _dataSource;

  @override
  Future<List<Tarefa>> listarTarefas(String eventoId) async {
    try {
      final registros = await _dataSource.listarTarefas(eventoId);
      return registros
          .map(TarefaModel.fromMap)
          .map((model) => model.toEntity())
          .toList();
    } catch (error) {
      throw TarefaRepositoryException(
        'Não foi possível carregar as tarefas do evento.',
        causa: error,
      );
    }
  }

  @override
  Future<Tarefa> criarTarefa(Tarefa tarefa) async {
    try {
      await _dataSource.inserirTarefa(TarefaModel.fromEntity(tarefa).toMap());
      return tarefa;
    } catch (error) {
      throw TarefaRepositoryException(
        'Não foi possível salvar a tarefa.',
        causa: error,
      );
    }
  }

  @override
  Future<void> atualizarTarefa(Tarefa tarefa) async {
    try {
      await _dataSource.atualizarTarefa(
        tarefa.id,
        TarefaModel.fromEntity(tarefa).toMap(),
      );
    } catch (error) {
      throw TarefaRepositoryException(
        'Não foi possível atualizar a tarefa.',
        causa: error,
      );
    }
  }
}
