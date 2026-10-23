import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/dtos/switch_scene_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IScenesRepository {
  AsyncResult<SceneListEntity> getScenes();

  AsyncResult<Unit> switchScene(SwitchSceneParams params);

  /// Emite quando algo mudou nas cenas do OBS (cena no ar, criada, removida,
  /// renomeada, reordenada). Quem ouve busca a lista de novo.
  Stream<void> get sceneChanges;
}
