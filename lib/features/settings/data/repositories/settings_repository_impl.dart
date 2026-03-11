
import '../../../../core/services/hive_service.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final HiveService hiveService;

  SettingsRepositoryImpl(this.hiveService);

  @override
  Future<void> logout() async {
    await hiveService.clearUser();
  }

  @override
  Future<void> saveThemeMode(bool isDarkMode) async {
    await hiveService.saveThemeMode(isDarkMode);
  }

  @override
  bool isDarkMode() {
    return hiveService.isDarkMode();
  }

  @override
  UserEntity? getUser() {
    return hiveService.getUser();
  }
}
