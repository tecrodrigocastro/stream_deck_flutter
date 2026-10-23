import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/validators/obs_connection_validators.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Primeira tela do app: endereço, porta e senha do servidor WebSocket do OBS.
///
/// Por enquanto só valida os campos. O cliente obs-websocket entra num PR
/// próprio; até lá o status fica em "Desconectado".
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados válidos. A conexão com o OBS chega no próximo PR.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  RedSpacing.screenMargin,
                  RedSpacing.xxl,
                  RedSpacing.screenMargin,
                  RedSpacing.xxl,
                ),
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
                    RedPrimaryButtonWidget(label: 'Conectar', icon: RedIcon.wifi, onPressed: _connect),
                    const Spacer(),
                    const SizedBox(height: RedSpacing.xxl),
                    const RedStatusDotWidget(status: RedStatus.disconnected, label: 'Desconectado'),
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
    );
  }
}
