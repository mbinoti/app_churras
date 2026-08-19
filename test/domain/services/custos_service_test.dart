import 'package:app_churras/domain/entities/despesa.dart';
import 'package:app_churras/domain/entities/evento.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:app_churras/domain/services/custos_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustosService — Sprint 5', () {
    final evento = Evento.novo(
      id: 'evento-custos',
      nome: 'Churrasco de domingo',
      dataEvento: DateTime(2026, 9, 5),
      tipo: TipoEvento.churrasco,
      quantidadeAdultos: 3,
      quantidadeCriancas: 1,
      agora: DateTime(2026, 8, 19),
    );

    test('calcula total, pago, pendente e cota por pessoa', () {
      final resumo = const CustosService().calcular(
        evento: evento,
        despesas: [
          Despesa(
            id: 'carne',
            eventoId: 'evento-custos',
            descricao: 'Carnes',
            valorCentavos: 25000,
            categoria: CategoriaItem.carnes,
            pagadorNome: 'Carlos',
            dataDespesa: DateTime(2026, 8, 19),
            status: StatusDespesa.pago,
          ),
          Despesa(
            id: 'bebidas',
            eventoId: 'evento-custos',
            descricao: 'Bebidas',
            valorCentavos: 5500,
            categoria: CategoriaItem.bebidas,
            pagadorNome: 'Ana',
            dataDespesa: DateTime(2026, 8, 19),
            status: StatusDespesa.pendente,
          ),
        ],
      );

      expect(resumo.totalCentavos, 30500);
      expect(resumo.totalPagoCentavos, 25000);
      expect(resumo.totalPendenteCentavos, 5500);
      expect(resumo.participantes, 4);
      expect(resumo.cotaPorPessoaCentavos, 6250);
      expect(resumo.saldosPagadores.single.nome, 'Carlos');
      expect(resumo.saldosPagadores.single.saldoCentavos, 18750);
    });

    test('não libera rateio quando não há participantes', () {
      final eventoSemParticipantes = evento.copyWith(
        quantidadeAdultos: 0,
        quantidadeCriancas: 0,
      );
      final resumo = const CustosService().calcular(
        evento: eventoSemParticipantes,
        despesas: [
          Despesa.novo(
            id: 'despesa',
            eventoId: evento.id,
            descricao: 'Carvão',
            valorCentavos: 3000,
            categoria: CategoriaItem.materiais,
            pagadorNome: 'João',
          ),
        ],
      );

      expect(resumo.temBaseParaRateio, isFalse);
      expect(resumo.cotaPorPessoaCentavos, isNull);
    });
  });
}
