import '../datasources/products_remote_data_source.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductResponseEntity> getProducts({int limit = 10, int skip = 0}) async {
    final responseData = await remoteDataSource.getProducts(limit: limit, skip: skip);
    return ProductResponse.fromJson(responseData);
  }
}
