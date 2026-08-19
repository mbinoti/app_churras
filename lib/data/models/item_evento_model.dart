import '../../domain/entities/item_evento.dart';

class EventoItemModel {
  const EventoItemModel({
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

  factory EventoItemModel.fromEntity(EventoItem item) {
    return EventoItemModel(
      id: item.id,
      eventoId: item.eventoId,
      nome: item.nome,
      categoria: item.categoria,
      unidade: item.unidade,
      quantidade: item.quantidade,
      precoUnitarioCentavos: item.precoUnitarioCentavos,
      origemQuantidade: item.origemQuantidade,
      foiComprado: item.foiComprado,
      observacoes: item.observacoes,
    );
  }

  factory EventoItemModel.fromMap(Map<String, Object?> map) {
    return EventoItemModel(
      id: map['id']! as String,
      eventoId: map['evento_id']! as String,
      nome: map['nome']! as String,
      categoria: CategoriaItem.values.byName(map['categoria']! as String),
      unidade: UnidadeItem.values.byName(map['unidade']! as String),
      quantidade: (map['quantidade']! as num).toDouble(),
      precoUnitarioCentavos: map['preco_unitario_centavos'] as int?,
      origemQuantidade: OrigemQuantidade.values.byName(
        map['origem_quantidade']! as String,
      ),
      foiComprado: (map['foi_comprado']! as int) == 1,
      observacoes: map['observacoes'] as String?,
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

  EventoItem toEntity() {
    return EventoItem(
      id: id,
      eventoId: eventoId,
      nome: nome,
      categoria: categoria,
      unidade: unidade,
      quantidade: quantidade,
      precoUnitarioCentavos: precoUnitarioCentavos,
      origemQuantidade: origemQuantidade,
      foiComprado: foiComprado,
      observacoes: observacoes,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'evento_id': eventoId,
      'nome': nome,
      'categoria': categoria.name,
      'unidade': unidade.name,
      'quantidade': quantidade,
      'preco_unitario_centavos': precoUnitarioCentavos,
      'origem_quantidade': origemQuantidade.name,
      'foi_comprado': foiComprado ? 1 : 0,
      'observacoes': observacoes,
    };
  }
}
