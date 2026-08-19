import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  const DatabaseMigrations._();

  static const int versaoAtual = 5;

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
    await _criarTabelaItensEvento(banco);
    await _criarTabelaCatalogoItens(banco);
    await _criarTabelaTarefas(banco);
    await _criarTabelaDespesas(banco);
  }

  static Future<void> atualizarEsquema(
    Database banco,
    int versaoAntiga,
    int versaoNova,
  ) async {
    if (versaoAntiga < 2 && versaoNova >= 2) {
      await _criarTabelaItensEvento(banco);
    }
    if (versaoAntiga < 3 && versaoNova >= 3) {
      await _criarTabelaCatalogoItens(banco);
    }
    if (versaoAntiga < 4 && versaoNova >= 4) {
      await _criarTabelaTarefas(banco);
    }
    if (versaoAntiga < 5 && versaoNova >= 5) {
      await _criarTabelaDespesas(banco);
    }
  }

  static Future<void> _criarTabelaItensEvento(Database banco) async {
    await banco.execute('''
      CREATE TABLE itens_evento (
        id TEXT PRIMARY KEY,
        evento_id TEXT NOT NULL,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        unidade TEXT NOT NULL,
        quantidade REAL NOT NULL,
        preco_unitario_centavos INTEGER,
        origem_quantidade TEXT NOT NULL,
        foi_comprado INTEGER NOT NULL DEFAULT 0,
        observacoes TEXT,
        FOREIGN KEY (evento_id) REFERENCES eventos (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> _criarTabelaCatalogoItens(Database banco) async {
    await banco.execute('''
      CREATE TABLE catalogo_itens (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        unidade TEXT NOT NULL,
        preco_unitario_centavos INTEGER NOT NULL,
        quantidade_por_adulto REAL NOT NULL,
        quantidade_por_crianca REAL NOT NULL,
        aumenta_com_duracao INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  static Future<void> _criarTabelaTarefas(Database banco) async {
    await banco.execute('''
      CREATE TABLE tarefas (
        id TEXT PRIMARY KEY,
        evento_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT,
        responsavel_nome TEXT,
        responsavel_id TEXT,
        data_limite TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY (evento_id) REFERENCES eventos (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> _criarTabelaDespesas(Database banco) async {
    await banco.execute('''
      CREATE TABLE despesas (
        id TEXT PRIMARY KEY,
        evento_id TEXT NOT NULL,
        descricao TEXT NOT NULL,
        valor_centavos INTEGER NOT NULL,
        categoria TEXT NOT NULL,
        pagador_nome TEXT NOT NULL,
        pagador_id TEXT,
        data_despesa TEXT NOT NULL,
        observacoes TEXT,
        status TEXT NOT NULL DEFAULT 'pago',
        FOREIGN KEY (evento_id) REFERENCES eventos (id) ON DELETE CASCADE
      )
    ''');
  }
}
