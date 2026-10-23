import 'package:base_clean_arch_bloc/src/app/features/obs_connection/domain/entities/obs_connection_entity.dart';

class ObsConnectionModel extends ObsConnectionEntity {
  const ObsConnectionModel({
    required super.host,
    required super.port,
    required super.obsVersion,
    required super.rpcVersion,
  });

  factory ObsConnectionModel.fromMap(Map<String, dynamic> map) {
    return ObsConnectionModel(
      host: map['host'] as String,
      port: map['port'] as int,
      obsVersion: map['obsVersion'] as String,
      rpcVersion: map['rpcVersion'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'host': host,
        'port': port,
        'obsVersion': obsVersion,
        'rpcVersion': rpcVersion,
      };
}
