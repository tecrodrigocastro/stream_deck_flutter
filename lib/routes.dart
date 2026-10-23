import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/pages/audio_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/base/presentation/pages/base_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/base/presentation/widgets/coming_soon_widget.dart';
import 'package:base_clean_arch_bloc/src/app/features/design_system/presentation/pages/design_system_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/pages/connect_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/pages/scenes_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/conectar',
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BasePage(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/cenas', builder: (context, state) => const ScenesPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/audio', builder: (context, state) => const AudioPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/macros', builder: (context, state) => const ComingSoonWidget(title: 'Macros')),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/ajustes', builder: (context, state) => const SettingsPage()),
          ],
        ),
      ],
    ),
    GoRoute(path: '/design-system', builder: (context, state) => const DesignSystemPage()),
    GoRoute(path: '/conectar', builder: (context, state) => const ConnectPage()),
  ],
);
