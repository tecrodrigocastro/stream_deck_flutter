import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Casca do app depois de conectar: abas Cenas, Áudio, Macros e Ajustes.
class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const List<RedNavItem> _items = [
    RedNavItem(icon: RedIcon.grid, label: 'Cenas'),
    RedNavItem(icon: RedIcon.sliders, label: 'Áudio'),
    RedNavItem(icon: RedIcon.bolt, label: 'Macros'),
    RedNavItem(icon: RedIcon.settings, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: RedNavBarWidget(
        items: _items,
        currentIndex: shell.currentIndex,
        onTap: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
      ),
    );
  }
}
