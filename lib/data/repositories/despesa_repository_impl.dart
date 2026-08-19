import '../../domain/entities/despesa.dart';
import '../datasources/local/despesa_local_datasource.dart';
import '../models/despesa_model.dart';
import 'despesa_repository.dart';

class DespesaRepositoryException implements Exception {
  const DespesaRepositoryException(this.message, {this.causa});

  final String message;
  final Object? causa;

  @override
  String toString() => message;
}

class DespesaRepositoryImpl implements DespesaRepository {
  const DespesaRepositoryImpl(this._dataSource);

  final DespesaLocalDataSource _dataSource;

  @override
  Future<List<Despesa>> listarDespesas(String eventoId) async {
    try {
      final registros = await _dataSource.listarDespesas(eventoId);
      return registros
          .map(DespesaModel.fromMap)
          .map((model) => model.toEntity())
          .toList();
    } catch (error) {
      throw DespesaRepositoryException(
        'Não foi possível carregar as despesas do evento.',
        causa: error,
      );
    }
  }

  @override
  Future<Despesa> criarDespesa(Despesa despesa) async {
    try {
      await _dataSource.inserirDespesa(
        DespesaModel.fromEntity(despesa).toMap(),
      );
      return despesa;
    } catch (error) {
      throw DespesaRepositoryException(
        'Não foi possível salvar a despesa.',
        causa: error,
      );
    }
  }

  @override
  Future<void> atualizarDespesa(Despesa despesa) async {
    try {
      await _dataSource.atualizarDespesa(
        despesa.id,
        DespesaModel.fromEntity(despesa).toMap(),
      );
    } catch (error) {
      throw DespesaRepositoryException(
        'Não foi possível atualizar a despesa.',
        causa: error,
      );
    }
  }
}
