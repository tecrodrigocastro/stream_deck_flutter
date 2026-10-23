part of 'audio_bloc.dart';

abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioLoaded extends AudioState {
  final List<AudioInputEntity> inputs;

  /// Nível de sinal por fonte, de 0 a 1.
  final Map<String, double> levels;

  /// Erro de uma ação (ex.: mutar). A lista continua válida; a tela mostra a
  /// mensagem uma vez.
  final String? errorMessage;

  const AudioLoaded({required this.inputs, this.levels = const {}, this.errorMessage});

  AudioLoaded copyWith({List<AudioInputEntity>? inputs, Map<String, double>? levels}) {
    return AudioLoaded(inputs: inputs ?? this.inputs, levels: levels ?? this.levels);
  }

  @override
  List<Object> get props => [inputs, levels, if (errorMessage != null) errorMessage!];
}

class AudioFailure extends AudioState {
  final BaseException exception;

  const AudioFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
