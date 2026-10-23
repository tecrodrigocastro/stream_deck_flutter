import 'package:base_clean_arch_bloc/routes.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            tooltip: 'Desconectar do OBS',
            onPressed: () {
              context.read<ObsConnectionBloc>().add(const ObsDisconnectRequested());
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
