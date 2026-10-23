import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/widgets/scene_icon_resolver.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Grade de teclas de cena, duas por linha. Se sobrar uma, ela ocupa a linha toda.
class SceneGridWidget extends StatelessWidget {
  const SceneGridWidget({
    super.key,
    required this.scenes,
    required this.currentSceneName,
    required this.onSelected,
  });

  final List<SceneEntity> scenes;
  final String currentSceneName;
  final ValueChanged<SceneEntity> onSelected;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var i = 0; i < scenes.length; i += 2) {
      final pair = scenes.skip(i).take(2).toList();

      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : RedSpacing.keyGap),
          child: Row(
            children: [
              for (var j = 0; j < pair.length; j++) ...[
                if (j > 0) const SizedBox(width: RedSpacing.keyGap),
                Expanded(child: _key(pair[j])),
              ],
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _key(SceneEntity scene) {
    return RedSceneKeyWidget(
      label: scene.name,
      icon: SceneIconResolver.iconFor(scene.name),
      active: scene.name == currentSceneName,
      onPressed: () => onSelected(scene),
    );
  }
}
