import 'package:app_churras/data/repositories/evento_repository.dart';
import 'package:app_churras/domain/entities/evento.dart';

class FakeEventoRepository implements EventoRepository {
  FakeEventoRepository([List<Evento>? eventos])
    : eventos = List<Evento>.from(eventos ?? const []);

  final List<Evento> eventos;
  bool falharListagem = false;
  int quantidadeCriacoes = 0;
  int quantidadeAtualizacoes = 0;
  int quantidadeExclusoes = 0;

  @override
  Future<List<Evento>> listarEventos() async {
    if (falharListagem) throw Exception('Falha simulada');
    return List<Evento>.from(eventos);
  }

  @override
  Future<Evento?> buscarEvento(String id) async {
    for (final evento in eventos) {
      if (evento.id == id) return evento;
    }
    return null;
  }

  @override
  Future<Evento> criarEvento(Evento evento) async {
    quantidadeCriacoes++;
    eventos.add(evento);
    return evento;
  }

  @override
  Future<void> atualizarEvento(Evento evento) async {
    quantidadeAtualizacoes++;
    final indice = eventos.indexWhere((item) => item.id == evento.id);
    if (indice == -1) throw Exception('Evento não encontrado');
    eventos[indice] = evento;
  }

  @override
  Future<void> excluirEvento(String id) async {
    quantidadeExclusoes++;
    eventos.removeWhere((evento) => evento.id == id);
  }
}
