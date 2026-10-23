import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/connect_obs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/saved_obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/disconnect_obs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/get_saved_obs_connection_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/observe_obs_connection_closed_usecase.dart';
import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'obs_connection_event.dart';
part 'obs_connection_state.dart';

class ObsConnectionBloc extends Bloc<ObsConnectionEvent, ObsConnectionState> {
  final ConnectObsUsecase _connectUsecase;
  final DisconnectObsUsecase _disconnectUsecase;
  final GetSavedObsConnectionUsecase _getSavedUsecase;
  StreamSubscription<void>? _closedSubscription;

  /// A conexão automática vale uma vez por abertura do app. Se o OBS cair
  /// depois, o usuário decide quando reconectar.
  bool _autoConnectAttempted = false;

  ObsConnectionBloc({
    required ConnectObsUsecase connectUsecase,
    required DisconnectObsUsecase disconnectUsecase,
    required GetSavedObsConnectionUsecase getSavedUsecase,
    required ObserveObsConnectionClosedUsecase observeClosedUsecase,
  })  : _connectUsecase = connectUsecase,
        _disconnectUsecase = disconnectUsecase,
        _getSavedUsecase = getSavedUsecase,
        super(ObsConnectionInitial()) {
    on<ObsStarted>((event, emit) async {
      if (state is ObsConnectionLoading || state is ObsConnectionSuccess) return;

      final saved = (await _getSavedUsecase(NoParams())).getOrNull();
      if (saved == null) return;

      emit(ObsSavedConnectionLoaded(saved));

      if (saved.autoConnect && !_autoConnectAttempted) {
        _autoConnectAttempted = true;
        await _connect(
          ObsConnectionParams(host: saved.host, port: saved.port, password: saved.password),
          emit,
        );
      }
    });

    on<ObsConnectRequested>((event, emit) => _connect(event.params, emit));

    on<ObsDisconnectRequested>((event, emit) async {
      await _disconnectUsecase(NoParams());
      emit(ObsConnectionInitial());
    });

    on<ObsConnectionDropped>((event, emit) {
      if (state is ObsConnectionSuccess) emit(ObsConnectionClosed());
    });

    _closedSubscription = observeClosedUsecase().listen((_) => add(const ObsConnectionDropped()));
  }

  Future<void> _connect(ObsConnectionParams params, Emitter<ObsConnectionState> emit) async {
    if (state is ObsConnectionLoading) return;

    emit(ObsConnectionLoading());

    final result = await _connectUsecase(params);
    emit(result.fold(
      ObsConnectionSuccess.new,
      (exception) => ObsConnectionFailure(exception: exception as BaseException),
    ));
  }

  @override
  Future<void> close() async {
    await _closedSubscription?.cancel();
    return super.close();
  }
}
