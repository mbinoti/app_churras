import 'item_evento.dart';

class ItemCatalogo {
  const ItemCatalogo({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.unidade,
    required this.precoUnitarioCentavos,
    required this.quantidadePorAdulto,
    required this.quantidadePorCrianca,
    this.aumentaComDuracao = false,
  });

  final String id;
  final String nome;
  final CategoriaItem categoria;
  final UnidadeItem unidade;
  final int precoUnitarioCentavos;
  final double quantidadePorAdulto;
  final double quantidadePorCrianca;
  final bool aumentaComDuracao;

  ItemCatalogo copyWith({
    String? id,
    String? nome,
    CategoriaItem? categoria,
    UnidadeItem? unidade,
    int? precoUnitarioCentavos,
    double? quantidadePorAdulto,
    double? quantidadePorCrianca,
    bool? aumentaComDuracao,
  }) {
    return ItemCatalogo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      unidade: unidade ?? this.unidade,
      precoUnitarioCentavos:
          precoUnitarioCentavos ?? this.precoUnitarioCentavos,
      quantidadePorAdulto: quantidadePorAdulto ?? this.quantidadePorAdulto,
      quantidadePorCrianca: quantidadePorCrianca ?? this.quantidadePorCrianca,
      aumentaComDuracao: aumentaComDuracao ?? this.aumentaComDuracao,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ItemCatalogo &&
        other.id == id &&
        other.nome == nome &&
        other.categoria == categoria &&
        other.unidade == unidade &&
        other.precoUnitarioCentavos == precoUnitarioCentavos &&
        other.quantidadePorAdulto == quantidadePorAdulto &&
        other.quantidadePorCrianca == quantidadePorCrianca &&
        other.aumentaComDuracao == aumentaComDuracao;
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    categoria,
    unidade,
    precoUnitarioCentavos,
    quantidadePorAdulto,
    quantidadePorCrianca,
    aumentaComDuracao,
  );
}
