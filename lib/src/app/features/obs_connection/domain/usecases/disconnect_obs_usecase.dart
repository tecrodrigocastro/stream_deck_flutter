import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class DisconnectObsUsecase implements UseCase<Unit, NoParams> {
  final IObsConnectionRepository _repository;

  DisconnectObsUsecase({required IObsConnectionRepository repository}) : _repository = repository;

  @override
  AsyncResult<Unit> call(NoParams params) => _repository.disconnect();
}
