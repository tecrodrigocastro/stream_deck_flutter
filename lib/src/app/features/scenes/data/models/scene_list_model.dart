import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';

class SceneListModel extends SceneListEntity {
  const SceneListModel({required super.scenes, required super.currentSceneName});

  /// Lê o `responseData` do pedido `GetSceneList`.
  ///
  /// O OBS devolve `sceneIndex` crescente de baixo para cima na lista da
  /// interface, então ordenamos do maior para o menor para mostrar as cenas na
  /// mesma ordem do OBS. Se vier invertido no seu OBS, é só trocar o sentido
  /// da comparação abaixo.
  factory SceneListModel.fromMap(Map<String, dynamic> map) {
    final raw = (map['scenes'] as List<dynamic>? ?? const <dynamic>[]).cast<Map<String, dynamic>>();
    final sorted = [...raw]..sort((a, b) => _index(b).compareTo(_index(a)));

    return SceneListModel(
      scenes: [for (final scene in sorted) SceneEntity(name: scene['sceneName'] as String)],
      currentSceneName: map['currentProgramSceneName'] as String? ?? '',
    );
  }

  static int _index(Map<String, dynamic> scene) => scene['sceneIndex'] as int? ?? 0;
}
