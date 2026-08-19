enum CategoriaItem {
  carnes,
  bebidas,
  acompanhamentos,
  materiais,
  sobremesas,
  personalizado,
}

extension CategoriaItemLabel on CategoriaItem {
  String get label => switch (this) {
    CategoriaItem.carnes => 'Carnes',
    CategoriaItem.bebidas => 'Bebidas',
    CategoriaItem.acompanhamentos => 'Acompanhamentos',
    CategoriaItem.materiais => 'Materiais',
    CategoriaItem.sobremesas => 'Sobremesas',
    CategoriaItem.personalizado => 'Personalizado',
  };
}

enum UnidadeItem {
  quilograma,
  litro,
  unidade,
  lata,
  pacote,
  saco,
  caixa,
  garrafa,
}

extension UnidadeItemLabel on UnidadeItem {
  String get label => switch (this) {
    UnidadeItem.quilograma => 'kg',
    UnidadeItem.litro => 'L',
    UnidadeItem.unidade => 'un.',
    UnidadeItem.lata => 'lata',
    UnidadeItem.pacote => 'pacote',
    UnidadeItem.saco => 'saco',
    UnidadeItem.caixa => 'caixa',
    UnidadeItem.garrafa => 'garrafa',
  };
}

enum OrigemQuantidade { automatica, manual }

class EventoItem {
  const EventoItem({
    required this.id,
    required this.eventoId,
    required this.nome,
    required this.categoria,
    required this.unidade,
    required this.quantidade,
    required this.precoUnitarioCentavos,
    required this.origemQuantidade,
    required this.foiComprado,
    this.observacoes,
  });

  factory EventoItem.novo({
    required String eventoId,
    required String nome,
    required CategoriaItem categoria,
    required UnidadeItem unidade,
    required double quantidade,
    int? precoUnitarioCentavos,
    OrigemQuantidade origemQuantidade = OrigemQuantidade.manual,
    String? observacoes,
    String? id,
    bool foiComprado = false,
  }) {
    return EventoItem(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      eventoId: eventoId,
      nome: nome.trim(),
      categoria: categoria,
      unidade: unidade,
      quantidade: quantidade,
      precoUnitarioCentavos: precoUnitarioCentavos,
      origemQuantidade: origemQuantidade,
      foiComprado: foiComprado,
      observacoes: observacoes,
    );
  }

  final String id;
  final String eventoId;
  final String nome;
  final CategoriaItem categoria;
  final UnidadeItem unidade;
  final double quantidade;
  final int? precoUnitarioCentavos;
  final OrigemQuantidade origemQuantidade;
  final bool foiComprado;
  final String? observacoes;

  int get custoEstimadoCentavos => precoUnitarioCentavos == null
      ? 0
      : (quantidade * precoUnitarioCentavos!).round();

  EventoItem copyWith({
    String? id,
    String? eventoId,
    String? nome,
    CategoriaItem? categoria,
    UnidadeItem? unidade,
    double? quantidade,
    int? precoUnitarioCentavos,
    OrigemQuantidade? origemQuantidade,
    bool? foiComprado,
    String? observacoes,
  }) {
    return EventoItem(
      id: id ?? this.id,
      eventoId: eventoId ?? this.eventoId,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      unidade: unidade ?? this.unidade,
      quantidade: quantidade ?? this.quantidade,
      precoUnitarioCentavos:
          precoUnitarioCentavos ?? this.precoUnitarioCentavos,
      origemQuantidade: origemQuantidade ?? this.origemQuantidade,
      foiComprado: foiComprado ?? this.foiComprado,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventoItem &&
        other.id == id &&
        other.eventoId == eventoId &&
        other.nome == nome &&
        other.categoria == categoria &&
        other.unidade == unidade &&
        other.quantidade == quantidade &&
        other.precoUnitarioCentavos == precoUnitarioCentavos &&
        other.origemQuantidade == origemQuantidade &&
        other.foiComprado == foiComprado &&
        other.observacoes == observacoes;
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventoId,
    nome,
    categoria,
    unidade,
    quantidade,
    precoUnitarioCentavos,
    origemQuantidade,
    foiComprado,
    observacoes,
  );
}
