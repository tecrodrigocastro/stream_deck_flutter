import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/dtos/switch_scene_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/repositories/scenes_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/get_scenes_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/observe_scene_changes_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/switch_scene_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/bloc/scenes_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockScenesRepository extends Mock implements IScenesRepository {}

void main() {
  late MockScenesRepository repository;
  late StreamController<void> changes;

  const codando = SceneEntity(name: 'Codando');
  const jogando = SceneEntity(name: 'Jogando');
  const noCodando = SceneListEntity(scenes: [codando, jogando], currentSceneName: 'Codando');
  const noJogando = SceneListEntity(scenes: [codando, jogando], currentSceneName: 'Jogando');
  const failure = DefaultException(message: 'Sem conexão com o OBS');

  setUpAll(() {
    registerFallbackValue(SwitchSceneParams.empty());
  });

  setUp(() {
    repository = MockScenesRepository();
    changes = StreamController<void>.broadcast();
    when(() => repository.sceneChanges).thenAnswer((_) => changes.stream);
  });

  tearDown(() => changes.close());

  ScenesBloc build() {
    return ScenesBloc(
      getScenesUsecase: GetScenesUsecase(repository: repository),
      switchSceneUsecase: SwitchSceneUsecase(repository: repository),
      observeChangesUsecase: ObserveSceneChangesUsecase(repository: repository),
    );
  }

  void stubGet(SceneListEntity list) {
    when(() => repository.getScenes()).thenAnswer((_) async => Success<SceneListEntity, Exception>(list));
  }

  blocTest<ScenesBloc, ScenesState>(
    'carrega as cenas: Loading e depois Loaded',
    build: () {
      stubGet(noCodando);
      return build();
    },
    act: (bloc) => bloc.add(const ScenesLoadRequested()),
    expect: () => [isA<ScenesLoading>(), const ScenesLoaded(noCodando)],
  );

  blocTest<ScenesBloc, ScenesState>(
    'falha ao carregar: Failure com a exceção',
    build: () {
      when(() => repository.getScenes()).thenAnswer((_) async => const Failure<SceneListEntity, Exception>(failure));
      return build();
    },
    act: (bloc) => bloc.add(const ScenesLoadRequested()),
    expect: () => [isA<ScenesLoading>(), const ScenesFailure(exception: failure)],
  );

  blocTest<ScenesBloc, ScenesState>(
    'trocar de cena manda o pedido e recarrega a lista',
    build: () {
      var calls = 0;
      when(() => repository.getScenes()).thenAnswer((_) async {
        calls++;
        return Success<SceneListEntity, Exception>(calls == 1 ? noCodando : noJogando);
      });
      when(() => repository.switchScene(any())).thenAnswer((_) async => const Success<Unit, Exception>(unit));
      return build();
    },
    act: (bloc) async {
      bloc.add(const ScenesLoadRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const ScenesSwitchRequested(sceneName: 'Jogando'));
    },
    wait: const Duration(milliseconds: 30),
    expect: () => [isA<ScenesLoading>(), const ScenesLoaded(noCodando), const ScenesLoaded(noJogando)],
    verify: (_) => verify(() => repository.switchScene(SwitchSceneParams(sceneName: 'Jogando'))).called(1),
  );

  blocTest<ScenesBloc, ScenesState>(
    'trocar para a cena que já está no ar não faz nada',
    build: () {
      stubGet(noCodando);
      return build();
    },
    act: (bloc) async {
      bloc.add(const ScenesLoadRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const ScenesSwitchRequested(sceneName: 'Codando'));
    },
    wait: const Duration(milliseconds: 30),
    verify: (_) => verifyNever(() => repository.switchScene(any())),
  );

  blocTest<ScenesBloc, ScenesState>(
    'erro ao trocar mantém a lista e leva a mensagem',
    build: () {
      stubGet(noCodando);
      when(() => repository.switchScene(any())).thenAnswer((_) async => const Failure<Unit, Exception>(failure));
      return build();
    },
    act: (bloc) async {
      bloc.add(const ScenesLoadRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const ScenesSwitchRequested(sceneName: 'Jogando'));
    },
    wait: const Duration(milliseconds: 30),
    expect: () => [
      isA<ScenesLoading>(),
      const ScenesLoaded(noCodando),
      const ScenesLoaded(noCodando, errorMessage: 'Sem conexão com o OBS'),
    ],
  );

  blocTest<ScenesBloc, ScenesState>(
    'evento do OBS recarrega a lista de quem já a tem',
    build: () {
      var calls = 0;
      when(() => repository.getScenes()).thenAnswer((_) async {
        calls++;
        return Success<SceneListEntity, Exception>(calls == 1 ? noCodando : noJogando);
      });
      return build();
    },
    act: (bloc) async {
      bloc.add(const ScenesLoadRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      changes.add(null);
    },
    wait: const Duration(milliseconds: 30),
    expect: () => [isA<ScenesLoading>(), const ScenesLoaded(noCodando), const ScenesLoaded(noJogando)],
  );

  blocTest<ScenesBloc, ScenesState>(
    'evento do OBS sem lista carregada é ignorado',
    build: build,
    act: (bloc) => changes.add(null),
    wait: const Duration(milliseconds: 20),
    expect: () => <ScenesState>[],
    verify: (_) => verifyNever(() => repository.getScenes()),
  );
}
