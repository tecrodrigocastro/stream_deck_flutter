/// Escala de espaçamento (múltiplos de 4).
class RedSpacing {
  RedSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// Margem lateral das telas.
  static const double screenMargin = 20;

  /// Espaço entre teclas de uma grade.
  static const double keyGap = 12;
}

/// Medidas fixas dos componentes.
class RedSizes {
  RedSizes._();

  /// Área mínima de toque.
  static const double minTouch = 44;

  /// Corte diagonal do canto superior direito de painéis e teclas.
  static const double cut = 18;

  /// Inclinação da borda direita das tags.
  static const double tagSlant = 8;

  static const double keyHeight = 92;
  static const double primaryButtonHeight = 56;
  static const double secondaryButtonHeight = 48;
  static const double fieldHeight = 52;
  static const double navBarHeight = 76;
  static const double segmentedHeight = 44;
  static const double liveBadgeHeight = 24;

  static const double switchWidth = 52;
  static const double switchHeight = 32;
  static const double switchThumb = 24;

  static const double statusDot = 9;
  static const double progressHeight = 6;
  static const double outlineWidth = 2;

  /// Grade e traço dos ícones.
  static const double iconGrid = 24;
  static const double iconStroke = 2;

  // Tamanhos de ícone por contexto.
  static const double iconKey = 26;
  static const double iconNav = 24;
  static const double iconButton = 22;
  static const double iconInline = 20;
}
