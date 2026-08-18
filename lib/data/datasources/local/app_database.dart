import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_migrations.dart';

class AppDatabase {
  AppDatabase({this.caminho});

  final String? caminho;
  Database? _banco;

  Future<Database> get banco async {
    final bancoAtual = _banco;
    if (bancoAtual != null) return bancoAtual;

    final caminhoBanco =
        caminho ?? join(await getDatabasesPath(), 'churras_facil.db');
    final bancoAberto = await openDatabase(
      caminhoBanco,
      version: DatabaseMigrations.versaoAtual,
      onConfigure: (banco) async {
        await banco.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: DatabaseMigrations.criarEsquemaInicial,
      onUpgrade: DatabaseMigrations.atualizarEsquema,
    );
    _banco = bancoAberto;
    return bancoAberto;
  }

  Future<void> fechar() async {
    final bancoAtual = _banco;
    _banco = null;
    await bancoAtual?.close();
  }
}
