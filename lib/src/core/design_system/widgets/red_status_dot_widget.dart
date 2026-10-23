import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:flutter/material.dart';

/// Estado de uma conexão.
enum RedStatus {
  connected(RedColors.ok),
  disconnected(RedColors.off);

  const RedStatus(this.color);

  final Color color;
}

/// Ponto colorido com texto: "OBS conectado", "Desconectado".
///
/// A cor sozinha não carrega o significado, o [label] sempre o repete.
class RedStatusDotWidget extends StatelessWidget {
  const RedStatusDotWidget({
    super.key,
    required this.status,
    required this.label,
  });

  final RedStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: RedSizes.statusDot,
          height: RedSizes.statusDot,
          decoration: BoxDecoration(shape: BoxShape.circle, color: status.color),
        ),
        const SizedBox(width: RedSpacing.sm),
        Text(label, style: RedTypography.body.copyWith(fontSize: 15)),
      ],
    );
  }
}
