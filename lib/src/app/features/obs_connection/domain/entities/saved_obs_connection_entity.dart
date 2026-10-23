import 'package:equatable/equatable.dart';

/// Última conexão que deu certo, guardada no aparelho.
class SavedObsConnectionEntity extends Equatable {
  final String host;
  final int port;
  final String password;

  /// Quando verdadeiro, o app conecta sozinho ao abrir.
  final bool autoConnect;

  const SavedObsConnectionEntity({
    required this.host,
    required this.port,
    required this.password,
    required this.autoConnect,
  });

  @override
  List<Object> get props => [host, port, password, autoConnect];
}
