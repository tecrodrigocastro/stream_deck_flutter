part of 'obs_connection_bloc.dart';

abstract class ObsConnectionState extends Equatable {
  const ObsConnectionState();

  @override
  List<Object> get props => [];
}

class ObsConnectionInitial extends ObsConnectionState {}

class ObsConnectionLoading extends ObsConnectionState {}

class ObsConnectionSuccess extends ObsConnectionState {
  final ObsConnectionEntity connection;

  const ObsConnectionSuccess(this.connection);

  @override
  List<Object> get props => [connection];
}

class ObsConnectionFailure extends ObsConnectionState {
  final BaseException exception;

  const ObsConnectionFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}

/// A conexão estava aberta e caiu.
class ObsConnectionClosed extends ObsConnectionState {}
