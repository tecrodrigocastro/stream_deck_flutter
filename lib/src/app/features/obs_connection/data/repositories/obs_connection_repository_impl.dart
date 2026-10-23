import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_websocket_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:result_dart/result_dart.dart';

class ObsConnectionRepositoryImpl implements IObsConnectionRepository {
  final ObsWebSocketDatasource _datasource;

  ObsConnectionRepositoryImpl({required ObsWebSocketDatasource datasource}) : _datasource = datasource;

  @override
  Stream<void> get connectionClosed => _datasource.connectionClosed;

  @override
  AsyncResult<ObsConnectionEntity> connect(ObsConnectionParams params) async {
    try {
      final connection = await _datasource.connect(
        host: params.host.trim(),
        port: params.port,
        password: params.password,
      );
      return Success(connection);
    } on ObsAuthFailedException {
      return Failure(UnauthorizedException(message: 'Senha incorreta'));
    } on ObsAuthRequiredException {
      return Failure(UnauthorizedException(message: 'O OBS pede senha. Informe a senha do servidor'));
    } on TimeoutException {
      return const Failure(DefaultException(
        message: 'O OBS não respondeu. Confira o endereço e se o celular está no mesmo Wi-Fi do PC',
      ));
    } on ObsConnectionException catch (error) {
      return Failure(DefaultException(message: error.message));
    } catch (error, stackTrace) {
      return Failure(DefaultException(
        message: 'Não foi possível conectar. Confira o endereço, a porta e se o servidor WebSocket está ativo no OBS',
        data: error,
        stackTracing: stackTrace,
      ));
    }
  }

  @override
  AsyncResult<Unit> disconnect() async {
    try {
      await _datasource.disconnect();
      return const Success(unit);
    } catch (error, stackTrace) {
      return Failure(DefaultException(
        message: 'Não foi possível encerrar a conexão',
        data: error,
        stackTracing: stackTrace,
      ));
    }
  }
}
