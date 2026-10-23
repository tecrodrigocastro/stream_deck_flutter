// Arquivo gerado a partir dos SVGs do canvas de design (grade 24x24).
// Edite com cuidado: os caminhos foram convertidos para comandos absolutos.
import 'dart:ui';

import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';

List<RedIconLayer> buildRedIconLayers(RedIcon icon) {
  return switch (icon) {
    RedIcon.clock => [
      RedIconLayer(
        Path()
            ..moveTo(21, 12)
            ..arcToPoint(const Offset(3, 12), radius: const Radius.circular(9), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(21, 12), radius: const Radius.circular(9), largeArc: true, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(12, 7)
            ..lineTo(12, 12)
            ..lineTo(15, 14),
      ),
    ],
    RedIcon.code => [
      RedIconLayer(
        Path()
            ..moveTo(8, 8)
            ..lineTo(4, 12)
            ..lineTo(8, 16)
            ..moveTo(16, 8)
            ..lineTo(20, 12)
            ..lineTo(16, 16)
            ..moveTo(14, 5)
            ..lineTo(10, 19),
      ),
    ],
    RedIcon.gamepad => [
      RedIconLayer(
        Path()
            ..moveTo(6, 8)
            ..lineTo(18, 8)
            ..arcToPoint(const Offset(22, 12), radius: const Radius.circular(4), largeArc: false, clockwise: true)
            ..lineTo(22, 14)
            ..arcToPoint(const Offset(16.8, 16), radius: const Radius.circular(3), largeArc: false, clockwise: true)
            ..lineTo(15, 14)
            ..lineTo(9, 14)
            ..lineTo(7.2, 16)
            ..arcToPoint(const Offset(2, 14), radius: const Radius.circular(3), largeArc: false, clockwise: true)
            ..lineTo(2, 12)
            ..arcToPoint(const Offset(6, 8), radius: const Radius.circular(4), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(8, 10.5)
            ..lineTo(8, 13.5)
            ..moveTo(6.5, 12)
            ..lineTo(9.5, 12),
      ),
    ],
    RedIcon.dualScreen => [
      RedIconLayer(
        Path()
            ..moveTo(4.5, 5)
            ..lineTo(9.5, 5)
            ..arcToPoint(const Offset(11, 6.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(11, 17.5)
            ..arcToPoint(const Offset(9.5, 19), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(4.5, 19)
            ..arcToPoint(const Offset(3, 17.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(3, 6.5)
            ..arcToPoint(const Offset(4.5, 5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(14.5, 5)
            ..lineTo(19.5, 5)
            ..arcToPoint(const Offset(21, 6.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(21, 17.5)
            ..arcToPoint(const Offset(19.5, 19), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(14.5, 19)
            ..arcToPoint(const Offset(13, 17.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(13, 6.5)
            ..arcToPoint(const Offset(14.5, 5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
      ),
    ],
    RedIcon.chat => [
      RedIconLayer(
        Path()
            ..moveTo(4, 5)
            ..lineTo(20, 5)
            ..lineTo(20, 16)
            ..lineTo(9, 16)
            ..lineTo(4, 20)
            ..close(),
      ),
    ],
    RedIcon.pause => [
      RedIconLayer(
        Path()
            ..moveTo(9, 5)
            ..lineTo(9, 19)
            ..moveTo(15, 5)
            ..lineTo(15, 19),
      ),
    ],
    RedIcon.flag => [
      RedIconLayer(
        Path()
            ..moveTo(5, 21)
            ..lineTo(5, 4)
            ..moveTo(5, 5)
            ..lineTo(17, 5)
            ..lineTo(15, 9)
            ..lineTo(17, 13)
            ..lineTo(5, 13),
      ),
    ],
    RedIcon.mic => [
      RedIconLayer(
        Path()
            ..moveTo(12, 3)
            ..lineTo(12, 3)
            ..arcToPoint(const Offset(15, 6), radius: const Radius.circular(3), largeArc: false, clockwise: true)
            ..lineTo(15, 11)
            ..arcToPoint(const Offset(12, 14), radius: const Radius.circular(3), largeArc: false, clockwise: true)
            ..lineTo(12, 14)
            ..arcToPoint(const Offset(9, 11), radius: const Radius.circular(3), largeArc: false, clockwise: true)
            ..lineTo(9, 6)
            ..arcToPoint(const Offset(12, 3), radius: const Radius.circular(3), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(5, 11)
            ..arcToPoint(const Offset(19, 11), radius: const Radius.circular(7), largeArc: false, clockwise: false)
            ..moveTo(12, 18)
            ..lineTo(12, 21),
      ),
    ],
    RedIcon.macMuted => [
      RedIconLayer(
        Path()
            ..moveTo(5, 4)
            ..lineTo(19, 4)
            ..arcToPoint(const Offset(21, 6), radius: const Radius.circular(2), largeArc: false, clockwise: true)
            ..lineTo(21, 14)
            ..arcToPoint(const Offset(19, 16), radius: const Radius.circular(2), largeArc: false, clockwise: true)
            ..lineTo(5, 16)
            ..arcToPoint(const Offset(3, 14), radius: const Radius.circular(2), largeArc: false, clockwise: true)
            ..lineTo(3, 6)
            ..arcToPoint(const Offset(5, 4), radius: const Radius.circular(2), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(8, 20)
            ..lineTo(16, 20)
            ..moveTo(12, 16)
            ..lineTo(12, 20)
            ..moveTo(3, 3)
            ..lineTo(21, 21),
      ),
    ],
    RedIcon.record => [
      RedIconLayer(
        Path()
            ..moveTo(20, 12)
            ..arcToPoint(const Offset(4, 12), radius: const Radius.circular(8), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(20, 12), radius: const Radius.circular(8), largeArc: true, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(15, 12)
            ..arcToPoint(const Offset(9, 12), radius: const Radius.circular(3), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(15, 12), radius: const Radius.circular(3), largeArc: true, clockwise: true)
            ..close(),
        filled: true,
      ),
    ],
    RedIcon.stop => [
      RedIconLayer(
        Path()
            ..moveTo(7.5, 6)
            ..lineTo(16.5, 6)
            ..arcToPoint(const Offset(18, 7.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(18, 16.5)
            ..arcToPoint(const Offset(16.5, 18), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(7.5, 18)
            ..arcToPoint(const Offset(6, 16.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(6, 7.5)
            ..arcToPoint(const Offset(7.5, 6), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
        filled: true,
      ),
    ],
    RedIcon.play => [
      RedIconLayer(
        Path()
            ..moveTo(8, 5)
            ..lineTo(19, 12)
            ..lineTo(8, 19)
            ..close(),
        filled: true,
      ),
    ],
    RedIcon.speaker => [
      RedIconLayer(
        Path()
            ..moveTo(4, 9)
            ..lineTo(4, 15)
            ..lineTo(8, 15)
            ..lineTo(13, 19)
            ..lineTo(13, 5)
            ..lineTo(8, 9)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(16.5, 9)
            ..arcToPoint(const Offset(16.5, 15), radius: const Radius.circular(4), largeArc: false, clockwise: true)
            ..moveTo(19, 6.5)
            ..arcToPoint(const Offset(19, 17.5), radius: const Radius.circular(8), largeArc: false, clockwise: true),
      ),
    ],
    RedIcon.grid => [
      RedIconLayer(
        Path()
            ..moveTo(5.5, 4)
            ..lineTo(9.5, 4)
            ..arcToPoint(const Offset(11, 5.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(11, 9.5)
            ..arcToPoint(const Offset(9.5, 11), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(5.5, 11)
            ..arcToPoint(const Offset(4, 9.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(4, 5.5)
            ..arcToPoint(const Offset(5.5, 4), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(14.5, 4)
            ..lineTo(18.5, 4)
            ..arcToPoint(const Offset(20, 5.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(20, 9.5)
            ..arcToPoint(const Offset(18.5, 11), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(14.5, 11)
            ..arcToPoint(const Offset(13, 9.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(13, 5.5)
            ..arcToPoint(const Offset(14.5, 4), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(5.5, 13)
            ..lineTo(9.5, 13)
            ..arcToPoint(const Offset(11, 14.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(11, 18.5)
            ..arcToPoint(const Offset(9.5, 20), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(5.5, 20)
            ..arcToPoint(const Offset(4, 18.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(4, 14.5)
            ..arcToPoint(const Offset(5.5, 13), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(14.5, 13)
            ..lineTo(18.5, 13)
            ..arcToPoint(const Offset(20, 14.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(20, 18.5)
            ..arcToPoint(const Offset(18.5, 20), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(14.5, 20)
            ..arcToPoint(const Offset(13, 18.5), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..lineTo(13, 14.5)
            ..arcToPoint(const Offset(14.5, 13), radius: const Radius.circular(1.5), largeArc: false, clockwise: true)
            ..close(),
      ),
    ],
    RedIcon.sliders => [
      RedIconLayer(
        Path()
            ..moveTo(4, 7)
            ..lineTo(14, 7)
            ..moveTo(18, 7)
            ..lineTo(20, 7)
            ..moveTo(4, 17)
            ..lineTo(6, 17)
            ..moveTo(10, 17)
            ..lineTo(20, 17),
      ),
      RedIconLayer(
        Path()
            ..moveTo(18, 7)
            ..arcToPoint(const Offset(14, 7), radius: const Radius.circular(2), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(18, 7), radius: const Radius.circular(2), largeArc: true, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(10, 17)
            ..arcToPoint(const Offset(6, 17), radius: const Radius.circular(2), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(10, 17), radius: const Radius.circular(2), largeArc: true, clockwise: true)
            ..close(),
      ),
    ],
    RedIcon.bolt => [
      RedIconLayer(
        Path()
            ..moveTo(13, 3)
            ..lineTo(5, 14)
            ..lineTo(11, 14)
            ..lineTo(10, 21)
            ..lineTo(18, 10)
            ..lineTo(12, 10)
            ..close(),
      ),
    ],
    RedIcon.settings => [
      RedIconLayer(
        Path()
            ..moveTo(15, 12)
            ..arcToPoint(const Offset(9, 12), radius: const Radius.circular(3), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(15, 12), radius: const Radius.circular(3), largeArc: true, clockwise: true)
            ..close(),
      ),
      RedIconLayer(
        Path()
            ..moveTo(12, 3)
            ..lineTo(12, 6)
            ..moveTo(12, 18)
            ..lineTo(12, 21)
            ..moveTo(3, 12)
            ..lineTo(6, 12)
            ..moveTo(18, 12)
            ..lineTo(21, 12)
            ..moveTo(5.6, 5.6)
            ..lineTo(7.7, 7.7)
            ..moveTo(16.3, 16.3)
            ..lineTo(18.4, 18.4)
            ..moveTo(18.4, 5.6)
            ..lineTo(16.3, 7.7)
            ..moveTo(7.7, 16.3)
            ..lineTo(5.6, 18.4),
      ),
    ],
    RedIcon.wifi => [
      RedIconLayer(
        Path()
            ..moveTo(3, 9)
            ..arcToPoint(const Offset(21, 9), radius: const Radius.circular(13), largeArc: false, clockwise: true)
            ..moveTo(6, 12.5)
            ..arcToPoint(const Offset(18, 12.5), radius: const Radius.circular(8.5), largeArc: false, clockwise: true)
            ..moveTo(9, 16)
            ..arcToPoint(const Offset(15, 16), radius: const Radius.circular(4), largeArc: false, clockwise: true),
      ),
      RedIconLayer(
        Path()
            ..moveTo(13, 19)
            ..arcToPoint(const Offset(11, 19), radius: const Radius.circular(1), largeArc: true, clockwise: true)
            ..arcToPoint(const Offset(13, 19), radius: const Radius.circular(1), largeArc: true, clockwise: true)
            ..close(),
        filled: true,
      ),
    ],
    RedIcon.plus => [
      RedIconLayer(
        Path()
            ..moveTo(12, 5)
            ..lineTo(12, 19)
            ..moveTo(5, 12)
            ..lineTo(19, 12),
      ),
    ],
  };
}
