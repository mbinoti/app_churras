import 'package:flutter/foundation.dart';

import '../../../data/repositories/evento_repository.dart';
import '../../../domain/entities/evento.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.eventoRepository});

  final EventoRepository eventoRepository;

  List<Evento> _eventos = const [];
  bool _estaCarregando = false;
  String? _mensagemErro;
  String? _idExcluindo;

  List<Evento> get eventos => List.unmodifiable(_eventos);
  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;
  String? get idExcluindo => _idExcluindo;

  List<Evento> get proximosEventos {
    final hoje = DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
    return _eventos
        .where((evento) => !evento.dataEvento.isBefore(inicioHoje))
        .toList();
  }

  List<Evento> get eventosRecentes {
    final hoje = DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
    return _eventos
        .where((evento) => evento.dataEvento.isBefore(inicioHoje))
        .toList()
        .reversed
        .toList();
  }

  Future<void> carregarEventos() async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _eventos = await eventoRepository.listarEventos();
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar seus eventos.';
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  Future<bool> excluirEvento(Evento evento) async {
    _idExcluindo = evento.id;
    _mensagemErro = null;
    notifyListeners();

    try {
      await eventoRepository.excluirEvento(evento.id);
      _eventos = _eventos.where((item) => item.id != evento.id).toList();
      return true;
    } catch (_) {
      _mensagemErro = 'Não foi possível excluir o evento.';
      return false;
    } finally {
      _idExcluindo = null;
      notifyListeners();
    }
  }
}
