enum TipoEvento { churrasco, aniversario, empresa, familia, outro }

extension TipoEventoLabel on TipoEvento {
  String get label => switch (this) {
    TipoEvento.churrasco => 'Churrasco',
    TipoEvento.aniversario => 'Aniversário',
    TipoEvento.empresa => 'Empresa',
    TipoEvento.familia => 'Família',
    TipoEvento.outro => 'Outro',
  };
}

enum StatusEvento { rascunho, planejado, concluido, cancelado }

class Evento {
  const Evento({
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

  factory Evento.novo({
    required String nome,
    required DateTime dataEvento,
    required TipoEvento tipo,
    int duracaoHoras = 4,
    int quantidadeAdultos = 0,
    int quantidadeCriancas = 0,
    String? id,
    DateTime? agora,
  }) {
    final instante = agora ?? DateTime.now();
    final data = DateTime(dataEvento.year, dataEvento.month, dataEvento.day);

    return Evento(
      id: id ?? instante.microsecondsSinceEpoch.toString(),
      nome: nome.trim(),
      dataEvento: data,
      tipo: tipo,
      duracaoHoras: duracaoHoras,
      quantidadeAdultos: quantidadeAdultos,
      quantidadeCriancas: quantidadeCriancas,
      status: StatusEvento.planejado,
      criadoEm: instante,
      atualizadoEm: instante,
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

  int get totalParticipantes => quantidadeAdultos + quantidadeCriancas;

  Evento copyWith({
    String? id,
    String? nome,
    DateTime? dataEvento,
    DateTime? horarioInicio,
    TipoEvento? tipo,
    int? duracaoHoras,
    int? quantidadeAdultos,
    int? quantidadeCriancas,
    int? convidadosConfirmados,
    StatusEvento? status,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Evento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataEvento: dataEvento ?? this.dataEvento,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      tipo: tipo ?? this.tipo,
      duracaoHoras: duracaoHoras ?? this.duracaoHoras,
      quantidadeAdultos: quantidadeAdultos ?? this.quantidadeAdultos,
      quantidadeCriancas: quantidadeCriancas ?? this.quantidadeCriancas,
      convidadosConfirmados:
          convidadosConfirmados ?? this.convidadosConfirmados,
      status: status ?? this.status,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Evento &&
        other.id == id &&
        other.nome == nome &&
        other.dataEvento == dataEvento &&
        other.horarioInicio == horarioInicio &&
        other.tipo == tipo &&
        other.duracaoHoras == duracaoHoras &&
        other.quantidadeAdultos == quantidadeAdultos &&
        other.quantidadeCriancas == quantidadeCriancas &&
        other.convidadosConfirmados == convidadosConfirmados &&
        other.status == status &&
        other.criadoEm == criadoEm &&
        other.atualizadoEm == atualizadoEm;
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    dataEvento,
    horarioInicio,
    tipo,
    duracaoHoras,
    quantidadeAdultos,
    quantidadeCriancas,
    convidadosConfirmados,
    status,
    criadoEm,
    atualizadoEm,
  );
}
