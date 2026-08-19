import 'package:app_churras/domain/entities/item_catalogo.dart';
import 'package:app_churras/domain/entities/item_evento.dart';

const itemCatalogoPicanha = ItemCatalogo(
  id: 'picanha',
  nome: 'Picanha',
  categoria: CategoriaItem.carnes,
  unidade: UnidadeItem.quilograma,
  precoUnitarioCentavos: 6500,
  quantidadePorAdulto: 0.12,
  quantidadePorCrianca: 0.06,
);

const itemCatalogoCerveja = ItemCatalogo(
  id: 'cerveja',
  nome: 'Cerveja',
  categoria: CategoriaItem.bebidas,
  unidade: UnidadeItem.lata,
  precoUnitarioCentavos: 450,
  quantidadePorAdulto: 3,
  quantidadePorCrianca: 0,
  aumentaComDuracao: true,
);

const itemCatalogoCarvao = ItemCatalogo(
  id: 'carvao',
  nome: 'Carvão',
  categoria: CategoriaItem.materiais,
  unidade: UnidadeItem.saco,
  precoUnitarioCentavos: 2500,
  quantidadePorAdulto: 0.10,
  quantidadePorCrianca: 0.05,
);

const catalogoItensTeste = <ItemCatalogo>[
  itemCatalogoPicanha,
  itemCatalogoCerveja,
  itemCatalogoCarvao,
];
