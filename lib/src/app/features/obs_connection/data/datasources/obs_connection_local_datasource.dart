import 'package:base_clean_arch_bloc/src/core/cache/cache.dart';

/// Guarda a última conexão num único valor JSON no [ICache].
///
/// A senha vai junto, em texto simples no armazenamento do app: serve para
/// reconectar sozinho numa rede doméstica, não para guardar segredo de verdade.
class ObsConnectionLocalDatasource {
  static const String key = 'obs_connection';

  final ICache _cache;

  ObsConnectionLocalDatasource({required ICache cache}) : _cache = cache;

  /// `null` quando nada foi guardado ou o valor guardado está inválido.
  Future<Map<String, dynamic>?> read() async {
    final value = await _cache.getData(key);
    if (value is! Map) return null;

    final host = value['host'];
    final port = value['port'];
    if (host is! String || port is! int) return null;

    return {
      'host': host,
      'port': port,
      'password': value['password'] is String ? value['password'] : '',
      'autoConnect': value['autoConnect'] == true,
    };
  }

  Future<void> write({
    required String host,
    required int port,
    required String password,
    required bool autoConnect,
  }) async {
    await _cache.setData(
      params: CacheParams(
        key: key,
        value: {'host': host, 'port': port, 'password': password, 'autoConnect': autoConnect},
      ),
    );
  }
}
