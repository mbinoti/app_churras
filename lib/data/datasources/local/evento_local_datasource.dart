import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

abstract interface class EventoLocalDataSource {
  Future<List<Map<String, Object?>>> listarEventos();

  Future<Map<String, Object?>?> buscarEvento(String id);

  Future<void> inserirEvento(Map<String, Object?> evento);

  Future<void> atualizarEvento(String id, Map<String, Object?> evento);

  Future<void> excluirEvento(String id);
}

class SqliteEventoLocalDataSource implements EventoLocalDataSource {
  const SqliteEventoLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<Map<String, Object?>>> listarEventos() async {
    final banco = await _appDatabase.banco;
    return banco.query('eventos', orderBy: 'data_evento ASC, criado_em DESC');
  }

  @override
  Future<Map<String, Object?>?> buscarEvento(String id) async {
    final banco = await _appDatabase.banco;
    final registros = await banco.query(
      'eventos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return registros.firstOrNull;
  }

  @override
  Future<void> inserirEvento(Map<String, Object?> evento) async {
    final banco = await _appDatabase.banco;
    await banco.insert(
      'eventos',
      evento,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> atualizarEvento(String id, Map<String, Object?> evento) async {
    final banco = await _appDatabase.banco;
    final quantidadeAtualizada = await banco.update(
      'eventos',
      evento,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (quantidadeAtualizada == 0) {
      throw StateError('Evento não encontrado para atualização.');
    }
  }

  @override
  Future<void> excluirEvento(String id) async {
    final banco = await _appDatabase.banco;
    await banco.delete('eventos', where: 'id = ?', whereArgs: [id]);
  }
}
