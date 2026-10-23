import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';

class ObserveObsConnectionClosedUsecase {
  final IObsConnectionRepository _repository;

  ObserveObsConnectionClosedUsecase({required IObsConnectionRepository repository}) : _repository = repository;

  Stream<void> call() => _repository.connectionClosed;
}
