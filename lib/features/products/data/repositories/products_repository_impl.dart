import 'package:taghyeer_task/core/network/api_client.dart';
import 'package:taghyeer_task/features/products/domain/repositories/products_repository.dart';
import 'package:taghyeer_task/features/products/data/models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ApiClient apiClient;
  ProductsRepositoryImpl(this.apiClient);

  @override
  Future<ProductResponse> getProducts({int limit = 10, int skip = 0}) async {
    final response = await apiClient.get(
      api: '/products',
      params: {'limit': limit, 'skip': skip},
    );
    return ProductResponse.fromJson(response.data);
  }
}
