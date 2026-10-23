import 'dart:math' as math;

import 'package:base_clean_arch_bloc/src/app/features/audio/data/datasources/audio_input_kinds.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/data/models/audio_input_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';

class ObsAudioDatasource {
  ObsAudioDatasource({
    required IObsRequester requester,
    this.meterInterval = const Duration(milliseconds: 100),
  }) : _requester = requester;

  /// O OBS manda os medidores umas 50 vezes por segundo. A tela não precisa
  /// disso: repassamos no máximo um a cada [meterInterval].
  final Duration meterInterval;

  final IObsRequester _requester;
  DateTime? _lastMeter;

  Future<List<AudioInputModel>> getInputs() async {
    final list = await _requester.request('GetInputList');
    final raw = (list['inputs'] as List<dynamic>? ?? const <dynamic>[]).cast<Map<String, dynamic>>();

    final audioNames = [
      for (final input in raw)
        if (AudioInputKinds.hasAudio(input['inputKind'] as String? ?? '')) input['inputName'] as String,
    ];

    final inputs = await Future.wait(audioNames.map(_readInput));
    return [
      for (final input in inputs)
        if (input != null) input,
    ];
  }

  /// `null` quando a fonte sumiu entre a listagem e a leitura.
  Future<AudioInputModel?> _readInput(String name) async {
    try {
      final data = {'inputName': name};
      final responses = await Future.wait([
        _requester.request('GetInputMute', data: data),
        _requester.request('GetInputVolume', data: data),
      ]);
      return AudioInputModel.fromResponses(name: name, mute: responses[0], volume: responses[1]);
    } on ObsRequestException {
      return null;
    }
  }

  Future<void> setMute(String inputName, bool muted) async {
    await _requester.request('SetInputMute', data: {'inputName': inputName, 'inputMuted': muted});
  }

  Future<void> setVolume(String inputName, double volumeDb) async {
    await _requester.request('SetInputVolume', data: {'inputName': inputName, 'inputVolumeDb': volumeDb});
  }

  Stream<AudioUpdate> get updates async* {
    await for (final event in _requester.events) {
      final update = _toUpdate(event);
      if (update != null) yield update;
    }
  }

  AudioUpdate? _toUpdate(ObsEvent event) {
    final data = event.data;

    switch (event.type) {
      case 'InputMuteStateChanged':
        return AudioMuteUpdate(
          inputName: data['inputName'] as String,
          muted: data['inputMuted'] as bool,
        );
      case 'InputVolumeChanged':
        return AudioVolumeUpdate(
          inputName: data['inputName'] as String,
          volumeDb: (data['inputVolumeDb'] as num).toDouble(),
        );
      case 'InputCreated' || 'InputRemoved' || 'InputNameChanged':
        return const AudioInputsChanged();
      case 'InputVolumeMeters':
        return _meters(data);
    }
    return null;
  }

  AudioUpdate? _meters(Map<String, dynamic> data) {
    final now = DateTime.now();
    final last = _lastMeter;
    if (last != null && now.difference(last) < meterInterval) return null;
    _lastMeter = now;

    final inputs = (data['inputs'] as List<dynamic>? ?? const <dynamic>[]).cast<Map<String, dynamic>>();
    return AudioLevelsUpdate({
      for (final input in inputs) input['inputName'] as String: _level(input['inputLevelsMul'] as List<dynamic>? ?? const []),
    });
  }

  /// Pico mais alto entre os canais, em escala de 0 a 1 (-60 dB a 0 dB).
  static double _level(List<dynamic> channels) {
    var peak = 0.0;
    for (final channel in channels) {
      final values = (channel as List<dynamic>).cast<num>();
      if (values.length > 1) peak = math.max(peak, values[1].toDouble());
    }
    if (peak <= 0) return 0;

    final db = 20 * math.log(peak) / math.ln10;
    return ((db + 60) / 60).clamp(0.0, 1.0);
  }
}
