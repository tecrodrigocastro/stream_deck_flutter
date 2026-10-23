import 'package:base_clean_arch_bloc/src/core/design_system/shapes/red_shapes.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:flutter/material.dart';

/// Painel (card) com o canto superior direito cortado.
///
/// [accentColor] desenha uma faixa de 3 px no topo, usada para marcar o card
/// ativo (ex.: a macro que está rodando).
class RedPanelWidget extends StatelessWidget {
  const RedPanelWidget({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(RedSpacing.lg),
    this.color = RedColors.panel,
    this.cut = true,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool cut;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor;

    return Material(
      color: color,
      shape: cut ? RedShapes.cut : RedShapes.square,
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: accent == null ? null : Border(top: BorderSide(color: accent, width: 3)),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
