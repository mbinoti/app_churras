import 'package:app_churras/data/datasources/local/evento_local_datasource.dart';

class FakeEventoLocalDataSource implements EventoLocalDataSource {
  final Map<String, Map<String, Object?>> _registros = {};

  @override
  Future<List<Map<String, Object?>>> listarEventos() async {
    return _registros.values
        .map((registro) => Map<String, Object?>.from(registro))
        .toList();
  }

  @override
  Future<Map<String, Object?>?> buscarEvento(String id) async {
    final registro = _registros[id];
    return registro == null ? null : Map<String, Object?>.from(registro);
  }

  @override
  Future<void> inserirEvento(Map<String, Object?> evento) async {
    _registros[evento['id']! as String] = Map<String, Object?>.from(evento);
  }

  @override
  Future<void> atualizarEvento(String id, Map<String, Object?> evento) async {
    if (!_registros.containsKey(id)) throw Exception('Evento não encontrado');
    _registros[id] = Map<String, Object?>.from(evento);
  }

  @override
  Future<void> excluirEvento(String id) async {
    _registros.remove(id);
  }
}
