import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:flutter/material.dart';

/// Barra fina de progresso (6 px). Também serve de medidor de áudio, com
/// [color] verde e [trackColor] mais escuro.
class RedProgressBarWidget extends StatelessWidget {
  const RedProgressBarWidget({
    super.key,
    required this.value,
    this.color = RedColors.pink,
    this.trackColor = RedColors.line,
    this.semanticLabel,
  });

  /// De 0 a 1. Valores fora desse intervalo são limitados.
  final double value;
  final Color color;
  final Color trackColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fraction = value.clamp(0.0, 1.0).toDouble();

    return Semantics(
      label: semanticLabel,
      value: '${(fraction * 100).round()}%',
      child: SizedBox(
        height: RedSizes.progressHeight,
        child: ColoredBox(
          color: trackColor,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraction,
              heightFactor: 1,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
