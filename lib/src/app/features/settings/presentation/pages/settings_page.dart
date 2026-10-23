import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Por enquanto só a desconexão do OBS (e, em debug, o catálogo do design system).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(RedSpacing.screenMargin),
        children: [
          const Text('Ajustes', style: RedTypography.screenTitle),
          const SizedBox(height: RedSpacing.xl),
          RedOutlineButtonWidget(
            label: 'Desconectar do OBS',
            icon: RedIcon.wifi,
            onPressed: () {
              context.read<ObsConnectionBloc>().add(const ObsDisconnectRequested());
              context.go('/conectar');
            },
          ),
          const SizedBox(height: RedSpacing.sm),
          Text(
            'O app não conecta sozinho na próxima vez. Os dados do OBS continuam preenchidos na tela de conexão.',
            style: RedTypography.caption.copyWith(color: RedColors.steel),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: RedSpacing.xl),
            RedOutlineButtonWidget(
              label: 'Design system',
              icon: RedIcon.grid,
              onPressed: () => context.push('/design-system'),
            ),
          ],
        ],
      ),
    );
  }
}
