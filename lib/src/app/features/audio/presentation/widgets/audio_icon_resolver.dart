import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';

/// Ícone do botão de mute de uma fonte, escolhido pelo nome (o OBS não diz
/// qual ícone usar). Sem pista, alto-falante.
class AudioIconResolver {
  const AudioIconResolver._();

  static RedIcon iconFor(String inputName, {required bool muted}) {
    final name = inputName.toLowerCase();

    if (name.contains('mac')) return muted ? RedIcon.macMuted : RedIcon.dualScreen;
    if (_hasAny(name, ['mic', 'voz', 'voice', 'aux'])) return RedIcon.mic;
    if (_hasAny(name, ['ps5', 'playstation', 'console', 'jogo', 'game', 'gta'])) return RedIcon.gamepad;
    return RedIcon.speaker;
  }

  static bool _hasAny(String name, List<String> keywords) => keywords.any(name.contains);
}
