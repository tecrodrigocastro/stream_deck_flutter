import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/widgets/scene_icon_resolver.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('escolhe o ícone pela palavra-chave do nome', () {
    expect(SceneIconResolver.iconFor('Codando'), RedIcon.code);
    expect(SceneIconResolver.iconFor('Jogando'), RedIcon.gamepad);
    expect(SceneIconResolver.iconFor('Codando e jogando'), RedIcon.dualScreen);
    expect(SceneIconResolver.iconFor('Bate-papo'), RedIcon.chat);
    expect(SceneIconResolver.iconFor('Já volto'), RedIcon.pause);
    expect(SceneIconResolver.iconFor('Encerramento'), RedIcon.flag);
    expect(SceneIconResolver.iconFor('Começando em breve'), RedIcon.clock);
  });

  test('sem pista no nome usa o ícone de grade', () {
    expect(SceneIconResolver.iconFor('Cena 7'), RedIcon.grid);
  });
}
