import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/widgets/audio_icon_resolver.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/widgets/audio_volume_scale.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AudioVolumeScale', () {
    test('0 dB fica na ponta direita e -60 dB na esquerda', () {
      expect(AudioVolumeScale.dbToSlider(0), 1);
      expect(AudioVolumeScale.dbToSlider(-60), 0);
      expect(AudioVolumeScale.dbToSlider(-30), 0.5);
    });

    test('fora da faixa fica nas pontas', () {
      expect(AudioVolumeScale.dbToSlider(12), 1);
      expect(AudioVolumeScale.dbToSlider(-100), 0);
    });

    test('ida e volta', () {
      expect(AudioVolumeScale.sliderToDb(1), 0);
      expect(AudioVolumeScale.sliderToDb(0.5), -30);
    });

    test('controle todo à esquerda vira silêncio do OBS', () {
      expect(AudioVolumeScale.sliderToDb(0), AudioVolumeScale.silenceDb);
    });

    test('arredonda para um décimo de dB', () {
      expect(AudioVolumeScale.sliderToDb(0.123456), -52.6);
    });

    test('formata com vírgula', () {
      expect(AudioVolumeScale.format(-6), '-6,0 dB');
      expect(AudioVolumeScale.format(0), '0,0 dB');
      expect(AudioVolumeScale.format(-0.04), '0,0 dB');
      expect(AudioVolumeScale.format(-18.25), '-18,3 dB');
      expect(AudioVolumeScale.format(-100), '-∞ dB');
    });
  });

  group('AudioIconResolver', () {
    test('escolhe pelo nome da fonte', () {
      expect(AudioIconResolver.iconFor('Microfone', muted: false), RedIcon.mic);
      expect(AudioIconResolver.iconFor('PS5', muted: false), RedIcon.gamepad);
      expect(AudioIconResolver.iconFor('Música e alertas', muted: false), RedIcon.speaker);
    });

    test('o Mac troca de ícone quando está mudo', () {
      expect(AudioIconResolver.iconFor('Mac', muted: false), RedIcon.dualScreen);
      expect(AudioIconResolver.iconFor('Mac', muted: true), RedIcon.macMuted);
    });
  });
}
