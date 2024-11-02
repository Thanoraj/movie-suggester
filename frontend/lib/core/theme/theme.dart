import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_palette.dart';

class AppTheme {
  static OutlineInputBorder _inputBorderDecoration({Color? color}) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color ?? AppPalette.borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _inputBorderDecoration(),
      focusedBorder: _inputBorderDecoration(color: AppPalette.gradient2),
      errorBorder: _inputBorderDecoration(color: AppPalette.errorColor),
      focusedErrorBorder: _inputBorderDecoration(color: AppPalette.errorColor),
    ),
  );
}
