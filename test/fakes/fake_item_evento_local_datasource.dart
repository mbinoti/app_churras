import 'package:app_churras/data/datasources/local/item_evento_local_datasource.dart';

class FakeEventoItemLocalDataSource implements EventoItemLocalDataSource {
  final Map<String, Map<String, Object?>> _registros = {};

  @override
  Future<List<Map<String, Object?>>> listarItens(String eventoId) async {
    return _registros.values
        .where((registro) => registro['evento_id'] == eventoId)
        .map((registro) => Map<String, Object?>.from(registro))
        .toList();
  }

  @override
  Future<void> inserirItem(Map<String, Object?> item) async {
    _registros[item['id']! as String] = Map<String, Object?>.from(item);
  }

  @override
  Future<void> atualizarItem(String id, Map<String, Object?> item) async {
    if (!_registros.containsKey(id)) throw Exception('Item não encontrado');
    _registros[id] = Map<String, Object?>.from(item);
  }

  @override
  Future<void> excluirItem(String id) async {
    _registros.remove(id);
  }
}
