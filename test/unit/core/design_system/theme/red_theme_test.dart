import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RedTheme.dark usa as cores e a fonte da marca', () {
    final theme = RedTheme.dark;

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, RedColors.ink);
    expect(theme.colorScheme.primary, RedColors.live);
    expect(theme.colorScheme.onPrimary, RedColors.onLive);
    expect(theme.textTheme.bodyMedium?.fontFamily, RedTypography.bodyFamily);
  });
}
