import 'dart:async';
import 'dart:convert';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_auth.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_socket.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/models/obs_connection_model.dart';

/// A senha está errada (o OBS fechou com o código 4009).
class ObsAuthFailedException implements Exception {
  const ObsAuthFailedException();
}

/// O OBS exige senha e nenhuma foi informada.
class ObsAuthRequiredException implements Exception {
  const ObsAuthRequiredException();
}

/// Qualquer outra falha de conexão ou de protocolo.
class ObsConnectionException implements Exception {
  const ObsConnectionException(this.message);

  final String message;
}

/// Fala o protocolo obs-websocket v5: Hello (op 0) -> Identify (op 1) ->
/// Identified (op 2). Só cuida da conexão; pedidos e eventos ficam para depois.
class ObsWebSocketDatasource {
  ObsWebSocketDatasource({
    ObsSocketConnector connector = WebSocketObsSocket.connect,
    this.timeout = const Duration(seconds: 8),
  }) : _connector = connector;

  static const int _rpcVersion = 1;
  static const int _authFailedCloseCode = 4009;

  final ObsSocketConnector _connector;
  final Duration timeout;

  final StreamController<void> _closed = StreamController<void>.broadcast();
  IObsSocket? _socket;
  StreamSubscription<String>? _subscription;

  Stream<void> get connectionClosed => _closed.stream;

  Future<ObsConnectionModel> connect({
    required String host,
    required int port,
    required String password,
  }) async {
    await disconnect();

    try {
      return await _handshake(host: host, port: port, password: password).timeout(timeout);
    } catch (_) {
      await disconnect();
      rethrow;
    }
  }

  Future<ObsConnectionModel> _handshake({
    required String host,
    required int port,
    required String password,
  }) async {
    final socket = await _connector(Uri(scheme: 'ws', host: host, port: port));
    _socket = socket;

    final completer = Completer<ObsConnectionModel>();
    var obsVersion = '';
    var established = false;

    void fail(Object error) {
      if (!completer.isCompleted) completer.completeError(error);
    }

    _subscription = socket.messages.listen(
      (raw) {
        try {
          final message = jsonDecode(raw) as Map<String, dynamic>;
          final data = (message['d'] as Map<String, dynamic>?) ?? const <String, dynamic>{};

          switch (message['op']) {
            case 0:
              obsVersion = data['obsWebSocketVersion'] as String? ?? '';
              socket.send(jsonEncode(_identify(data, password)));
            case 2:
              established = true;
              if (!completer.isCompleted) {
                completer.complete(ObsConnectionModel(
                  host: host,
                  port: port,
                  obsVersion: obsVersion,
                  rpcVersion: data['negotiatedRpcVersion'] as int? ?? _rpcVersion,
                ));
              }
          }
        } on ObsAuthRequiredException catch (error) {
          fail(error);
        } catch (_) {
          fail(const ObsConnectionException('Resposta inválida do OBS'));
        }
      },
      onError: (Object _) => fail(const ObsConnectionException('Erro na conexão com o OBS')),
      onDone: () {
        if (established) {
          _closed.add(null);
        } else if (socket.closeCode == _authFailedCloseCode) {
          fail(const ObsAuthFailedException());
        } else {
          fail(const ObsConnectionException('O OBS encerrou a conexão'));
        }
      },
    );

    return completer.future;
  }

  Map<String, dynamic> _identify(Map<String, dynamic> hello, String password) {
    final authentication = hello['authentication'] as Map<String, dynamic>?;

    String? authString;
    if (authentication != null) {
      if (password.isEmpty) throw const ObsAuthRequiredException();
      authString = ObsAuth.buildAuthString(
        password: password,
        salt: authentication['salt'] as String,
        challenge: authentication['challenge'] as String,
      );
    }

    return {
      'op': 1,
      'd': {
        'rpcVersion': _rpcVersion,
        // Sem eventos por enquanto: o app só manda pedidos.
        'eventSubscriptions': 0,
        if (authString != null) 'authentication': authString,
      },
    };
  }

  Future<void> disconnect() async {
    final subscription = _subscription;
    final socket = _socket;
    _subscription = null;
    _socket = null;

    // Cancelar antes de fechar: assim o onDone não vira um "conexão caiu".
    await subscription?.cancel();
    await socket?.close();
  }
}
