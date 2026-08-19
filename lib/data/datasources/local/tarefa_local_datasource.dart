import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

abstract interface class TarefaLocalDataSource {
  Future<List<Map<String, Object?>>> listarTarefas(String eventoId);

  Future<void> inserirTarefa(Map<String, Object?> tarefa);

  Future<void> atualizarTarefa(String id, Map<String, Object?> tarefa);
}

class SqliteTarefaLocalDataSource implements TarefaLocalDataSource {
  const SqliteTarefaLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<Map<String, Object?>>> listarTarefas(String eventoId) async {
    final banco = await _appDatabase.banco;
    return banco.query(
      'tarefas',
      where: 'evento_id = ?',
      whereArgs: [eventoId],
      orderBy: 'titulo COLLATE NOCASE ASC',
    );
  }

  @override
  Future<void> inserirTarefa(Map<String, Object?> tarefa) async {
    final banco = await _appDatabase.banco;
    await banco.insert(
      'tarefas',
      tarefa,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> atualizarTarefa(String id, Map<String, Object?> tarefa) async {
    final banco = await _appDatabase.banco;
    final quantidadeAtualizada = await banco.update(
      'tarefas',
      tarefa,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (quantidadeAtualizada == 0) {
      throw StateError('Tarefa não encontrada para atualização.');
    }
  }
}
