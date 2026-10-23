import 'package:base_clean_arch_bloc/src/app/features/scenes/data/models/scene_list_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lê a cena no ar e ordena do maior sceneIndex para o menor', () {
    final model = SceneListModel.fromMap({
      'currentProgramSceneName': 'Codando',
      'scenes': [
        {'sceneName': 'Encerramento', 'sceneIndex': 0},
        {'sceneName': 'Codando', 'sceneIndex': 1},
        {'sceneName': 'Começando em breve', 'sceneIndex': 2},
      ],
    });

    expect(model.currentSceneName, 'Codando');
    expect(model.scenes.map((s) => s.name), ['Começando em breve', 'Codando', 'Encerramento']);
  });

  test('resposta vazia vira lista vazia', () {
    final model = SceneListModel.fromMap({});

    expect(model.scenes, isEmpty);
    expect(model.currentSceneName, '');
  });
}
