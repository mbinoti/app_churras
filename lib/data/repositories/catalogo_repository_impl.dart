import '../../domain/entities/item_catalogo.dart';
import '../datasources/local/catalogo_local_datasource.dart';
import '../models/item_catalogo_model.dart';
import 'catalogo_repository.dart';

class CatalogoRepositoryException implements Exception {
  const CatalogoRepositoryException(this.message, {this.causa});

  final String message;
  final Object? causa;

  @override
  String toString() => message;
}

class CatalogoRepositoryImpl implements CatalogoRepository {
  const CatalogoRepositoryImpl(this._dataSource);

  final CatalogoLocalDataSource _dataSource;

  @override
  Future<List<ItemCatalogo>> listarItens() async {
    try {
      final registros = await _dataSource.listarItens();
      return registros
          .map(ItemCatalogoModel.fromMap)
          .map((model) => model.toEntity())
          .toList();
    } catch (error) {
      throw CatalogoRepositoryException(
        'Não foi possível carregar o catálogo.',
        causa: error,
      );
    }
  }

  @override
  Future<void> inicializarComPadrao(List<ItemCatalogo> itens) async {
    try {
      final existentes = await _dataSource.listarItens();
      if (existentes.isNotEmpty) return;
      for (final item in itens) {
        await _dataSource.inserirItem(
          ItemCatalogoModel.fromEntity(item).toMap(),
        );
      }
    } catch (error) {
      throw CatalogoRepositoryException(
        'Não foi possível inicializar o catálogo.',
        causa: error,
      );
    }
  }

  @override
  Future<void> atualizarItem(ItemCatalogo item) async {
    try {
      await _dataSource.atualizarItem(
        item.id,
        ItemCatalogoModel.fromEntity(item).toMap(),
      );
    } catch (error) {
      throw CatalogoRepositoryException(
        'Não foi possível atualizar o item do catálogo.',
        causa: error,
      );
    }
  }
}
