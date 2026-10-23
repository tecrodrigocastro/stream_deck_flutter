import 'dart:async';
import 'dart:convert';

import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_socket.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_websocket_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/models/obs_connection_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeObsSocket implements IObsSocket {
  final incoming = StreamController<String>();
  final sent = <Map<String, dynamic>>[];
  bool closed = false;

  @override
  int? closeCode;

  @override
  Stream<String> get messages => incoming.stream;

  @override
  void send(String message) => sent.add(jsonDecode(message) as Map<String, dynamic>);

  @override
  Future<void> close() async => closed = true;

  void receive(Map<String, dynamic> message) => incoming.add(jsonEncode(message));

  Future<void> closeFromServer(int code) async {
    closeCode = code;
    await incoming.close();
  }
}

Map<String, dynamic> _hello({Map<String, String>? authentication}) => {
      'op': 0,
      'd': {
        'obsWebSocketVersion': '5.5.4',
        'rpcVersion': 1,
        if (authentication != null) 'authentication': authentication,
      },
    };

const _identified = {
  'op': 2,
  'd': {'negotiatedRpcVersion': 1},
};

void main() {
  late FakeObsSocket socket;
  late ObsWebSocketDatasource datasource;
  Uri? requestedUri;

  ObsWebSocketDatasource build({Duration timeout = const Duration(seconds: 2)}) {
    return ObsWebSocketDatasource(
      timeout: timeout,
      connector: (uri) async {
        requestedUri = uri;
        return socket;
      },
    );
  }

  setUp(() {
    socket = FakeObsSocket();
    requestedUri = null;
    datasource = build();
  });

  Future<ObsConnectionModel> connect({String password = ''}) {
    return datasource.connect(host: '192.168.0.12', port: 4455, password: password);
  }

  Future<void> handshake() async {
    final future = connect();
    await pumpEventQueue();
    socket.receive(_hello());
    await pumpEventQueue();
    socket.receive(_identified);
    await future;
  }

  test('conecta em ws://host:porta e conclui o handshake sem senha', () async {
    final future = connect();
    await pumpEventQueue();

    socket.receive(_hello());
    await pumpEventQueue();
    socket.receive(_identified);
    final model = await future;

    expect(requestedUri.toString(), 'ws://192.168.0.12:4455');
    expect(socket.sent.single['op'], 1);
    expect(socket.sent.single['d']['rpcVersion'], 1);
    expect(socket.sent.single['d'].containsKey('authentication'), isFalse);
    expect(model.obsVersion, '5.5.4');
    expect(model.host, '192.168.0.12');
    expect(model.port, 4455);
  });

  test('envia a string de autenticação quando o OBS pede senha', () async {
    final future = connect(password: 'supersecretpassword');
    await pumpEventQueue();

    socket.receive(_hello(authentication: {
      'challenge': '+IxH4CnCiqpX1rM9scsNynZzbOe4KhDeYcTNS3PDaeY=',
      'salt': 'lM1GncleQOaCu9lT1yeUZhFYnqhsLLP1G5lAGo3ixaI=',
    }));
    await pumpEventQueue();
    socket.receive(_identified);
    await future;

    expect(socket.sent.single['d']['authentication'], '1Ct943GAT+6YQUUX47Ia/ncufilbe6+oD6lY+5kaCu4=');
  });

  test('falha com ObsAuthRequiredException quando pede senha e não há nenhuma', () async {
    final future = connect();
    final expectation = expectLater(future, throwsA(isA<ObsAuthRequiredException>()));
    await pumpEventQueue();

    socket.receive(_hello(authentication: {'challenge': 'c', 'salt': 's'}));
    await expectation;

    expect(socket.sent, isEmpty);
    expect(socket.closed, isTrue);
  });

  test('falha com ObsAuthFailedException quando o OBS fecha com 4009', () async {
    final future = connect(password: 'errada');
    final expectation = expectLater(future, throwsA(isA<ObsAuthFailedException>()));
    await pumpEventQueue();

    socket.receive(_hello(authentication: {'challenge': 'c', 'salt': 's'}));
    await pumpEventQueue();
    await socket.closeFromServer(4009);
    await expectation;
  });

  test('falha com ObsConnectionException quando o OBS fecha antes de identificar', () async {
    final future = connect();
    final expectation = expectLater(future, throwsA(isA<ObsConnectionException>()));
    await pumpEventQueue();

    await socket.closeFromServer(1006);
    await expectation;
  });

  test('falha com TimeoutException quando o OBS não responde', () async {
    datasource = build(timeout: const Duration(milliseconds: 50));

    await expectLater(connect(), throwsA(isA<TimeoutException>()));
    expect(socket.closed, isTrue);
  });

  test('falha com ObsConnectionException a uma mensagem que não é JSON', () async {
    final future = connect();
    final expectation = expectLater(future, throwsA(isA<ObsConnectionException>()));
    await pumpEventQueue();

    socket.incoming.add('isso não é json');
    await expectation;
  });

  test('avisa quando uma conexão aberta cai', () async {
    await handshake();
    var notified = 0;
    datasource.connectionClosed.listen((_) => notified++);

    await socket.closeFromServer(1006);
    await pumpEventQueue();

    expect(notified, 1);
  });

  test('não avisa quando o próprio app desconecta', () async {
    await handshake();
    var notified = 0;
    datasource.connectionClosed.listen((_) => notified++);

    await datasource.disconnect();
    await socket.incoming.close();
    await pumpEventQueue();

    expect(notified, 0);
    expect(socket.closed, isTrue);
  });
}
