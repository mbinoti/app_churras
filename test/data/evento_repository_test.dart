import 'package:app_churras/data/repositories/evento_repository_impl.dart';
import 'package:app_churras/domain/entities/evento.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_evento_local_datasource.dart';

void main() {
  group('EventoRepositoryImpl', () {
    late FakeEventoLocalDataSource dataSource;
    late EventoRepositoryImpl repository;

    setUp(() {
      dataSource = FakeEventoLocalDataSource();
      repository = EventoRepositoryImpl(dataSource);
    });

    test('salva e recupera um evento pelo datasource', () async {
      final evento = Evento.novo(
        id: 'evento-1',
        nome: 'Churrasco',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.churrasco,
        quantidadeAdultos: 5,
        agora: DateTime(2026, 8, 18),
      );

      await repository.criarEvento(evento);
      final recuperado = await repository.buscarEvento(evento.id);

      expect(recuperado, evento);
    });

    test('edita sem alterar o identificador e exclui o evento', () async {
      final evento = Evento.novo(
        id: 'evento-2',
        nome: 'Antes',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.familia,
        agora: DateTime(2026, 8, 18),
      );
      await repository.criarEvento(evento);

      final atualizado = evento.copyWith(nome: 'Depois');
      await repository.atualizarEvento(atualizado);
      expect(await repository.buscarEvento('evento-2'), atualizado);

      await repository.excluirEvento('evento-2');
      expect(await repository.buscarEvento('evento-2'), isNull);
    });
  });
}
