import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

abstract interface class CatalogoLocalDataSource {
  Future<List<Map<String, Object?>>> listarItens();

  Future<void> inserirItem(Map<String, Object?> item);

  Future<void> atualizarItem(String id, Map<String, Object?> item);
}

class SqliteCatalogoLocalDataSource implements CatalogoLocalDataSource {
  const SqliteCatalogoLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<Map<String, Object?>>> listarItens() async {
    final banco = await _appDatabase.banco;
    return banco.query('catalogo_itens', orderBy: 'categoria ASC, nome ASC');
  }

  @override
  Future<void> inserirItem(Map<String, Object?> item) async {
    final banco = await _appDatabase.banco;
    await banco.insert(
      'catalogo_itens',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> atualizarItem(String id, Map<String, Object?> item) async {
    final banco = await _appDatabase.banco;
    final atualizado = await banco.update(
      'catalogo_itens',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (atualizado == 0) {
      throw StateError('Item de catálogo não encontrado.');
    }
  }
}
