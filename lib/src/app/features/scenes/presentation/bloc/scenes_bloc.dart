import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/dtos/switch_scene_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/entities/scene_list_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/get_scenes_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/observe_scene_changes_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/scenes/domain/usecases/switch_scene_usecase.dart';
import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scenes_event.dart';
part 'scenes_state.dart';

class ScenesBloc extends Bloc<ScenesEvent, ScenesState> {
  final GetScenesUsecase _getScenesUsecase;
  final SwitchSceneUsecase _switchSceneUsecase;
  StreamSubscription<void>? _changesSubscription;

  ScenesBloc({
    required GetScenesUsecase getScenesUsecase,
    required SwitchSceneUsecase switchSceneUsecase,
    required ObserveSceneChangesUsecase observeChangesUsecase,
  })  : _getScenesUsecase = getScenesUsecase,
        _switchSceneUsecase = switchSceneUsecase,
        super(ScenesInitial()) {
    on<ScenesLoadRequested>((event, emit) async {
      emit(ScenesLoading());
      await _load(emit);
    });

    on<ScenesChanged>((event, emit) async {
      // Só atualiza quem já tem a lista na tela; o resto carrega pelo LoadRequested.
      if (state is ScenesLoaded) await _load(emit);
    });

    on<ScenesSwitchRequested>((event, emit) async {
      final current = state;
      if (current is! ScenesLoaded) return;
      if (event.sceneName == current.sceneList.currentSceneName) return;

      final result = await _switchSceneUsecase(SwitchSceneParams(sceneName: event.sceneName));

      if (result.isError()) {
        emit(ScenesLoaded(current.sceneList, errorMessage: (result.exceptionOrNull()! as BaseException).message));
        return;
      }

      // O OBS também avisa por evento, mas buscar aqui garante a tela certa
      // mesmo que o evento não chegue.
      await _load(emit);
    });

    _changesSubscription = observeChangesUsecase().listen((_) => add(const ScenesChanged()));
  }

  Future<void> _load(Emitter<ScenesState> emit) async {
    final result = await _getScenesUsecase(NoParams());
    emit(result.fold(
      ScenesLoaded.new,
      (exception) => ScenesFailure(exception: exception as BaseException),
    ));
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    return super.close();
  }
}
