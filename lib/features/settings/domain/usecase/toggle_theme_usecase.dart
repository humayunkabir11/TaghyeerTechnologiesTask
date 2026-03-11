import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

class ToggleThemeUseCase implements UseCase<void, bool> {
  final SettingsRepository settingsRepository;

  ToggleThemeUseCase(this.settingsRepository);

  @override
  Future<Either<Failure, void>> call(bool isDarkMode) async {
    try {
      await settingsRepository.saveThemeMode(isDarkMode);
      return const Right(null);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }
}
