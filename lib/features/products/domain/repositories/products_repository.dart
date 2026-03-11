
import 'package:taghyeer_task/features/products/data/models/product_model.dart';

abstract class ProductsRepository {
  Future<ProductResponse> getProducts({int limit = 10, int skip = 0});
}
