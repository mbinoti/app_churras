import 'package:flutter/foundation.dart';

import '../../../data/repositories/evento_repository.dart';
import '../../../domain/entities/evento.dart';

class EventPlanningViewModel extends ChangeNotifier {
  EventPlanningViewModel({required this.eventoRepository, Evento? evento})
    : _eventoOriginal = evento,
      _nome = evento?.nome ?? '',
      _dataEvento = evento?.dataEvento,
      _tipo = evento?.tipo ?? TipoEvento.churrasco,
      _duracaoHoras = evento?.duracaoHoras ?? 4,
      _quantidadeAdultos = evento?.quantidadeAdultos ?? 0,
      _quantidadeCriancas = evento?.quantidadeCriancas ?? 0;

  final EventoRepository eventoRepository;
  final Evento? _eventoOriginal;

  String _nome;
  DateTime? _dataEvento;
  TipoEvento _tipo;
  int _duracaoHoras;
  int _quantidadeAdultos;
  int _quantidadeCriancas;
  bool _estaSalvando = false;
  bool _foiSalvo = false;
  String? _erroNome;
  String? _erroData;
  String? _mensagemErro;

  String get nome => _nome;
  DateTime? get dataEvento => _dataEvento;
  TipoEvento get tipo => _tipo;
  int get duracaoHoras => _duracaoHoras;
  int get quantidadeAdultos => _quantidadeAdultos;
  int get quantidadeCriancas => _quantidadeCriancas;
  int get totalParticipantes => _quantidadeAdultos + _quantidadeCriancas;
  bool get estaSalvando => _estaSalvando;
  bool get foiSalvo => _foiSalvo;
  String? get erroNome => _erroNome;
  String? get erroData => _erroData;
  String? get mensagemErro => _mensagemErro;
  bool get estaEditando => _eventoOriginal != null;

  void alterarNome(String valor) {
    _nome = valor;
    if (_erroNome != null && valor.trim().isNotEmpty) _erroNome = null;
    notifyListeners();
  }

  void alterarDataEvento(DateTime? valor) {
    _dataEvento = valor;
    if (valor != null) _erroData = null;
    notifyListeners();
  }

  void alterarTipo(TipoEvento valor) {
    _tipo = valor;
    notifyListeners();
  }

  void alterarDuracao(int valor) {
    _duracaoHoras = valor.clamp(1, 12).toInt();
    notifyListeners();
  }

  void alterarQuantidadeAdultos(int valor) {
    _quantidadeAdultos = valor < 0 ? 0 : valor;
    notifyListeners();
  }

  void alterarQuantidadeCriancas(int valor) {
    _quantidadeCriancas = valor < 0 ? 0 : valor;
    notifyListeners();
  }

  bool validar() {
    _erroNome = _nome.trim().isEmpty ? 'Informe o nome do evento.' : null;
    _erroData = _dataEvento == null ? 'Selecione a data do evento.' : null;
    notifyListeners();
    return _erroNome == null && _erroData == null;
  }

  Future<bool> salvarEvento() async {
    if (!validar()) return false;

    _estaSalvando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final original = _eventoOriginal;
      final evento = original == null
          ? Evento.novo(
              nome: _nome,
              dataEvento: _dataEvento!,
              tipo: _tipo,
              duracaoHoras: _duracaoHoras,
              quantidadeAdultos: _quantidadeAdultos,
              quantidadeCriancas: _quantidadeCriancas,
            )
          : original.copyWith(
              nome: _nome.trim(),
              dataEvento: _dataEvento,
              tipo: _tipo,
              duracaoHoras: _duracaoHoras,
              quantidadeAdultos: _quantidadeAdultos,
              quantidadeCriancas: _quantidadeCriancas,
              atualizadoEm: DateTime.now(),
            );

      if (original == null) {
        await eventoRepository.criarEvento(evento);
      } else {
        await eventoRepository.atualizarEvento(evento);
      }
      _foiSalvo = true;
      return true;
    } catch (_) {
      _mensagemErro = 'Não foi possível salvar o evento. Tente novamente.';
      return false;
    } finally {
      _estaSalvando = false;
      notifyListeners();
    }
  }
}
