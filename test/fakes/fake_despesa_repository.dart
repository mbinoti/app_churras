import 'package:app_churras/data/repositories/despesa_repository.dart';
import 'package:app_churras/domain/entities/despesa.dart';

class FakeDespesaRepository implements DespesaRepository {
  FakeDespesaRepository([List<Despesa>? despesas])
    : despesas = List<Despesa>.from(despesas ?? const []);

  final List<Despesa> despesas;
  int quantidadeCriacoes = 0;
  int quantidadeAtualizacoes = 0;
  bool falharListagem = false;
  bool falharAtualizacao = false;

  @override
  Future<List<Despesa>> listarDespesas(String eventoId) async {
    if (falharListagem) throw Exception('Falha simulada');
    return despesas.where((despesa) => despesa.eventoId == eventoId).toList();
  }

  @override
  Future<Despesa> criarDespesa(Despesa despesa) async {
    quantidadeCriacoes++;
    despesas.add(despesa);
    return despesa;
  }

  @override
  Future<void> atualizarDespesa(Despesa despesa) async {
    quantidadeAtualizacoes++;
    if (falharAtualizacao) throw Exception('Falha simulada');
    final indice = despesas.indexWhere(
      (existente) => existente.id == despesa.id,
    );
    if (indice == -1) throw Exception('Despesa não encontrada');
    despesas[indice] = despesa;
  }
}
