import 'package:base_clean_arch_bloc/src/core/design_system/shapes/red_tag_border.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:flutter/material.dart';

/// Etiqueta com a borda direita inclinada (um passo de macro, uma tecnologia).
/// [highlighted] marca o passo que está rodando, em vermelho.
class RedTagWidget extends StatelessWidget {
  const RedTagWidget({
    super.key,
    required this.label,
    this.highlighted = false,
  });

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? RedColors.live : RedColors.key,
      shape: const RedTagBorder(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 12, 5),
        child: Text(
          label,
          style: RedTypography.caption.copyWith(
            fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
            color: highlighted ? RedColors.onLive : RedColors.mist,
          ),
        ),
      ),
    );
  }
}
