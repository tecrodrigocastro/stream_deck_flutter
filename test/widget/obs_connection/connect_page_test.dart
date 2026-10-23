import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/pages/connect_page.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockObsConnectionBloc extends MockBloc<ObsConnectionEvent, ObsConnectionState> implements ObsConnectionBloc {}

class FakeObsConnectRequested extends Fake implements ObsConnectRequested {}

void main() {
  late MockObsConnectionBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeObsConnectRequested());
  });

  setUp(() {
    bloc = MockObsConnectionBloc();
    when(() => bloc.state).thenReturn(ObsConnectionInitial());
  });

  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget app() {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const ConnectPage()),
        GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Text('HOME'))),
      ],
    );

    return BlocProvider<ObsConnectionBloc>.value(
      value: bloc,
      child: MaterialApp.router(theme: RedTheme.dark, routerConfig: router),
    );
  }

  testWidgets('mostra título, porta padrão e status desconectado', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    expect(find.text('Conectar ao OBS'), findsOneWidget);
    expect(find.text('4455'), findsOneWidget);
    expect(find.text('Desconectado'), findsOneWidget);
  });

  testWidgets('endereço vazio mostra erro e não chama o bloc', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    await tester.tap(find.text('Conectar'));
    await tester.pump();

    expect(find.text('Informe o endereço do PC'), findsOneWidget);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('dados válidos disparam ObsConnectRequested com os valores digitados', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app());

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), ' 192.168.0.12 ');
    await tester.enterText(fields.at(2), 'senha-da-live');
    await tester.tap(find.text('Conectar'));
    await tester.pump();

    final event = verify(() => bloc.add(captureAny())).captured.single as ObsConnectRequested;
    expect(event.params, ObsConnectionParams(host: '192.168.0.12', port: 4455, password: 'senha-da-live'));
  });

  testWidgets('mostra "Conectando…" enquanto conecta', (tester) async {
    useTallScreen(tester);
    when(() => bloc.state).thenReturn(ObsConnectionLoading());

    await tester.pumpWidget(app());

    expect(find.text('Conectando…'), findsOneWidget);
  });

  testWidgets('mostra a mensagem de erro quando a conexão falha', (tester) async {
    useTallScreen(tester);
    whenListen(
      bloc,
      Stream<ObsConnectionState>.fromIterable([
        const ObsConnectionFailure(exception: DefaultException(message: 'Senha incorreta')),
      ]),
      initialState: ObsConnectionInitial(),
    );

    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.text('Senha incorreta'), findsOneWidget);
  });

  testWidgets('vai para a Home quando conecta', (tester) async {
    useTallScreen(tester);
    whenListen(
      bloc,
      Stream<ObsConnectionState>.fromIterable([
        const ObsConnectionSuccess(
          ObsConnectionEntity(host: '192.168.0.12', port: 4455, obsVersion: '5.5.4', rpcVersion: 1),
        ),
      ]),
      initialState: ObsConnectionInitial(),
    );

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
  });
}
