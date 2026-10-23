import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/scenes/data/datasources/obs_scenes_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/data/repositories/scenes_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/dtos/switch_scene_params.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRequester implements IObsRequester {
  final calls = <(String, Map<String, dynamic>?)>[];
  final eventController = StreamController<ObsEvent>.broadcast();
  Object? error;
  Map<String, dynamic> response = {};

  @override
  Stream<ObsEvent> get events => eventController.stream;

  @override
  Future<Map<String, dynamic>> request(String type, {Map<String, dynamic>? data}) async {
    calls.add((type, data));
    if (error != null) throw error!;
    return response;
  }
}

void main() {
  late FakeRequester requester;
  late ScenesRepositoryImpl repository;

  setUp(() {
    requester = FakeRequester();
    repository = ScenesRepositoryImpl(datasource: ObsScenesDatasource(requester: requester));
  });

  test('getScenes pede GetSceneList e devolve a lista', () async {
    requester.response = {
      'currentProgramSceneName': 'Codando',
      'scenes': [
        {'sceneName': 'Codando', 'sceneIndex': 0},
      ],
    };

    final list = (await repository.getScenes()).getOrNull()!;

    expect(requester.calls.single.$1, 'GetSceneList');
    expect(list.currentSceneName, 'Codando');
    expect(list.scenes.single.name, 'Codando');
  });

  test('getScenes devolve a mensagem do OBS quando ele recusa', () async {
    requester.error = const ObsRequestException(message: 'Sem conexão com o OBS', code: 600);

    final exception = (await repository.getScenes()).exceptionOrNull();

    expect(exception, isA<DefaultException>());
    expect((exception! as DefaultException).message, 'Sem conexão com o OBS');
  });

  test('getScenes com resposta fora do formato vira DefaultException genérica', () async {
    requester.response = {'scenes': 'não é lista'};

    final exception = (await repository.getScenes()).exceptionOrNull();

    expect(exception, isA<DefaultException>());
  });

  test('switchScene manda SetCurrentProgramScene com o nome', () async {
    final result = await repository.switchScene(SwitchSceneParams(sceneName: 'Jogando'));

    expect(result.isSuccess(), isTrue);
    expect(requester.calls.single.$1, 'SetCurrentProgramScene');
    expect(requester.calls.single.$2, {'sceneName': 'Jogando'});
  });

  test('switchScene devolve Failure quando o OBS recusa', () async {
    requester.error = const ObsRequestException(message: 'No scene was found');

    final result = await repository.switchScene(SwitchSceneParams(sceneName: 'x'));

    expect(result.isError(), isTrue);
  });

  test('sceneChanges só emite para eventos de cena', () async {
    var changes = 0;
    final subscription = repository.sceneChanges.listen((_) => changes++);

    requester.eventController
      ..add(const ObsEvent(type: 'CurrentProgramSceneChanged'))
      ..add(const ObsEvent(type: 'SceneListChanged'))
      ..add(const ObsEvent(type: 'InputMuteStateChanged'));
    await pumpEventQueue();
    await subscription.cancel();

    expect(changes, 2);
  });
}
