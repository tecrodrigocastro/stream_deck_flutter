import 'package:base_clean_arch_bloc/src/core/design_system/shapes/red_shapes.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_icon_widget.dart';
import 'package:flutter/material.dart';

/// Tecla de cena da grade principal. A cena que está no ar fica em vermelho
/// ([active]); as outras ficam em [RedColors.key] com o ícone rosa.
class RedSceneKeyWidget extends StatelessWidget {
  const RedSceneKeyWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.active = false,
    this.height = RedSizes.keyHeight,
  });

  final String label;
  final RedIcon icon;
  final VoidCallback? onPressed;
  final bool active;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textColor = active ? RedColors.onLive : RedColors.mist;
    final iconColor = active ? RedColors.onLive : RedColors.pink;

    return Semantics(
      button: true,
      selected: active,
      enabled: onPressed != null,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: active ? RedColors.live : RedColors.key,
        shape: RedShapes.cut,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: RedSpacing.lg, vertical: RedSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RedIconWidget(icon: icon, size: RedSizes.iconKey, color: iconColor),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: RedTypography.keyLabel.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
