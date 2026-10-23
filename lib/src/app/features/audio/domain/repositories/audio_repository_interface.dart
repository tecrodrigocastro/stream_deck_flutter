import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_mute_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_volume_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IAudioRepository {
  AsyncResult<List<AudioInputEntity>> getInputs();

  AsyncResult<Unit> setMute(SetInputMuteParams params);

  AsyncResult<Unit> setVolume(SetInputVolumeParams params);

  Stream<AudioUpdate> get updates;
}
