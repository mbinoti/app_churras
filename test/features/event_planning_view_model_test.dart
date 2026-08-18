import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/features/event_planning/viewmodel/event_planning_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_evento_repository.dart';

void main() {
  group('EventPlanningViewModel', () {
    late FakeEventoRepository repository;
    late EventPlanningViewModel viewModel;

    setUp(() {
      repository = FakeEventoRepository();
      viewModel = EventPlanningViewModel(eventoRepository: repository);
    });

    test('rejeita nome vazio e data ausente', () async {
      final salvou = await viewModel.salvarEvento();

      expect(salvou, isFalse);
      expect(viewModel.erroNome, 'Informe o nome do evento.');
      expect(viewModel.erroData, 'Selecione a data do evento.');
      expect(repository.quantidadeCriacoes, 0);
    });

    test('salva evento válido com adultos e crianças', () async {
      viewModel.alterarNome('Churrasco de sábado');
      viewModel.alterarDataEvento(DateTime(2026, 9, 5));
      viewModel.alterarQuantidadeAdultos(7);
      viewModel.alterarQuantidadeCriancas(2);

      final salvou = await viewModel.salvarEvento();

      expect(salvou, isTrue);
      expect(repository.quantidadeCriacoes, 1);
      expect(repository.eventos.single.nome, 'Churrasco de sábado');
      expect(repository.eventos.single.totalParticipantes, 9);
    });

    test('edita o evento preservando seu identificador', () async {
      final original = Evento.novo(
        id: 'evento-editado',
        nome: 'Nome antigo',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.churrasco,
        agora: DateTime(2026, 8, 18),
      );
      repository.eventos.add(original);
      viewModel = EventPlanningViewModel(
        eventoRepository: repository,
        evento: original,
      );

      viewModel.alterarNome('Nome novo');
      final salvou = await viewModel.salvarEvento();

      expect(salvou, isTrue);
      expect(repository.quantidadeAtualizacoes, 1);
      expect(repository.eventos.single.id, 'evento-editado');
      expect(repository.eventos.single.nome, 'Nome novo');
      expect(repository.eventos.single.criadoEm, original.criadoEm);
    });
  });
}
