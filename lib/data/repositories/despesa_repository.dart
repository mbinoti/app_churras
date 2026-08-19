import '../../domain/entities/despesa.dart';

abstract interface class DespesaRepository {
  Future<List<Despesa>> listarDespesas(String eventoId);

  Future<Despesa> criarDespesa(Despesa despesa);

  Future<void> atualizarDespesa(Despesa despesa);
}
