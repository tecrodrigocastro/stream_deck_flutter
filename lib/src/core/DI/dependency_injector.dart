import 'package:base_clean_arch_bloc/src/app/features/audio/data/datasources/obs_audio_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/data/repositories/audio_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/get_audio_inputs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/observe_audio_updates_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/set_input_mute_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/set_input_volume_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/repositories/auth_repository_mock.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/infrastructure/auth_interceptor.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_connection_local_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_websocket_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/repositories/obs_connection_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/repositories/obs_connection_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/connect_obs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/disconnect_obs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/get_saved_obs_connection_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/usecases/observe_obs_connection_closed_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/obs_connection/presentation/bloc/obs_connection_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/data/datasources/obs_scenes_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/data/repositories/scenes_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/repositories/scenes_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/get_scenes_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/observe_scene_changes_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/switch_scene_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/presentation/bloc/scenes_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/cache/shared_preferences/shared_preferences_impl.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/dio/rest_client_dio_impl.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/logger/client_interceptor_logger_impl.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';
import 'package:base_clean_arch_bloc/src/core/services/session_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final injector = GetIt.instance;

void setupDependencyInjector({bool loggerApi = false, bool useMocks = true, Logger? logger}) {
  injector.registerLazySingleton<Logger>(() => logger ?? Logger());

  injector.registerFactory<RestClientDioImpl>(() {
    final instance = RestClientDioImpl(
      dio: DioFactory.dio(),
    );

    instance.addInterceptors(AuthInterceptor(
      sessionService: injector<SessionService>(),
    ));

    if (loggerApi) {
      instance.addInterceptors(ClientInterceptorLoggerImpl(logger: injector<Logger>()));
    }

    return instance;
  });

  injector.registerLazySingleton<SessionService>(() {
    return SessionService(
      sharedPreferencesImpl: SharedPreferencesImpl(),
    );
  });

  injector.registerLazySingleton<AuthRemoteDatasource>(() {
    return AuthRemoteDatasource(
      restClient: injector<RestClientDioImpl>(),
    );
  });

  if (useMocks) {
    injector.registerLazySingleton<IAuthRepository>(() => AuthRepositoryMock());
  } else {
    injector.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: injector<AuthRemoteDatasource>()));
  }

  injector.registerLazySingleton(() => AuthBloc(
        loginUsecase: LoginUsecase(
          authRepository: injector<IAuthRepository>(),
          sessionService: injector<SessionService>(),
        ),
      ));

  injector.registerLazySingleton<ObsWebSocketDatasource>(() => ObsWebSocketDatasource());

  injector.registerLazySingleton<IObsConnectionRepository>(
    () => ObsConnectionRepositoryImpl(
      datasource: injector<ObsWebSocketDatasource>(),
      local: ObsConnectionLocalDatasource(cache: SharedPreferencesImpl()),
    ),
  );

  injector.registerLazySingleton<IObsRequester>(() => injector<ObsWebSocketDatasource>());

  injector.registerLazySingleton(() => ObsConnectionBloc(
        connectUsecase: ConnectObsUsecase(repository: injector<IObsConnectionRepository>()),
        disconnectUsecase: DisconnectObsUsecase(repository: injector<IObsConnectionRepository>()),
        getSavedUsecase: GetSavedObsConnectionUsecase(repository: injector<IObsConnectionRepository>()),
        observeClosedUsecase: ObserveObsConnectionClosedUsecase(repository: injector<IObsConnectionRepository>()),
      ));

  injector.registerLazySingleton<IScenesRepository>(
    () => ScenesRepositoryImpl(datasource: ObsScenesDatasource(requester: injector<IObsRequester>())),
  );

  injector.registerLazySingleton(() => ScenesBloc(
        getScenesUsecase: GetScenesUsecase(repository: injector<IScenesRepository>()),
        switchSceneUsecase: SwitchSceneUsecase(repository: injector<IScenesRepository>()),
        observeChangesUsecase: ObserveSceneChangesUsecase(repository: injector<IScenesRepository>()),
      ));

  injector.registerLazySingleton<IAudioRepository>(
    () => AudioRepositoryImpl(datasource: ObsAudioDatasource(requester: injector<IObsRequester>())),
  );

  injector.registerLazySingleton(() => AudioBloc(
        getInputsUsecase: GetAudioInputsUsecase(repository: injector<IAudioRepository>()),
        setMuteUsecase: SetInputMuteUsecase(repository: injector<IAudioRepository>()),
        setVolumeUsecase: SetInputVolumeUsecase(repository: injector<IAudioRepository>()),
        observeUpdatesUsecase: ObserveAudioUpdatesUsecase(repository: injector<IAudioRepository>()),
      ));
}
