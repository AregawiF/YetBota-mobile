import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_readInitial(_prefs));

  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  void setMode(ThemeMode mode) {
    _prefs.setString(_key, mode.name);
    emit(mode);
  }

  static ThemeMode _readInitial(SharedPreferences prefs) {
    final raw = prefs.getString(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => ThemeMode.system,
    );
  }
}

