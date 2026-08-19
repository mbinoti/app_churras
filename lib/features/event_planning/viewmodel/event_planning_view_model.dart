import 'package:flutter/foundation.dart';

import '../../../data/repositories/catalogo_repository.dart';
import '../../../data/repositories/evento_repository.dart';
import '../../../data/repositories/item_evento_repository.dart';
import '../../../domain/entities/evento.dart';
import '../../../domain/entities/item_catalogo.dart';
import '../../../domain/entities/item_evento.dart';
import '../../../domain/services/estimation_service.dart';

class EventPlanningViewModel extends ChangeNotifier {
  EventPlanningViewModel({
    required this.eventoRepository,
    this.catalogoRepository,
    this.itemRepository,
    EstimationService? estimationService,
    Evento? evento,
  }) : _eventoOriginal = evento,
       _estimationService = estimationService ?? const EstimationService(),
       _nome = evento?.nome ?? '',
       _dataEvento = evento?.dataEvento,
       _tipo = evento?.tipo ?? TipoEvento.churrasco,
       _duracaoHoras = evento?.duracaoHoras ?? 4,
       _quantidadeAdultos = evento?.quantidadeAdultos ?? 0,
       _quantidadeCriancas = evento?.quantidadeCriancas ?? 0;

  final EventoRepository eventoRepository;
  final CatalogoRepository? catalogoRepository;
  final EventoItemRepository? itemRepository;
  final EstimationService _estimationService;
  final Evento? _eventoOriginal;

  String _nome;
  DateTime? _dataEvento;
  TipoEvento _tipo;
  int _duracaoHoras;
  int _quantidadeAdultos;
  int _quantidadeCriancas;
  List<ItemCatalogo> _catalogo = [];
  List<EventoItem> _itens = [];
  List<EventoItem> _itensOriginais = const [];
  bool _estaSalvando = false;
  bool _estaCarregandoCatalogo = false;
  bool _estaCarregandoItens = false;
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
  List<ItemCatalogo> get catalogo => List.unmodifiable(_catalogo);
  List<EventoItem> get itens => List.unmodifiable(_itens);
  bool get estaSalvando => _estaSalvando;
  bool get estaCarregandoCatalogo => _estaCarregandoCatalogo;
  bool get estaCarregandoItens => _estaCarregandoItens;
  bool get foiSalvo => _foiSalvo;
  String? get erroNome => _erroNome;
  String? get erroData => _erroData;
  String? get mensagemErro => _mensagemErro;
  bool get estaEditando => _eventoOriginal != null;
  int get custoEstimadoCentavos =>
      _itens.fold(0, (total, item) => total + item.custoEstimadoCentavos);

  Map<CategoriaItem, List<EventoItem>> get itensAgrupados {
    final grupos = <CategoriaItem, List<EventoItem>>{};
    for (final item in _itens) {
      grupos.putIfAbsent(item.categoria, () => []).add(item);
    }
    return grupos.map(
      (categoria, itens) => MapEntry(categoria, List.unmodifiable(itens)),
    );
  }

