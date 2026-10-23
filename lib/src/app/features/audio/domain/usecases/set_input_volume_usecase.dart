import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_volume_params.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class SetInputVolumeUsecase implements UseCase<Unit, SetInputVolumeParams> {
  final IAudioRepository _repository;

  SetInputVolumeUsecase({required IAudioRepository repository}) : _repository = repository;

  @override
  AsyncResult<Unit> call(SetInputVolumeParams params) => _repository.setVolume(params);
}
