import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:flutter/painting.dart';

/// Forma das tags: um paralelogramo com a borda direita inclinada em [slant].
class RedTagBorder extends ShapeBorder {
  const RedTagBorder({this.slant = RedSizes.tagSlant});

  final double slant;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => RedTagBorder(slant: slant * t);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right - slant, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  bool operator ==(Object other) {
    return other is RedTagBorder && other.slant == slant;
  }

  @override
  int get hashCode => slant.hashCode;
}
