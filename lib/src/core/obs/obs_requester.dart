/// Evento enviado pelo OBS (op 5 do obs-websocket).
class ObsEvent {
  const ObsEvent({required this.type, this.data = const {}});

  final String type;
  final Map<String, dynamic> data;
}

/// O OBS recusou o pedido, não respondeu, ou não há conexão aberta.
class ObsRequestException implements Exception {
  const ObsRequestException({required this.message, this.code});

  final String message;
  final int? code;
}

/// Porta de entrada para falar com o OBS depois de conectado. As features
/// (cenas, áudio...) dependem desta interface e não de quem abre o WebSocket.
abstract interface class IObsRequester {
  /// Manda um pedido e devolve o `responseData` (vazio quando não há).
  /// Lança [ObsRequestException] em qualquer falha.
  Future<Map<String, dynamic>> request(String type, {Map<String, dynamic>? data});

  /// Eventos do OBS. Só chegam os das categorias assinadas no Identify.
  Stream<ObsEvent> get events;
}
