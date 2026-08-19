import 'package:app_churras/data/datasources/local/tarefa_local_datasource.dart';

class FakeTarefaLocalDataSource implements TarefaLocalDataSource {
  final Map<String, Map<String, Object?>> _registros = {};

  @override
  Future<List<Map<String, Object?>>> listarTarefas(String eventoId) async {
    return _registros.values
        .where((registro) => registro['evento_id'] == eventoId)
        .map((registro) => Map<String, Object?>.from(registro))
        .toList();
  }

  @override
  Future<void> inserirTarefa(Map<String, Object?> tarefa) async {
    _registros[tarefa['id']! as String] = Map<String, Object?>.from(tarefa);
  }

  @override
  Future<void> atualizarTarefa(String id, Map<String, Object?> tarefa) async {
    if (!_registros.containsKey(id)) throw Exception('Tarefa não encontrada');
    _registros[id] = Map<String, Object?>.from(tarefa);
  }
}
