class ServerInfo {
  String name;
  String host;
  int port;
  String userName;
  String password;

  ServerInfo({required this.name, required this.host, this.port = 22, required this.userName, required this.password});

  Map<String, dynamic> toJSon() {
    final Map<String, dynamic> map = {};
    map['name'] = name;
    map['host'] = host;
    map['port'] = port;
    map['userName'] = userName;
    map['password'] = password;

    return map;
  }
}