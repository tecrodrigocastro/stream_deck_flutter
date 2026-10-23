import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_mute_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_volume_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/get_audio_inputs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/observe_audio_updates_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/set_input_mute_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/set_input_volume_usecase.dart';
import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  /// Depois de o usuário mexer no volume de uma fonte, avisos do OBS sobre o
  /// volume dela são ignorados por este tempo: costumam ser ecos de valores
  /// antigos e fariam o controle "pular" para trás durante o arrasto.
  static const Duration _echoWindow = Duration(milliseconds: 500);

  final GetAudioInputsUsecase _getInputsUsecase;
  final SetInputMuteUsecase _setMuteUsecase;
  final SetInputVolumeUsecase _setVolumeUsecase;
  final DateTime Function() _now;
  StreamSubscription<AudioUpdate>? _updatesSubscription;

  final Map<String, double> _pendingVolume = {};
  final Set<String> _sendingVolume = {};
  final Map<String, DateTime> _lastLocalVolumeChange = {};

  AudioBloc({
    required GetAudioInputsUsecase getInputsUsecase,
    required SetInputMuteUsecase setMuteUsecase,
    required SetInputVolumeUsecase setVolumeUsecase,
    required ObserveAudioUpdatesUsecase observeUpdatesUsecase,
    DateTime Function() now = DateTime.now,
  })  : _getInputsUsecase = getInputsUsecase,
        _setMuteUsecase = setMuteUsecase,
        _setVolumeUsecase = setVolumeUsecase,
        _now = now,
        super(AudioInitial()) {
    on<AudioLoadRequested>((event, emit) async {
      emit(AudioLoading());
      await _load(emit);
    });

    on<AudioMuteToggled>(_onMuteToggled);
    on<AudioVolumeChanged>(_onVolumeChanged);
    on<AudioUpdated>(_onUpdated);

    _updatesSubscription = observeUpdatesUsecase().listen((update) => add(AudioUpdated(update)));
  }

  Future<void> _load(Emitter<AudioState> emit) async {
    final previous = state;
    final levels = previous is AudioLoaded ? previous.levels : const <String, double>{};

    final result = await _getInputsUsecase(NoParams());
    emit(result.fold(
      (inputs) => AudioLoaded(inputs: inputs, levels: levels),
      (exception) => AudioFailure(exception: exception as BaseException),
    ));
  }

  Future<void> _onMuteToggled(AudioMuteToggled event, Emitter<AudioState> emit) async {
    final current = state;
    if (current is! AudioLoaded) return;

    final input = current.inputs.where((i) => i.name == event.inputName).firstOrNull;
    if (input == null) return;

    final muted = !input.muted;
    emit(current.copyWith(inputs: _replace(current.inputs, input.copyWith(muted: muted))));

    final result = await _setMuteUsecase(SetInputMuteParams(inputName: input.name, muted: muted));
    if (result.isError()) {
      // Desfaz o que a tela já mostrou.
      final latest = state;
      if (latest is AudioLoaded) {
        emit(AudioLoaded(
          inputs: _replace(latest.inputs, input.copyWith(muted: input.muted)),
          levels: latest.levels,
          errorMessage: (result.exceptionOrNull()! as BaseException).message,
        ));
      }
    }
  }

  Future<void> _onVolumeChanged(AudioVolumeChanged event, Emitter<AudioState> emit) async {
    final current = state;
    if (current is! AudioLoaded) return;

    final input = current.inputs.where((i) => i.name == event.inputName).firstOrNull;
    if (input == null) return;

    emit(current.copyWith(inputs: _replace(current.inputs, input.copyWith(volumeDb: event.volumeDb))));

    _lastLocalVolumeChange[input.name] = _now();
    _pendingVolume[input.name] = event.volumeDb;
    if (!_sendingVolume.add(input.name)) return;

    // Arrastar o controle gera dezenas de valores por segundo. Mandamos um
    // pedido por vez e, quando ele volta, só o valor mais recente.
    try {
      String? errorMessage;
      while (_pendingVolume.containsKey(input.name)) {
        final volumeDb = _pendingVolume.remove(input.name)!;
        final result = await _setVolumeUsecase(SetInputVolumeParams(inputName: input.name, volumeDb: volumeDb));
        if (result.isError()) {
          errorMessage = (result.exceptionOrNull()! as BaseException).message;
          _pendingVolume.remove(input.name);
        }
      }

      if (errorMessage != null) {
        final latest = state;
        if (latest is AudioLoaded) {
          emit(AudioLoaded(inputs: latest.inputs, levels: latest.levels, errorMessage: errorMessage));
        }
      }
    } finally {
      _sendingVolume.remove(input.name);
    }
  }

  Future<void> _onUpdated(AudioUpdated event, Emitter<AudioState> emit) async {
    final current = state;
    if (current is! AudioLoaded) return;

    switch (event.update) {
      case AudioLevelsUpdate(:final levels):
        emit(current.copyWith(levels: levels));
      case AudioMuteUpdate(:final inputName, :final muted):
        final input = current.inputs.where((i) => i.name == inputName).firstOrNull;
        if (input != null) emit(current.copyWith(inputs: _replace(current.inputs, input.copyWith(muted: muted))));
      case AudioVolumeUpdate(:final inputName, :final volumeDb):
        if (_isEcho(inputName)) return;
        final input = current.inputs.where((i) => i.name == inputName).firstOrNull;
        if (input != null) emit(current.copyWith(inputs: _replace(current.inputs, input.copyWith(volumeDb: volumeDb))));
      case AudioInputsChanged():
        await _load(emit);
    }
  }

  bool _isEcho(String inputName) {
    final last = _lastLocalVolumeChange[inputName];
    return _sendingVolume.contains(inputName) || (last != null && _now().difference(last) < _echoWindow);
  }

  List<AudioInputEntity> _replace(List<AudioInputEntity> inputs, AudioInputEntity updated) {
    return [for (final input in inputs) input.name == updated.name ? updated : input];
  }

  @override
  Future<void> close() async {
    await _updatesSubscription?.cancel();
    return super.close();
  }
}
