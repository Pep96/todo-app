import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';
  late Box _box;

  ThemeCubit() : super(ThemeMode.system);

  Future<void> init() async {
    _box = Hive.box('settings');
    final stored = _box.get(_key, defaultValue: 'system') as String;
    emit(_modeFromString(stored));
  }

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _box.put(_key, next == ThemeMode.dark ? 'dark' : 'light');
    emit(next);
  }

  ThemeMode _modeFromString(String s) {
    if (s == 'dark') return ThemeMode.dark;
    if (s == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }
}
