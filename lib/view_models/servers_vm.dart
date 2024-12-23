import 'package:flutter/material.dart';
import 'package:sftp_flutter/data/server_info.dart';
import 'package:sftp_flutter/models/servers_model.dart';

class ServersViewModel with ChangeNotifier {
  final ServersModel model = ServersModel();

  final List<ServerInfo> _servers = [];
  List<ServerInfo> get servers => _servers;

  Future<void> addServer(String name, String host, String userName, String password, int port) async {
    final serverInfo = ServerInfo(name: name, host: host, userName: userName, password: password, port: port);
    
    await model.newServer(name, serverInfo.toJSon());
    await model.updateAllServerKey(name);
    
    _servers.add(serverInfo);
    notifyListeners();
  }

  Future<void> getAllServers() async {
    final keys = await model.getAllServerKeys();
    for(final k in keys.toList()) {
      final server = (await model.getServer(k))!;
      _servers.add(ServerInfo(name: server['name'], host: server['host'], userName: server['userName'], password: server['password'], port: server['port']));
    }
  
    notifyListeners();
  }
}