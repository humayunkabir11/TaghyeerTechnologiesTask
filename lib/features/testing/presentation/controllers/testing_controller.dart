import 'package:get/get.dart';
import '../../domain/usecase/testing_usecase.dart';

class TestingController extends GetxController {
  final TestingUseCase? testingUseCase;
  TestingController({this.testingUseCase});
}