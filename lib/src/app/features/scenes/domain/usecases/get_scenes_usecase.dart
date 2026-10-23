import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/repositories/scenes_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class GetScenesUsecase implements UseCase<SceneListEntity, NoParams> {
  final IScenesRepository _repository;

  GetScenesUsecase({required IScenesRepository repository}) : _repository = repository;

  @override
  AsyncResult<SceneListEntity> call(NoParams params) => _repository.getScenes();
}
