import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';

class ObserveAudioUpdatesUsecase {
  final IAudioRepository _repository;

  ObserveAudioUpdatesUsecase({required IAudioRepository repository}) : _repository = repository;

  Stream<AudioUpdate> call() => _repository.updates;
}
