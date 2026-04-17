import 'package:mobile_arquitetura_02/core/errors/failure.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/models/product_model.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  Product _toEntity(dynamic m) {
    return Product(
      id: m.id,
      title: m.title,
      price: m.price,
      image: m.image,
      description: m.description,
      isFavorited: m.isFavorited,
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final remoteModels = await remote.getProducts();
      final cachedModels = cache.get() ?? [];

      final favoritesById = {for (final c in cachedModels) c.id: c.isFavorited};

      final merged = remoteModels
          .map((m) => m.copyWith(isFavorited: favoritesById[m.id] ?? false))
          .toList();

      cache.save(merged);

      return merged.map(_toEntity).toList();
    } catch (_) {
      final cached = cache.get();
      final cachedEntities = cached?.map(_toEntity).toList();

      if (cachedEntities != null && cachedEntities.isNotEmpty) {
        throw OfflineFailure(
          "Falha na conexão com a API. Exibindo dados locais.",
          cachedData: cachedEntities,
        );
      }
      throw Failure(
          "Não foi possível carregar os produtos. Verifique sua conexão e tente novamente.");
    }
  }

  @override
  Future<Product> toggleFavorite(int productId) {
    final cached = cache.get();

    if (cached == null || cached.isEmpty) {
      return Future.error(Failure("Nenhum produto em cache para favoritar"));
    }

    final index = cached.indexWhere((p) => p.id == productId);

    if (index == -1) {
      return Future.error(Failure("Produto não encontrado: $productId"));
    }

    final current = cached[index];
    final updated = current.copyWith(isFavorited: !current.isFavorited);

    final updatedList = List.of(cached);
    updatedList[index] = updated;

    cache.save(updatedList);

    return Future.value(_toEntity(updated));
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final addedModel = await remote.addProduct(model);
      
      // Update cache
      final cached = cache.get() ?? [];
      final updatedList = List<ProductModel>.from(cached)..add(addedModel);
      cache.save(updatedList);

      return _toEntity(addedModel);
    } catch (_) {
      throw Failure("Erro ao cadastrar produto na API.");
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final updatedModel = await remote.updateProduct(model);

      // Update cache
      final cached = cache.get() ?? [];
      final index = cached.indexWhere((p) => p.id == updatedModel.id);
      if (index != -1) {
        final updatedList = List<ProductModel>.from(cached);
        updatedList[index] = updatedModel;
        cache.save(updatedList);
      }

      return _toEntity(updatedModel);
    } catch (_) {
      throw Failure("Erro ao atualizar produto.");
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remote.deleteProduct(id);

      // Update cache
      final cached = cache.get() ?? [];
      final updatedList = cached.where((p) => p.id != id).toList();
      cache.save(updatedList);
    } catch (_) {
      throw Failure("Erro ao excluir produto.");
    }
  }
}
