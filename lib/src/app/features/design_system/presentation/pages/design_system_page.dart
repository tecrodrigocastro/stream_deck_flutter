import 'package:base_clean_arch_bloc/src/app/features/design_system/presentation/widgets/catalog_section_widget.dart';
import 'package:base_clean_arch_bloc/src/app/features/design_system/presentation/widgets/color_swatch_widget.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Catálogo vivo do design system: mostra tokens e componentes no aparelho.
class DesignSystemPage extends StatefulWidget {
  const DesignSystemPage({super.key});

  @override
  State<DesignSystemPage> createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends State<DesignSystemPage> {
  final _controller = TextEditingController();
  bool _switch = true;
  String _segment = 'scenes';
  double _volume = 0.7;
  bool _muted = false;
  int _tab = 0;
  int _activeKey = 0;

  static const _colors = <String, Color>{
    'ink': RedColors.ink,
    'bar': RedColors.bar,
    'panel': RedColors.panel,
    'key': RedColors.key,
    'mist': RedColors.mist,
    'steel': RedColors.steel,
    'live': RedColors.live,
    'pink': RedColors.pink,
    'ok': RedColors.ok,
    'off': RedColors.off,
  };

  static const _keys = <(String, RedIcon)>[
    ('Só código', RedIcon.code),
    ('Jogo + câmera', RedIcon.gamepad),
    ('Duas telas', RedIcon.dualScreen),
    ('Bate-papo', RedIcon.chat),
    ('Pausa', RedIcon.pause),
    ('Encerrar', RedIcon.flag),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design system'),
        scrolledUnderElevation: 0,
        backgroundColor: RedColors.bar,
      ),
      bottomNavigationBar: RedNavBarWidget(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
        items: const [
          RedNavItem(icon: RedIcon.grid, label: 'Cenas'),
          RedNavItem(icon: RedIcon.sliders, label: 'Áudio'),
          RedNavItem(icon: RedIcon.bolt, label: 'Macros'),
          RedNavItem(icon: RedIcon.settings, label: 'Ajustes'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(RedSpacing.screenMargin),
        children: [
          CatalogSectionWidget(
            title: 'Cores',
            child: Column(
              children: [
                for (final entry in _colors.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: RedSpacing.sm),
                    child: ColorSwatchWidget(name: entry.key, color: entry.value),
                  ),
              ],
            ),
          ),
          CatalogSectionWidget(
            title: 'Tipografia',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('00:42:17', style: RedTypography.timer),
                Text('Título de tela', style: RedTypography.screenTitle),
                Text('Título de seção', style: RedTypography.sectionTitle),
                Text('Título de cartão', style: RedTypography.cardTitle),
                Text('Texto de corpo', style: RedTypography.body),
                Text('Texto de apoio', style: RedTypography.secondary),
                Text('Legenda', style: RedTypography.caption),
              ],
            ),
          ),
          CatalogSectionWidget(
            title: 'Ícones',
            child: Wrap(
              spacing: RedSpacing.lg,
              runSpacing: RedSpacing.lg,
              children: [
                for (final icon in RedIcon.values)
                  SizedBox(
                    width: 72,
                    child: Column(
                      children: [
                        RedIconWidget(icon: icon, size: 32, color: RedColors.pink),
                        const SizedBox(height: RedSpacing.xs),
                        Text(
                          icon.label,
                          style: RedTypography.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          CatalogSectionWidget(
            title: 'Teclas de cena',
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: RedSpacing.keyGap,
              crossAxisSpacing: RedSpacing.keyGap,
              childAspectRatio: 1.6,
              children: [
                for (var i = 0; i < _keys.length; i++)
                  RedSceneKeyWidget(
                    label: _keys[i].$1,
                    icon: _keys[i].$2,
                    active: i == _activeKey,
                    onPressed: () => setState(() => _activeKey = i),
                  ),
              ],
            ),
          ),
          CatalogSectionWidget(
            title: 'Botões',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RedPrimaryButtonWidget(label: 'Iniciar live', icon: RedIcon.play, onPressed: () {}),
                const SizedBox(height: RedSpacing.md),
                const RedPrimaryButtonWidget(label: 'Desabilitado', onPressed: null),
                const SizedBox(height: RedSpacing.md),
                RedOutlineButtonWidget(label: 'Conectar ao OBS', icon: RedIcon.wifi, onPressed: () {}),
                const SizedBox(height: RedSpacing.md),
                Row(
                  children: [
                    RedIconButtonWidget(
                      icon: RedIcon.mic,
                      semanticLabel: 'Microfone',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          CatalogSectionWidget(
            title: 'Campos e seletores',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RedTextFieldWidget(
                  label: 'Endereço do OBS',
                  controller: _controller,
                  hintText: '192.168.0.10:4455',
                ),
                const SizedBox(height: RedSpacing.lg),
                Row(
                  children: [
                    const Expanded(child: Text('Reconectar sozinho', style: RedTypography.body)),
                    RedSwitchWidget(
                      value: _switch,
                      semanticLabel: 'Reconectar sozinho',
                      onChanged: (value) => setState(() => _switch = value),
                    ),
                  ],
                ),
                const SizedBox(height: RedSpacing.lg),
                RedSegmentedWidget<String>(
                  segments: const [
                    RedSegment(value: 'scenes', label: 'Cenas'),
                    RedSegment(value: 'sources', label: 'Fontes'),
                  ],
                  selected: _segment,
                  onChanged: (value) => setState(() => _segment = value),
                ),
              ],
            ),
          ),
          const CatalogSectionWidget(
            title: 'Status',
            child: Wrap(
              spacing: RedSpacing.lg,
              runSpacing: RedSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RedLiveBadgeWidget(),
                RedStatusDotWidget(status: RedStatus.connected, label: 'OBS conectado'),
                RedStatusDotWidget(status: RedStatus.disconnected, label: 'Desconectado'),
                RedTagWidget(label: 'Flutter'),
                RedTagWidget(label: 'Rodando', highlighted: true),
              ],
            ),
          ),
          CatalogSectionWidget(
            title: 'Progresso e áudio',
            child: Column(
              children: [
                const RedProgressBarWidget(value: 0.6),
                const SizedBox(height: RedSpacing.lg),
                RedAudioFaderWidget(
                  name: 'Microfone',
                  icon: RedIcon.mic,
                  volume: _volume,
                  volumeLabel: '${((_volume - 1) * 60).toStringAsFixed(1)} dB',
                  level: 0.55,
                  muted: _muted,
                  onVolumeChanged: (value) => setState(() => _volume = value),
                  onMutePressed: () => setState(() => _muted = !_muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
