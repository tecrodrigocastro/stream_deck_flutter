import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: RedTheme.dark,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('RedSceneKeyWidget', () {
    testWidgets('mostra o rótulo e dispara o toque', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(
        RedSceneKeyWidget(label: 'Só código', icon: RedIcon.code, onPressed: () => taps++),
      ));

      expect(find.text('Só código'), findsOneWidget);
      await tester.tap(find.text('Só código'));
      expect(taps, 1);
    });

    testWidgets('rótulo de duas linhas cabe sem estourar', (tester) async {
      await tester.pumpWidget(_wrap(
        const SizedBox(
          width: 150,
          child: RedSceneKeyWidget(
            label: 'Jogo com câmera grande',
            icon: RedIcon.gamepad,
            onPressed: null,
          ),
        ),
      ));

      expect(tester.takeException(), isNull);
    });
  });

  group('RedPrimaryButtonWidget', () {
    testWidgets('não dispara quando está desabilitado', (tester) async {
      await tester.pumpWidget(_wrap(const RedPrimaryButtonWidget(label: 'Iniciar', onPressed: null)));

      await tester.tap(find.text('Iniciar'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('dispara o toque quando habilitado', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(RedPrimaryButtonWidget(label: 'Iniciar', onPressed: () => taps++)));

      await tester.tap(find.text('Iniciar'));
      expect(taps, 1);
    });
  });

  group('RedSwitchWidget', () {
    testWidgets('inverte o valor ao tocar', (tester) async {
      bool? received;
      await tester.pumpWidget(_wrap(
        RedSwitchWidget(value: false, semanticLabel: 'Auto', onChanged: (v) => received = v),
      ));

      await tester.tap(find.byType(RedSwitchWidget));
      expect(received, isTrue);
    });
  });

  group('RedSegmentedWidget', () {
    testWidgets('informa o segmento escolhido', (tester) async {
      String? chosen;
      await tester.pumpWidget(_wrap(
        RedSegmentedWidget<String>(
          segments: const [
            RedSegment(value: 'a', label: 'Cenas'),
            RedSegment(value: 'b', label: 'Fontes'),
          ],
          selected: 'a',
          onChanged: (v) => chosen = v,
        ),
      ));

      await tester.tap(find.text('Fontes'));
      expect(chosen, 'b');
    });
  });

  group('RedProgressBarWidget', () {
    testWidgets('limita valores fora de 0 a 1', (tester) async {
      await tester.pumpWidget(_wrap(const RedProgressBarWidget(value: 3)));

      final box = tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox));
      expect(box.widthFactor, 1);
    });
  });

  group('RedAudioFaderWidget', () {
    testWidgets('mostra dB quando ativo e "Mudo" quando mutado', (tester) async {
      await tester.pumpWidget(_wrap(
        RedAudioFaderWidget(
          name: 'Microfone',
          icon: RedIcon.mic,
          volume: 0.5,
          volumeLabel: '-6,0 dB',
          onVolumeChanged: (_) {},
          onMutePressed: () {},
        ),
      ));
      expect(find.text('-6,0 dB'), findsOneWidget);

      await tester.pumpWidget(_wrap(
        RedAudioFaderWidget(
          name: 'Microfone',
          icon: RedIcon.mic,
          volume: 0.5,
          volumeLabel: '-6,0 dB',
          muted: true,
          onVolumeChanged: (_) {},
          onMutePressed: () {},
        ),
      ));
      expect(find.text('Mudo'), findsOneWidget);
      expect(find.text('-6,0 dB'), findsNothing);
    });
  });

  group('RedNavBarWidget', () {
    testWidgets('informa o índice tocado', (tester) async {
      int? tapped;
      await tester.pumpWidget(_wrap(
        RedNavBarWidget(
          currentIndex: 0,
          onTap: (i) => tapped = i,
          items: const [
            RedNavItem(icon: RedIcon.grid, label: 'Cenas'),
            RedNavItem(icon: RedIcon.sliders, label: 'Áudio'),
          ],
        ),
      ));

      await tester.tap(find.text('Áudio'));
      expect(tapped, 1);
    });
  });

  group('Selos e etiquetas', () {
    testWidgets('renderizam seus textos', (tester) async {
      await tester.pumpWidget(_wrap(
        const Column(
          children: [
            RedLiveBadgeWidget(),
            RedStatusDotWidget(status: RedStatus.connected, label: 'OBS conectado'),
            RedTagWidget(label: 'Flutter'),
          ],
        ),
      ));

      expect(find.text('Ao vivo'), findsOneWidget);
      expect(find.text('OBS conectado'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
    });
  });

  testWidgets('RedTextFieldWidget mostra rótulo e erro', (tester) async {
    await tester.pumpWidget(_wrap(
      RedTextFieldWidget(label: 'Endereço', controller: TextEditingController(), errorText: 'Inválido'),
    ));

    expect(find.text('Endereço'), findsOneWidget);
    expect(find.text('Inválido'), findsOneWidget);
  });
}
