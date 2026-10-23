import 'package:base_clean_arch_bloc/src/app/features/scenes/data/models/scene_list_model.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';

class ObsScenesDatasource {
  static const Set<String> _sceneEvents = {
    'CurrentProgramSceneChanged',
    'SceneListChanged',
    'SceneCreated',
    'SceneRemoved',
    'SceneNameChanged',
  };

  final IObsRequester _requester;

  ObsScenesDatasource({required IObsRequester requester}) : _requester = requester;

  Stream<void> get sceneChanges {
    return _requester.events.where((event) => _sceneEvents.contains(event.type)).map((_) {});
  }

  Future<SceneListModel> getScenes() async {
    final data = await _requester.request('GetSceneList');
    return SceneListModel.fromMap(data);
  }

  Future<void> switchScene(String sceneName) async {
    await _requester.request('SetCurrentProgramScene', data: {'sceneName': sceneName});
  }
}
