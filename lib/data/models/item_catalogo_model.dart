import 'dart:convert';

import '../../domain/entities/item_catalogo.dart';
import '../../domain/entities/item_evento.dart';

class ItemCatalogoModel {
  const ItemCatalogoModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.unidade,
    required this.precoUnitarioCentavos,
    required this.quantidadePorAdulto,
    required this.quantidadePorCrianca,
    required this.aumentaComDuracao,
  });

  factory ItemCatalogoModel.fromEntity(ItemCatalogo item) {
    return ItemCatalogoModel(
      id: item.id,
      nome: item.nome,
      categoria: item.categoria,
      unidade: item.unidade,
      precoUnitarioCentavos: item.precoUnitarioCentavos,
      quantidadePorAdulto: item.quantidadePorAdulto,
      quantidadePorCrianca: item.quantidadePorCrianca,
      aumentaComDuracao: item.aumentaComDuracao,
    );
  }

  factory ItemCatalogoModel.fromMap(Map<String, Object?> map) {
    return ItemCatalogoModel(
      id: map['id']! as String,
      nome: map['nome']! as String,
      categoria: CategoriaItem.values.byName(map['categoria']! as String),
      unidade: UnidadeItem.values.byName(map['unidade']! as String),
      precoUnitarioCentavos: map['preco_unitario_centavos']! as int,
      quantidadePorAdulto: (map['quantidade_por_adulto']! as num).toDouble(),
      quantidadePorCrianca: (map['quantidade_por_crianca']! as num).toDouble(),
      aumentaComDuracao: (map['aumenta_com_duracao']! as int) == 1,
    );
  }

  factory ItemCatalogoModel.fromJson(Map<String, Object?> json) {
    return ItemCatalogoModel(
      id: json['id']! as String,
      nome: json['nome']! as String,
      categoria: CategoriaItem.values.byName(json['categoria']! as String),
      unidade: UnidadeItem.values.byName(json['unidade']! as String),
      precoUnitarioCentavos: json['preco_unitario_centavos']! as int,
      quantidadePorAdulto: (json['quantidade_por_adulto']! as num).toDouble(),
      quantidadePorCrianca: (json['quantidade_por_crianca']! as num).toDouble(),
      aumentaComDuracao: json['aumenta_com_duracao']! as bool,
    );
  }

  static List<ItemCatalogo> listaFromJson(String source) {
    final json = jsonDecode(source) as List<Object?>;
    return json
        .map(
          (item) => ItemCatalogoModel.fromJson(
            (item! as Map<Object?, Object?>).map(
              (key, value) => MapEntry(key! as String, value),
            ),
          ).toEntity(),
        )
        .toList();
  }

  final String id;
  final String nome;
  final CategoriaItem categoria;
  final UnidadeItem unidade;
  final int precoUnitarioCentavos;
  final double quantidadePorAdulto;
  final double quantidadePorCrianca;
  final bool aumentaComDuracao;

  ItemCatalogo toEntity() {
    return ItemCatalogo(
      id: id,
      nome: nome,
      categoria: categoria,
      unidade: unidade,
      precoUnitarioCentavos: precoUnitarioCentavos,
      quantidadePorAdulto: quantidadePorAdulto,
      quantidadePorCrianca: quantidadePorCrianca,
      aumentaComDuracao: aumentaComDuracao,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria.name,
      'unidade': unidade.name,
      'preco_unitario_centavos': precoUnitarioCentavos,
      'quantidade_por_adulto': quantidadePorAdulto,
      'quantidade_por_crianca': quantidadePorCrianca,
      'aumenta_com_duracao': aumentaComDuracao ? 1 : 0,
    };
  }
}
