import 'package:equatable/equatable.dart';

/// Uma fonte de áudio do OBS (microfone, captura do PS5, música...).
class AudioInputEntity extends Equatable {
  final String name;
  final bool muted;

  /// Volume em dB, como o OBS usa (0 = ganho original, -100 = silêncio).
  final double volumeDb;

  const AudioInputEntity({required this.name, required this.muted, required this.volumeDb});

  AudioInputEntity copyWith({bool? muted, double? volumeDb}) {
    return AudioInputEntity(
      name: name,
      muted: muted ?? this.muted,
      volumeDb: volumeDb ?? this.volumeDb,
    );
  }

  @override
  List<Object> get props => [name, muted, volumeDb];
}
