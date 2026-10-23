import 'dart:async';
import 'dart:convert';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_auth.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_socket.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/models/obs_connection_model.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';

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
/// Identified (op 2); depois disso, pedidos (op 6), respostas (op 7) e
/// eventos (op 5).
class ObsWebSocketDatasource implements IObsRequester {
  ObsWebSocketDatasource({
    ObsSocketConnector connector = WebSocketObsSocket.connect,
    this.timeout = const Duration(seconds: 8),
    this.requestTimeout = const Duration(seconds: 5),
  }) : _connector = connector;

  static const int _rpcVersion = 1;
  static const int _authFailedCloseCode = 4009;

  /// Categorias de evento assinadas no Identify (bitmask do obs-websocket):
  /// Scenes (1 << 2), Inputs (1 << 3) e InputVolumeMeters (1 << 16, os
  /// medidores de áudio). Ao incluir gravação etc., somar aqui.
  static const int _eventSubscriptions = (1 << 2) | (1 << 3) | (1 << 16);

  final ObsSocketConnector _connector;
  final Duration timeout;
  final Duration requestTimeout;

  final StreamController<void> _closed = StreamController<void>.broadcast();
  final StreamController<ObsEvent> _events = StreamController<ObsEvent>.broadcast();
  final Map<String, Completer<Map<String, dynamic>>> _pending = {};
  int _requestCounter = 0;
  bool _established = false;
  IObsSocket? _socket;
  StreamSubscription<String>? _subscription;

  Stream<void> get connectionClosed => _closed.stream;

  @override
  Stream<ObsEvent> get events => _events.stream;

  @override
  Future<Map<String, dynamic>> request(String type, {Map<String, dynamic>? data}) {
    final socket = _socket;
    if (socket == null || !_established) {
      return Future.error(const ObsRequestException(message: 'Sem conexão com o OBS'));
    }

    final id = '${++_requestCounter}';
    final completer = Completer<Map<String, dynamic>>();
    _pending[id] = completer;

    socket.send(jsonEncode({
      'op': 6,
      'd': {
        'requestType': type,
        'requestId': id,
        if (data != null) 'requestData': data,
      },
    }));

    return completer.future.timeout(requestTimeout, onTimeout: () {
      _pending.remove(id);
      throw ObsRequestException(message: 'O OBS não respondeu ao pedido $type');
    });
  }

  void _handleResponse(Map<String, dynamic> data) {
    final completer = _pending.remove(data['requestId']);
    if (completer == null) return;

    final status = (data['requestStatus'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    if (status['result'] == true) {
      completer.complete((data['responseData'] as Map<String, dynamic>?) ?? const <String, dynamic>{});
    } else {
      completer.completeError(ObsRequestException(
        message: status['comment'] as String? ?? 'O OBS recusou o pedido',
        code: status['code'] as int?,
      ));
    }
  }

  void _failPending(String message) {
    final pending = _pending.values.toList();
    _pending.clear();
    for (final completer in pending) {
      completer.completeError(ObsRequestException(message: message));
    }
  }

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
              _established = true;
              if (!completer.isCompleted) {
                completer.complete(ObsConnectionModel(
                  host: host,
                  port: port,
                  obsVersion: obsVersion,
                  rpcVersion: data['negotiatedRpcVersion'] as int? ?? _rpcVersion,
                ));
              }
            case 5:
              _events.add(ObsEvent(
                type: data['eventType'] as String? ?? '',
                data: (data['eventData'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
              ));
            case 7:
              _handleResponse(data);
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
          _established = false;
          _failPending('A conexão com o OBS caiu');
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
        'eventSubscriptions': _eventSubscriptions,
        if (authString != null) 'authentication': authString,
      },
    };
  }

  Future<void> disconnect() async {
    final subscription = _subscription;
    final socket = _socket;
    _subscription = null;
    _socket = null;
    _established = false;
    _failPending('Conexão com o OBS encerrada');

    // Cancelar antes de fechar: assim o onDone não vira um "conexão caiu".
    await subscription?.cancel();
    await socket?.close();
  }
}
