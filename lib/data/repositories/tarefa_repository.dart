import '../../domain/entities/tarefa.dart';

abstract interface class TarefaRepository {
  Future<List<Tarefa>> listarTarefas(String eventoId);

  Future<Tarefa> criarTarefa(Tarefa tarefa);

  Future<void> atualizarTarefa(Tarefa tarefa);
}
