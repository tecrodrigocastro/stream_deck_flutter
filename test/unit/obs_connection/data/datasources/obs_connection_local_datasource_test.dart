import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_connection_local_datasource.dart';
import 'package:base_clean_arch_bloc/src/core/cache/cache.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCache implements ICache {
  final Map<String, dynamic> store = {};

  @override
  Future<bool> clean() async {
    store.clear();
    return true;
  }

  @override
  Future<dynamic> getData(String key) async => store[key];

  @override
  Future<bool> removeData(String key) async => store.remove(key) != null;

  @override
  Future<bool> setData({required CacheParams params}) async {
    store[params.key] = params.value;
    return true;
  }
}

void main() {
  late FakeCache cache;
  late ObsConnectionLocalDatasource datasource;

  setUp(() {
    cache = FakeCache();
    datasource = ObsConnectionLocalDatasource(cache: cache);
  });

  test('devolve null quando nada foi guardado', () async {
    expect(await datasource.read(), isNull);
  });

  test('grava e lê de volta', () async {
    await datasource.write(host: '192.168.0.12', port: 4455, password: 'senha', autoConnect: true);

    expect(await datasource.read(), {
      'host': '192.168.0.12',
      'port': 4455,
      'password': 'senha',
      'autoConnect': true,
    });
  });

  test('valor guardado inválido é tratado como "nada guardado"', () async {
    cache.store[ObsConnectionLocalDatasource.key] = {'host': 10, 'port': 'x'};

    expect(await datasource.read(), isNull);
  });

  test('sem senha ou flag guardados usa os padrões', () async {
    cache.store[ObsConnectionLocalDatasource.key] = {'host': 'pc', 'port': 4455};

    expect(await datasource.read(), {'host': 'pc', 'port': 4455, 'password': '', 'autoConnect': false});
  });
}
