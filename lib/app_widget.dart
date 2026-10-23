import 'package:base_clean_arch_bloc/routes.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/DI/dependency_injector.dart';
import 'package:base_clean_arch_bloc/src/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injector<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => injector<ObsConnectionBloc>(),
        ),
      ],
      // Se o OBS cair com o app aberto, volta para a tela de conexão.
      child: BlocListener<ObsConnectionBloc, ObsConnectionState>(
        listenWhen: (previous, current) => current is ObsConnectionClosed,
        listener: (context, state) => router.go('/conectar'),
        child: MaterialApp.router(
          title: 'Stream Deck',
          theme: RedTheme.dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
