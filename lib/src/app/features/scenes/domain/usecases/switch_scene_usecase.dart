import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/dtos/switch_scene_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/repositories/scenes_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class SwitchSceneUsecase implements UseCase<Unit, SwitchSceneParams> {
  final IScenesRepository _repository;

  SwitchSceneUsecase({required IScenesRepository repository}) : _repository = repository;

  @override
  AsyncResult<Unit> call(SwitchSceneParams params) => _repository.switchScene(params);
}
