part of 'obs_connection_bloc.dart';

abstract class ObsConnectionEvent extends Equatable {
  const ObsConnectionEvent();

  @override
  List<Object> get props => [];
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
