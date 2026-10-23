/// Conversão entre o dB do OBS e a posição (0 a 1) do controle deslizante.
///
/// O controle cobre de -60 dB a 0 dB, com 0 dB na ponta direita: dá para
/// baixar e voltar ao ganho original, não para amplificar. Fontes que o OBS
/// deixou acima de 0 dB aparecem no máximo do controle.
class AudioVolumeScale {
  const AudioVolumeScale._();

  static const double minDb = -60;
  static const double maxDb = 0;

  /// Valor que o OBS entende como silêncio total.
  static const double silenceDb = -100;

  static double dbToSlider(double db) => ((db - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);

  static double sliderToDb(double value) {
    final clamped = value.clamp(0.0, 1.0);
    if (clamped == 0) return silenceDb;
    // Um décimo de dB basta e evita mandar 7 casas decimais ao OBS.
    return ((minDb + clamped * (maxDb - minDb)) * 10).roundToDouble() / 10;
  }

  /// "-6,0 dB". Abaixo do piso do controle vira "-∞ dB".
  static String format(double db) {
    if (db <= minDb) return '-∞ dB';
    final text = db.toStringAsFixed(1).replaceAll('.', ',');
    return '${text == '-0,0' ? '0,0' : text} dB';
  }
}
