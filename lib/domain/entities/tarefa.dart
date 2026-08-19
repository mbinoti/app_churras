enum StatusTarefa { pendente, concluida }

extension StatusTarefaLabel on StatusTarefa {
  String get label => switch (this) {
    StatusTarefa.pendente => 'Pendente',
    StatusTarefa.concluida => 'Concluída',
  };
}

class Tarefa {
  const Tarefa({
    required this.id,
    required this.eventoId,
    required this.titulo,
    required this.status,
    this.descricao,
    this.responsavelNome,
    this.responsavelId,
    this.dataLimite,
  });

  factory Tarefa.novo({
    required String eventoId,
    required String titulo,
    String? descricao,
    String? responsavelNome,
    String? responsavelId,
    DateTime? dataLimite,
    StatusTarefa status = StatusTarefa.pendente,
    String? id,
  }) {
    return Tarefa(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      eventoId: eventoId,
      titulo: titulo.trim(),
      descricao: _textoOpcional(descricao),
      responsavelNome: _textoOpcional(responsavelNome),
      responsavelId: _textoOpcional(responsavelId),
      dataLimite: dataLimite,
      status: status,
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

  bool get estaConcluida => status == StatusTarefa.concluida;

  Tarefa copyWith({
    String? titulo,
    Object? descricao = _naoInformado,
    Object? responsavelNome = _naoInformado,
    Object? responsavelId = _naoInformado,
    Object? dataLimite = _naoInformado,
    StatusTarefa? status,
  }) {
    return Tarefa(
      id: id,
      eventoId: eventoId,
      titulo: titulo ?? this.titulo,
      descricao: _valorOpcional<String>(descricao, this.descricao),
      responsavelNome: _valorOpcional<String>(
        responsavelNome,
        this.responsavelNome,
      ),
      responsavelId: _valorOpcional<String>(responsavelId, this.responsavelId),
      dataLimite: _valorOpcional<DateTime>(dataLimite, this.dataLimite),
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Tarefa &&
        other.id == id &&
        other.eventoId == eventoId &&
        other.titulo == titulo &&
        other.descricao == descricao &&
        other.responsavelNome == responsavelNome &&
        other.responsavelId == responsavelId &&
        other.dataLimite == dataLimite &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventoId,
    titulo,
    descricao,
    responsavelNome,
    responsavelId,
    dataLimite,
    status,
  );
}

const _naoInformado = Object();

T? _valorOpcional<T>(Object? valor, T? atual) {
  return identical(valor, _naoInformado) ? atual : valor as T?;
}

String? _textoOpcional(String? texto) {
  final valor = texto?.trim();
  return valor == null || valor.isEmpty ? null : valor;
}
