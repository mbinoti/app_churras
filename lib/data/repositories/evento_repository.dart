import '../../domain/entities/evento.dart';

abstract interface class EventoRepository {
  Future<List<Evento>> listarEventos();

  Future<Evento?> buscarEvento(String id);

  Future<Evento> criarEvento(Evento evento);

  Future<void> atualizarEvento(Evento evento);

  Future<void> excluirEvento(String id);
}
