import 'package:base_clean_arch_bloc/routes.dart';
import 'package:base_clean_arch_bloc/src/core/DI/dependency_injector.dart';
import 'package:base_clean_arch_bloc/src/core/services/session_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Design system',
              onPressed: () => router.push('/design-system'),
              icon: const Icon(Icons.palette_outlined),
            ),
          IconButton(
            onPressed: () async {
              final sessionService = injector<SessionService>();
              await sessionService.removeToken();
              router.go('/conectar');
            },
            icon: const Icon(Icons.logout_sharp),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
