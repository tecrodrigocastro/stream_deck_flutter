import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/pages/audio_page.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioBloc extends MockBloc<AudioEvent, AudioState> implements AudioBloc {}

class FakeAudioEvent extends Fake implements AudioEvent {}

void main() {
  late MockAudioBloc bloc;

  const loaded = AudioLoaded(
    inputs: [
      AudioInputEntity(name: 'Microfone', muted: false, volumeDb: 0),
      AudioInputEntity(name: 'Mac', muted: true, volumeDb: -12),
    ],
    levels: {'Microfone': 0.5},
  );

  setUpAll(() {
    registerFallbackValue(FakeAudioEvent());
  });

  setUp(() {
    bloc = MockAudioBloc();
    when(() => bloc.state).thenReturn(loaded);
  });

  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget app() {
    return BlocProvider<AudioBloc>.value(
      value: bloc,
      child: MaterialApp(theme: RedTheme.dark, home: const Scaffold(body: AudioPage())),
    );
  }

  testWidgets('pede as fontes ao abrir', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    verify(() => bloc.add(const AudioLoadRequested())).called(1);
  });

  testWidgets('mostra uma fonte por fader, com dB e "Mudo"', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    expect(find.byType(RedAudioFaderWidget), findsNWidgets(2));
    expect(find.text('0,0 dB'), findsOneWidget);
    expect(find.text('Mudo'), findsOneWidget);
  });

  testWidgets('tocar no ícone pede o mute daquela fonte', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    await tester.tap(find.byType(RedIconButtonWidget).first);

    verify(() => bloc.add(const AudioMuteToggled(inputName: 'Microfone'))).called(1);
  });

  testWidgets('arrastar o controle pede a mudança de volume', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    await tester.drag(find.byType(Slider).first, const Offset(-100, 0));
    await tester.pump();

    final events = verify(() => bloc.add(captureAny(that: isA<AudioVolumeChanged>()))).captured;
    expect(events, isNotEmpty);
    expect((events.last as AudioVolumeChanged).inputName, 'Microfone');
    expect((events.last as AudioVolumeChanged).volumeDb, lessThan(0));
  });

  testWidgets('sem fontes mostra um aviso', (tester) async {
    useTallScreen(tester);
    when(() => bloc.state).thenReturn(const AudioLoaded(inputs: []));

    await tester.pumpWidget(app());

    expect(find.text('O OBS não tem nenhuma fonte de áudio.'), findsOneWidget);
  });

  testWidgets('erro de leitura mostra a mensagem e deixa tentar de novo', (tester) async {
    useTallScreen(tester);
    when(() => bloc.state).thenReturn(const AudioFailure(exception: DefaultException(message: 'Sem conexão com o OBS')));

    await tester.pumpWidget(app());
    await tester.tap(find.text('Tentar de novo'));

    expect(find.text('Sem conexão com o OBS'), findsOneWidget);
    verify(() => bloc.add(const AudioLoadRequested())).called(2);
  });
}
