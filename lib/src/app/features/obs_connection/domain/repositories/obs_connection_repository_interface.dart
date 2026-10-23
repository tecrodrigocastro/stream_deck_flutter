import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IObsConnectionRepository {
  AsyncResult<ObsConnectionEntity> connect(ObsConnectionParams params);

  AsyncResult<Unit> disconnect();

  /// Emite quando uma conexão que estava aberta cai (OBS fechou, Wi-Fi caiu).
  /// Não emite quando o próprio app chama [disconnect].
  Stream<void> get connectionClosed;
}
