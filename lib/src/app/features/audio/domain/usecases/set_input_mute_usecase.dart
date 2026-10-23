import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_mute_params.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class SetInputMuteUsecase implements UseCase<Unit, SetInputMuteParams> {
  final IAudioRepository _repository;

  SetInputMuteUsecase({required IAudioRepository repository}) : _repository = repository;

  @override
  AsyncResult<Unit> call(SetInputMuteParams params) => _repository.setMute(params);
}
