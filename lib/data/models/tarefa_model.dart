import '../../domain/entities/tarefa.dart';

class TarefaModel {
  const TarefaModel({
    required this.id,
    required this.eventoId,
    required this.titulo,
    required this.status,
    this.descricao,
    this.responsavelNome,
    this.responsavelId,
    this.dataLimite,
  });

  factory TarefaModel.fromEntity(Tarefa tarefa) {
    return TarefaModel(
      id: tarefa.id,
      eventoId: tarefa.eventoId,
      titulo: tarefa.titulo,
      descricao: tarefa.descricao,
      responsavelNome: tarefa.responsavelNome,
      responsavelId: tarefa.responsavelId,
      dataLimite: tarefa.dataLimite,
      status: tarefa.status,
    );
  }

  factory TarefaModel.fromMap(Map<String, Object?> map) {
    final dataLimite = map['data_limite'] as String?;
    return TarefaModel(
      id: map['id']! as String,
      eventoId: map['evento_id']! as String,
      titulo: map['titulo']! as String,
      descricao: map['descricao'] as String?,
      responsavelNome: map['responsavel_nome'] as String?,
      responsavelId: map['responsavel_id'] as String?,
      dataLimite: dataLimite == null ? null : DateTime.tryParse(dataLimite),
      status: StatusTarefa.values.byName(map['status']! as String),
    );
  }

  final String id;
  final String eventoId;
  final String titulo;
  final String? descricao;
  final String? responsavelNome;
  final String? responsavelId;
  final DateTime? dataLimite;
  final StatusTarefa status;

  Tarefa toEntity() {
    return Tarefa(
      id: id,
      eventoId: eventoId,
      titulo: titulo,
      descricao: descricao,
      responsavelNome: responsavelNome,
      responsavelId: responsavelId,
      dataLimite: dataLimite,
      status: status,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'evento_id': eventoId,
      'titulo': titulo,
      'descricao': descricao,
      'responsavel_nome': responsavelNome,
      'responsavel_id': responsavelId,
      'data_limite': dataLimite?.toIso8601String(),
      'status': status.name,
    };
  }
}
