import '../entities/item_catalogo.dart';
import '../entities/item_evento.dart';

class EstimationService {
  const EstimationService();

  double calcularQuantidade({
    required ItemCatalogo item,
    required int quantidadeAdultos,
    required int quantidadeCriancas,
    required int duracaoHoras,
  }) {
    final base =
        quantidadeAdultos * item.quantidadePorAdulto +
        quantidadeCriancas * item.quantidadePorCrianca;
    final horasAdicionais = (duracaoHoras - 4).clamp(0, 8);
    final multiplicadorDuracao = item.aumentaComDuracao
        ? 1 + horasAdicionais * 0.10
        : 1.0;
    final quantidade = base * multiplicadorDuracao;

    return _arredondarQuantidade(quantidade, item.unidade);
  }

  EventoItem criarItemAutomatico({
    required ItemCatalogo item,
    required String eventoId,
    required int quantidadeAdultos,
    required int quantidadeCriancas,
    required int duracaoHoras,
  }) {
    return EventoItem.novo(
      eventoId: eventoId,
      nome: item.nome,
      categoria: item.categoria,
      unidade: item.unidade,
      quantidade: calcularQuantidade(
        item: item,
        quantidadeAdultos: quantidadeAdultos,
        quantidadeCriancas: quantidadeCriancas,
        duracaoHoras: duracaoHoras,
      ),
      precoUnitarioCentavos: item.precoUnitarioCentavos,
      origemQuantidade: OrigemQuantidade.automatica,
    );
  }

  EventoItem recalcularItem({
    required EventoItem item,
    required ItemCatalogo catalogo,
    required int quantidadeAdultos,
    required int quantidadeCriancas,
    required int duracaoHoras,
  }) {
    return item.copyWith(
      quantidade: calcularQuantidade(
        item: catalogo,
        quantidadeAdultos: quantidadeAdultos,
        quantidadeCriancas: quantidadeCriancas,
        duracaoHoras: duracaoHoras,
      ),
      origemQuantidade: OrigemQuantidade.automatica,
    );
  }

  double _arredondarQuantidade(double quantidade, UnidadeItem unidade) {
    if (quantidade <= 0) return 0;
    final fracionada = switch (unidade) {
      UnidadeItem.quilograma ||
      UnidadeItem.litro => (quantidade * 100).ceil() / 100,
      _ => quantidade.ceilToDouble(),
    };
    return fracionada;
  }
}
