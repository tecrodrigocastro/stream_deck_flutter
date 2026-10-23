import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:flutter/material.dart';

/// Selo vermelho "Ao vivo", com um ponto branco.
class RedLiveBadgeWidget extends StatelessWidget {
  const RedLiveBadgeWidget({super.key, this.label = 'Ao vivo'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RedSizes.liveBadgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: RedColors.live,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: RedSpacing.sm,
            height: RedSpacing.sm,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: RedColors.onLive),
          ),
          const SizedBox(width: RedSpacing.sm),
          Text(
            label,
            style: RedTypography.bodyStrong.copyWith(fontSize: 14, color: RedColors.onLive),
          ),
        ],
      ),
    );
  }
}
