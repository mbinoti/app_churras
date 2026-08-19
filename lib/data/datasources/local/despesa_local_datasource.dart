import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

abstract interface class DespesaLocalDataSource {
  Future<List<Map<String, Object?>>> listarDespesas(String eventoId);

  Future<void> inserirDespesa(Map<String, Object?> despesa);

  Future<void> atualizarDespesa(String id, Map<String, Object?> despesa);
}

class SqliteDespesaLocalDataSource implements DespesaLocalDataSource {
  const SqliteDespesaLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<Map<String, Object?>>> listarDespesas(String eventoId) async {
    final banco = await _appDatabase.banco;
    return banco.query(
      'despesas',
      where: 'evento_id = ?',
      whereArgs: [eventoId],
      orderBy: 'data_despesa DESC, rowid DESC',
    );
  }

  @override
  Future<void> inserirDespesa(Map<String, Object?> despesa) async {
    final banco = await _appDatabase.banco;
    await banco.insert(
      'despesas',
      despesa,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> atualizarDespesa(String id, Map<String, Object?> despesa) async {
    final banco = await _appDatabase.banco;
    final quantidadeAtualizada = await banco.update(
      'despesas',
      despesa,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (quantidadeAtualizada == 0) {
      throw StateError('Despesa não encontrada para atualização.');
    }
  }
}
