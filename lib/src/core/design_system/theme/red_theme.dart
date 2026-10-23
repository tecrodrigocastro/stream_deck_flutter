import 'package:base_clean_arch_bloc/src/core/design_system/shapes/red_shapes.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:flutter/material.dart';

/// Tema escuro do app. Os widgets `Red*Widget` não dependem dele para ficar
/// certos; o tema existe para que os widgets padrão do Material (AppBar,
/// SnackBar, botões, Slider...) combinem com o resto.
class RedTheme {
  const RedTheme._();

  static const ColorScheme _colorScheme = ColorScheme.dark(
    primary: RedColors.live,
    onPrimary: RedColors.onLive,
    secondary: RedColors.pink,
    onSecondary: RedColors.ink,
    surface: RedColors.panel,
    onSurface: RedColors.mist,
    error: RedColors.pink,
    onError: RedColors.ink,
    outline: RedColors.outline,
    outlineVariant: RedColors.line,
  );

  static const TextTheme _textTheme = TextTheme(
    displaySmall: RedTypography.timer,
    headlineMedium: RedTypography.screenTitle,
    titleLarge: RedTypography.sectionTitle,
    titleMedium: RedTypography.cardTitle,
    bodyLarge: RedTypography.body,
    bodyMedium: RedTypography.body,
    bodySmall: RedTypography.caption,
    labelLarge: RedTypography.button,
    labelMedium: RedTypography.label,
    labelSmall: RedTypography.caption,
  );

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorScheme,
      primaryColor: RedColors.live,
      scaffoldBackgroundColor: RedColors.ink,
      canvasColor: RedColors.ink,
      fontFamily: RedTypography.bodyFamily,
      textTheme: _textTheme.apply(
        bodyColor: RedColors.mist,
        displayColor: RedColors.mist,
      ),
      iconTheme: const IconThemeData(color: RedColors.mist),
      dividerTheme: const DividerThemeData(color: RedColors.line, space: 1, thickness: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: RedColors.bar,
        selectedItemColor: RedColors.pink,
        unselectedItemColor: RedColors.steel,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RedColors.live,
          foregroundColor: RedColors.onLive,
          minimumSize: const Size(RedSizes.minTouch, RedSizes.primaryButtonHeight),
          shape: RedShapes.cut,
          textStyle: RedTypography.button,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: RedColors.live,
          foregroundColor: RedColors.onLive,
          minimumSize: const Size(RedSizes.minTouch, RedSizes.primaryButtonHeight),
          shape: RedShapes.cut,
          textStyle: RedTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: RedColors.mist,
          minimumSize: const Size(RedSizes.minTouch, RedSizes.secondaryButtonHeight),
          shape: RedShapes.square,
          side: const BorderSide(color: RedColors.outline, width: RedSizes.outlineWidth),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: RedColors.pink,
          minimumSize: const Size(RedSizes.minTouch, RedSizes.minTouch),
        ),
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: RedSizes.progressHeight,
        activeTrackColor: RedColors.pink,
        inactiveTrackColor: RedColors.track,
        thumbColor: RedColors.mist,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: RedColors.pink,
        linearTrackColor: RedColors.line,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: RedColors.key,
        contentTextStyle: RedTypography.body,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
