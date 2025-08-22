import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.light));

  void toggleTheme() {
    emit(
      ThemeState(
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
