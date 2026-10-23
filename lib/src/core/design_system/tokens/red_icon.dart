/// Ícones do app (grade de 24 px, traço de 2 px, pontas arredondadas).
///
/// Os desenhos ficam em `red_icon_layers.dart`, gerado a partir dos SVGs do
/// canvas de design. Para adicionar um ícone: inclua o valor aqui e o `case`
/// correspondente lá (o `switch` é exaustivo, então o compilador avisa se faltar).
import 'dart:ui';

enum RedIcon {
  clock('Relógio', 'Cena Começando em breve'),
  code('Código', 'Cena Codando'),
  gamepad('Controle', 'Cena Jogando e áudio do PS5'),
  dualScreen('Duas telas', 'Cena Codando e jogando'),
  chat('Balão de chat', 'Cena Bate-papo'),
  pause('Pausa', 'Cena Já volto'),
  flag('Bandeira', 'Cena Encerramento'),
  mic('Microfone', 'Atalho e áudio do mic'),
  macMuted('Mac mudo', 'Atalho e áudio do Mac silenciado'),
  record('Gravar', 'Atalho de gravação'),
  stop('Parar', 'Encerrar live e parar macro'),
  play('Tocar', 'Rodar uma macro'),
  speaker('Alto-falante', 'Áudio de música e alertas'),
  grid('Grade', 'Aba Cenas'),
  sliders('Controles deslizantes', 'Aba Áudio'),
  bolt('Raio', 'Aba Macros'),
  settings('Ajustes', 'Aba Ajustes'),
  wifi('Wi-Fi', 'Botão Conectar'),
  plus('Mais', 'Botão Nova macro');

  const RedIcon(this.label, this.usage);

  /// Nome do ícone em português, usado no catálogo do design system.
  final String label;

  /// Onde o ícone aparece no app.
  final String usage;
}

/// Uma forma do ícone. Sempre recebe o traço; quando [filled] é verdadeiro
/// também é preenchida com a mesma cor (ex.: Gravar, Parar e Tocar).
class RedIconLayer {
  RedIconLayer(this.path, {this.filled = false});

  final Path path;
  final bool filled;
}
