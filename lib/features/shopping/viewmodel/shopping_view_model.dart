import 'package:flutter/foundation.dart';

import '../../../data/repositories/evento_repository.dart';
import '../../../data/repositories/item_evento_repository.dart';
import '../../../domain/entities/evento.dart';
import '../../../domain/entities/item_evento.dart';

class ShoppingViewModel extends ChangeNotifier {
  ShoppingViewModel({
    required this.eventoRepository,
    required this.itemRepository,
  });

  final EventoRepository eventoRepository;
  final EventoItemRepository? itemRepository;

  List<Evento> _eventos = const [];
  Evento? _eventoSelecionado;
  List<EventoItem> _itens = const [];
  bool _estaCarregando = false;
  bool _estaAdicionando = false;
  String? _idAtualizando;
  String? _mensagemErro;
  int _geracaoCarregamento = 0;

  List<Evento> get eventos => List.unmodifiable(_eventos);
  Evento? get eventoSelecionado => _eventoSelecionado;
  List<EventoItem> get itens => List.unmodifiable(_itens);
  bool get estaCarregando => _estaCarregando;
  bool get estaAdicionando => _estaAdicionando;
  String? get idAtualizando => _idAtualizando;
  String? get mensagemErro => _mensagemErro;

  int get totalItens => _itens.length;
  int get itensComprados => _itens.where((item) => item.foiComprado).length;
  int get itensPendentes => totalItens - itensComprados;
  double get progresso => totalItens == 0 ? 0 : itensComprados / totalItens;
  int get custoTotalCentavos =>
      _itens.fold(0, (total, item) => total + item.custoEstimadoCentavos);

  Map<CategoriaItem, List<EventoItem>> get itensAgrupados {
    final grupos = <CategoriaItem, List<EventoItem>>{};
    for (final categoria in CategoriaItem.values) {
      final itensDaCategoria = _itens
          .where((item) => item.categoria == categoria)
          .toList();
      if (itensDaCategoria.isNotEmpty) {
        grupos[categoria] = List.unmodifiable(itensDaCategoria);
      }
    }
    return Map.unmodifiable(grupos);
  }

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

      final evento = _eventoSelecionado;
      if (evento == null) {
        _itens = const [];
      } else {
        final repository = itemRepository;
        if (repository == null) {
          _itens = const [];
          _mensagemErro = 'A lista de compras não está disponível.';
        } else {
          _itens = List.unmodifiable(await repository.listarItens(evento.id));
        }
      }
    } catch (_) {
      if (geracao == _geracaoCarregamento) {
        _mensagemErro = 'Não foi possível carregar a lista de compras.';
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

  Future<bool> alterarItemComprado(String itemId, bool foiComprado) async {
    final repository = itemRepository;
    final indice = _itens.indexWhere((item) => item.id == itemId);
    if (repository == null || indice == -1 || _idAtualizando != null) {
      return false;
    }

    final itemAnterior = _itens[indice];
    final itemAtualizado = itemAnterior.copyWith(foiComprado: foiComprado);
    _itens = [
      for (var i = 0; i < _itens.length; i++)
        i == indice ? itemAtualizado : _itens[i],
    ];
    _idAtualizando = itemId;
    _mensagemErro = null;
    notifyListeners();

    try {
      await repository.atualizarItem(itemAtualizado);
      return true;
    } catch (_) {
      _itens = [
        for (var i = 0; i < _itens.length; i++)
          i == indice ? itemAnterior : _itens[i],
      ];
      _mensagemErro = 'Não foi possível atualizar o item.';
      return false;
    } finally {
      _idAtualizando = null;
      notifyListeners();
    }
  }

  Future<bool> adicionarItem({
    required String nome,
    required CategoriaItem categoria,
    required UnidadeItem unidade,
    required double quantidade,
    int? precoUnitarioCentavos,
    String? observacoes,
  }) async {
    final evento = _eventoSelecionado;
    final repository = itemRepository;
    if (evento == null || repository == null || nome.trim().isEmpty) {
      return false;
    }
    if (quantidade <= 0 || quantidade.isNaN || quantidade.isInfinite) {
      return false;
    }

    _estaAdicionando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final item = EventoItem.novo(
        eventoId: evento.id,
        nome: nome,
        categoria: categoria,
        unidade: unidade,
        quantidade: quantidade,
        precoUnitarioCentavos: precoUnitarioCentavos,
        origemQuantidade: OrigemQuantidade.manual,
        observacoes: observacoes,
      );
      final itemSalvo = await repository.criarItem(item);
      _itens = [..._itens, itemSalvo];
      return true;
    } catch (_) {
      _mensagemErro = 'Não foi possível adicionar o item.';
      return false;
    } finally {
      _estaAdicionando = false;
      notifyListeners();
    }
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
