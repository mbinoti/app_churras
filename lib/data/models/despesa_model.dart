import '../../domain/entities/despesa.dart';
import '../../domain/entities/item_evento.dart';

class DespesaModel {
  const DespesaModel({
    required this.id,
    required this.eventoId,
    required this.descricao,
    required this.valorCentavos,
    required this.categoria,
    required this.pagadorNome,
    required this.dataDespesa,
    required this.status,
    this.pagadorId,
    this.observacoes,
  });

  factory DespesaModel.fromEntity(Despesa despesa) {
    return DespesaModel(
      id: despesa.id,
      eventoId: despesa.eventoId,
      descricao: despesa.descricao,
      valorCentavos: despesa.valorCentavos,
      categoria: despesa.categoria,
      pagadorNome: despesa.pagadorNome,
      pagadorId: despesa.pagadorId,
      dataDespesa: despesa.dataDespesa,
      observacoes: despesa.observacoes,
      status: despesa.status,
    );
  }

  factory DespesaModel.fromMap(Map<String, Object?> map) {
    return DespesaModel(
      id: map['id']! as String,
      eventoId: map['evento_id']! as String,
      descricao: map['descricao']! as String,
      valorCentavos: map['valor_centavos']! as int,
      categoria: CategoriaItem.values.byName(map['categoria']! as String),
      pagadorNome: map['pagador_nome']! as String,
      pagadorId: map['pagador_id'] as String?,
      dataDespesa: DateTime.parse(map['data_despesa']! as String),
      observacoes: map['observacoes'] as String?,
      status: StatusDespesa.values.byName(map['status']! as String),
    );
  }

  final String id;
  final String eventoId;
  final String descricao;
  final int valorCentavos;
  final CategoriaItem categoria;
  final String pagadorNome;
  final String? pagadorId;
  final DateTime dataDespesa;
  final String? observacoes;
  final StatusDespesa status;

  Despesa toEntity() {
    return Despesa(
      id: id,
      eventoId: eventoId,
      descricao: descricao,
      valorCentavos: valorCentavos,
      categoria: categoria,
      pagadorNome: pagadorNome,
      pagadorId: pagadorId,
      dataDespesa: dataDespesa,
      observacoes: observacoes,
      status: status,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'evento_id': eventoId,
      'descricao': descricao,
      'valor_centavos': valorCentavos,
      'categoria': categoria.name,
      'pagador_nome': pagadorNome,
      'pagador_id': pagadorId,
      'data_despesa': dataDespesa.toIso8601String(),
      'observacoes': observacoes,
      'status': status.name,
    };
  }
}
