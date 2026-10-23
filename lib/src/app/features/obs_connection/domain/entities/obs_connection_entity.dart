import 'package:equatable/equatable.dart';

/// Conexão aberta e autenticada com o servidor WebSocket do OBS.
class ObsConnectionEntity extends Equatable {
  final String host;
  final int port;
  final String obsVersion;
  final int rpcVersion;

  const ObsConnectionEntity({
    required this.host,
    required this.port,
    required this.obsVersion,
    required this.rpcVersion,
  });

  @override
  List<Object> get props => [host, port, obsVersion, rpcVersion];
}
