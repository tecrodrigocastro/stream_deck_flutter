import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_icon_button_widget.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_panel_widget.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_progress_bar_widget.dart';
import 'package:flutter/material.dart';

/// Controle de uma fonte de áudio: nome, volume em dB, botão de mute, controle
/// deslizante e medidor de nível.
///
/// [volume] e [level] vão de 0 a 1; a conversão de/para o volume do OBS fica
/// com quem usa o componente. Mudo: o nome fica cinza, o texto vira
/// [mutedLabel] em rosa, o controle apaga e o medidor zera.
class RedAudioFaderWidget extends StatelessWidget {
  const RedAudioFaderWidget({
    super.key,
    required this.name,
    required this.icon,
    required this.volume,
    required this.onVolumeChanged,
    required this.onMutePressed,
    this.volumeLabel,
    this.level = 0,
    this.muted = false,
    this.mutedLabel = 'Mudo',
  });

  final String name;
  final RedIcon icon;
  final double volume;
  final ValueChanged<double>? onVolumeChanged;
  final VoidCallback? onMutePressed;

  /// Valor mostrado abaixo do nome, ex.: "-6,0 dB".
  final String? volumeLabel;
  final double level;
  final bool muted;
  final String mutedLabel;

  @override
  Widget build(BuildContext context) {
    final statusText = muted ? mutedLabel : volumeLabel;

    return RedPanelWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: RedTypography.cardTitle.copyWith(
                        color: muted ? RedColors.steel : RedColors.mist,
                      ),
                    ),
                    if (statusText != null)
                      Text(
                        statusText,
                        style: muted
                            ? RedTypography.secondary.copyWith(
                                color: RedColors.pink,
                                fontWeight: FontWeight.w600,
                              )
                            : RedTypography.secondary,
                      ),
                  ],
                ),
              ),
              RedIconButtonWidget(
                icon: icon,
                semanticLabel: muted ? 'Ativar áudio: $name' : 'Mutar $name',
                onPressed: onMutePressed,
                color: muted ? RedColors.pink : RedColors.mist,
              ),
            ],
          ),
          Opacity(
            opacity: muted ? 0.45 : 1,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: RedSizes.progressHeight,
                trackShape: const RectangularSliderTrackShape(),
                activeTrackColor: RedColors.pink,
                inactiveTrackColor: RedColors.track,
                thumbColor: RedColors.mist,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 0,
                  pressedElevation: 0,
                ),
                overlayColor: const Color(0x29FF3C8E),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
              ),
              child: Semantics(
                label: 'Volume: $name',
                child: Slider(
                  value: volume.clamp(0.0, 1.0).toDouble(),
                  onChanged: onVolumeChanged,
                  semanticFormatterCallback: (double value) => '${(value * 100).round()}%',
                ),
              ),
            ),
          ),
          RedProgressBarWidget(
            value: muted ? 0 : level,
            color: RedColors.ok,
            trackColor: RedColors.meterTrack,
            semanticLabel: 'Nível: $name',
          ),
        ],
      ),
    );
  }
}
