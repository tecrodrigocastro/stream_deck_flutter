import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/widgets/red_icon_widget.dart';
import 'package:flutter/material.dart';

/// Uma aba da [RedNavBarWidget].
class RedNavItem {
  const RedNavItem({required this.icon, required this.label});

  final RedIcon icon;
  final String label;
}

/// Barra de navegação inferior: aba ativa em rosa com peso 600, as outras em
/// [RedColors.steel]. Respeita a área segura do aparelho.
class RedNavBarWidget extends StatelessWidget {
  const RedNavBarWidget({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<RedNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RedColors.bar,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: RedColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: RedSizes.navBarHeight,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavTile(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final RedNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? RedColors.pink : RedColors.steel;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RedIconWidget(icon: item.icon, size: RedSizes.iconNav, color: color),
            const SizedBox(height: RedSpacing.xs),
            Text(
              item.label,
              style: RedTypography.caption.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
