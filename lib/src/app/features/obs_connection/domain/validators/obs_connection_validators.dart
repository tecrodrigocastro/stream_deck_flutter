/// Validação dos campos da tela de conexão com o OBS. Cada método devolve a
/// mensagem de erro, ou `null` quando o valor é válido.
class ObsConnectionValidators {
  const ObsConnectionValidators();

  static const int defaultPort = 4455;

  String? host(String value) {
    final text = value.trim();
    if (text.isEmpty) return 'Informe o endereço do PC';
    if (text.contains(RegExp(r'\s')) || text.contains('/') || text.contains(':')) {
      return 'Use só o endereço, sem http:// nem porta';
    }
    return null;
  }

  String? port(String value) {
    final number = int.tryParse(value.trim());
    if (number == null || number < 1 || number > 65535) {
      return 'Porta de 1 a 65535';
    }
    return null;
  }
}
