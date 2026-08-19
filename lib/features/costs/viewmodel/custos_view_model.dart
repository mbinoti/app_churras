import 'package:flutter/foundation.dart';

import '../../../data/repositories/evento_repository.dart';
import '../../../data/repositories/item_evento_repository.dart';
import '../../../domain/entities/evento.dart';
import '../../../domain/entities/item_evento.dart';

class CustosViewModel extends ChangeNotifier {
  CustosViewModel({required this.eventoRepository, this.itemRepository});

  final EventoRepository eventoRepository;
  final EventoItemRepository? itemRepository;

  List<Evento> _eventos = const [];
  Evento? _eventoSelecionado;
  List<EventoItem> _itens = const [];
  bool _estaCarregando = false;
  String? _mensagemErro;
  int _geracaoCarregamento = 0;

  List<Evento> get eventos => List.unmodifiable(_eventos);
  Evento? get eventoSelecionado => _eventoSelecionado;
  List<EventoItem> get itens => List.unmodifiable(_itens);
  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;

  int get totalItens => _itens.length;
  int get itensComprados => _itens.where((item) => item.foiComprado).length;
  double get progressoCompras =>
      totalItens == 0 ? 0 : itensComprados / totalItens;
  int get custoTotalCentavos =>
      _itens.fold(0, (total, item) => total + item.custoEstimadoCentavos);

  Future<void> carregar({String? eventoId}) async {
    final geracao = ++_geracaoCarregamento;
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final eventos = await eventoRepository.listarEventos();
      if (geracao != _geracaoCarregamento) return;

      _eventos = List.unmodifiable(eventos);
      _eventoSelecionado = _selecionarEvento(eventos, eventoId);
      _itens = const [];

      final evento = _eventoSelecionado;
      final repository = itemRepository;
      if (evento == null || repository == null) {
        if (evento != null && repository == null) {
          _mensagemErro = 'Os itens do evento não estão disponíveis.';
        }
      } else {
        _itens = List.unmodifiable(await repository.listarItens(evento.id));
        if (geracao != _geracaoCarregamento) return;
      }
    } catch (_) {
      if (geracao == _geracaoCarregamento) {
        _mensagemErro = 'Não foi possível carregar os itens do evento.';
      }
    } finally {
      if (geracao == _geracaoCarregamento) {
        _estaCarregando = false;
        notifyListeners();
      }
    }
  }

  Future<void> selecionarEvento(String eventoId) {
    return carregar(eventoId: eventoId);
  }

  Evento? _selecionarEvento(List<Evento> eventos, String? eventoId) {
    if (eventos.isEmpty) return null;

    if (eventoId != null) {
      for (final evento in eventos) {
        if (evento.id == eventoId) return evento;
      }
    }

    final eventoAtual = _eventoSelecionado;
    if (eventoAtual != null) {
      for (final evento in eventos) {
        if (evento.id == eventoAtual.id) return evento;
      }
    }

    final ordenados = List<Evento>.from(eventos)
      ..sort((a, b) => a.dataEvento.compareTo(b.dataEvento));
    final hoje = DateTime.now();
    final proximo = ordenados.where(
      (evento) => !evento.dataEvento.isBefore(
        DateTime(hoje.year, hoje.month, hoje.day),
      ),
    );
    return proximo.isNotEmpty ? proximo.first : ordenados.last;
  }
}
