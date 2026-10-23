import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/saved_obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class GetSavedObsConnectionUsecase implements UseCase<SavedObsConnectionEntity, NoParams> {
  final IObsConnectionRepository _repository;

  GetSavedObsConnectionUsecase({required IObsConnectionRepository repository}) : _repository = repository;

  @override
  AsyncResult<SavedObsConnectionEntity> call(NoParams params) => _repository.getSavedConnection();
}