  Future<void> carregarCatalogo() async {
    final repository = catalogoRepository;
    if (repository == null) return;

    _estaCarregandoCatalogo = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _catalogo = await repository.listarItens();
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar as sugestões do cardápio.';
    } finally {
      _estaCarregandoCatalogo = false;
      notifyListeners();
    }
  }

  Future<void> carregarItens() async {
    final evento = _eventoOriginal;
    final repository = itemRepository;
    if (evento == null || repository == null) return;

    _estaCarregandoItens = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _itens = await repository.listarItens(evento.id);
      _itensOriginais = List.unmodifiable(_itens);
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar os itens do evento.';
    } finally {
      _estaCarregandoItens = false;
      notifyListeners();
    }
  }

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
    _recalcularItensAutomaticos();
    notifyListeners();
  }

  void alterarQuantidadeAdultos(int valor) {
    _quantidadeAdultos = valor < 0 ? 0 : valor;
    _recalcularItensAutomaticos();
    notifyListeners();
  }

  void alterarQuantidadeCriancas(int valor) {
    _quantidadeCriancas = valor < 0 ? 0 : valor;
    _recalcularItensAutomaticos();
    notifyListeners();
  }

  void adicionarItemDoCatalogo(ItemCatalogo catalogo) {
    final jaAdicionado = _itens.any(
      (item) =>
          item.nome == catalogo.nome && item.categoria == catalogo.categoria,
    );
    if (jaAdicionado) return;

    _itens = [
      ..._itens,
      _estimationService.criarItemAutomatico(
        item: catalogo,
        eventoId: _eventoOriginal?.id ?? '',
        quantidadeAdultos: _quantidadeAdultos,
        quantidadeCriancas: _quantidadeCriancas,
        duracaoHoras: _duracaoHoras,
      ),
    ];
    notifyListeners();
  }

  bool itemCatalogoSelecionado(ItemCatalogo catalogo) {
    return _itens.any(
      (item) =>
          item.nome == catalogo.nome && item.categoria == catalogo.categoria,
    );
  }

  void alternarItemDoCatalogo(ItemCatalogo catalogo, bool selecionado) {
    if (selecionado) {
      adicionarItemDoCatalogo(catalogo);
      return;
    }

    final item = _itens
        .where(
          (item) =>
              item.nome == catalogo.nome &&
              item.categoria == catalogo.categoria,
        )
        .firstOrNull;
    if (item != null) removerItem(item.id);
  }

  void adicionarItemPersonalizado(EventoItem item) {
    _itens = [..._itens, item.copyWith(eventoId: _eventoOriginal?.id ?? '')];
    notifyListeners();
  }

  void alterarQuantidadeItem(String id, double quantidade) {
    if (quantidade <= 0) return;
    _atualizarItem(
      id,
      (item) => item.copyWith(
        quantidade: quantidade,
        origemQuantidade: OrigemQuantidade.manual,
      ),
    );
  }

  void alterarPrecoItem(String id, int? precoUnitarioCentavos) {
    _atualizarItem(
      id,
      (item) => item.copyWith(precoUnitarioCentavos: precoUnitarioCentavos),
    );
  }

  void removerItem(String id) {
    _itens = _itens.where((item) => item.id != id).toList();
    notifyListeners();
  }

  Future<bool> atualizarItemCatalogo(ItemCatalogo item) async {
    final repository = catalogoRepository;
    if (repository == null) return false;

    try {
      await repository.atualizarItem(item);
      _catalogo = [
        for (final existente in _catalogo)
          existente.id == item.id ? item : existente,
      ];
      _recalcularItensAutomaticos();
      notifyListeners();
      return true;
    } catch (_) {
      _mensagemErro = 'Não foi possível salvar a sugestão.';
      notifyListeners();
      return false;
    }
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
      await _salvarItens(evento.id);
      _foiSalvo = true;
      return true;
    } catch (_) {
      _mensagemErro =
          'Não foi possível salvar o planejamento. Tente novamente.';
      return false;
    } finally {
      _estaSalvando = false;
      notifyListeners();
    }
  }

  Future<void> _salvarItens(String eventoId) async {
    final repository = itemRepository;
    if (repository == null) return;

    final idsAtuais = _itens.map((item) => item.id).toSet();
    for (final itemOriginal in _itensOriginais) {
      if (!idsAtuais.contains(itemOriginal.id)) {
        await repository.excluirItem(itemOriginal.id);
      }
    }

    final idsOriginais = _itensOriginais.map((item) => item.id).toSet();
    final itensSalvos = <EventoItem>[];
    for (final item in _itens) {
      final itemComEvento = item.copyWith(eventoId: eventoId);
      if (idsOriginais.contains(item.id)) {
        await repository.atualizarItem(itemComEvento);
      } else {
        await repository.criarItem(itemComEvento);
      }
      itensSalvos.add(itemComEvento);
    }
    _itens = itensSalvos;
    _itensOriginais = List.unmodifiable(itensSalvos);
  }

  void _atualizarItem(String id, EventoItem Function(EventoItem) atualizar) {
    _itens = [
      for (final item in _itens) item.id == id ? atualizar(item) : item,
    ];
    notifyListeners();
  }

  void _recalcularItensAutomaticos() {
    _itens = [
      for (final item in _itens)
        if (item.origemQuantidade == OrigemQuantidade.automatica)
          _recalcularItemAutomatico(item)
        else
          item,
    ];
  }

  EventoItem _recalcularItemAutomatico(EventoItem item) {
    final catalogo = _catalogo.firstWhere(
      (catalogo) =>
          catalogo.nome == item.nome && catalogo.categoria == item.categoria,
      orElse: () => const ItemCatalogo(
        id: 'ausente',
        nome: '',
        categoria: CategoriaItem.personalizado,
        unidade: UnidadeItem.unidade,
        precoUnitarioCentavos: 0,
        quantidadePorAdulto: 0,
        quantidadePorCrianca: 0,
      ),
    );
    if (catalogo.id == 'ausente') return item;
    return _estimationService.recalcularItem(
      item: item,
      catalogo: catalogo,
      quantidadeAdultos: _quantidadeAdultos,
      quantidadeCriancas: _quantidadeCriancas,
      duracaoHoras: _duracaoHoras,
    );
  }
}
