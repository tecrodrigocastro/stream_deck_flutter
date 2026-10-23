import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/repositories/scenes_repository_interface.dart';

class ObserveSceneChangesUsecase {
  final IScenesRepository _repository;

  ObserveSceneChangesUsecase({required IScenesRepository repository}) : _repository = repository;

  Stream<void> call() => _repository.sceneChanges;
}
