import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/audio/data/datasources/audio_input_kinds.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/data/datasources/obs_audio_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Handler = Map<String, dynamic> Function(String type, Map<String, dynamic>? data);

class FakeRequester implements IObsRequester {
  FakeRequester(this.handler);

  Handler handler;
  final calls = <(String, Map<String, dynamic>?)>[];
  final eventController = StreamController<ObsEvent>.broadcast();

  @override
  Stream<ObsEvent> get events => eventController.stream;

  @override
  Future<Map<String, dynamic>> request(String type, {Map<String, dynamic>? data}) async {
    calls.add((type, data));
    return handler(type, data);
  }
}

void main() {
  group('AudioInputKinds', () {
    test('reconhece fontes que têm áudio', () {
      for (final kind in [
        'wasapi_input_capture',
        'wasapi_output_capture',
        'coreaudio_input_capture',
        'pulse_input_capture',
        'dshow_input',
        'av_capture_input_v2',
        'ffmpeg_source',
        'browser_source',
      ]) {
        expect(AudioInputKinds.hasAudio(kind), isTrue, reason: kind);
      }
    });

    test('ignora fontes sem áudio', () {
      for (final kind in ['image_source', 'text_gdiplus_v3', 'monitor_capture', 'window_capture', 'color_source_v3']) {
        expect(AudioInputKinds.hasAudio(kind), isFalse, reason: kind);
      }
    });
  });

  group('getInputs', () {
    test('lista só as fontes de áudio, com mute e volume', () async {
      final requester = FakeRequester((type, data) {
        switch (type) {
          case 'GetInputList':
            return {
              'inputs': [
                {'inputName': 'Microfone', 'inputKind': 'wasapi_input_capture'},
                {'inputName': 'Logo', 'inputKind': 'image_source'},
                {'inputName': 'PS5', 'inputKind': 'dshow_input'},
              ],
            };
          case 'GetInputMute':
            return {'inputMuted': data!['inputName'] == 'PS5'};
          case 'GetInputVolume':
            return {'inputVolumeMul': 0.5, 'inputVolumeDb': data!['inputName'] == 'PS5' ? -6 : 0.0};
        }
        return {};
      });

      final inputs = await ObsAudioDatasource(requester: requester).getInputs();

      expect(inputs.map((i) => i.name), ['Microfone', 'PS5']);
      expect(inputs[0].muted, isFalse);
      expect(inputs[0].volumeDb, 0);
      expect(inputs[1].muted, isTrue);
      expect(inputs[1].volumeDb, -6);
    });

    test('pula a fonte que sumiu entre a listagem e a leitura', () async {
      final requester = FakeRequester((type, data) {
        if (type == 'GetInputList') {
          return {
            'inputs': [
              {'inputName': 'A', 'inputKind': 'wasapi_input_capture'},
              {'inputName': 'B', 'inputKind': 'wasapi_input_capture'},
            ],
          };
        }
        if (data!['inputName'] == 'B') throw const ObsRequestException(message: 'não existe', code: 600);
        return {'inputMuted': false, 'inputVolumeDb': -3.0};
      });

      final inputs = await ObsAudioDatasource(requester: requester).getInputs();

      expect(inputs.map((i) => i.name), ['A']);
    });
  });

  group('pedidos', () {
    late FakeRequester requester;
    late ObsAudioDatasource datasource;

    setUp(() {
      requester = FakeRequester((type, data) => {});
      datasource = ObsAudioDatasource(requester: requester);
    });

    test('setMute manda SetInputMute', () async {
      await datasource.setMute('Mac', true);

      expect(requester.calls.single.$1, 'SetInputMute');
      expect(requester.calls.single.$2, {'inputName': 'Mac', 'inputMuted': true});
    });

    test('setVolume manda SetInputVolume em dB', () async {
      await datasource.setVolume('Mac', -12.5);

      expect(requester.calls.single.$1, 'SetInputVolume');
      expect(requester.calls.single.$2, {'inputName': 'Mac', 'inputVolumeDb': -12.5});
    });
  });

  group('updates', () {
    late FakeRequester requester;

    setUp(() {
      requester = FakeRequester((type, data) => {});
    });

    Future<List<AudioUpdate>> collect(ObsAudioDatasource datasource, List<ObsEvent> events) async {
      final updates = <AudioUpdate>[];
      final subscription = datasource.updates.listen(updates.add);
      await pumpEventQueue();
      events.forEach(requester.eventController.add);
      await pumpEventQueue();
      await subscription.cancel();
      return updates;
    }

    test('traduz mute, volume e mudanças na lista de fontes', () async {
      final updates = await collect(ObsAudioDatasource(requester: requester), const [
        ObsEvent(type: 'InputMuteStateChanged', data: {'inputName': 'Mac', 'inputMuted': true}),
        ObsEvent(type: 'InputVolumeChanged', data: {'inputName': 'Mac', 'inputVolumeMul': 0.5, 'inputVolumeDb': -6.0}),
        ObsEvent(type: 'InputCreated'),
        ObsEvent(type: 'InputRemoved'),
        ObsEvent(type: 'InputNameChanged'),
        ObsEvent(type: 'CurrentProgramSceneChanged'),
      ]);

      expect(updates, [
        const AudioMuteUpdate(inputName: 'Mac', muted: true),
        const AudioVolumeUpdate(inputName: 'Mac', volumeDb: -6),
        const AudioInputsChanged(),
        const AudioInputsChanged(),
        const AudioInputsChanged(),
      ]);
    });

    test('converte o pico dos medidores para 0 a 1 em dB', () async {
      final updates = await collect(ObsAudioDatasource(requester: requester), const [
        ObsEvent(type: 'InputVolumeMeters', data: {
          'inputs': [
            {
              'inputName': 'Cheio',
              'inputLevelsMul': [
                [0.5, 1.0, 1.0],
                [0.1, 0.5, 0.5],
              ],
            },
            {
              'inputName': 'Meio',
              'inputLevelsMul': [
                [0.05, 0.1, 0.1],
              ],
            },
            {
              'inputName': 'Silencio',
              'inputLevelsMul': [
                [0.0, 0.0, 0.0],
              ],
            },
          ],
        }),
      ]);

      final levels = (updates.single as AudioLevelsUpdate).levels;
      expect(levels['Cheio'], 1.0);
      expect(levels['Meio'], closeTo(2 / 3, 0.001));
      expect(levels['Silencio'], 0.0);
    });

    test('limita a frequência dos medidores', () async {
      const meters = ObsEvent(type: 'InputVolumeMeters', data: {'inputs': <dynamic>[]});

      final throttled = await collect(
        ObsAudioDatasource(requester: requester, meterInterval: const Duration(hours: 1)),
        const [meters, meters, meters],
      );
      final unthrottled = await collect(
        ObsAudioDatasource(requester: requester, meterInterval: Duration.zero),
        const [meters, meters, meters],
      );

      expect(throttled, hasLength(1));
      expect(unthrottled, hasLength(3));
    });
  });
}
