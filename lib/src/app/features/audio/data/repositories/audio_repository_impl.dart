import 'package:base_clean_arch_bloc/src/app/features/audio/data/datasources/obs_audio_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_mute_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_volume_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/obs/obs_requester.dart';
import 'package:result_dart/result_dart.dart';

class AudioRepositoryImpl implements IAudioRepository {
  final ObsAudioDatasource _datasource;

  AudioRepositoryImpl({required ObsAudioDatasource datasource}) : _datasource = datasource;

  @override
  Stream<AudioUpdate> get updates => _datasource.updates;

  @override
  AsyncResult<List<AudioInputEntity>> getInputs() {
    return _guard('Não foi possível ler as fontes de áudio do OBS', () => _datasource.getInputs());
  }

  @override
  AsyncResult<Unit> setMute(SetInputMuteParams params) {
    return _guard('Não foi possível mutar a fonte', () async {
      await _datasource.setMute(params.inputName, params.muted);
      return unit;
    });
  }

  @override
  AsyncResult<Unit> setVolume(SetInputVolumeParams params) {
    return _guard('Não foi possível mudar o volume', () async {
      await _datasource.setVolume(params.inputName, params.volumeDb);
      return unit;
    });
  }

  AsyncResult<T> _guard<T extends Object>(String fallbackMessage, Future<T> Function() action) async {
    try {
      return Success(await action());
    } on ObsRequestException catch (error) {
      return Failure(DefaultException(message: error.message, statusCode: error.code));
    } catch (error, stackTrace) {
      return Failure(DefaultException(message: fallbackMessage, data: error, stackTracing: stackTrace));
    }
  }
}
