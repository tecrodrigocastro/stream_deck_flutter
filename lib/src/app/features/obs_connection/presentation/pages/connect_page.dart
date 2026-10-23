import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/dtos/obs_connection_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/validators/obs_connection_validators.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Primeira tela do app: endereço, porta e senha do servidor WebSocket do OBS.
/// Conectou, vai para a Home.
class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _validators = const ObsConnectionValidators();
  final _host = TextEditingController();
  final _port = TextEditingController(text: '${ObsConnectionValidators.defaultPort}');
  final _password = TextEditingController();

  String? _hostError;
  String? _portError;

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _password.dispose();
    super.dispose();
  }

  void _connect() {
    final hostError = _validators.host(_host.text);
    final portError = _validators.port(_port.text);
    setState(() {
      _hostError = hostError;
      _portError = portError;
    });
    if (hostError != null || portError != null) return;

    FocusScope.of(context).unfocus();
    context.read<ObsConnectionBloc>().add(
          ObsConnectRequested(
            params: ObsConnectionParams(
              host: _host.text.trim(),
              port: int.parse(_port.text.trim()),
              password: _password.text,
            ),
          ),
        );
  }

  void _onStateChanged(BuildContext context, ObsConnectionState state) {
    if (state is ObsConnectionSuccess) {
      context.go('/home');
    }
    if (state is ObsConnectionFailure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.exception.message)));
    }
  }

  static String _statusLabel(ObsConnectionState state) {
    return switch (state) {
      ObsConnectionLoading() => 'Conectando…',
      ObsConnectionSuccess() => 'Conectado',
      ObsConnectionClosed() => 'Conexão perdida',
      _ => 'Desconectado',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ObsConnectionBloc, ObsConnectionState>(
      listener: _onStateChanged,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(RedSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: RedSpacing.xxl),
                      const Text('Conectar ao OBS', style: RedTypography.screenTitle),
                      const SizedBox(height: RedSpacing.md),
                      Text(
                        'No OBS, abra Ferramentas e Configurações do servidor WebSocket e '
                        'ative o servidor. Celular e PC precisam estar no mesmo Wi-Fi.',
                        style: RedTypography.body.copyWith(color: RedColors.steel),
                      ),
                      const SizedBox(height: RedSpacing.xxl),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RedTextFieldWidget(
                              label: 'Endereço do PC',
                              controller: _host,
                              hintText: '192.168.0.12',
                              errorText: _hostError,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: RedSpacing.md),
                          SizedBox(
                            width: 108,
                            child: RedTextFieldWidget(
                              label: 'Porta',
                              controller: _port,
                              errorText: _portError,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RedSpacing.lg),
                      RedTextFieldWidget(
                        label: 'Senha do servidor',
                        controller: _password,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: RedSpacing.xxl),
                      BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
                        builder: (context, state) {
                          final loading = state is ObsConnectionLoading;
                          return RedPrimaryButtonWidget(
                            label: 'Conectar',
                            icon: RedIcon.wifi,
                            loading: loading,
                            onPressed: _connect,
                          );
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: RedSpacing.xxl),
                      BlocBuilder<ObsConnectionBloc, ObsConnectionState>(
                        builder: (context, state) {
                          return RedStatusDotWidget(
                            status: state is ObsConnectionSuccess ? RedStatus.connected : RedStatus.disconnected,
                            label: _statusLabel(state),
                          );
                        },
                      ),
                      const SizedBox(height: RedSpacing.sm + 2),
                      Text(
                        'Use só na rede local. Nunca exponha a porta 4455 para a internet.',
                        style: RedTypography.caption.copyWith(color: RedColors.steel),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
