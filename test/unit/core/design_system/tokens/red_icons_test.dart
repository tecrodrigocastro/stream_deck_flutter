import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RedIcons', () {
    test('todo ícone tem ao menos uma camada desenhável', () {
      for (final icon in RedIcon.values) {
        expect(RedIcons.layersOf(icon), isNotEmpty, reason: icon.name);
      }
    });

    test('todo ícone tem rótulo e uso descritos', () {
      for (final icon in RedIcon.values) {
        expect(icon.label, isNotEmpty, reason: icon.name);
        expect(icon.usage, isNotEmpty, reason: icon.name);
      }
    });

    test('reaproveita as camadas em chamadas seguidas', () {
      expect(identical(RedIcons.layersOf(RedIcon.mic), RedIcons.layersOf(RedIcon.mic)), isTrue);
    });
  });
}
