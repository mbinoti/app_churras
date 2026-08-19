import 'package:flutter/foundation.dart';

import '../../../data/repositories/evento_repository.dart';
import '../../../data/repositories/tarefa_repository.dart';
import '../../../domain/entities/evento.dart';
import '../../../domain/entities/tarefa.dart';

class TarefasViewModel extends ChangeNotifier {
  TarefasViewModel({
    required this.eventoRepository,
    required this.tarefaRepository,
  });

  final EventoRepository eventoRepository;
  final TarefaRepository? tarefaRepository;

  List<Evento> _eventos = const [];
  Evento? _eventoSelecionado;
  List<Tarefa> _tarefas = const [];
  bool _estaCarregando = false;
  bool _estaSalvando = false;
  String? _idAtualizando;
  String? _mensagemErro;
  int _geracaoCarregamento = 0;

  List<Evento> get eventos => List.unmodifiable(_eventos);
  Evento? get eventoSelecionado => _eventoSelecionado;
  List<Tarefa> get tarefas => List.unmodifiable(_tarefas);
  bool get estaCarregando => _estaCarregando;
  bool get estaSalvando => _estaSalvando;
  String? get idAtualizando => _idAtualizando;
  String? get mensagemErro => _mensagemErro;

  int get totalTarefas => _tarefas.length;
  int get tarefasConcluidas =>
      _tarefas.where((tarefa) => tarefa.estaConcluida).length;
  int get tarefasPendentes => totalTarefas - tarefasConcluidas;
  double get progresso =>
      totalTarefas == 0 ? 0 : tarefasConcluidas / totalTarefas;

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
      final repository = tarefaRepository;
      if (evento == null) {
        _tarefas = const [];
      } else if (repository == null) {
        _tarefas = const [];
        _mensagemErro = 'As tarefas não estão disponíveis.';
      } else {
        _tarefas = List.unmodifiable(await repository.listarTarefas(evento.id));
      }
    } catch (_) {
      if (geracao == _geracaoCarregamento) {
        _mensagemErro = 'Não foi possível carregar as tarefas.';
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

  Future<bool> criarTarefa({
    required String titulo,
    String? descricao,
    String? responsavelNome,
    DateTime? dataLimite,
  }) async {
    final evento = _eventoSelecionado;
    final repository = tarefaRepository;
    if (evento == null || repository == null || titulo.trim().isEmpty) {
      return false;
    }

    _estaSalvando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final tarefa = Tarefa.novo(
        eventoId: evento.id,
        titulo: titulo,
        descricao: descricao,
        responsavelNome: responsavelNome,
        dataLimite: dataLimite,
      );
      final tarefaSalva = await repository.criarTarefa(tarefa);
      _tarefas = _ordenarTarefas([..._tarefas, tarefaSalva]);
      return true;
    } catch (_) {
      _mensagemErro = 'Não foi possível salvar a tarefa.';
      return false;
    } finally {
      _estaSalvando = false;
      notifyListeners();
    }
  }

  Future<bool> alterarStatus(String tarefaId, bool concluida) async {
    final status = concluida ? StatusTarefa.concluida : StatusTarefa.pendente;
    return _atualizarTarefa(
      tarefaId,
      (tarefa) => tarefa.copyWith(status: status),
      'Não foi possível atualizar o status da tarefa.',
    );
  }

  Future<bool> atribuirResponsavel(
    String tarefaId,
    String? responsavelNome,
  ) async {
    final nome = responsavelNome?.trim();
    return _atualizarTarefa(
      tarefaId,
      (tarefa) =>
          tarefa.copyWith(responsavelNome: nome?.isEmpty == true ? null : nome),
      'Não foi possível atualizar o responsável.',
    );
  }

  Future<bool> _atualizarTarefa(
    String tarefaId,
    Tarefa Function(Tarefa tarefa) atualizar,
    String mensagemErro,
  ) async {
    final repository = tarefaRepository;
    final indice = _tarefas.indexWhere((tarefa) => tarefa.id == tarefaId);
    if (repository == null || indice == -1 || _idAtualizando != null) {
      return false;
    }

    final tarefaAnterior = _tarefas[indice];
    final tarefaAtualizada = atualizar(tarefaAnterior);
    _tarefas = _ordenarTarefas([
      for (var i = 0; i < _tarefas.length; i++)
        if (i == indice) tarefaAtualizada else _tarefas[i],
    ]);
    _idAtualizando = tarefaId;
    _mensagemErro = null;
    notifyListeners();

    try {
      await repository.atualizarTarefa(tarefaAtualizada);
      return true;
    } catch (_) {
      _tarefas = _ordenarTarefas([
        for (var i = 0; i < _tarefas.length; i++)
          if (_tarefas[i].id == tarefaId) tarefaAnterior else _tarefas[i],
      ]);
      _mensagemErro = mensagemErro;
      return false;
    } finally {
      _idAtualizando = null;
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

  List<Tarefa> _ordenarTarefas(Iterable<Tarefa> tarefas) {
    final ordenadas = List<Tarefa>.from(tarefas)
      ..sort((a, b) {
        if (a.estaConcluida != b.estaConcluida) {
          return a.estaConcluida ? 1 : -1;
        }
        final prazoA = a.dataLimite;
        final prazoB = b.dataLimite;
        if (prazoA == null && prazoB != null) return 1;
        if (prazoA != null && prazoB == null) return -1;
        if (prazoA != null && prazoB != null) {
          final comparacaoPrazo = prazoA.compareTo(prazoB);
          if (comparacaoPrazo != 0) return comparacaoPrazo;
        }
        return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
      });
    return List.unmodifiable(ordenadas);
  }
}
