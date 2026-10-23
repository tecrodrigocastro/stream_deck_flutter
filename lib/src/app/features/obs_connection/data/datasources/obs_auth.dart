import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Autenticação do obs-websocket v5:
///
/// ```
/// secret = base64(sha256(senha + salt))
/// auth   = base64(sha256(secret + challenge))
/// ```
class ObsAuth {
  const ObsAuth._();

  static String buildAuthString({
    required String password,
    required String salt,
    required String challenge,
  }) {
    final secret = base64.encode(sha256.convert(utf8.encode(password + salt)).bytes);
    return base64.encode(sha256.convert(utf8.encode(secret + challenge)).bytes);
  }
}
