import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTheme {
  light,
  dark,
  gray,
  blue,
  green,
  red;

  String get name {
    switch (this) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.gray:
        return 'Gray';
      case AppTheme.blue:
        return 'Blue';
      case AppTheme.green:
        return 'Green';
      case AppTheme.red:
        return 'Red';
    }
  }

  IconData get icon {
    switch (this) {
      case AppTheme.light:
        return Icons.light_mode;
      case AppTheme.dark:
        return Icons.dark_mode;
      case AppTheme.gray:
        return Icons.invert_colors;
      case AppTheme.blue:
        return Icons.water_drop;
      case AppTheme.green:
        return Icons.eco;
      case AppTheme.red:
        return Icons.favorite;
    }
  }

  Color get seedColor {
    switch (this) {
      case AppTheme.light:
        return Colors.blue;
      case AppTheme.dark:
        return Colors.blue;
      case AppTheme.gray:
        return Colors.grey;
      case AppTheme.blue:
        return Colors.blue;
      case AppTheme.green:
        return Colors.green;
      case AppTheme.red:
        return Colors.red;
    }
  }

  bool get isDark {
    switch (this) {
      case AppTheme.dark:
      case AppTheme.gray:
        return true;
      default:
        return false;
    }
  }
}

// Events
abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;
  ThemeChanged(this.theme);
}

// State
class ThemeState {
  final AppTheme theme;
  ThemeState(this.theme);
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(AppTheme.light)) {
    on<ThemeChanged>((event, emit) {
      emit(ThemeState(event.theme));
    });
  }
}
