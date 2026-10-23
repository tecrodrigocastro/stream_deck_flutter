import 'package:base_clean_arch_bloc/src/app/features/obs_connection/data/datasources/obs_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('gera a string de autenticação do exemplo da documentação do obs-websocket', () {
    final auth = ObsAuth.buildAuthString(
      password: 'supersecretpassword',
      salt: 'lM1GncleQOaCu9lT1yeUZhFYnqhsLLP1G5lAGo3ixaI=',
      challenge: '+IxH4CnCiqpX1rM9scsNynZzbOe4KhDeYcTNS3PDaeY=',
    );

    expect(auth, '1Ct943GAT+6YQUUX47Ia/ncufilbe6+oD6lY+5kaCu4=');
  });
}
