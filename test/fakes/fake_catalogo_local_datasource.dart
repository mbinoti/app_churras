import 'package:app_churras/data/datasources/local/catalogo_local_datasource.dart';

class FakeCatalogoLocalDataSource implements CatalogoLocalDataSource {
  final Map<String, Map<String, Object?>> _registros = {};

  @override
  Future<List<Map<String, Object?>>> listarItens() async {
    return _registros.values
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
}
