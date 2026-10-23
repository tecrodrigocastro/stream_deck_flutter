import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/tokens/red_icon_layers.dart';

/// Acesso aos desenhos dos [RedIcon], com cache (cada `Path` é montado uma vez).
class RedIcons {
  RedIcons._();

  static final Map<RedIcon, List<RedIconLayer>> _cache = <RedIcon, List<RedIconLayer>>{};

  static List<RedIconLayer> layersOf(RedIcon icon) {
    return _cache.putIfAbsent(icon, () => buildRedIconLayers(icon));
  }
}
