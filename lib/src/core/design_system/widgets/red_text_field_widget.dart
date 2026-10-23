import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_typography.dart';
import 'package:flutter/material.dart';

/// Campo de texto com o rótulo acima, borda fina e foco rosa.
class RedTextFieldWidget extends StatelessWidget {
  const RedTextFieldWidget({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: Text(label, style: RedTypography.label)),
        const SizedBox(height: RedSpacing.sm),
        Semantics(
          label: label,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,
            style: RedTypography.field,
            cursorColor: RedColors.pink,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: RedTypography.field.copyWith(color: RedColors.steel),
              errorText: errorText,
              errorStyle: RedTypography.secondary.copyWith(color: RedColors.pink),
              filled: true,
              fillColor: RedColors.panel,
              contentPadding: const EdgeInsets.symmetric(horizontal: RedSpacing.lg, vertical: 15),
              enabledBorder: _border(RedColors.fieldBorder, 1),
              disabledBorder: _border(RedColors.fieldBorder, 1),
              focusedBorder: _border(RedColors.pink, 2),
              errorBorder: _border(RedColors.pink, 1),
              focusedErrorBorder: _border(RedColors.pink, 2),
            ),
          ),
        ),
      ],
    );
  }
}
