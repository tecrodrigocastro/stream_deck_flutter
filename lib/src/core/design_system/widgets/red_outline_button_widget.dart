import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_icon_widget.dart';
import 'package:flutter/material.dart';

/// Variações do botão de contorno.
enum RedOutlineTone {
  /// Contorno e texto neutros (ação secundária).
  neutral,

  /// Contorno e texto rosa (ação que pede atenção, como encerrar a live).
  accent,
}

/// Botão secundário: só contorno de 2 px, cantos retos.
class RedOutlineButtonWidget extends StatelessWidget {
  const RedOutlineButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = RedOutlineTone.neutral,
  });

  final String label;
  final VoidCallback? onPressed;
  final RedIcon? icon;
  final RedOutlineTone tone;

  @override
  Widget build(BuildContext context) {
    final accent = tone == RedOutlineTone.accent;
    final contentColor = accent ? RedColors.pink : RedColors.mist;
    final borderColor = accent ? RedColors.pink : RedColors.outline;
    final leading = icon;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: Opacity(
        opacity: onPressed == null ? 0.45 : 1,
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: RedSizes.outlineWidth),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              height: RedSizes.secondaryButtonHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: RedSpacing.xl),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) ...[
                        RedIconWidget(icon: leading, size: RedSizes.iconInline, color: contentColor),
                        const SizedBox(width: RedSpacing.sm),
                      ],
                      Text(label, style: RedTypography.bodyStrong.copyWith(color: contentColor)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
