import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Aba que ainda não foi construída.
class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(RedSpacing.screenMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: RedTypography.screenTitle),
              const SizedBox(height: RedSpacing.sm),
              Text('Em breve', style: RedTypography.body.copyWith(color: RedColors.steel)),
            ],
          ),
        ),
      ),
    );
  }
}
