part of 'scenes_bloc.dart';

abstract class ScenesEvent extends Equatable {
  const ScenesEvent();

  @override
  List<Object> get props => [];
}

/// Carrega a lista de cenas (ao abrir a tela ou tentar de novo).
class ScenesLoadRequested extends ScenesEvent {
  const ScenesLoadRequested();
}

class ScenesSwitchRequested extends ScenesEvent {
  final String sceneName;

  const ScenesSwitchRequested({required this.sceneName});

  @override
  List<Object> get props => [sceneName];
}

/// Disparado pelo próprio bloc quando o OBS avisa que as cenas mudaram.
class ScenesChanged extends ScenesEvent {
  const ScenesChanged();
}
