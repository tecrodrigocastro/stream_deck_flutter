part of 'obs_connection_bloc.dart';

abstract class ObsConnectionEvent extends Equatable {
  const ObsConnectionEvent();

  @override
  List<Object> get props => [];
}

/// Disparado ao abrir a tela de conexão: carrega a conexão guardada (para
/// preencher os campos) e, na primeira vez que o app abre, conecta sozinho
/// quando a conexão automática está ligada.
class ObsStarted extends ObsConnectionEvent {
  const ObsStarted();
}

class ObsConnectRequested extends ObsConnectionEvent {
  final ObsConnectionParams params;

  const ObsConnectRequested({required this.params});

  @override
  List<Object> get props => [params];
}

class ObsDisconnectRequested extends ObsConnectionEvent {
  const ObsDisconnectRequested();
}

/// Disparado pelo próprio bloc quando o OBS fecha uma conexão aberta.
class ObsConnectionDropped extends ObsConnectionEvent {
  const ObsConnectionDropped();
}
