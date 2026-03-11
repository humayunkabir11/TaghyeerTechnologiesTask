
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<ProductResponseEntity> getProducts({int limit = 10, int skip = 0});
}
