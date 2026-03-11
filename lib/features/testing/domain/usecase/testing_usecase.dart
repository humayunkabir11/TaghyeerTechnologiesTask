import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/testing_repository.dart';
import '../../data/models/testing_response.dart';


class TestingUseCase implements UseCase<TestingResponse, GetTestingParams> {
  final TestingRepository? testingRepository;
  TestingUseCase({this.testingRepository});
  @override
  Future<Either<Failure, TestingResponse>> call(GetTestingParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

}

class GetTestingParams{
  final String? path;
  final Map<String, dynamic>? query;
  final Map<String, dynamic>? body;

  GetTestingParams({
    this.path,
    this.query,
    this.body,
  });
}