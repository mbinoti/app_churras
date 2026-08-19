import 'package:app_churras/data/repositories/tarefa_repository_impl.dart';
import 'package:app_churras/domain/entities/tarefa.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_tarefa_local_datasource.dart';

void main() {
  test('TarefaRepository salva, lista e atualiza tarefas', () async {
    final dataSource = FakeTarefaLocalDataSource();
    final repository = TarefaRepositoryImpl(dataSource);
    final tarefa = Tarefa.novo(
      id: 'tarefa-1',
      eventoId: 'evento-1',
      titulo: 'Comprar gelo',
      responsavelNome: 'Marcos',
      dataLimite: DateTime(2026, 9, 4),
    );

    await repository.criarTarefa(tarefa);
    expect(await repository.listarTarefas('evento-1'), [tarefa]);

    final atualizada = tarefa.copyWith(status: StatusTarefa.concluida);
    await repository.atualizarTarefa(atualizada);
    expect(
      (await repository.listarTarefas('evento-1')).single.status,
      StatusTarefa.concluida,
    );
  });
}
