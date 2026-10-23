import 'dart:ui';

import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rect = Rect.fromLTWH(0, 0, 100, 24);

  test('a borda direita é inclinada: embaixo a forma é mais curta que em cima', () {
    final path = const RedTagBorder().getOuterPath(rect);

    expect(path.contains(const Offset(1, 12)), isTrue);
    expect(path.contains(const Offset(99, 1)), isTrue);
    expect(path.contains(const Offset(99, 23)), isFalse);
  });

  test('igualdade considera a inclinação', () {
    expect(const RedTagBorder(), const RedTagBorder());
    expect(const RedTagBorder(), isNot(const RedTagBorder(slant: 4)));
  });
}
