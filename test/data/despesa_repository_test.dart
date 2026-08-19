import 'package:app_churras/data/repositories/despesa_repository_impl.dart';
import 'package:app_churras/domain/entities/despesa.dart';
import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_despesa_local_datasource.dart';

void main() {
  test('DespesaRepository salva, lista e atualiza despesas', () async {
    final dataSource = FakeDespesaLocalDataSource();
    final repository = DespesaRepositoryImpl(dataSource);
    final despesa = Despesa.novo(
      id: 'despesa-1',
      eventoId: 'evento-1',
      descricao: 'Carnes',
      valorCentavos: 25000,
      categoria: CategoriaItem.carnes,
      pagadorNome: 'Carlos',
      dataDespesa: DateTime(2026, 8, 19),
    );

    await repository.criarDespesa(despesa);
    expect(await repository.listarDespesas('evento-1'), [despesa]);

    final atualizada = despesa.copyWith(status: StatusDespesa.pendente);
    await repository.atualizarDespesa(atualizada);
    expect(
      (await repository.listarDespesas('evento-1')).single.status,
      StatusDespesa.pendente,
    );
  });
}
