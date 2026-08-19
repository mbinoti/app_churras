import 'package:app_churras/data/datasources/local/despesa_local_datasource.dart';

class FakeDespesaLocalDataSource implements DespesaLocalDataSource {
  final Map<String, Map<String, Object?>> _registros = {};

  @override
  Future<List<Map<String, Object?>>> listarDespesas(String eventoId) async {
    return _registros.values
        .where((registro) => registro['evento_id'] == eventoId)
        .map((registro) => Map<String, Object?>.from(registro))
        .toList();
  }

  @override
  Future<void> inserirDespesa(Map<String, Object?> despesa) async {
    _registros[despesa['id']! as String] = Map<String, Object?>.from(despesa);
  }

  @override
  Future<void> atualizarDespesa(String id, Map<String, Object?> despesa) async {
    if (!_registros.containsKey(id)) throw Exception('Despesa não encontrada');
    _registros[id] = Map<String, Object?>.from(despesa);
  }
}
