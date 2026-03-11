import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final SettingsRepository settingsRepository;

  LogoutUseCase(this.settingsRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await settingsRepository.logout();
      return const Right(null);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }
}
