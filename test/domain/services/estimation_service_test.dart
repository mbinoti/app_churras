import 'package:app_churras/domain/entities/item_evento.dart';
import 'package:app_churras/domain/services/estimation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/catalogo_test_data.dart';

void main() {
  group('EstimationService', () {
    const service = EstimationService();

    test('calcula quantidade de carne para adultos e crianças', () {
      final picanha = itemCatalogoPicanha;

      final quantidade = service.calcularQuantidade(
        item: picanha,
        quantidadeAdultos: 4,
        quantidadeCriancas: 2,
        duracaoHoras: 4,
      );

      expect(quantidade, 0.6);
    });

    test('aumenta bebidas para eventos mais longos e arredonda unidades', () {
      final cerveja = itemCatalogoCerveja;

      final quantidade = service.calcularQuantidade(
        item: cerveja,
        quantidadeAdultos: 4,
        quantidadeCriancas: 0,
        duracaoHoras: 6,
      );

      expect(quantidade, 15);
    });

    test('cria item automático com custo estimado', () {
      final picanha = itemCatalogoPicanha;

      final item = service.criarItemAutomatico(
        item: picanha,
        eventoId: 'evento-1',
        quantidadeAdultos: 5,
        quantidadeCriancas: 0,
        duracaoHoras: 4,
      );

      expect(item.origemQuantidade, OrigemQuantidade.automatica);
      expect(item.quantidade, 0.6);
      expect(item.custoEstimadoCentavos, 3900);
    });
  });
}
