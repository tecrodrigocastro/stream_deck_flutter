import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class ConnectObsUsecase implements UseCase<ObsConnectionEntity, ObsConnectionParams> {
  final IObsConnectionRepository _repository;

  ConnectObsUsecase({required IObsConnectionRepository repository}) : _repository = repository;

  @override
  AsyncResult<ObsConnectionEntity> call(ObsConnectionParams params) async {
    final result = await _repository.connect(params);

    // Conectou: guarda para reconectar sozinho na próxima abertura do app.
    // Se não conseguir guardar, a conexão que já está aberta segue valendo.
    if (result.isSuccess()) {
      await _repository.saveConnection(params);
    }

    return result;
  }
}
