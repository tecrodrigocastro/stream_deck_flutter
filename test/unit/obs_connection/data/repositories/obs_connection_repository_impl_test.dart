import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_connection_local_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_websocket_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/models/obs_connection_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/repositories/obs_connection_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/not_found_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockObsWebSocketDatasource extends Mock implements ObsWebSocketDatasource {}

class MockObsConnectionLocalDatasource extends Mock implements ObsConnectionLocalDatasource {}

void main() {
  late MockObsWebSocketDatasource datasource;
  late MockObsConnectionLocalDatasource local;
  late ObsConnectionRepositoryImpl repository;
  final params = ObsConnectionParams(host: ' 192.168.0.12 ', port: 4455, password: 'senha');

  setUp(() {
    datasource = MockObsWebSocketDatasource();
    local = MockObsConnectionLocalDatasource();
    repository = ObsConnectionRepositoryImpl(datasource: datasource, local: local);
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

  group('conexão guardada', () {
    test('sem nada guardado devolve NotFoundException', () async {
      when(() => local.read()).thenAnswer((_) async => null);

      final result = await repository.getSavedConnection();

      expect(result.exceptionOrNull(), isA<NotFoundException>());
    });

    test('lê endereço, porta, senha e conexão automática', () async {
      when(() => local.read()).thenAnswer(
        (_) async => {'host': '192.168.0.12', 'port': 4455, 'password': 'senha', 'autoConnect': true},
      );

      final saved = (await repository.getSavedConnection()).getOrNull()!;

      expect(saved.host, '192.168.0.12');
      expect(saved.port, 4455);
      expect(saved.password, 'senha');
      expect(saved.autoConnect, isTrue);
    });

    test('saveConnection grava com a conexão automática ligada', () async {
      when(() => local.write(
            host: any(named: 'host'),
            port: any(named: 'port'),
            password: any(named: 'password'),
            autoConnect: any(named: 'autoConnect'),
          )).thenAnswer((_) async {});

      final result = await repository.saveConnection(params);

      expect(result.isSuccess(), isTrue);
      verify(() => local.write(host: '192.168.0.12', port: 4455, password: 'senha', autoConnect: true)).called(1);
    });

    test('disableAutoConnect mantém os dados e desliga só a conexão automática', () async {
      when(() => local.read()).thenAnswer(
        (_) async => {'host': '192.168.0.12', 'port': 4455, 'password': 'senha', 'autoConnect': true},
      );
      when(() => local.write(
            host: any(named: 'host'),
            port: any(named: 'port'),
            password: any(named: 'password'),
            autoConnect: any(named: 'autoConnect'),
          )).thenAnswer((_) async {});

      await repository.disableAutoConnect();

      verify(() => local.write(host: '192.168.0.12', port: 4455, password: 'senha', autoConnect: false)).called(1);
    });

    test('disableAutoConnect sem nada guardado não grava', () async {
      when(() => local.read()).thenAnswer((_) async => null);

      final result = await repository.disableAutoConnect();

      expect(result.isSuccess(), isTrue);
      verifyNever(() => local.write(
            host: any(named: 'host'),
            port: any(named: 'port'),
            password: any(named: 'password'),
            autoConnect: any(named: 'autoConnect'),
          ));
    });
  });
}
