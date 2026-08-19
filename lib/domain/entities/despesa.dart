import 'item_evento.dart';

enum StatusDespesa { pendente, pago }

extension StatusDespesaLabel on StatusDespesa {
  String get label => switch (this) {
    StatusDespesa.pendente => 'Pendente',
    StatusDespesa.pago => 'Pago',
  };
}

class Despesa {
  const Despesa({
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

  factory Despesa.novo({
    required String eventoId,
    required String descricao,
    required int valorCentavos,
    required CategoriaItem categoria,
    required String pagadorNome,
    DateTime? dataDespesa,
    StatusDespesa status = StatusDespesa.pago,
    String? pagadorId,
    String? observacoes,
    String? id,
  }) {
    return Despesa(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      eventoId: eventoId,
      descricao: descricao.trim(),
      valorCentavos: valorCentavos,
      categoria: categoria,
      pagadorNome: pagadorNome.trim(),
      dataDespesa: dataDespesa ?? DateTime.now(),
      status: status,
      pagadorId: _textoOpcional(pagadorId),
      observacoes: _textoOpcional(observacoes),
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

  bool get estaPaga => status == StatusDespesa.pago;

  Despesa copyWith({
    String? descricao,
    int? valorCentavos,
    CategoriaItem? categoria,
    String? pagadorNome,
    Object? pagadorId = _naoInformado,
    DateTime? dataDespesa,
    Object? observacoes = _naoInformado,
    StatusDespesa? status,
  }) {
    return Despesa(
      id: id,
      eventoId: eventoId,
      descricao: descricao ?? this.descricao,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      categoria: categoria ?? this.categoria,
      pagadorNome: pagadorNome ?? this.pagadorNome,
      pagadorId: _valorOpcional<String>(pagadorId, this.pagadorId),
      dataDespesa: dataDespesa ?? this.dataDespesa,
      observacoes: _valorOpcional<String>(observacoes, this.observacoes),
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Despesa &&
        other.id == id &&
        other.eventoId == eventoId &&
        other.descricao == descricao &&
        other.valorCentavos == valorCentavos &&
        other.categoria == categoria &&
        other.pagadorNome == pagadorNome &&
        other.pagadorId == pagadorId &&
        other.dataDespesa == dataDespesa &&
        other.observacoes == observacoes &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventoId,
    descricao,
    valorCentavos,
    categoria,
    pagadorNome,
    pagadorId,
    dataDespesa,
    observacoes,
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
