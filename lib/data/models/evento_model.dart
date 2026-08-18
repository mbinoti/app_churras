import '../../domain/entities/evento.dart';

class EventoModel {
  const EventoModel({
    required this.id,
    required this.nome,
    required this.dataEvento,
    required this.tipo,
    required this.duracaoHoras,
    required this.quantidadeAdultos,
    required this.quantidadeCriancas,
    required this.status,
    required this.criadoEm,
    required this.atualizadoEm,
    this.horarioInicio,
    this.convidadosConfirmados,
  });

  factory EventoModel.fromEntity(Evento evento) {
    return EventoModel(
      id: evento.id,
      nome: evento.nome,
      dataEvento: evento.dataEvento,
      horarioInicio: evento.horarioInicio,
      tipo: evento.tipo,
      duracaoHoras: evento.duracaoHoras,
      quantidadeAdultos: evento.quantidadeAdultos,
      quantidadeCriancas: evento.quantidadeCriancas,
      convidadosConfirmados: evento.convidadosConfirmados,
      status: evento.status,
      criadoEm: evento.criadoEm,
      atualizadoEm: evento.atualizadoEm,
    );
  }

  factory EventoModel.fromMap(Map<String, Object?> map) {
    return EventoModel(
      id: map['id']! as String,
      nome: map['nome']! as String,
      dataEvento: DateTime.parse(map['data_evento']! as String),
      horarioInicio: _parseDate(map['horario_inicio'] as String?),
      tipo: TipoEvento.values.byName(map['tipo']! as String),
      duracaoHoras: map['duracao_horas']! as int,
      quantidadeAdultos: map['quantidade_adultos']! as int,
      quantidadeCriancas: map['quantidade_criancas']! as int,
      convidadosConfirmados: map['convidados_confirmados'] as int?,
      status: StatusEvento.values.byName(map['status']! as String),
      criadoEm: DateTime.parse(map['criado_em']! as String),
      atualizadoEm: DateTime.parse(map['atualizado_em']! as String),
    );
  }

  final String id;
  final String nome;
  final DateTime dataEvento;
  final DateTime? horarioInicio;
  final TipoEvento tipo;
  final int duracaoHoras;
  final int quantidadeAdultos;
  final int quantidadeCriancas;
  final int? convidadosConfirmados;
  final StatusEvento status;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  Evento toEntity() {
    return Evento(
      id: id,
      nome: nome,
      dataEvento: dataEvento,
      horarioInicio: horarioInicio,
      tipo: tipo,
      duracaoHoras: duracaoHoras,
      quantidadeAdultos: quantidadeAdultos,
      quantidadeCriancas: quantidadeCriancas,
      convidadosConfirmados: convidadosConfirmados,
      status: status,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_evento': dataEvento.toIso8601String(),
      'horario_inicio': horarioInicio?.toIso8601String(),
      'tipo': tipo.name,
      'duracao_horas': duracaoHoras,
      'quantidade_adultos': quantidadeAdultos,
      'quantidade_criancas': quantidadeCriancas,
      'convidados_confirmados': convidadosConfirmados,
      'status': status.name,
      'criado_em': criadoEm.toIso8601String(),
      'atualizado_em': atualizadoEm.toIso8601String(),
    };
  }

  static DateTime? _parseDate(String? value) {
    return value == null ? null : DateTime.parse(value);
  }
}
