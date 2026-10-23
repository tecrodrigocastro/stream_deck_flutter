import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/pages/connect_page.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => MaterialApp(theme: RedTheme.dark, home: const ConnectPage());

void main() {
  testWidgets('mostra título, porta padrão e status desconectado', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Conectar ao OBS'), findsOneWidget);
    expect(find.text('4455'), findsOneWidget);
    expect(find.text('Desconectado'), findsOneWidget);
  });

  testWidgets('mostra erros quando o endereço está vazio', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('Conectar'));
    await tester.pump();

    expect(find.text('Informe o endereço do PC'), findsOneWidget);
  });

  testWidgets('com dados válidos não mostra erros', (tester) async {
    await tester.pumpWidget(_app());

    await tester.enterText(find.byType(TextField).first, '192.168.0.12');
    await tester.tap(find.text('Conectar'));
    await tester.pump();

    expect(find.text('Informe o endereço do PC'), findsNothing);
    expect(find.text('Porta de 1 a 65535'), findsNothing);
  });
}
