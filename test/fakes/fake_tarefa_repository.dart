import 'package:app_churras/data/repositories/tarefa_repository.dart';
import 'package:app_churras/domain/entities/tarefa.dart';

class FakeTarefaRepository implements TarefaRepository {
  FakeTarefaRepository([List<Tarefa>? tarefas])
    : tarefas = List<Tarefa>.from(tarefas ?? const []);

  final List<Tarefa> tarefas;
  int quantidadeCriacoes = 0;
  int quantidadeAtualizacoes = 0;
  bool falharListagem = false;
  bool falharAtualizacao = false;

  @override
  Future<List<Tarefa>> listarTarefas(String eventoId) async {
    if (falharListagem) throw Exception('Falha simulada');
    return tarefas.where((tarefa) => tarefa.eventoId == eventoId).toList();
  }

  @override
  Future<Tarefa> criarTarefa(Tarefa tarefa) async {
    quantidadeCriacoes++;
    tarefas.add(tarefa);
    return tarefa;
  }

  @override
  Future<void> atualizarTarefa(Tarefa tarefa) async {
    quantidadeAtualizacoes++;
    if (falharAtualizacao) throw Exception('Falha simulada');
    final indice = tarefas.indexWhere((existente) => existente.id == tarefa.id);
    if (indice == -1) throw Exception('Tarefa não encontrada');
    tarefas[indice] = tarefa;
  }
}
