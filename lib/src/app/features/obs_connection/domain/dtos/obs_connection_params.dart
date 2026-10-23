class ObsConnectionParams {
  String host;
  int port;
  String password;

  ObsConnectionParams({
    required this.host,
    required this.port,
    this.password = '',
  });

  factory ObsConnectionParams.empty() => ObsConnectionParams(host: '', port: 4455);

  void setHost(String value) => host = value;
  void setPort(int value) => port = value;
  void setPassword(String value) => password = value;

  /// A senha fica de fora de propósito: este mapa pode acabar em log.
  Map<String, dynamic> toJson() => {'host': host, 'port': port};

  @override
  bool operator ==(Object other) {
    return other is ObsConnectionParams && other.host == host && other.port == port && other.password == password;
  }

  @override
  int get hashCode => Object.hash(host, port, password);

  @override
  String toString() => 'ObsConnectionParams(host: $host, port: $port)';
}
