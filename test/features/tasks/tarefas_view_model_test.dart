import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/tarefa.dart';
import 'package:app_churras/features/tasks/viewmodel/tarefas_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_evento_repository.dart';
import '../../fakes/fake_tarefa_repository.dart';

void main() {
  group('TarefasViewModel — Sprint 4', () {
    late Evento evento;
    late FakeEventoRepository eventoRepository;
    late FakeTarefaRepository tarefaRepository;
    late TarefasViewModel viewModel;

    setUp(() async {
      evento = Evento.novo(
        id: 'evento-tarefas',
        nome: 'Churrasco de domingo',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.churrasco,
        agora: DateTime(2026, 8, 19),
      );
      eventoRepository = FakeEventoRepository([evento]);
      tarefaRepository = FakeTarefaRepository([
        Tarefa.novo(
          id: 'tarefa-carne',
          eventoId: evento.id,
          titulo: 'Comprar carne',
          responsavelNome: 'Ana',
        ),
        Tarefa.novo(
          id: 'tarefa-limpeza',
          eventoId: evento.id,
          titulo: 'Limpar churrasqueira',
          status: StatusTarefa.concluida,
        ),
      ]);
      viewModel = TarefasViewModel(
        eventoRepository: eventoRepository,
        tarefaRepository: tarefaRepository,
      );
      await viewModel.carregar();
    });

    test('carrega tarefas e calcula o progresso', () {
      expect(viewModel.eventoSelecionado, evento);
      expect(viewModel.totalTarefas, 2);
      expect(viewModel.tarefasConcluidas, 1);
      expect(viewModel.tarefasPendentes, 1);
      expect(viewModel.progresso, 0.5);
    });

    test('cria uma tarefa com responsável e prazo', () async {
      final criada = await viewModel.criarTarefa(
        titulo: 'Preparar vinagrete',
        descricao: 'Deixar pronto antes dos convidados chegarem.',
        responsavelNome: 'João',
        dataLimite: DateTime(2026, 9, 5),
      );

      expect(criada, isTrue);
      expect(
        viewModel.tarefas.map((tarefa) => tarefa.titulo),
        contains('Preparar vinagrete'),
      );
      expect(tarefaRepository.quantidadeCriacoes, 1);
      expect(
        tarefaRepository.tarefas.last,
        isA<Tarefa>()
            .having((tarefa) => tarefa.responsavelNome, 'responsável', 'João')
            .having(
              (tarefa) => tarefa.dataLimite,
              'prazo',
              DateTime(2026, 9, 5),
            ),
      );
    });

    test('atribui responsável e conclui uma tarefa', () async {
      expect(
        await viewModel.atribuirResponsavel('tarefa-carne', 'Carlos'),
        isTrue,
      );
      expect(await viewModel.alterarStatus('tarefa-carne', true), isTrue);

      final tarefa = tarefaRepository.tarefas.firstWhere(
        (item) => item.id == 'tarefa-carne',
      );
      expect(tarefa.responsavelNome, 'Carlos');
      expect(tarefa.estaConcluida, isTrue);
      expect(tarefaRepository.quantidadeAtualizacoes, 2);
    });
  });
}
