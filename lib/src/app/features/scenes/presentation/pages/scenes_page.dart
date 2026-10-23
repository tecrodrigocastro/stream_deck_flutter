import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/bloc/scenes_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/widgets/scene_grid_widget.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Painel de cenas do OBS: toque numa tecla para colocar a cena no ar.
class ScenesPage extends StatefulWidget {
  const ScenesPage({super.key});

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScenesBloc>().add(const ScenesLoadRequested());
  }

  void _onStateChanged(BuildContext context, ScenesState state) {
    if (state is ScenesLoaded && state.errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScenesBloc, ScenesState>(
      listener: _onStateChanged,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<ScenesBloc, ScenesState>(
          builder: (context, state) {
            return switch (state) {
              ScenesLoaded() => _Loaded(state: state),
              ScenesFailure() => _Failure(
                  message: state.exception.message,
                  onRetry: () => context.read<ScenesBloc>().add(const ScenesLoadRequested()),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final ScenesLoaded state;

  @override
  Widget build(BuildContext context) {
    final list = state.sceneList;
    final count = list.scenes.length;

    return ListView(
      padding: const EdgeInsets.all(RedSpacing.screenMargin),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: RedStatusDotWidget(status: RedStatus.connected, label: 'OBS conectado'),
        ),
        const SizedBox(height: RedSpacing.lg),
        RedPanelWidget(
          padding: const EdgeInsets.symmetric(horizontal: RedSpacing.lg, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Na tela agora', style: RedTypography.secondary.copyWith(fontSize: 15)),
              const SizedBox(height: RedSpacing.xs),
              Text(
                list.currentSceneName.isEmpty ? '—' : list.currentSceneName,
                style: RedTypography.screenTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: RedSpacing.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Cenas', style: RedTypography.sectionTitle),
            Text(
              count == 1 ? '1 cena no OBS' : '$count cenas no OBS',
              style: RedTypography.secondary,
            ),
          ],
        ),
        const SizedBox(height: RedSpacing.md),
        if (count == 0)
          Text('O OBS não tem nenhuma cena ainda.', style: RedTypography.body.copyWith(color: RedColors.steel))
        else
          SceneGridWidget(
            scenes: list.scenes,
            currentSceneName: list.currentSceneName,
            onSelected: (scene) => context.read<ScenesBloc>().add(ScenesSwitchRequested(sceneName: scene.name)),
          ),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RedSpacing.screenMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Não deu para ler as cenas', style: RedTypography.sectionTitle, textAlign: TextAlign.center),
            const SizedBox(height: RedSpacing.sm),
            Text(message, style: RedTypography.body.copyWith(color: RedColors.steel), textAlign: TextAlign.center),
            const SizedBox(height: RedSpacing.xl),
            RedOutlineButtonWidget(label: 'Tentar de novo', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
