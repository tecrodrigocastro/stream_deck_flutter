import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icons.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:flutter/material.dart';

/// Desenha um [RedIcon]. Sem [color], usa a cor do `IconTheme` do contexto.
///
/// Sem [semanticLabel] o ícone é decorativo (ignorado por leitores de tela),
/// o que é o certo quando ele acompanha um texto.
class RedIconWidget extends StatelessWidget {
  const RedIconWidget({
    super.key,
    required this.icon,
    this.size = RedSizes.iconNav,
    this.color,
    this.semanticLabel,
  });

  final RedIcon icon;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? IconTheme.of(context).color ?? RedColors.mist;
    final painted = CustomPaint(
      size: Size.square(size),
      painter: _RedIconPainter(icon: icon, color: resolvedColor),
    );

    final label = semanticLabel;
    if (label == null) {
      return ExcludeSemantics(child: painted);
    }
    return Semantics(label: label, image: true, child: painted);
  }
}

class _RedIconPainter extends CustomPainter {
  _RedIconPainter({required this.icon, required this.color});

  final RedIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / RedSizes.iconGrid);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = RedSizes.iconStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final layer in RedIcons.layersOf(icon)) {
      if (layer.filled) {
        canvas.drawPath(layer.path, fill);
      }
      canvas.drawPath(layer.path, stroke);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_RedIconPainter oldDelegate) {
    return oldDelegate.icon != icon || oldDelegate.color != color;
  }
}
