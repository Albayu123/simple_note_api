import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ThemeMode get themeMode => themeModeNotifier.value;

  void toggleTheme(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;
    if (currentBrightness == Brightness.dark) {
      themeModeNotifier.value = ThemeMode.light;
    } else {
      themeModeNotifier.value = ThemeMode.dark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
}
