import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'data/datasources/local/app_database.dart';
import 'data/datasources/local/catalogo_local_datasource.dart';
import 'data/datasources/local/despesa_local_datasource.dart';
import 'data/datasources/local/evento_local_datasource.dart';
import 'data/datasources/local/item_evento_local_datasource.dart';
import 'data/datasources/local/tarefa_local_datasource.dart';
import 'data/models/item_catalogo_model.dart';
import 'data/repositories/catalogo_repository_impl.dart';
import 'data/repositories/despesa_repository_impl.dart';
import 'data/repositories/item_evento_repository_impl.dart';
import 'data/repositories/evento_repository_impl.dart';
import 'data/repositories/tarefa_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDatabase = AppDatabase();
  final catalogoDataSource = SqliteCatalogoLocalDataSource(appDatabase);
  final eventoDataSource = SqliteEventoLocalDataSource(appDatabase);
  final eventoItemDataSource = SqliteEventoItemLocalDataSource(appDatabase);
  final tarefaDataSource = SqliteTarefaLocalDataSource(appDatabase);
  final despesaDataSource = SqliteDespesaLocalDataSource(appDatabase);
  final catalogoRepository = CatalogoRepositoryImpl(catalogoDataSource);
  final eventoRepository = EventoRepositoryImpl(eventoDataSource);
  final eventoItemRepository = EventoItemRepositoryImpl(eventoItemDataSource);
  final tarefaRepository = TarefaRepositoryImpl(tarefaDataSource);
  final despesaRepository = DespesaRepositoryImpl(despesaDataSource);
  final catalogoJson = await rootBundle.loadString(
    'assets/data/catalogo_itens.json',
  );
  await catalogoRepository.inicializarComPadrao(
    ItemCatalogoModel.listaFromJson(catalogoJson),
  );

  runApp(
    ChurrasFacilApp(
      catalogoRepository: catalogoRepository,
      eventoRepository: eventoRepository,
      eventoItemRepository: eventoItemRepository,
      tarefaRepository: tarefaRepository,
      despesaRepository: despesaRepository,
    ),
  );
}
