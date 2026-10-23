import 'package:web_socket_channel/web_socket_channel.dart';

/// Pedaço mínimo de um WebSocket que o datasource usa. Existe para os testes
/// trocarem a rede por um fake.
abstract interface class IObsSocket {
  Stream<String> get messages;

  /// Código de fechamento, disponível depois que o stream terminou.
  int? get closeCode;

  void send(String message);

  Future<void> close();
}

typedef ObsSocketConnector = Future<IObsSocket> Function(Uri uri);

class WebSocketObsSocket implements IObsSocket {
  WebSocketObsSocket._(this._channel);

  final WebSocketChannel _channel;

  static Future<IObsSocket> connect(Uri uri) async {
    final channel = WebSocketChannel.connect(uri);
    await channel.ready;
    return WebSocketObsSocket._(channel);
  }

  @override
  Stream<String> get messages => _channel.stream.where((event) => event is String).cast<String>();

  @override
  int? get closeCode => _channel.closeCode;

  @override
  void send(String message) => _channel.sink.add(message);

  @override
  Future<void> close() async {
    try {
      await _channel.sink.close(1000).timeout(const Duration(seconds: 2));
    } catch (_) {
      // Fechando mesmo assim: o socket já pode estar morto.
    }
  }
}
