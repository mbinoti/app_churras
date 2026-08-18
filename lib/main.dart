import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/datasources/local/app_database.dart';
import 'data/datasources/local/evento_local_datasource.dart';
import 'data/repositories/evento_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDatabase = AppDatabase();
  final eventoDataSource = SqliteEventoLocalDataSource(appDatabase);
  final eventoRepository = EventoRepositoryImpl(eventoDataSource);

  runApp(ChurrasFacilApp(eventoRepository: eventoRepository));
}
