import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/bloc/scenes_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/pages/scenes_page.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScenesBloc extends MockBloc<ScenesEvent, ScenesState> implements ScenesBloc {}

class FakeScenesEvent extends Fake implements ScenesEvent {}

void main() {
  late MockScenesBloc bloc;

  const list = SceneListEntity(
    scenes: [
      SceneEntity(name: 'Codando'),
      SceneEntity(name: 'Jogando'),
      SceneEntity(name: 'Encerramento'),
    ],
    currentSceneName: 'Codando',
  );

  setUpAll(() {
    registerFallbackValue(FakeScenesEvent());
  });

  setUp(() {
    bloc = MockScenesBloc();
    when(() => bloc.state).thenReturn(const ScenesLoaded(list));
  });

  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget app() {
    return BlocProvider<ScenesBloc>.value(
      value: bloc,
      child: MaterialApp(theme: RedTheme.dark, home: const Scaffold(body: ScenesPage())),
    );
  }

  testWidgets('pede a lista ao abrir', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    verify(() => bloc.add(const ScenesLoadRequested())).called(1);
  });

  testWidgets('mostra a cena no ar, a contagem e uma tecla por cena', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    expect(find.text('Na tela agora'), findsOneWidget);
    expect(find.text('3 cenas no OBS'), findsOneWidget);
    expect(find.byType(RedSceneKeyWidget), findsNWidgets(3));
  });

  testWidgets('tocar numa tecla pede a troca de cena', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    await tester.tap(find.text('Jogando'));

    verify(() => bloc.add(const ScenesSwitchRequested(sceneName: 'Jogando'))).called(1);
  });

  testWidgets('só a cena no ar fica marcada como ativa', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    final keys = tester.widgetList<RedSceneKeyWidget>(find.byType(RedSceneKeyWidget)).toList();

    expect(keys.where((key) => key.active).map((key) => key.label), ['Codando']);
  });

  testWidgets('mostra o erro e deixa tentar de novo quando a lista falha', (tester) async {
    useTallScreen(tester);
    when(() => bloc.state).thenReturn(const ScenesFailure(exception: DefaultException(message: 'Sem conexão com o OBS')));

    await tester.pumpWidget(app());
    expect(find.text('Sem conexão com o OBS'), findsOneWidget);

    await tester.tap(find.text('Tentar de novo'));
    verify(() => bloc.add(const ScenesLoadRequested())).called(2);
  });

  testWidgets('mostra a mensagem de erro de uma troca que falhou', (tester) async {
    useTallScreen(tester);
    whenListen(
      bloc,
      Stream<ScenesState>.fromIterable([const ScenesLoaded(list, errorMessage: 'No scene was found')]),
      initialState: const ScenesLoaded(list),
    );

    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.text('No scene was found'), findsOneWidget);
  });
}
