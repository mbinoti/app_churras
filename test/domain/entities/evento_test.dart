import 'package:app_churras/domain/entities/evento.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Evento', () {
    final agora = DateTime(2026, 8, 18, 10, 30);

    test('cria um evento novo com identificador e totais', () {
      final evento = Evento.novo(
        nome: '  Churrasco da família  ',
        dataEvento: DateTime(2026, 9, 5, 15),
        tipo: TipoEvento.churrasco,
        quantidadeAdultos: 8,
        quantidadeCriancas: 3,
        agora: agora,
      );

      expect(evento.id, isNotEmpty);
      expect(evento.nome, 'Churrasco da família');
      expect(evento.dataEvento, DateTime(2026, 9, 5));
      expect(evento.totalParticipantes, 11);
      expect(evento.status, StatusEvento.planejado);
    });

    test('copyWith preserva os dados não alterados', () {
      final evento = Evento.novo(
        nome: 'Encontro',
        dataEvento: DateTime(2026, 9, 5),
        tipo: TipoEvento.familia,
        agora: agora,
      );

      final atualizado = evento.copyWith(nome: 'Encontro atualizado');

      expect(atualizado.id, evento.id);
      expect(atualizado.dataEvento, evento.dataEvento);
      expect(atualizado.criadoEm, evento.criadoEm);
      expect(atualizado.nome, 'Encontro atualizado');
    });
  });
}
