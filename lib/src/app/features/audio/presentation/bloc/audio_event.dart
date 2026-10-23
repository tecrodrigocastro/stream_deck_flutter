part of 'audio_bloc.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class AudioLoadRequested extends AudioEvent {
  const AudioLoadRequested();
}

class AudioMuteToggled extends AudioEvent {
  final String inputName;

  const AudioMuteToggled({required this.inputName});

  @override
  List<Object> get props => [inputName];
}

class AudioVolumeChanged extends AudioEvent {
  final String inputName;
  final double volumeDb;

  const AudioVolumeChanged({required this.inputName, required this.volumeDb});

  @override
  List<Object> get props => [inputName, volumeDb];
}

/// Disparado pelo próprio bloc com o que o OBS avisou.
class AudioUpdated extends AudioEvent {
  final AudioUpdate update;

  const AudioUpdated(this.update);

  @override
  List<Object> get props => [update];
}
