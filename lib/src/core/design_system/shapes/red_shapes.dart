import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_spacing.dart';
import 'package:flutter/painting.dart';

/// Formas da marca. O corte diagonal vem dos chevrons do logo: só o canto
/// superior direito é cortado, os outros ficam retos. Só pontos de status e
/// interruptores são redondos.
class RedShapes {
  RedShapes._();

  /// Canto superior direito cortado em [RedSizes.cut].
  static const BeveledRectangleBorder cut = BeveledRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(RedSizes.cut),
    ),
  );

  /// Retângulo sem cantos arredondados.
  static const RoundedRectangleBorder square = RoundedRectangleBorder();
}
