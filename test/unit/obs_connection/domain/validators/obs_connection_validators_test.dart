import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/validators/obs_connection_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validators = ObsConnectionValidators();

  group('host', () {
    test('aceita IP e nome de máquina', () {
      expect(validators.host('192.168.0.12'), isNull);
      expect(validators.host('pc-gamer.local'), isNull);
    });

    test('recusa vazio, protocolo e porta embutida', () {
      expect(validators.host('  '), isNotNull);
      expect(validators.host('http://192.168.0.12'), isNotNull);
      expect(validators.host('192.168.0.12:4455'), isNotNull);
    });
  });

  group('port', () {
    test('aceita de 1 a 65535', () {
      expect(validators.port('4455'), isNull);
      expect(validators.port('1'), isNull);
      expect(validators.port('65535'), isNull);
    });

    test('recusa fora da faixa ou não numérica', () {
      expect(validators.port('0'), isNotNull);
      expect(validators.port('65536'), isNotNull);
      expect(validators.port('abc'), isNotNull);
      expect(validators.port(''), isNotNull);
    });
  });
}
