/// O OBS não diz se uma fonte tem áudio. O `GetInputList` traz tudo (imagem,
/// texto, captura de tela...) e `GetInputMute` responde para qualquer uma.
/// Por isso filtramos pelo tipo da fonte.
class AudioInputKinds {
  const AudioInputKinds._();

  static final RegExp _audioKinds = RegExp(
    r'^(wasapi_|coreaudio_|pulse_|alsa_|jack_|sndio_|audio_|ffmpeg_source|vlc_source|browser_source|'
    r'dshow_input|av_capture_input|v4l2_input|decklink-input)',
  );

  static bool hasAudio(String kind) => _audioKinds.hasMatch(kind);
}
