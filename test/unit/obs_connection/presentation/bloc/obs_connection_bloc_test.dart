import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/connect_obs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/saved_obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/disconnect_obs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/get_saved_obs_connection_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/observe_obs_connection_closed_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/not_found_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockObsConnectionRepository extends Mock implements IObsConnectionRepository {}

void main() {
  late MockObsConnectionRepository repository;
  late StreamController<void> closed;
  final params = ObsConnectionParams(host: '192.168.0.12', port: 4455);
  const connection = ObsConnectionEntity(host: '192.168.0.12', port: 4455, obsVersion: '5.5.4', rpcVersion: 1);
  const failure = DefaultException(message: 'sem resposta');
  const saved = SavedObsConnectionEntity(host: '192.168.0.12', port: 4455, password: 'senha', autoConnect: true);
  const savedManual = SavedObsConnectionEntity(host: '192.168.0.12', port: 4455, password: 'senha', autoConnect: false);

  setUpAll(() {
    registerFallbackValue(ObsConnectionParams.empty());
  });

  setUp(() {
    repository = MockObsConnectionRepository();
    closed = StreamController<void>.broadcast();
    when(() => repository.connectionClosed).thenAnswer((_) => closed.stream);
    when(() => repository.disconnect()).thenAnswer((_) async => const Success<Unit, Exception>(unit));
    when(() => repository.saveConnection(any())).thenAnswer((_) async => const Success<Unit, Exception>(unit));
    when(() => repository.disableAutoConnect()).thenAnswer((_) async => const Success<Unit, Exception>(unit));
    when(() => repository.getSavedConnection()).thenAnswer(
      (_) async => Failure<SavedObsConnectionEntity, Exception>(NotFoundException(message: 'nada guardado')),
    );
  });

  tearDown(() => closed.close());

  ObsConnectionBloc build() {
    return ObsConnectionBloc(
      connectUsecase: ConnectObsUsecase(repository: repository),
      disconnectUsecase: DisconnectObsUsecase(repository: repository),
      getSavedUsecase: GetSavedObsConnectionUsecase(repository: repository),
      observeClosedUsecase: ObserveObsConnectionClosedUsecase(repository: repository),
    );
  }

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'conectou: Loading e depois Success',
    build: () {
      when(() => repository.connect(any())).thenAnswer((_) async => const Success<ObsConnectionEntity, Exception>(connection));
      return build();
    },
    act: (bloc) => bloc.add(ObsConnectRequested(params: params)),
    expect: () => [isA<ObsConnectionLoading>(), const ObsConnectionSuccess(connection)],
  );

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'falhou: Loading e depois Failure com a exceção',
    build: () {
      when(() => repository.connect(any())).thenAnswer((_) async => const Failure<ObsConnectionEntity, Exception>(failure));
      return build();
    },
    act: (bloc) => bloc.add(ObsConnectRequested(params: params)),
    expect: () => [isA<ObsConnectionLoading>(), const ObsConnectionFailure(exception: failure)],
  );

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'ignora um segundo pedido enquanto conecta',
    build: () {
      when(() => repository.connect(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return const Success<ObsConnectionEntity, Exception>(connection);
      });
      return build();
    },
    act: (bloc) {
      bloc
        ..add(ObsConnectRequested(params: params))
        ..add(ObsConnectRequested(params: params));
    },
    wait: const Duration(milliseconds: 50),
    verify: (_) => verify(() => repository.connect(any())).called(1),
  );

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'desconectar volta ao estado inicial',
    build: build,
    act: (bloc) => bloc.add(const ObsDisconnectRequested()),
    expect: () => [isA<ObsConnectionInitial>()],
    verify: (_) {
      verify(() => repository.disconnect()).called(1);
      verify(() => repository.disableAutoConnect()).called(1);
    },
  );

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'conectou: guarda a conexão para a próxima abertura',
    build: () {
      when(() => repository.connect(any())).thenAnswer((_) async => const Success<ObsConnectionEntity, Exception>(connection));
      return build();
    },
    act: (bloc) => bloc.add(ObsConnectRequested(params: params)),
    verify: (_) => verify(() => repository.saveConnection(params)).called(1),
  );

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'falhou: não guarda nada',
    build: () {
      when(() => repository.connect(any())).thenAnswer((_) async => const Failure<ObsConnectionEntity, Exception>(failure));
      return build();
    },
    act: (bloc) => bloc.add(ObsConnectRequested(params: params)),
    verify: (_) => verifyNever(() => repository.saveConnection(any())),
  );

  group('ObsStarted', () {
    blocTest<ObsConnectionBloc, ObsConnectionState>(
      'sem conexão guardada não emite nada',
      build: build,
      act: (bloc) => bloc.add(const ObsStarted()),
      expect: () => <ObsConnectionState>[],
    );

    blocTest<ObsConnectionBloc, ObsConnectionState>(
      'com conexão automática ligada: preenche e conecta sozinho',
      build: () {
        when(() => repository.getSavedConnection()).thenAnswer((_) async => const Success<SavedObsConnectionEntity, Exception>(saved));
        when(() => repository.connect(any())).thenAnswer((_) async => const Success<ObsConnectionEntity, Exception>(connection));
        return build();
      },
      act: (bloc) => bloc.add(const ObsStarted()),
      expect: () => [
        const ObsSavedConnectionLoaded(saved),
        isA<ObsConnectionLoading>(),
        const ObsConnectionSuccess(connection),
      ],
      verify: (_) => verify(
        () => repository.connect(ObsConnectionParams(host: '192.168.0.12', port: 4455, password: 'senha')),
      ).called(1),
    );

    blocTest<ObsConnectionBloc, ObsConnectionState>(
      'com conexão automática desligada: só preenche os campos',
      build: () {
        when(() => repository.getSavedConnection()).thenAnswer((_) async => const Success<SavedObsConnectionEntity, Exception>(savedManual));
        return build();
      },
      act: (bloc) => bloc.add(const ObsStarted()),
      expect: () => [const ObsSavedConnectionLoaded(savedManual)],
      verify: (_) => verifyNever(() => repository.connect(any())),
    );

    blocTest<ObsConnectionBloc, ObsConnectionState>(
      'a conexão automática vale uma vez por abertura do app',
      build: () {
        when(() => repository.getSavedConnection()).thenAnswer((_) async => const Success<SavedObsConnectionEntity, Exception>(saved));
        when(() => repository.connect(any())).thenAnswer((_) async => const Failure<ObsConnectionEntity, Exception>(failure));
        return build();
      },
      act: (bloc) async {
        bloc.add(const ObsStarted());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(const ObsStarted());
      },
      wait: const Duration(milliseconds: 40),
      verify: (_) => verify(() => repository.connect(any())).called(1),
    );
  });

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'conexão que cai depois de conectada vira Closed',
    build: () {
      when(() => repository.connect(any())).thenAnswer((_) async => const Success<ObsConnectionEntity, Exception>(connection));
      return build();
    },
    act: (bloc) async {
      bloc.add(ObsConnectRequested(params: params));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      closed.add(null);
    },
    wait: const Duration(milliseconds: 30),
    expect: () => [
      isA<ObsConnectionLoading>(),
      const ObsConnectionSuccess(connection),
      isA<ObsConnectionClosed>(),
    ],
  );

  blocTest<ObsConnectionBloc, ObsConnectionState>(
    'aviso de queda sem conexão aberta é ignorado',
    build: build,
    act: (bloc) => closed.add(null),
    wait: const Duration(milliseconds: 20),
    expect: () => <ObsConnectionState>[],
  );
}
