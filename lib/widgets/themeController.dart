part of '../quote.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode') ?? 'system';

    themeMode.value = _themeModeFromString(mode);
    Get.changeThemeMode(themeMode.value);
  }

  void setTheme(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_mode', mode.toString());
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
