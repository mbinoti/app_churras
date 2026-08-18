import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  const DatabaseMigrations._();

  static const int versaoAtual = 1;

  static Future<void> criarEsquemaInicial(Database banco, int versao) async {
    await banco.execute('''
      CREATE TABLE eventos (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        data_evento TEXT NOT NULL,
        horario_inicio TEXT,
        tipo TEXT NOT NULL,
        duracao_horas INTEGER NOT NULL,
        quantidade_adultos INTEGER NOT NULL DEFAULT 0,
        quantidade_criancas INTEGER NOT NULL DEFAULT 0,
        convidados_confirmados INTEGER,
        status TEXT NOT NULL,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT NOT NULL
      )
    ''');
  }

  static Future<void> atualizarEsquema(
    Database banco,
    int versaoAntiga,
    int versaoNova,
  ) async {
    // As próximas alterações de schema devem ser adicionadas aqui em ordem.
  }
}
