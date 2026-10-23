import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Amostra de cor com nome e valor hexadecimal.
class ColorSwatchWidget extends StatelessWidget {
  const ColorSwatchWidget({super.key, required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();

    return Row(
      children: [
        Container(
          width: RedSizes.minTouch,
          height: RedSizes.minTouch,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: RedColors.outline),
          ),
        ),
        const SizedBox(width: RedSpacing.md),
        Expanded(child: Text(name, style: RedTypography.bodyStrong)),
        Text('#$hex', style: RedTypography.secondary),
      ],
    );
  }
}
