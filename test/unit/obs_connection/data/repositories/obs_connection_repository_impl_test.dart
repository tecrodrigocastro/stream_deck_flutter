import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_websocket_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/models/obs_connection_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/repositories/obs_connection_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockObsWebSocketDatasource extends Mock implements ObsWebSocketDatasource {}

void main() {
  late MockObsWebSocketDatasource datasource;
  late ObsConnectionRepositoryImpl repository;
  final params = ObsConnectionParams(host: ' 192.168.0.12 ', port: 4455, password: 'senha');

  setUp(() {
    datasource = MockObsWebSocketDatasource();
    repository = ObsConnectionRepositoryImpl(datasource: datasource);
  });

  test('devolve Success e limpa os espaços do endereço', () async {
    const model = ObsConnectionModel(host: '192.168.0.12', port: 4455, obsVersion: '5.5.4', rpcVersion: 1);
    when(() => datasource.connect(host: '192.168.0.12', port: 4455, password: 'senha')).thenAnswer((_) async => model);

    final result = await repository.connect(params);

    expect(result.getOrNull(), model);
  });

  Future<Object?> failureOf(Object error) async {
    when(() => datasource.connect(
          host: any(named: 'host'),
          port: any(named: 'port'),
          password: any(named: 'password'),
        )).thenThrow(error);

    final result = await repository.connect(params);
    return result.exceptionOrNull();
  }

  test('senha errada vira UnauthorizedException', () async {
    final exception = await failureOf(const ObsAuthFailedException());

    expect(exception, isA<UnauthorizedException>());
  });

  test('senha ausente vira UnauthorizedException', () async {
    final exception = await failureOf(const ObsAuthRequiredException());

    expect(exception, isA<UnauthorizedException>());
  });

  test('timeout vira DefaultException com mensagem sobre o Wi-Fi', () async {
    final exception = await failureOf(TimeoutException('x'));

    expect(exception, isA<DefaultException>());
    expect((exception as DefaultException).message, contains('Wi-Fi'));
  });

  test('erro de conexão mantém a mensagem do datasource', () async {
    final exception = await failureOf(const ObsConnectionException('O OBS encerrou a conexão'));

    expect((exception as DefaultException).message, 'O OBS encerrou a conexão');
  });

  test('erro inesperado vira DefaultException genérica', () async {
    final exception = await failureOf(StateError('boom'));

    expect(exception, isA<DefaultException>());
  });

  test('disconnect devolve Success', () async {
    when(() => datasource.disconnect()).thenAnswer((_) async {});

    final result = await repository.disconnect();

    expect(result.isSuccess(), isTrue);
  });
}
