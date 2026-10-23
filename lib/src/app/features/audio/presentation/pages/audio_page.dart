import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/widgets/audio_icon_resolver.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/widgets/audio_volume_scale.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixer do OBS: mute, volume e nível de cada fonte de áudio.
class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  @override
  void initState() {
    super.initState();
    context.read<AudioBloc>().add(const AudioLoadRequested());
  }

  void _onStateChanged(BuildContext context, AudioState state) {
    if (state is AudioLoaded && state.errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioBloc, AudioState>(
      listener: _onStateChanged,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<AudioBloc, AudioState>(
          builder: (context, state) {
            return switch (state) {
              AudioLoaded() => _Loaded(state: state),
              AudioFailure() => _Failure(
                  message: state.exception.message,
                  onRetry: () => context.read<AudioBloc>().add(const AudioLoadRequested()),
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

  final AudioLoaded state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AudioBloc>();

    return ListView(
      padding: const EdgeInsets.all(RedSpacing.screenMargin),
      children: [
        const Text('Áudio', style: RedTypography.screenTitle),
        const SizedBox(height: 2),
        Text('Toque no ícone para mutar uma fonte', style: RedTypography.secondary.copyWith(fontSize: 15)),
        const SizedBox(height: RedSpacing.xl),
        if (state.inputs.isEmpty)
          Text(
            'O OBS não tem nenhuma fonte de áudio.',
            style: RedTypography.body.copyWith(color: RedColors.steel),
          )
        else
          for (final input in state.inputs)
            Padding(
              padding: const EdgeInsets.only(bottom: RedSpacing.md),
              child: RedAudioFaderWidget(
                name: input.name,
                icon: AudioIconResolver.iconFor(input.name, muted: input.muted),
                volume: AudioVolumeScale.dbToSlider(input.volumeDb),
                volumeLabel: AudioVolumeScale.format(input.volumeDb),
                level: state.levels[input.name] ?? 0,
                muted: input.muted,
                onMutePressed: () => bloc.add(AudioMuteToggled(inputName: input.name)),
                onVolumeChanged: (value) => bloc.add(
                  AudioVolumeChanged(inputName: input.name, volumeDb: AudioVolumeScale.sliderToDb(value)),
                ),
              ),
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
            const Text('Não deu para ler o áudio', style: RedTypography.sectionTitle, textAlign: TextAlign.center),
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
