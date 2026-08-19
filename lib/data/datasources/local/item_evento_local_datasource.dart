import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

abstract interface class EventoItemLocalDataSource {
  Future<List<Map<String, Object?>>> listarItens(String eventoId);

  Future<void> inserirItem(Map<String, Object?> item);

  Future<void> atualizarItem(String id, Map<String, Object?> item);

  Future<void> excluirItem(String id);
}

class SqliteEventoItemLocalDataSource implements EventoItemLocalDataSource {
  const SqliteEventoItemLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<Map<String, Object?>>> listarItens(String eventoId) async {
    final banco = await _appDatabase.banco;
    return banco.query(
      'itens_evento',
      where: 'evento_id = ?',
      whereArgs: [eventoId],
      orderBy: 'categoria ASC, nome COLLATE NOCASE ASC',
    );
  }

  @override
  Future<void> inserirItem(Map<String, Object?> item) async {
    final banco = await _appDatabase.banco;
    await banco.insert(
      'itens_evento',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> atualizarItem(String id, Map<String, Object?> item) async {
    final banco = await _appDatabase.banco;
    final quantidadeAtualizada = await banco.update(
      'itens_evento',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (quantidadeAtualizada == 0) {
      throw StateError('Item não encontrado para atualização.');
    }
  }

  @override
  Future<void> excluirItem(String id) async {
    final banco = await _appDatabase.banco;
    await banco.delete('itens_evento', where: 'id = ?', whereArgs: [id]);
  }
}
