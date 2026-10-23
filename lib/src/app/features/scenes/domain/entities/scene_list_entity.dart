import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_entity.dart';
import 'package:equatable/equatable.dart';

class SceneListEntity extends Equatable {
  /// Na ordem em que aparecem no OBS.
  final List<SceneEntity> scenes;

  /// Nome da cena que está no ar.
  final String currentSceneName;

  const SceneListEntity({required this.scenes, required this.currentSceneName});

  @override
  List<Object> get props => [scenes, currentSceneName];
}
