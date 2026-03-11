import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../usecase/testing_usecase.dart';
import '../../../../core/common/models/success_response.dart';

abstract class TestingRepository {
  Future<Either<Failure, SuccessResponse?>> login(GetTestingParams params);
}
