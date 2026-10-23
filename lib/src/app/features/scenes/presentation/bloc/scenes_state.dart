part of 'scenes_bloc.dart';

abstract class ScenesState extends Equatable {
  const ScenesState();

  @override
  List<Object> get props => [];
}

class ScenesInitial extends ScenesState {}

class ScenesLoading extends ScenesState {}

class ScenesLoaded extends ScenesState {
  final SceneListEntity sceneList;

  /// Erro de uma ação sobre a lista (ex.: trocar de cena). A lista continua
  /// válida; a tela mostra a mensagem uma vez.
  final String? errorMessage;

  const ScenesLoaded(this.sceneList, {this.errorMessage});

  @override
  List<Object> get props => [sceneList, if (errorMessage != null) errorMessage!];
}

class ScenesFailure extends ScenesState {
  final BaseException exception;

  const ScenesFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
