import 'dart:math';

import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RedColors', () {
    test('texto branco sobre o vermelho ao vivo passa de 4,5:1', () {
      double lum(Color c) {
        double ch(double v) => v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
        return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
      }

      final a = lum(RedColors.onLive);
      final b = lum(RedColors.live);
      expect((a + 0.05) / (b + 0.05), greaterThan(4.5));
    });
  });

  group('RedSpacing', () {
    test('espaçamentos são múltiplos de 4', () {
      for (final v in [
        RedSpacing.xs,
        RedSpacing.sm,
        RedSpacing.md,
        RedSpacing.lg,
        RedSpacing.xl,
        RedSpacing.xxl,
        RedSpacing.screenMargin,
        RedSpacing.keyGap,
      ]) {
        expect(v % 4, 0);
      }
    });

    test('alvos de toque respeitam o mínimo de 44', () {
      expect(RedSizes.keyHeight, greaterThanOrEqualTo(RedSizes.minTouch));
      expect(RedSizes.primaryButtonHeight, greaterThanOrEqualTo(RedSizes.minTouch));
      expect(RedSizes.secondaryButtonHeight, greaterThanOrEqualTo(RedSizes.minTouch));
    });
  });

  group('RedTypography', () {
    test('títulos usam Chakra Petch e o corpo usa Barlow', () {
      expect(RedTypography.screenTitle.fontFamily, RedTypography.displayFamily);
      expect(RedTypography.body.fontFamily, RedTypography.bodyFamily);
    });
  });
}
