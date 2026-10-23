import 'package:base_clean_arch_bloc/src/app/features/scenes/data/datasources/obs_scenes_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/dtos/switch_scene_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/repositories/scenes_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';
import 'package:result_dart/result_dart.dart';

class ScenesRepositoryImpl implements IScenesRepository {
  final ObsScenesDatasource _datasource;

  ScenesRepositoryImpl({required ObsScenesDatasource datasource}) : _datasource = datasource;

  @override
  Stream<void> get sceneChanges => _datasource.sceneChanges;

  @override
  AsyncResult<SceneListEntity> getScenes() async {
    try {
      return Success(await _datasource.getScenes());
    } on ObsRequestException catch (error) {
      return Failure(DefaultException(message: error.message, statusCode: error.code));
    } catch (error, stackTrace) {
      return Failure(DefaultException(
        message: 'Não foi possível ler as cenas do OBS',
        data: error,
        stackTracing: stackTrace,
      ));
    }
  }

  @override
  AsyncResult<Unit> switchScene(SwitchSceneParams params) async {
    try {
      await _datasource.switchScene(params.sceneName);
      return const Success(unit);
    } on ObsRequestException catch (error) {
      return Failure(DefaultException(message: error.message, statusCode: error.code));
    } catch (error, stackTrace) {
      return Failure(DefaultException(
        message: 'Não foi possível trocar de cena',
        data: error,
        stackTracing: stackTrace,
      ));
    }
  }
}
