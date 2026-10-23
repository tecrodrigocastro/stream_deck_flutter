import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/saved_obs_connection_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IObsConnectionRepository {
  AsyncResult<ObsConnectionEntity> connect(ObsConnectionParams params);

  AsyncResult<Unit> disconnect();

  /// Falha com `NotFoundException` quando nenhuma conexão foi guardada.
  AsyncResult<SavedObsConnectionEntity> getSavedConnection();

  /// Guarda a conexão e liga a conexão automática.
  AsyncResult<Unit> saveConnection(ObsConnectionParams params);

  /// Mantém endereço, porta e senha guardados, mas o app deixa de conectar sozinho.
  AsyncResult<Unit> disableAutoConnect();

  /// Emite quando uma conexão que estava aberta cai (OBS fechou, Wi-Fi caiu).
  /// Não emite quando o próprio app chama [disconnect].
  Stream<void> get connectionClosed;
}
