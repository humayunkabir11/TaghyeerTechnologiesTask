import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taghyeer_task/features/login/data/models/user_model.dart';

class HiveService extends GetxService {
  static const String _userBoxName = 'userBox';
  static const String _settingsBoxName = 'settingsBox';
  static const String _userKey = 'user';
  static const String _themeKey = 'isDarkMode';

  /// Initialize Hive and open boxes
  Future<HiveService> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_userBoxName);
    await Hive.openBox(_settingsBoxName);
    return this;
  }

  /// Save user data
  Future<void> saveUser(UserModel user) async {
    final box = Hive.box(_userBoxName);
    await box.put(_userKey, user.toJson());
  }

  /// Get user data
  UserModel? getUser() {
    final box = Hive.box(_userBoxName);
    final data = box.get(_userKey);
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// Clear user data
  Future<void> clearUser() async {
    final box = Hive.box(_userBoxName);
    await box.delete(_userKey);
    // Also clear settings if needed, or keep them
  }

  /// Save theme mode
  Future<void> saveThemeMode(bool isDarkMode) async {
    final box = Hive.box(_settingsBoxName);
    await box.put(_themeKey, isDarkMode);
  }

  /// Get theme mode
  bool isDarkMode() {
    final box = Hive.box(_settingsBoxName);
    return box.get(_themeKey, defaultValue: false);
  }
}
