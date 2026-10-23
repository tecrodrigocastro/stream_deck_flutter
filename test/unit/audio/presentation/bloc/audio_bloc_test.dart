import 'dart:async';

import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_mute_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/dtos/set_input_volume_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_input_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/entities/audio_update_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/repositories/audio_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/get_audio_inputs_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/observe_audio_updates_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/set_input_mute_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/domain/usecases/set_input_volume_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockAudioRepository extends Mock implements IAudioRepository {}

void main() {
  late MockAudioRepository repository;
  late StreamController<AudioUpdate> updates;
  late DateTime clock;

  const mic = AudioInputEntity(name: 'Microfone', muted: false, volumeDb: 0);
  const ps5 = AudioInputEntity(name: 'PS5', muted: false, volumeDb: -6);
  const failure = DefaultException(message: 'Sem conexão com o OBS');
  const ok = Success<Unit, Exception>(unit);

  setUpAll(() {
    registerFallbackValue(SetInputMuteParams.empty());
    registerFallbackValue(SetInputVolumeParams.empty());
  });

  setUp(() {
    repository = MockAudioRepository();
    updates = StreamController<AudioUpdate>.broadcast();
    clock = DateTime(2026, 10, 23, 15);
    when(() => repository.updates).thenAnswer((_) => updates.stream);
    when(() => repository.getInputs()).thenAnswer((_) async => const Success<List<AudioInputEntity>, Exception>([mic, ps5]));
    when(() => repository.setMute(any())).thenAnswer((_) async => ok);
    when(() => repository.setVolume(any())).thenAnswer((_) async => ok);
  });

  tearDown(() => updates.close());

  AudioBloc build() {
    return AudioBloc(
      getInputsUsecase: GetAudioInputsUsecase(repository: repository),
      setMuteUsecase: SetInputMuteUsecase(repository: repository),
      setVolumeUsecase: SetInputVolumeUsecase(repository: repository),
      observeUpdatesUsecase: ObserveAudioUpdatesUsecase(repository: repository),
      now: () => clock,
    );
  }

  Future<void> pause([int ms = 10]) => Future<void>.delayed(Duration(milliseconds: ms));

  blocTest<AudioBloc, AudioState>(
    'carrega as fontes: Loading e depois Loaded',
    build: build,
    act: (bloc) => bloc.add(const AudioLoadRequested()),
    expect: () => [isA<AudioLoading>(), const AudioLoaded(inputs: [mic, ps5])],
  );

  blocTest<AudioBloc, AudioState>(
    'falha ao carregar: Failure',
    build: () {
      when(() => repository.getInputs()).thenAnswer((_) async => const Failure<List<AudioInputEntity>, Exception>(failure));
      return build();
    },
    act: (bloc) => bloc.add(const AudioLoadRequested()),
    expect: () => [isA<AudioLoading>(), const AudioFailure(exception: failure)],
  );

  group('mute', () {
    blocTest<AudioBloc, AudioState>(
      'muta na hora e manda o pedido',
      build: build,
      act: (bloc) async {
        bloc.add(const AudioLoadRequested());
        await pause();
        bloc.add(const AudioMuteToggled(inputName: 'PS5'));
      },
      skip: 2,
      expect: () => [
        const AudioLoaded(inputs: [mic, AudioInputEntity(name: 'PS5', muted: true, volumeDb: -6)]),
      ],
      verify: (_) => verify(() => repository.setMute(SetInputMuteParams(inputName: 'PS5', muted: true))).called(1),
    );

    blocTest<AudioBloc, AudioState>(
      'se o OBS recusar, desfaz e mostra a mensagem',
      build: () {
        when(() => repository.setMute(any())).thenAnswer((_) async => const Failure<Unit, Exception>(failure));
        return build();
      },
      act: (bloc) async {
        bloc.add(const AudioLoadRequested());
        await pause();
        bloc.add(const AudioMuteToggled(inputName: 'PS5'));
      },
      skip: 2,
      expect: () => [
        const AudioLoaded(inputs: [mic, AudioInputEntity(name: 'PS5', muted: true, volumeDb: -6)]),
        const AudioLoaded(inputs: [mic, ps5], errorMessage: 'Sem conexão com o OBS'),
      ],
    );

    blocTest<AudioBloc, AudioState>(
      'fonte desconhecida é ignorada',
      build: build,
      act: (bloc) async {
        bloc.add(const AudioLoadRequested());
        await pause();
        bloc.add(const AudioMuteToggled(inputName: 'Outra'));
      },
      skip: 2,
      expect: () => <AudioState>[],
      verify: (_) => verifyNever(() => repository.setMute(any())),
    );
  });

  group('volume', () {
    blocTest<AudioBloc, AudioState>(
      'muda o volume na hora e manda o pedido',
      build: build,
      act: (bloc) async {
        bloc.add(const AudioLoadRequested());
        await pause();
        bloc.add(const AudioVolumeChanged(inputName: 'Microfone', volumeDb: -12));
      },
      wait: const Duration(milliseconds: 20),
      skip: 2,
      expect: () => [
        const AudioLoaded(inputs: [AudioInputEntity(name: 'Microfone', muted: false, volumeDb: -12), ps5]),
      ],
      verify: (_) => verify(() => repository.setVolume(SetInputVolumeParams(inputName: 'Microfone', volumeDb: -12))).called(1),
    );

    blocTest<AudioBloc, AudioState>(
      'arrastando: manda o primeiro valor e o último, sem os do meio',
      build: () {
        when(() => repository.setVolume(any())).thenAnswer((_) async {
          await pause(20);
          return ok;
        });
        return build();
      },
      act: (bloc) async {
        bloc.add(const AudioLoadRequested());
        await pause();
        bloc
          ..add(const AudioVolumeChanged(inputName: 'Microfone', volumeDb: -10))
          ..add(const AudioVolumeChanged(inputName: 'Microfone', volumeDb: -20))
          ..add(const AudioVolumeChanged(inputName: 'Microfone', volumeDb: -30));
      },
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => repository.setVolume(SetInputVolumeParams(inputName: 'Microfone', volumeDb: -10))).called(1);
        verify(() => repository.setVolume(SetInputVolumeParams(inputName: 'Microfone', volumeDb: -30))).called(1);
        verifyNever(() => repository.setVolume(SetInputVolumeParams(inputName: 'Microfone', volumeDb: -20)));
      },
    );

    blocTest<AudioBloc, AudioState>(
      'se o OBS recusar o volume, mostra a mensagem e mantém a lista',
      build: () {
        when(() => repository.setVolume(any())).thenAnswer((_) async => const Failure<Unit, Exception>(failure));
        return build();
      },
      act: (bloc) async {
        bloc.add(const AudioLoadRequested());
        await pause();
        bloc.add(const AudioVolumeChanged(inputName: 'Microfone', volumeDb: -12));
      },
      wait: const Duration(milliseconds: 20),
      skip: 3,
      expect: () => [
        const AudioLoaded(
          inputs: [AudioInputEntity(name: 'Microfone', muted: false, volumeDb: -12), ps5],
          errorMessage: 'Sem conexão com o OBS',
        ),
      ],
    );
  });

  group('avisos do OBS', () {
    Future<void> loaded(AudioBloc bloc) async {
      bloc.add(const AudioLoadRequested());
      await pause();
    }

    blocTest<AudioBloc, AudioState>(
      'mute feito no próprio OBS aparece na tela',
      build: build,
      act: (bloc) async {
        await loaded(bloc);
        updates.add(const AudioMuteUpdate(inputName: 'Microfone', muted: true));
      },
      wait: const Duration(milliseconds: 20),
      skip: 2,
      expect: () => [
        const AudioLoaded(inputs: [AudioInputEntity(name: 'Microfone', muted: true, volumeDb: 0), ps5]),
      ],
    );

    blocTest<AudioBloc, AudioState>(
      'medidores atualizam os níveis',
      build: build,
      act: (bloc) async {
        await loaded(bloc);
        updates.add(const AudioLevelsUpdate({'Microfone': 0.5}));
      },
      wait: const Duration(milliseconds: 20),
      skip: 2,
      expect: () => [
        const AudioLoaded(inputs: [mic, ps5], levels: {'Microfone': 0.5}),
      ],
    );

    blocTest<AudioBloc, AudioState>(
      'volume mudado no OBS aparece na tela',
      build: build,
      act: (bloc) async {
        await loaded(bloc);
        updates.add(const AudioVolumeUpdate(inputName: 'PS5', volumeDb: -20));
      },
      wait: const Duration(milliseconds: 20),
      skip: 2,
      expect: () => [
        const AudioLoaded(inputs: [mic, AudioInputEntity(name: 'PS5', muted: false, volumeDb: -20)]),
      ],
    );

    blocTest<AudioBloc, AudioState>(
      'eco de volume logo depois de o usuário mexer é ignorado',
      build: build,
      act: (bloc) async {
        await loaded(bloc);
        bloc.add(const AudioVolumeChanged(inputName: 'PS5', volumeDb: -30));
        await pause();
        updates.add(const AudioVolumeUpdate(inputName: 'PS5', volumeDb: -10));
      },
      wait: const Duration(milliseconds: 20),
      skip: 3,
      expect: () => <AudioState>[],
    );

    blocTest<AudioBloc, AudioState>(
      'volume do OBS passado o tempo do eco volta a valer',
      build: build,
      act: (bloc) async {
        await loaded(bloc);
        bloc.add(const AudioVolumeChanged(inputName: 'PS5', volumeDb: -30));
        await pause();
        clock = clock.add(const Duration(seconds: 2));
        updates.add(const AudioVolumeUpdate(inputName: 'PS5', volumeDb: -10));
      },
      wait: const Duration(milliseconds: 20),
      skip: 3,
      expect: () => [
        const AudioLoaded(inputs: [mic, AudioInputEntity(name: 'PS5', muted: false, volumeDb: -10)]),
      ],
    );

    blocTest<AudioBloc, AudioState>(
      'fonte criada ou removida recarrega a lista',
      build: build,
      act: (bloc) async {
        await loaded(bloc);
        updates.add(const AudioInputsChanged());
      },
      wait: const Duration(milliseconds: 20),
      verify: (_) => verify(() => repository.getInputs()).called(2),
    );

    blocTest<AudioBloc, AudioState>(
      'avisos sem a lista carregada são ignorados',
      build: build,
      act: (bloc) => updates.add(const AudioMuteUpdate(inputName: 'Microfone', muted: true)),
      wait: const Duration(milliseconds: 20),
      expect: () => <AudioState>[],
    );
  });
}
