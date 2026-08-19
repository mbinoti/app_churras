import '../entities/despesa.dart';
import '../entities/evento.dart';

class SaldoPagador {
  const SaldoPagador({
    required this.nome,
    required this.valorPagoCentavos,
    required this.cotaCentavos,
  });

  final String nome;
  final int valorPagoCentavos;
  final int cotaCentavos;

  int get saldoCentavos => valorPagoCentavos - cotaCentavos;
  bool get temCredito => saldoCentavos > 0;
  bool get temDebito => saldoCentavos < 0;
}

class ResumoCustos {
  const ResumoCustos({
    required this.totalCentavos,
    required this.totalPagoCentavos,
    required this.totalPendenteCentavos,
    required this.participantes,
    required this.cotaPorPessoaCentavos,
    required this.saldosPagadores,
  });

  const ResumoCustos.vazio()
    : totalCentavos = 0,
      totalPagoCentavos = 0,
      totalPendenteCentavos = 0,
      participantes = 0,
      cotaPorPessoaCentavos = null,
      saldosPagadores = const [];

  final int totalCentavos;
  final int totalPagoCentavos;
  final int totalPendenteCentavos;
  final int participantes;
  final int? cotaPorPessoaCentavos;
  final List<SaldoPagador> saldosPagadores;

  bool get temDespesas => totalCentavos > 0;
  bool get temBaseParaRateio => cotaPorPessoaCentavos != null;
  double get progressoPagamento =>
      totalCentavos == 0 ? 0 : totalPagoCentavos / totalCentavos;
}

class CustosService {
  const CustosService();

  ResumoCustos calcular({
    required Evento evento,
    required List<Despesa> despesas,
  }) {
    final totalCentavos = despesas.fold<int>(
      0,
      (total, despesa) => total + despesa.valorCentavos,
    );
    final totalPagoCentavos = despesas
        .where((despesa) => despesa.estaPaga)
        .fold<int>(0, (total, despesa) => total + despesa.valorCentavos);
    final totalPendenteCentavos = totalCentavos - totalPagoCentavos;
    final participantes =
        evento.convidadosConfirmados ?? evento.totalParticipantes;

    final cotaPorPessoaCentavos = participantes > 0 && totalPagoCentavos > 0
        ? (totalPagoCentavos / participantes).round()
        : null;
    final saldosPagadores = cotaPorPessoaCentavos == null
        ? const <SaldoPagador>[]
        : _calcularSaldos(despesas, cotaPorPessoaCentavos);

    return ResumoCustos(
      totalCentavos: totalCentavos,
      totalPagoCentavos: totalPagoCentavos,
      totalPendenteCentavos: totalPendenteCentavos,
      participantes: participantes,
      cotaPorPessoaCentavos: cotaPorPessoaCentavos,
      saldosPagadores: saldosPagadores,
    );
  }

  List<SaldoPagador> _calcularSaldos(
    List<Despesa> despesas,
    int cotaPorPessoaCentavos,
  ) {
    final pagamentos = <String, int>{};
    for (final despesa in despesas) {
      if (!despesa.estaPaga) continue;
      pagamentos.update(
        despesa.pagadorNome,
        (valor) => valor + despesa.valorCentavos,
        ifAbsent: () => despesa.valorCentavos,
      );
    }

    final saldos =
        pagamentos.entries
            .map(
              (entrada) => SaldoPagador(
                nome: entrada.key,
                valorPagoCentavos: entrada.value,
                cotaCentavos: cotaPorPessoaCentavos,
              ),
            )
            .toList()
          ..sort((a, b) => b.saldoCentavos.compareTo(a.saldoCentavos));
    return List.unmodifiable(saldos);
  }
}
