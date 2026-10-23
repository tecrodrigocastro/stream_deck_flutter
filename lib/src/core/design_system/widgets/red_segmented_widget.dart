import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:flutter/material.dart';

/// Uma opção do [RedSegmentedWidget].
class RedSegment<T> {
  const RedSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// Escolha entre poucas opções (ex.: 2 ou 3 colunas). A opção marcada fica
/// vermelha e as outras em [RedColors.key]; todas dividem a largura por igual.
class RedSegmentedWidget<T> extends StatelessWidget {
  const RedSegmentedWidget({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<RedSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RedSizes.segmentedHeight,
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _SegmentTile(
                label: segment.label,
                selected: segment.value == selected,
                onTap: () => onChanged(segment.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _SegmentTile extends StatelessWidget {
  const _SegmentTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: selected ? RedColors.live : RedColors.key,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: RedTypography.keyLabel.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? RedColors.onLive : RedColors.steel,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
