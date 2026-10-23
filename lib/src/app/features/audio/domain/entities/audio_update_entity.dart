import 'package:equatable/equatable.dart';

/// Mudança de áudio que o OBS avisou por conta própria.
sealed class AudioUpdate extends Equatable {
  const AudioUpdate();

  @override
  List<Object> get props => [];
}

class AudioMuteUpdate extends AudioUpdate {
  final String inputName;
  final bool muted;

  const AudioMuteUpdate({required this.inputName, required this.muted});

  @override
  List<Object> get props => [inputName, muted];
}

class AudioVolumeUpdate extends AudioUpdate {
  final String inputName;
  final double volumeDb;

  const AudioVolumeUpdate({required this.inputName, required this.volumeDb});

  @override
  List<Object> get props => [inputName, volumeDb];
}

/// Nível de sinal de cada fonte, de 0 a 1, já limitado a poucas vezes por segundo.
class AudioLevelsUpdate extends AudioUpdate {
  final Map<String, double> levels;

  const AudioLevelsUpdate(this.levels);

  @override
  List<Object> get props => [levels];
}

/// Fonte criada, removida ou renomeada: a lista precisa ser lida de novo.
class AudioInputsChanged extends AudioUpdate {
  const AudioInputsChanged();
}
