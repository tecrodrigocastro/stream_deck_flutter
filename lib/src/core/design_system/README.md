# Design system RED

Identidade visual do app: escuro, vermelho "ao vivo" e rosa de destaque, com um corte diagonal de 18 px no canto superior direito.

```dart
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
```

## Estrutura

| Pasta | Conteúdo |
|---|---|
| `tokens/` | `RedColors`, `RedTypography`, `RedSpacing`/`RedSizes`, ícones (`RedIcon`) |
| `shapes/` | `RedShapes.cut` (corte diagonal), `RedTagBorder` (paralelogramo) |
| `theme/` | `RedTheme.dark`, usado no `MaterialApp` |
| `widgets/` | componentes `Red*Widget` |

Para ver tudo na tela, rode o app em debug e toque na paleta da Home (rota `/design-system`).

## Regras

- Texto sobre `RedColors.live` é sempre `RedColors.onLive` (branco, 5,0:1). O `mist` sobre o vermelho dá só 4,4:1.
- Alvos de toque de pelo menos 44 px; espaçamentos múltiplos de 4.
- Cor nunca é a única informação: status sempre tem texto.
- `core/design_system` não importa nenhuma feature.

## Fontes

Chakra Petch (títulos e números) e Barlow (corpo), empacotadas em `assets/fonts/`, ambas sob licença OFL (textos em `assets/fonts/OFL-*.txt`). Sem `google_fonts`, então funciona offline.

## Ícones

São 19 ícones de 24x24 convertidos de SVG para `Path` do Flutter e desenhados por `RedIconWidget`. Não há dependência de `flutter_svg`. `red_icon.dart` e `red_icon_layers.dart` são **gerados**: não edite à mão.
