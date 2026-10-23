import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';

class AudioInputModel extends AudioInputEntity {
  const AudioInputModel({required super.name, required super.muted, required super.volumeDb});

  /// Junta o nome (de `GetInputList`) com as respostas de `GetInputMute` e
  /// `GetInputVolume`.
  factory AudioInputModel.fromResponses({
    required String name,
    required Map<String, dynamic> mute,
    required Map<String, dynamic> volume,
  }) {
    return AudioInputModel(
      name: name,
      muted: mute['inputMuted'] as bool? ?? false,
      volumeDb: (volume['inputVolumeDb'] as num?)?.toDouble() ?? 0,
    );
  }
}
