import 'package:base_clean_arch_bloc/src/app/features/design_system/presentation/pages/design_system_page.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('catálogo abre sem erros e mostra as seções', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(theme: RedTheme.dark, home: const DesignSystemPage()));

    expect(find.text('Design system'), findsOneWidget);
    expect(find.text('Cores'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
