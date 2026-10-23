import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';

/// Escolhe o ícone de uma cena pelo nome. Não há como o OBS dizer qual ícone
/// usar, então vale uma palavra-chave no nome; sem pista, vai o ícone de grade.
class SceneIconResolver {
  const SceneIconResolver._();

  static const List<(List<String>, RedIcon)> _rules = [
    (['e jogando', 'e jogo', 'duas telas', 'dividid'], RedIcon.dualScreen),
    (['cod', 'dev', 'program'], RedIcon.code),
    (['jog', 'game', 'ps5', 'gta'], RedIcon.gamepad),
    (['bate', 'chat', 'papo', 'conversa'], RedIcon.chat),
    (['volto', 'volta', 'pausa', 'intervalo', 'brb'], RedIcon.pause),
    (['encerr', 'final', 'fim', 'tchau', 'ending'], RedIcon.flag),
    (['começ', 'comec', 'breve', 'início', 'inicio', 'abertura', 'starting'], RedIcon.clock),
  ];

  static RedIcon iconFor(String sceneName) {
    final name = sceneName.toLowerCase();
    for (final (keywords, icon) in _rules) {
      if (keywords.any(name.contains)) return icon;
    }
    return RedIcon.grid;
  }
}
