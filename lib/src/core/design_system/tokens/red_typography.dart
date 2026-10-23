import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_colors.dart';
import 'package:flutter/painting.dart';

/// Duas famílias, embutidas em `assets/fonts` (funcionam sem internet):
///
/// * Chakra Petch, de traço angular como os chevrons do logo, para títulos,
///   números e teclas.
/// * Barlow, mais neutra, para o resto.
class RedTypography {
  RedTypography._();

  static const String displayFamily = 'ChakraPetch';
  static const String bodyFamily = 'Barlow';

  // Chakra Petch.

  /// Tempo de live.
  static const TextStyle timer = TextStyle(
    fontFamily: displayFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: RedColors.mist,
  );

  /// Título de tela.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: RedColors.mist,
  );

  /// Título de seção.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: RedColors.mist,
  );

  /// Título de card.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: RedColors.mist,
  );

  /// Nome na tecla de cena.
  static const TextStyle keyLabel = TextStyle(
    fontFamily: displayFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.15,
    color: RedColors.mist,
  );

  /// Botão principal.
  static const TextStyle button = TextStyle(
    fontFamily: displayFamily,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: RedColors.onLive,
  );

  // Barlow.

  /// Texto corrido e botões secundários.
  static const TextStyle body = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: RedColors.mist,
  );

  /// Texto corrido com mais peso.
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: RedColors.mist,
  );

  /// Texto digitado nos campos.
  static const TextStyle field = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: RedColors.mist,
  );

  /// Rótulo acima de um campo.
  static const TextStyle label = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: RedColors.steel,
  );

  /// Texto secundário.
  static const TextStyle secondary = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: RedColors.steel,
  );

  /// Legenda e barra de navegação.
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: RedColors.mist,
  );
}
