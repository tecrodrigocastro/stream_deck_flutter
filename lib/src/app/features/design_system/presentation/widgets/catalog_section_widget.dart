import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Bloco do catálogo: título de seção e o conteúdo logo abaixo.
class CatalogSectionWidget extends StatelessWidget {
  const CatalogSectionWidget({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RedSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: RedTypography.sectionTitle),
          const SizedBox(height: RedSpacing.md),
          child,
        ],
      ),
    );
  }
}
