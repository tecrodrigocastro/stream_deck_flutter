import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_icon_widget.dart';
import 'package:flutter/material.dart';

/// Botão quadrado só com ícone. Tem 44 px (a área mínima de toque).
///
/// [semanticLabel] é obrigatório: sem texto, é ele que o leitor de tela lê.
class RedIconButtonWidget extends StatelessWidget {
  const RedIconButtonWidget({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.color = RedColors.pink,
    this.background = RedColors.key,
    this.iconSize = RedSizes.iconButton,
    this.size = RedSizes.minTouch,
  });

  final RedIcon icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final Color color;
  final Color background;
  final double iconSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: background,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: RedIconWidget(icon: icon, size: iconSize, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
