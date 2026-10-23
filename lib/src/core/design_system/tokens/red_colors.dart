import 'package:flutter/painting.dart';

/// Paleta do app, tirada do logo e dos overlays do OBS: fundos quase pretos
/// com um toque de vinho, vermelho para o que está no ar e rosa para o que
/// está ativo.
///
/// Contrastes (WCAG): texto [mist] e [steel] sobre [ink], [bar], [panel] e
/// [key] passa de 4,5:1 (o menor é [steel] sobre [key], 8,4:1); [pink] sobre
/// [ink] tem 5,9:1 e sobre [key] 5,1:1.
///
/// Sobre [live] use sempre [onLive] (5,0:1). [mist] (4,4:1), [steel] (2,5:1) e
/// [pink] (1,5:1) não têm contraste suficiente sobre o vermelho.
class RedColors {
  RedColors._();

  // Superfícies.

  /// Fundo das telas.
  static const Color ink = Color(0xFF0F0A10);

  /// Barra de navegação e app bar.
  static const Color bar = Color(0xFF140C16);

  /// Cards, painéis e campos.
  static const Color panel = Color(0xFF1A1220);

  /// Teclas de cena e botões de ícone.
  static const Color key = Color(0xFF231829);

  // Texto.

  /// Texto principal.
  static const Color mist = Color(0xFFEEF1F5);

  /// Texto secundário e ícones inativos.
  static const Color steel = Color(0xFFB9B4BF);

  /// Texto e ícones sobre [live].
  static const Color onLive = Color(0xFFFFFFFF);

  // Destaques e estados.

  /// Cena no ar e ação principal.
  static const Color live = Color(0xFFE0000E);

  /// Ícones, item ativo e erros (o design não define um vermelho de erro à parte).
  static const Color pink = Color(0xFFFF3C8E);

  /// Conectado e nível de áudio.
  static const Color ok = Color(0xFF3DDC97);

  /// Desconectado.
  static const Color off = Color(0xFF8A8490);

  // Variações translúcidas de [mist] (a porcentagem é o alfa).

  /// 10%: fundo do medidor de áudio.
  static const Color meterTrack = Color(0x1AEEF1F5);

  /// 12%: divisores de lista e trilho da barra de progresso.
  static const Color line = Color(0x1FEEF1F5);

  /// 18%: trilho do controle deslizante.
  static const Color track = Color(0x2EEEF1F5);

  /// 20%: borda dos campos de texto.
  static const Color fieldBorder = Color(0x33EEF1F5);

  /// 25%: contorno de botões secundários.
  static const Color outline = Color(0x40EEF1F5);

  /// 30%: contorno do interruptor desligado.
  static const Color switchOutline = Color(0x4DEEF1F5);

  // Degradê da marca (direto do logo). Fica para a abertura e os overlays do
  // OBS; dentro das telas do app usam-se só as cores chapadas acima.

  static const Color brandPink = Color(0xFFFF3C8E);
  static const Color brandRed = Color(0xFFFF0F1F);
  static const Color brandCrimson = Color(0xFFB80000);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[brandPink, brandRed, brandCrimson],
    stops: <double>[0.0, 0.45, 1.0],
  );
}
