import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

/// Desconexão pedida pelo usuário: além de fechar o WebSocket, desliga a
/// conexão automática (quem sai de propósito não quer voltar conectado).
class DisconnectObsUsecase implements UseCase<Unit, NoParams> {
  final IObsConnectionRepository _repository;

  DisconnectObsUsecase({required IObsConnectionRepository repository}) : _repository = repository;

  @override
  AsyncResult<Unit> call(NoParams params) async {
    final result = await _repository.disconnect();
    await _repository.disableAutoConnect();
    return result;
  }
}
