import 'package:base_clean_arch_bloc/src/core/design_system/shapes/red_shapes.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_icon_widget.dart';
import 'package:flutter/material.dart';

/// Botão de ação principal (vermelho, canto cortado). Um por tela.
///
/// Com [onPressed] nulo fica desabilitado; com [loading] mostra um indicador
/// e ignora toques.
class RedPrimaryButtonWidget extends StatelessWidget {
  const RedPrimaryButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final RedIcon? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final leading = icon;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      onTap: enabled ? onPressed : null,
      excludeSemantics: true,
      child: Opacity(
        opacity: onPressed == null ? 0.45 : 1,
        child: Material(
          color: RedColors.live,
          shape: RedShapes.cut,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: SizedBox(
              height: RedSizes.primaryButtonHeight,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: RedSizes.iconButton,
                        height: RedSizes.iconButton,
                        child: CircularProgressIndicator(strokeWidth: 2, color: RedColors.onLive),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leading != null) ...[
                            RedIconWidget(icon: leading, size: RedSizes.iconButton, color: RedColors.onLive),
                            const SizedBox(width: 10),
                          ],
                          Text(label, style: RedTypography.button),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
