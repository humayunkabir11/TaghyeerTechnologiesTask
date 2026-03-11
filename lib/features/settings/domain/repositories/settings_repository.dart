
import '../../../login/domain/entities/user_entity.dart';

abstract class SettingsRepository {
  Future<void> logout();
  Future<void> saveThemeMode(bool isDarkMode);
  bool isDarkMode();
  UserEntity? getUser();
}
