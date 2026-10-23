import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:flutter/material.dart';

/// Interruptor de 52x32: ligado é vermelho com bolinha branca, desligado é só
/// contorno com bolinha cinza. A área de toque tem 48 px de altura.
class RedSwitchWidget extends StatelessWidget {
  const RedSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final callback = onChanged;
    final VoidCallback? toggle = callback == null ? null : () => callback(!value);

    return Semantics(
      toggled: value,
      enabled: callback != null,
      label: semanticLabel,
      onTap: toggle,
      excludeSemantics: true,
      child: Opacity(
        opacity: callback == null ? 0.45 : 1,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: toggle,
          child: SizedBox(
            width: RedSizes.switchWidth + RedSpacing.sm,
            height: RedSizes.minTouch + RedSpacing.xs,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: RedSizes.switchWidth,
                height: RedSizes.switchHeight,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: value ? RedColors.live : Colors.transparent,
                  border: Border.all(
                    color: value ? RedColors.live : RedColors.switchOutline,
                    width: RedSizes.outlineWidth,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(RedSizes.switchHeight / 2)),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 150),
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: RedSizes.switchThumb,
                    height: RedSizes.switchThumb,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value ? RedColors.onLive : RedColors.steel,
                    ),
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
