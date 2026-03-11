import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase implements UseCase<ProductResponseEntity, GetProductsParams> {
  final ProductsRepository productsRepository;

  GetProductsUseCase(this.productsRepository);

  @override
  Future<Either<Failure, ProductResponseEntity>> call(GetProductsParams params) async {
    try {
      final productsResponse = await productsRepository.getProducts(
        limit: params.limit,
        skip: params.skip,
      );
      return Right(productsResponse);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }
}

class GetProductsParams {
  final int limit;
  final int skip;

  GetProductsParams({this.limit = 10, this.skip = 0});
}
