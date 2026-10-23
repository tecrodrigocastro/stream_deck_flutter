import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class GetAudioInputsUsecase implements UseCase<List<AudioInputEntity>, NoParams> {
  final IAudioRepository _repository;

  GetAudioInputsUsecase({required IAudioRepository repository}) : _repository = repository;

  @override
  AsyncResult<List<AudioInputEntity>> call(NoParams params) => _repository.getInputs();
}
