import 'package:base_clean_arch_bloc/src/app/features/base/presentation/pages/base_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/design_system/presentation/pages/design_system_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/home/presentation/pages/home_page.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/pages/connect_page.dart';
import 'package:flutter/material.dart';
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
            GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const Placeholder()),
          ],
        ),
      ],
    ),
    GoRoute(path: '/', builder: (context, state) => const Placeholder()),
    GoRoute(path: '/design-system', builder: (context, state) => const DesignSystemPage()),
    GoRoute(path: '/conectar', builder: (context, state) => const ConnectPage()),
  ],
);
